import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LibraryPage extends StatefulWidget {
  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final Map<String, String> fixedCategories = {
    'want_to_read': 'Want to Read',
    'currently_reading': 'Currently Reading',
    'finished': 'Finished',
    'gave_up': 'Gave up',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          const SizedBox(height: 50),
          _buildHeader("My Library"),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: fixedCategories.entries.map((entry) {
                return _buildCategorySection(entry.key, entry.value);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(String title) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFFD6C6A6),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      width: double.infinity,
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySection(String categoryId, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            IconButton(
              icon: Icon(Icons.add, color: Colors.white),
              onPressed: () => _showAddBookDialog(categoryId),
            ),
          ],
        ),
        const SizedBox(height: 10),
        StreamBuilder<QuerySnapshot>(
          stream: _getBooksStream(categoryId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final docs = snapshot.data?.docs ?? [];

            if (docs.isEmpty) {
              return const Text(
                'No books yet',
                style: TextStyle(color: Colors.white54),
              );
            }

            return Column(
              children: docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    data['title'] ?? '',
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    data['author'] ?? '',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteBook(categoryId, doc.id),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Stream<QuerySnapshot> _getBooksStream(String categoryId) {
    final user = _auth.currentUser;
    if (user == null) return const Stream.empty();
    return _firestore
        .collection('libraries')
        .doc(user.uid)
        .collection('categories')
        .doc(categoryId)
        .collection('books')
        .snapshots();
  }

  void _showAddBookDialog(String categoryId) {
    String bookTitle = '';
    String author = '';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Add Book"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Book Title'),
              onChanged: (value) => bookTitle = value,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Author'),
              onChanged: (value) => author = value,
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text("Add"),
            onPressed: () async {
              if (bookTitle.trim().isEmpty) return;
              await _addBookToCategory(categoryId, bookTitle, author);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _addBookToCategory(
      String categoryId, String title, String author) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection('libraries')
          .doc(user.uid)
          .collection('categories')
          .doc(categoryId)
          .collection('books')
          .add({
        'title': title,
        'author': author,
        'added_at': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<void> _deleteBook(String categoryId, String bookId) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection('libraries')
          .doc(user.uid)
          .collection('categories')
          .doc(categoryId)
          .collection('books')
          .doc(bookId)
          .delete();
    }
  }
}
