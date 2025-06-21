import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../database_helper.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profile = await DatabaseHelper.getProfile();
    usernameController.text = profile['username'] ?? '';
    dobController.text = profile['date_of_birth'] ?? '';
    cityController.text = profile['city'] ?? '';
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      dobController.text = "${pickedDate.toLocal()}".split(' ')[0];
    }
  }

  Future<void> _saveProfile() async {
    await DatabaseHelper.saveProfile(
      usernameController.text.trim(),
      dobController.text.trim(),
      cityController.text.trim(),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile updated")),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage:
                    _profileImage != null ? FileImage(_profileImage!) : null,
                child: _profileImage == null
                    ? const Icon(Icons.camera_alt, color: Colors.white, size: 30)
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: usernameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Username",
                labelStyle: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: dobController,
              readOnly: true,
              onTap: () => _selectDate(context),
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Date of Birth",
                labelStyle: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: cityController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "City",
                labelStyle: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _saveProfile,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
              child: const Text("Save", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
