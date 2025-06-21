import 'package:flutter/material.dart';
import 'News.dart';
import 'Explore.dart';
import 'Library.dart';
import 'profile.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 2;

  final List<Widget> _pages = [
    NewsPage(),
    ExplorePage(),
    HomePage(),
    LibraryPage(),
    ProfilePage(),
  ];

  final List<String> trendingBookClubs = [
    "Sci-Fi Lovers",
    "Fiction",
    "Mystery Enthusiasts",
    "Historical Fiction Fans",
    "Romance Readers",
    "Fantasy Fanatics",
    "Non-Fiction Nerds",
    "Poetry Corner",
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _selectedIndex == 2 ? _buildHomeContent() : _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.newspaper), label: 'News'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.library_books), label: 'Library'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildHomeContent() {
    return Column(
      children: [
        const SizedBox(height: 50),
        _buildHeader("Home"),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _buildFeaturedBook(),
              const SizedBox(height: 20),
              _buildSectionTitle("Trending Book Clubs"),
              _buildBookClubList(),
            ],
          ),
        ),
      ],
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

  Widget _buildFeaturedBook() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: const DecorationImage(
          image: AssetImage('assets/featured_book.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black.withOpacity(0.4),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildBookClubList() {
    return Column(
      children: trendingBookClubs.map((club) {
        return Card(
          color: Colors.white10,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            title: Text(
              club,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white54),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Tapped on "$club"')),
              );
            },
          ),
        );
      }).toList(),
    );
  }
}
