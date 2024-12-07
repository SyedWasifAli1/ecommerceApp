import 'dart:convert'; // For base64Decode
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart'; // Import go_router
import 'package:firebase_auth/firebase_auth.dart';
class ProductDetailPage extends StatefulWidget {
  final String productId;

  const ProductDetailPage({Key? key, required this.productId})
      : super(key: key);

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  Map<String, dynamic>? product;
  bool isLoading = true;
  bool isAddedToCart = false;
  bool isOutOfStock = false;
  int selectedImageIndex = 0;

  // Fetch product details by ID from Firestore
  Future<void> fetchProductDetails() async {
    try {
      final productDoc = await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.productId)
          .get();

      if (productDoc.exists) {
        setState(() {
          product = productDoc.data();
          isLoading = false;
          isOutOfStock = product!['stock'] <= 0;
        });

        // Check if product is already in the cart
        isAddedToCart = await _checkIfAddedToCart();
      } else {
        throw Exception("Product not found");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load product details: $e')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  // Check if product is already added to the cart using SharedPreferences
  Future<bool> _checkIfAddedToCart() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? cartItems = prefs.getStringList('cartItems') ?? [];
    return cartItems.contains(widget.productId);
  }

  @override
  void initState() {
    super.initState();
    fetchProductDetails();
  }

  // Add the product to the cart
Future<void> _addToCart() async {
  try {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please log in to add items to the cart.')),
      );
      return;
    }

    final cartRef = FirebaseFirestore.instance
        .collection('cart')
        .doc(user.uid)
        .collection('products');

    final productId = widget.productId;

    // Check if the product is already in the cart
    final existingProduct = await cartRef.doc(productId).get();
    if (existingProduct.exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product is already in the cart.')),
      );
      return;
    }

    // Add product to the cart
    await cartRef.doc(productId).set({
      'name': product!['name'],
      'price': product!['price'],
      'quantity': 1, // Default quantity
      'image': product!['images1']?.first, // Thumbnail image (if available)
    });

    setState(() {
      isAddedToCart = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${product!['name']} added to cart!')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to add to cart: $e')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text("Product Details")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (product == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Product Details")),
        body: Center(child: Text("Product not found")),
      );
    }

    final images = product!['images1'] as List<dynamic>? ?? [];
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(product!['name'] ?? 'Product Details'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            GoRouter.of(context).go('/home');
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: screenWidth > 800
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image on the left
                  Expanded(
                    flex: 4,
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: images.isNotEmpty
                              ? Image.memory(
                                  base64Decode(images[selectedImageIndex]),
                                  width: double.infinity,
                                  height: 400,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  height: 400,
                                  color: Colors.grey,
                                  child: Icon(
                                    Icons.broken_image,
                                    size: 48,
                                  ),
                                ),
                        ),
                        SizedBox(height: 16),
                        // Thumbnails
                        if (images.isNotEmpty)
                          SizedBox(
                            height: 100,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: images.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedImageIndex = index;
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: selectedImageIndex == index
                                            ? Colors.blue
                                            : Colors.transparent,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.memory(
                                        base64Decode(images[index]),
                                        fit: BoxFit.cover,
                                        width: 100,
                                        height: 100,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(width: 24),
                  // Product details on the right
                  Expanded(
                    flex: 6,
                    child: _buildProductDetails(context),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: images.isNotEmpty
                        ? Image.memory(
                            base64Decode(images[selectedImageIndex]),
                            width: screenWidth * 0.9,
                            height: screenWidth * 0.6,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            width: screenWidth * 0.9,
                            height: screenWidth * 0.6,
                            color: Colors.grey,
                            child: Icon(
                              Icons.broken_image,
                              size: 48,
                            ),
                          ),
                  ),
                  SizedBox(height: 16),
                  if (images.isNotEmpty)
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: images.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedImageIndex = index;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: selectedImageIndex == index
                                      ? Colors.blue
                                      : Colors.transparent,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.memory(
                                  base64Decode(images[index]),
                                  fit: BoxFit.cover,
                                  width: 100,
                                  height: 100,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  SizedBox(height: 16),
                  _buildProductDetails(context),
                ],
              ),
      ),
    );
  }

  Widget _buildProductDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product!['name'] ?? 'No name available',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Text(
              'Rs. ${product!['price']}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Text(
              'SKU: ${product!['sku']}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(width: 16),
            Text(
              'Category: ${product!['category']}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        SizedBox(height: 8),
        Text(
          'Weight: ${product!['weight']} kg',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 8),
        Text(
          'Stock: ${product!['stock']} units',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 24),
        Text(
          product!['description'] ?? 'No description available.',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 24),
        isOutOfStock
            ? Text(
                'Out of stock',
                style: TextStyle(color: Colors.red, fontSize: 18),
              )
            : ElevatedButton(
                onPressed: isAddedToCart ? null : _addToCart,
                child: Text(isAddedToCart ? 'Added to Cart' : 'Add to Cart'),
              ),
      ],
    );
  }
}
