import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:html/parser.dart' show parse;

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  List<dynamic> _articles = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchNews();
  }

  Future<void> _fetchNews() async {
    const String apiUrl =
        'https://newsdata.io/api/1/news?apikey=pub_768966df1a98d091a086f35d9d5e06cc53a22&q=literature&country=in,us&language=en&category=entertainment';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          _articles = jsonData['results'] ?? [];
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to fetch news. Code: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching news: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not launch URL")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          const SizedBox(height: 50),
          _buildHeader("News"),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.white))
                : _errorMessage != null
                    ? Center(
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: _articles.length,
                        itemBuilder: (context, index) {
                          final article = _articles[index];
                          final rawTitle = article['title'] ?? 'No Title';
                          final rawDescription = article['description'] ?? 'No Description';
                          final imageUrl = article['image_url'] ??
                              'https://via.placeholder.com/150';
                          final link = article['link'] ?? '';

                          // Decode HTML entities
                          final decodedTitle = parse(rawTitle).body?.text ?? rawTitle;
                          final decodedDescription =
                              parse(rawDescription).body?.text ?? rawDescription;

                          return _buildNewsCard(decodedTitle, decodedDescription, imageUrl, link);
                        },
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

  Widget _buildNewsCard(String title, String description, String imageUrl, String link) {
    return Card(
      color: Colors.white10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              imageUrl,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => _launchURL(link),
                    child: const Text(
                      "Read More",
                      style: TextStyle(color: Color(0xFFB29A77)),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
