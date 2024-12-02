import 'package:flutter/material.dart';

class ProductDetail extends StatelessWidget {
  final Map<String, String> product;

  const ProductDetail({required this.product});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(product['name']!),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: screenWidth > 800 // Check for large screens
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image on the left
                    Expanded(
                      flex: 4,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          product['image']!,
                          width: double.infinity,
                          height: 400,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 400,
                              color: Colors.grey,
                              child: Icon(
                                Icons.broken_image,
                                size: 48,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: 24), // Space between image and details
                    // Details on the right
                    Expanded(
                      flex: 6,
                      child: _buildProductDetails(context),
                    ),
                  ],
                )
              : Column(
                  // Stack image and details for smaller screens
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Responsive Image
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          product['image']!,
                          width: screenWidth * 0.9,
                          height: screenWidth * 0.6,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: screenWidth * 0.9,
                              height: screenWidth * 0.6,
                              color: Colors.grey,
                              child: Icon(
                                Icons.broken_image,
                                size: 48,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    _buildProductDetails(context),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildProductDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product Name
        Text(
          product['name']!,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        SizedBox(height: 8),
        // Product Price
        Text(
          '\$${product['price']}',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
        ),
        SizedBox(height: 16),
        // Product Description
        Text(
          'Product Description',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        SizedBox(height: 8),
        Text(
          'This is a placeholder description for ${product['name']}. More details can be added here.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        SizedBox(height: 16),
        // Rating Section
        Row(
          children: [
            Text(
              'Rating:',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(width: 8),
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  index < 4 ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                );
              }),
            ),
          ],
        ),
        SizedBox(height: 16),
        // Customer Feedback Section
        Text(
          'Customer Feedback',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12.0),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'This product is amazing! Highly recommend it to others. The quality is top-notch.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        SizedBox(height: 16),
        // Action Buttons
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // Add to Cart functionality
                },
                child: Text('Add to Cart'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // Buy Now functionality
                },
                child: Text('Buy Now'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
