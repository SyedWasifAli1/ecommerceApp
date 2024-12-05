import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:html' as html;
import 'package:flutter/foundation.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedCategory;
  String _sku = '';
  String _name = '';
  double _price = 0.0;
  double _weight = 0.0;
  String _description = '';
  String? _thumbnailBase64;
  List<String>? _imagesBase64;

  int _stock = 0;
  bool _isLoading = false;

  final ImagePicker _picker = ImagePicker();

  // Fetch categories for dropdown
  Future<List<String>> fetchCategories() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('categories').get();
    return snapshot.docs.map((doc) => doc['title'].toString()).toList();
  }

  // Image picker logic for thumbnail (single image)
  Future<void> pickThumbnail() async {
    if (kIsWeb) {
      final html.FileUploadInputElement uploadInput =
          html.FileUploadInputElement();
      uploadInput.accept = 'image/*';
      uploadInput.click();

      uploadInput.onChange.listen((e) async {
        final files = uploadInput.files;
        if (files!.isEmpty) return;

        final reader = html.FileReader();
        reader.readAsArrayBuffer(files[0]);
        reader.onLoadEnd.listen((e) async {
          final Uint8List data = reader.result as Uint8List;
          setState(() {
            _thumbnailBase64 = base64Encode(data);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Thumbnail selected successfully")),
          );
        });
      });
    } else {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        Uint8List data = await image.readAsBytes();
        setState(() {
          _thumbnailBase64 = base64Encode(data);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Thumbnail selected successfully")),
        );
      }
    }
  }

  // Image picker logic for product images (multiple images)
  Future<void> pickImages() async {
    if (kIsWeb) {
      final html.FileUploadInputElement uploadInput =
          html.FileUploadInputElement();
      uploadInput.accept = 'image/*';
      uploadInput.multiple = true; // Allow multiple files
      uploadInput.click();

      uploadInput.onChange.listen((e) async {
        final files = uploadInput.files;
        if (files!.isEmpty) return;

        List<String> selectedImages = [];

        // Loop through the selected files and convert them to base64
        for (var file in files) {
          final reader = html.FileReader();
          reader.readAsArrayBuffer(file);
          reader.onLoadEnd.listen((e) async {
            final Uint8List data = reader.result as Uint8List;
            selectedImages
                .add(base64Encode(data)); // Add base64 image to the list

            // Update the state only when all images are processed
            if (selectedImages.length == files.length) {
              setState(() {
                _imagesBase64 = selectedImages; // Store the list of images
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Images selected successfully")),
              );
            }
          });
        }
      });
    } else {
      // For non-web platforms, allow selecting multiple images
      final List<XFile>? images = await _picker.pickMultiImage();
      if (images != null && images.isNotEmpty) {
        List<String> selectedImages = [];

        for (var image in images) {
          Uint8List data = await image.readAsBytes();
          selectedImages
              .add(base64Encode(data)); // Convert to base64 and add to list
        }

        setState(() {
          _imagesBase64 = selectedImages; // Store the list of images
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Images selected successfully")),
        );
      }
    }
  }

  // Add product to Firestore with custom ID
  Future<void> addProduct() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      _formKey.currentState!.save();

      try {
        await FirebaseFirestore.instance.collection('products').add({
          'sku': _sku,
          'name': _name,
          'price': _price,
          'weight': _weight,
          'description': _description,
          'thumbnail': _thumbnailBase64,
          'images1': _imagesBase64,
          'category': _selectedCategory,
          'stock': _stock,
          'create_date': DateTime.now(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Product added successfully!")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Build product form
  Widget buildProductForm() {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: "SKU"),
            validator: (value) => value!.isEmpty ? "Please enter SKU" : null,
            onSaved: (value) => _sku = value!,
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: "Name"),
            validator: (value) => value!.isEmpty ? "Please enter name" : null,
            onSaved: (value) => _name = value!,
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: "Price"),
            keyboardType: TextInputType.number,
            validator: (value) => value!.isEmpty ? "Please enter price" : null,
            onSaved: (value) => _price = double.parse(value!),
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: "Weight"),
            keyboardType: TextInputType.number,
            validator: (value) => value!.isEmpty ? "Please enter weight" : null,
            onSaved: (value) => _weight = double.parse(value!),
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: "Description"),
            validator: (value) =>
                value!.isEmpty ? "Please enter description" : null,
            onSaved: (value) => _description = value!,
          ),
          FutureBuilder<List<String>>(
            future: fetchCategories(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              }
              final categories = snapshot.data ?? [];
              return DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedCategory = value),
                decoration: const InputDecoration(labelText: "Category"),
                validator: (value) =>
                    value == null ? "Please select a category" : null,
              );
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: pickThumbnail,
            child: const Text("Select Thumbnail"),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: pickImages,
            child: const Text("Select Product Images"),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: addProduct,
            child: _isLoading
                ? const CircularProgressIndicator()
                : const Text("Add Product"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Product")),
      body: buildProductForm(),
    );
  }
}
