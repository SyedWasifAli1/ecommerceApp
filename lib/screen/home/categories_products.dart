import 'dart:convert'; // For base64Decode
import 'dart:typed_data'; // For Uint8List

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/screen/home/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // For navigation

class CategoryDetailPage extends StatelessWidget {
  final String categoryId;

  CategoryDetailPage({Key? key, required this.categoryId}) : super(key: key);

  // Fetch category details by categoryId
  Future<String> fetchCategoryName() async {
    try {
      final categoryDoc = await FirebaseFirestore.instance
          .collection('categories')
          .doc(categoryId) // Fetch category by ID
          .get();

      if (categoryDoc.exists) {
        return categoryDoc['title'] ?? 'Unknown Category';
      } else {
        return 'Category Not Found';
      }
    } catch (e) {
      print('Error fetching category name: $e');
      return 'Error fetching category name';
    }
  }

  // Fetch products from Firestore filtered by categoryId
  Stream<List<Map<String, dynamic>>> fetchProductsByCategory() {
    return FirebaseFirestore.instance
        .collection('products')
        .where('category', isEqualTo: categoryId) // Filter by categoryId
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'name': doc['name'] ?? '',
          'price': doc['price'] ?? 0,
          'images1': doc['images1'] ?? [], // Default to an empty list if null
        };
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<String>(
          future: fetchCategoryName(), // Fetch category name
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('Loading...');
            }

            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            // Display category name in the app bar
            return Text(snapshot.data ?? 'Category Details');
          },
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            GoRouter.of(context).go('/home');
          },
        ),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        // Fetch products
        stream: fetchProductsByCategory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final products = snapshot.data ?? [];

          if (products.isEmpty) {
            return Center(
                child: Text("No products available in this category"));
          }

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:
                  2, // Two items per row, you can adjust this as needed
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            padding: EdgeInsets.all(10),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              final images = product['images1'];

              // Handle base64 decoding for images:
              List<Uint8List> imageBytesList = [];

              if (images is List) {
                // If images is a list, decode each item (assuming base64 strings)
                for (var image in images) {
                  if (image is String && image.isNotEmpty) {
                    try {
                      imageBytesList.add(base64Decode(image));
                    } catch (e) {
                      print('Error decoding base64 image: $e');
                    }
                  }
                }
              } else if (images is String && images.isNotEmpty) {
                // If images is a single base64 string, decode it
                try {
                  imageBytesList.add(base64Decode(images));
                } catch (e) {
                  print('Error decoding base64 image: $e');
                }
              }

              return ProductCard(
                imageUrl: imageBytesList.isNotEmpty
                    ? 'data:image/png;base64,${base64Encode(imageBytesList[0])}'
                    : '', // Convert base64 to URL format
                price: product['price'].toString(),
                onAddToCart: () {
                  // Handle adding to cart functionality here
                  print("Add to Cart clicked for ${product['name']}");
                },
              );
            },
          );
        },
      ),
    );
  }
}
