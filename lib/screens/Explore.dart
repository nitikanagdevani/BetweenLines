import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import '../database_helper.dart'; // Ensure correct path

class ExplorePage extends StatefulWidget {
  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  List<Map<String, dynamic>> bookClubs = [];
  bool isLoading = true;
  String city = 'Mumbai'; // default, will be overwritten
  final String apiKey = 'AIzaSyDJlJCXFEviUHK6yvKkSdT4iDf0t_ZiTPo'; // Replace with your actual key

  @override
  void initState() {
    super.initState();
    _loadCityAndFetch();
  }

  Future<void> _loadCityAndFetch() async {
    final prefs = await DatabaseHelper.getProfile();
    city = prefs['city'] ?? 'Mumbai';
    await fetchBookClubs();
  }

  Future<void> fetchBookClubs() async {
    final url =
        'https://maps.googleapis.com/maps/api/place/textsearch/json?query=book+clubs+in+$city&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List;

        setState(() {
          bookClubs = results.map((place) {
            return {
              'name': place['name'],
              'lat': place['geometry']['location']['lat'],
              'lng': place['geometry']['location']['lng'],
              'address': place['formatted_address'],
              'rating': place['rating']?.toString(),
              'reviews': place['user_ratings_total']?.toString(),
              'place_id': place['place_id'],
            };
          }).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _openMap(double lat, double lng, String? placeId) async {
    final Uri url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$lat,$lng${placeId != null ? '&query_place_id=$placeId' : ''}',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not open Google Maps")),
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
          _buildHeader("Explore Book Clubs in $city"),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.white))
                : GridView.builder(
                    padding: const EdgeInsets.all(20),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: bookClubs.length,
                    itemBuilder: (context, index) {
                      final club = bookClubs[index];
                      return GestureDetector(
                        onTap: () => _openMap(club['lat'], club['lng'], club['place_id']),
                        child: _buildClubCard(club),
                      );
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
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildClubCard(Map<String, dynamic> club) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            club['name'] ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            club['address'] ?? '',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const Spacer(),
          if (club['rating'] != null)
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 16),
                const SizedBox(width: 4),
                Text(
                  '${club['rating']} (${club['reviews'] ?? 0})',
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          const SizedBox(height: 5),
          const Align(
            alignment: Alignment.bottomRight,
            child: Icon(Icons.location_pin, color: Colors.redAccent),
          ),
        ],
      ),
    );
  }
}
