import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'EditProfile.dart';
import '../database_helper.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String username = "Loading...";
  String dob = "";
  int _selectedIndex = 4;
  final int booksRead = 25;
  final int yearlyGoal = 50;
  File? _profileImage;

  final picker = ImagePicker();

  final List<String> bookClubs = [
    "Sci-Fi Lovers",
    "Mystery Enthusiasts",
    "Historical Fiction Fans"
  ];
  final List<Map<String, dynamic>> achievements = [
    {"icon": Icons.star, "label": "Beginner Reader", "color": Colors.amber},
    {"icon": Icons.local_fire_department, "label": "Reading Streak", "color": Colors.red},
    {"icon": Icons.book, "label": "50 Books Completed", "color": Colors.blue},
    {"icon": Icons.emoji_events, "label": "Top Reviewer", "color": Colors.green},
  ];

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await DatabaseHelper.getProfile();
    setState(() {
      username = prefs['username'] ?? 'Guest';
      dob = prefs['date_of_birth'] ?? '';
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (context) => SafeArea(
        child: Wrap(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Take a Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/News');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/Explore');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/homepage');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/Library');
        break;
      case 4:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    double progress = booksRead / yearlyGoal;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50),
            Center(
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : AssetImage('assets/profile.jpg') as ImageProvider,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 4,
                        child: GestureDetector(
                          onTap: _showImagePickerOptions,
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.camera_alt, color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    username,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  if (dob.isNotEmpty)
                    Text(
                      "DOB: $dob",
                      style: const TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("Followers: 10", style: TextStyle(color: Colors.white, fontSize: 16)),
                      SizedBox(width: 15),
                      Text("|", style: TextStyle(color: Colors.grey, fontSize: 16)),
                      SizedBox(width: 15),
                      Text("Following: 20", style: TextStyle(color: Colors.white, fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EditProfilePage()),
                      );
                      _loadProfile();
                    },
                    icon: const Icon(Icons.edit, color: Colors.white),
                    label: const Text("Edit Profile", style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Books Read This Year", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                        const SizedBox(height: 5),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.grey[800],
                            valueColor: const AlwaysStoppedAnimation(Colors.brown),
                            minHeight: 10,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text("$booksRead / $yearlyGoal Books", style: const TextStyle(fontSize: 16, color: Colors.white70)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Book Clubs Joined", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                        const SizedBox(height: 10),
                        Column(
                          children: bookClubs.map((club) => Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.white10,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(club, style: const TextStyle(fontSize: 16, color: Colors.white)),
                                const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 18),
                              ],
                            ),
                          )).toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Achievements & Badges", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 15,
                          runSpacing: 15,
                          children: achievements.map((badge) => Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: badge["color"].withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(badge["icon"], size: 30, color: badge["color"]),
                                const SizedBox(height: 5),
                                Text(badge["label"], style: const TextStyle(fontSize: 14, color: Colors.white)),
                              ],
                            ),
                          )).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
