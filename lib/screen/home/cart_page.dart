import 'package:flutter/material.dart';

class CartPage extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems = [
    {
      'name': 'Logitech G305 LIGHTSPEED Wireless Gaming Mouse',
      'price': 39.97,
    },
    {
      'name': 'Redragon K556 RGB LED Backlit Wired Mechanical Gaming Keyboard',
      'price': 59.99,
    },
    {
      'name': 'Razer DeathAdder Essential Gaming Mouse: 6400 DPI',
      'price': 25.03,
    },
    {
      'name': 'Redragon M908 Impact RGB LED MMO Gaming Mouse',
      'price': 19.73,
    },
    {
      'name': 'Lenovo IdeaPad',
      'price': 417.55,
    },
    {
      'name': 'Lenovo IdeaPad',
      'price': 417.55,
    },
    {
      'name': 'Lenovo IdeaPad',
      'price': 417.55,
    },
    {
      'name': 'Lenovo IdeaPad',
      'price': 417.55,
    },
  ];

  @override
  Widget build(BuildContext context) {
    double totalPrice = cartItems.fold(0, (sum, item) => sum + item['price']);

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: Icon(Icons.computer, size: 40),
                    title: Text(
                      item['name'],
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    trailing: Text(
                      '\$${item['price'].toStringAsFixed(2)}',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total (${cartItems.length} items)',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '\$${totalPrice.toStringAsFixed(2)}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Add your checkout logic here
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 64),
                  ),
                  child: Text(
                    'Checkout',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
