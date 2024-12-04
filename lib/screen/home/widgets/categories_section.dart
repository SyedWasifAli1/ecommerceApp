import 'package:flutter/material.dart';

class CategoriesSection extends StatelessWidget {
  // Dummy data for categories
  final List<Map<String, String>> categoriesData = [
    {
      "image":
          "https://tse4.mm.bing.net/th?id=OIP.pLkz2kXu8wy0FPxjy5U1OwHaFk&pid=Api&P=0&h=220",
      "name": "Electronics"
    },
    {
      "image":
          "https://sp.yimg.com/ib/th?id=OPHS.AK3xL1ouxWD5fA474C474&o=5&pid=21.1&w=160&h=105",
      "name": "Fashion"
    },
    {"image": "https://via.placeholder.com/100", "name": "Grocery"},
    {"image": "https://via.placeholder.com/100", "name": "Home Decor"},
    {"image": "https://via.placeholder.com/100", "name": "Toys"},
    {"image": "https://via.placeholder.com/100", "name": "Toys"},
    {"image": "https://via.placeholder.com/100", "name": "Toys"},
    {"image": "https://via.placeholder.com/100", "name": "Toys"},
    {"image": "https://via.placeholder.com/100", "name": "Toys"},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 16.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Check if the screen is wide (for tablets/desktops)
          bool isLargeScreen =
              constraints.maxWidth > 600; // You can adjust this breakpoint

          // Set height for categories
          double heightFactor =
              isLargeScreen ? 0.15 : 0.25; // Less height on large screens

          // Set radius and font size based on screen size
          double radiusFactor = isLargeScreen ? 0.03 : 0.08;
          double fontSizeFactor = isLargeScreen ? 0.01 : 0.03;

          return Column(
            children: [
              // More Button
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () {
                    // Functionality for more categories
                  },
                  child: Text(
                    "More",
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              // Categories Section with ListView
              SizedBox(
                height: constraints.maxWidth *
                    heightFactor, // Responsive height for the categories
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categoriesData.length,
                  itemBuilder: (context, index) {
                    final category = categoriesData[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        children: [
                          // Circular image with border for categories
                          Container(
                            child: CircleAvatar(
                              radius: constraints.maxWidth *
                                  radiusFactor, // Responsive size
                              backgroundImage: NetworkImage(category["image"]!),
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Category name
                          Text(
                            category["name"]!,
                            style: TextStyle(
                              fontSize: constraints.maxWidth *
                                  fontSizeFactor, // Responsive text size
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
