import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ecommerce/models/categories.dart';

class CategoriesService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final String collectionPath = 'categories';

  // Fetch all categories
  Future<List<Category>> getCategories() async {
    try {
      final snapshot = await _db.collection(collectionPath).get();
      return snapshot.docs
          .map((doc) => Category.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print("Error fetching categories: $e");
      return [];
    }
  }

  // Create new category
  Future<void> createCategory(Category category, {File? imageFile}) async {
    try {
      String imageUrl = '';
      if (imageFile != null) {
        imageUrl = await _uploadImage(imageFile); // Upload image
      }
      category.thumbnail = imageUrl; // Set image URL in category object
      await _db.collection(collectionPath).add(category.toMap());
    } catch (e) {
      print("Error adding category: $e");
    }
  }

  // Update an existing category
  Future<void> updateCategory(Category category, {File? imageFile}) async {
    try {
      if (imageFile != null) {
        String imageUrl = await _uploadImage(imageFile);
        category.thumbnail = imageUrl;
      }
      await _db
          .collection(collectionPath)
          .doc(category.id)
          .update(category.toMap());
    } catch (e) {
      print("Error updating category: $e");
    }
  }

  // Delete category
  Future<void> deleteCategory(String categoryId) async {
    try {
      await _db.collection(collectionPath).doc(categoryId).delete();
    } catch (e) {
      print("Error deleting category: $e");
    }
  }

  // Upload image to Firebase Storage
  Future<String> _uploadImage(File imageFile) async {
    try {
      // Define a unique path for the image
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final ref = _storage.ref().child('categories/abc.jpg');

      // Upload the image file
      final uploadTask = ref.putFile(imageFile);
      final snapshot = await uploadTask;

      // Get the download URL after upload is complete
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Error uploading image: $e");
      return ''; // Return empty URL in case of error
    }
  }
}
