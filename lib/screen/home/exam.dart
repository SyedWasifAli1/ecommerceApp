import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:typed_data';

class UserCRUDPage extends StatefulWidget {
  @override
  _UserCRUDPageState createState() => _UserCRUDPageState();
}

class _UserCRUDPageState extends State<UserCRUDPage> {
  final TextEditingController _nameController = TextEditingController();
  XFile? _pickedImage;
  Uint8List? _webImageBytes;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> _pickImageAndAddUser() async {
    try {
      XFile? file;
      Uint8List? imageBytes;
      String? fileName;

      if (kIsWeb) {
        // For Web
        ImagePicker picker = ImagePicker();
        file = await picker.pickImage(source: ImageSource.gallery);
        if (file != null) {
          imageBytes = await file.readAsBytes();
          fileName = file.name; // Get file name for Web
          setState(() {
            _webImageBytes = imageBytes;
            _pickedImage = file;
          });
        } else {
          print('No image selected');
          return;
        }
      } else {
        // For Android/iOS
        ImagePicker picker = ImagePicker();
        file = await picker.pickImage(source: ImageSource.gallery);
        if (file != null) {
          fileName = file.name; // Get file name for Mobile
          setState(() {
            _pickedImage = file;
          });
        } else {
          print('No image selected');
          return;
        }
      }

      // Generate a unique filename
      String uniqueFileName =
          '${DateTime.now().microsecondsSinceEpoch}_$fileName';

      // Create a reference to Firebase Storage
      Reference storageRoot = FirebaseStorage.instance.ref();
      Reference imagesFolder = storageRoot.child('images');
      Reference imageFile = imagesFolder.child(uniqueFileName);

      // Upload to Firebase Storage
      if (kIsWeb) {
        // Upload for Web
        await imageFile.putData(imageBytes!);
      } else {
        // Upload for Mobile
        await imageFile.putFile(File(file!.path));
      }

      // Get the download URL
      String downloadURL = await imageFile.getDownloadURL();

      // Save to Firestore
      if (_nameController.text.isNotEmpty) {
        await _firestore.collection('users').add({
          'name': _nameController.text,
          'imageUrl': downloadURL,
          'fileName': fileName,
          'uniqueName': uniqueFileName,
        });
        print('User details saved to Firestore.');
      } else {
        print('Please provide a name');
      }

      // Clear the input fields
      _nameController.clear();
      setState(() {
        _pickedImage = null;
        _webImageBytes = null;
      });

      // Print success
      print('Image uploaded successfully.');
      print('File Name: $fileName');
      print('Unique Name: $uniqueFileName');
      print('URL: $downloadURL');
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User CRUD')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
          ),
          if (_pickedImage != null)
            Container(
              height: 100,
              width: 100,
              margin: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
                image: DecorationImage(
                  image: kIsWeb
                      ? MemoryImage(_webImageBytes!)
                      : FileImage(File(_pickedImage!.path)) as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ElevatedButton(
            onPressed: _pickImageAndAddUser,
            child: Text('Pick Image & Add User'),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                final docs = snapshot.data?.docs ?? [];
                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final user = docs[index];
                    final name = user['name'];
                    final imageUrl = user['imageUrl'];

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(imageUrl),
                      ),
                      title: Text(name),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
