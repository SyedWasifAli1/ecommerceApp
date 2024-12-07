import 'dart:convert';

import 'package:ecommerce/screen/home/payment.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:typed_data';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // Variable to hold cart data from Firestore
  List<Map<String, dynamic>> cartItems = [];

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  // Fetch cart items from Firestore
  Future<void> fetchCartItems() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print("No user is logged in.");
      return;
    }

    try {
      // Fetch cart items for the current user
      final cartRef = FirebaseFirestore.instance
          .collection('cart')
          .doc(user.uid)
          .collection('products');

      final snapshot = await cartRef.get();

      print("Cart snapshot: ${snapshot.docs.length} items found.");

      // Parse the cart data
      setState(() {
        cartItems = snapshot.docs.map((doc) {
          final price = doc['price'];

          // Ensure price is converted to a double
          double parsedPrice = price is String
              ? double.tryParse(price) ?? 0.0
              : price.toDouble();

          // Get image byte data
          Uint8List? imageBytes;
          if (doc['image'] != null) {
            imageBytes = doc['image'] is String
                ? base64Decode(doc['image']) // If the image is base64 encoded
                : doc['image']; // If image is stored as byte data
          }

          return {
            'id': doc.id,
            'name': doc['name'],
            'price': parsedPrice,
            'quantity': doc['quantity'],
            'image': imageBytes, // Store the byte data for the image
            'isSelected': false, // Add isSelected to track the checkbox state
          };
        }).toList();
      });
    } catch (e) {
      // Handle any errors while fetching data
      print('Failed to load cart items: $e');
    }
  }

  // Update item quantity in Firestore
  Future<void> updateItemQuantity(String itemId, int quantity) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print("No user is logged in.");
      return;
    }

    try {
      final cartRef = FirebaseFirestore.instance
          .collection('cart')
          .doc(user.uid)
          .collection('products');

      await cartRef.doc(itemId).update({'quantity': quantity});

      // Update the local cartItems list
      setState(() {
        final index = cartItems.indexWhere((item) => item['id'] == itemId);
        if (index != -1) {
          cartItems[index]['quantity'] = quantity;
        }
      });

      print("Quantity updated successfully.");
    } catch (e) {
      print("Failed to update quantity: $e");
    }
  }

  // Delete an item from the cart
  Future<void> deleteItem(String itemId) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print("No user is logged in.");
      return;
    }

    try {
      final cartRef = FirebaseFirestore.instance
          .collection('cart')
          .doc(user.uid)
          .collection('products');

      await cartRef.doc(itemId).delete();

      // Remove the item from the local list as well
      setState(() {
        cartItems.removeWhere((item) => item['id'] == itemId);
      });

      print("Item deleted successfully.");
    } catch (e) {
      print("Failed to delete item: $e");
    }
  }

  // Toggle the checkbox for selecting cart items
  void toggleItemSelection(String itemId) {
    setState(() {
      final index = cartItems.indexWhere((item) => item['id'] == itemId);
      if (index != -1) {
        cartItems[index]['isSelected'] = !cartItems[index]['isSelected'];
      }
    });
  }

  void showCheckoutBottomSheet() {
    // Filter selected items for checkout
    final selectedItems =
        cartItems.where((item) => item['isSelected']).toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Ensures the bottom sheet is scrollable
      builder: (context) {
        // Define controllers for the shipping details form
        final phoneController = TextEditingController();
        final addressController = TextEditingController();
        final streetController = TextEditingController();
        final cityController = TextEditingController();
        final countryController = TextEditingController();

        // Calculate the total price of selected items
        double totalPrice = selectedItems.fold(
            0, (sum, item) => sum + (item['price'] * item['quantity']));

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // Fit the content to screen
              children: [
                Text(
                  'Checkout',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                // List of selected cart items
                ListView.builder(
                  shrinkWrap: true, // Fit content to avoid overflow
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: selectedItems.length,
                  itemBuilder: (context, index) {
                    final item = selectedItems[index];
                    return ListTile(
                      leading: item['image'] != null
                          ? Image.memory(
                              item['image'],
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            )
                          : Icon(Icons.computer, size: 40),
                      title: Text(item['name']),
                      subtitle: Text('Quantity: ${item['quantity']}'),
                      trailing: Text(
                        '\$${(item['price'] * item['quantity']).toStringAsFixed(2)}',
                      ),
                    );
                  },
                ),
                Divider(),
                // Shipping details form
                TextField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 16),
                TextField(
                  controller: addressController,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    prefixIcon: Icon(Icons.location_on),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: streetController,
                  decoration: InputDecoration(
                    labelText: 'Street Address (Optional)',
                    prefixIcon: Icon(Icons.streetview),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: cityController,
                        decoration: InputDecoration(
                          labelText: 'City',
                          prefixIcon: Icon(Icons.location_city),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: countryController,
                        decoration: InputDecoration(
                          labelText: 'Country',
                          prefixIcon: Icon(Icons.flag),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // Total price
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '\$${totalPrice.toStringAsFixed(2)}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // Proceed to payment button
                ElevatedButton(
                  onPressed: () {
                    // Validate inputs
                    if (phoneController.text.isEmpty ||
                        addressController.text.isEmpty ||
                        cityController.text.isEmpty ||
                        countryController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text("Please fill all required fields.")),
                      );
                      return;
                    }

                    // Navigate to the payment page with shipping details
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentPage(
                          shippingDetails: {
                            'phone': phoneController.text,
                            'address': addressController.text,
                            'street': streetController.text,
                            'city': cityController.text,
                            'country': countryController.text,
                          },
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: Text(
                    'Proceed to Payment',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Calculate the total price
    double totalPrice = cartItems.fold(
        0, (sum, item) => sum + (item['price'] * item['quantity']));

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          // Display cart items
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: item['image'] != null
                        ? Image.memory(
                            item['image'],
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          )
                        : Icon(Icons.computer, size: 40),
                    title: Text(
                      item['name'],
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text('Quantity: ${item['quantity']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '\$${(item['price'] * item['quantity']).toStringAsFixed(2)}',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            deleteItem(item['id']); // Delete logic
                          },
                        ),
                        // Increase quantity
                        IconButton(
                          icon: Icon(Icons.add, color: Colors.green),
                          onPressed: () {
                            final newQuantity = item['quantity'] + 1;
                            updateItemQuantity(item['id'],
                                newQuantity); // Update quantity logic
                          },
                        ),
                        // Decrease quantity
                        IconButton(
                          icon: Icon(Icons.remove, color: Colors.orange),
                          onPressed: () {
                            if (item['quantity'] > 1) {
                              final newQuantity = item['quantity'] - 1;
                              updateItemQuantity(item['id'],
                                  newQuantity); // Update quantity logic
                            }
                          },
                        ),
                        // Checkbox to select item for checkout
                        Checkbox(
                          value: item['isSelected'],
                          onChanged: (bool? newValue) {
                            toggleItemSelection(item['id']); // Toggle selection
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Total price and checkout button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: \$${totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: cartItems.any((item) => item['isSelected'])
                      ? showCheckoutBottomSheet // Show checkout if any item is selected
                      : null,
                  child: Text('Proceed to Checkout'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
