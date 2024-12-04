import 'package:ecommerce/screen/home/widgets/product_d.dart';
import 'package:ecommerce/screen/home/widgets/productdetail.dart';
import 'package:flutter/material.dart';

class ProductList extends StatelessWidget {
  final List<Map<String, String>> products = [
    {
      'name': 'Product 1',
      'price': '29.99',
      'image':
          'https://images.pexels.com/photos/2693644/pexels-photo-2693644.jpeg?auto=compress&cs=tinysrgb&w=600',
    },
    {
      'name': 'Product 1',
      'price': '29.99',
      'image':
          'https://images.pexels.com/photos/2697786/pexels-photo-2697786.jpeg?auto=compress&cs=tinysrgb&w=600',
    },
    {
      'name': 'Product 2',
      'price': '59.99',
      'image':
          'https://images.pexels.com/photos/2536965/pexels-photo-2536965.jpeg?auto=compress&cs=tinysrgb&w=600',
    },
    {
      'name': 'Product 3',
      'price': '19.99',
      'image':
          'https://images.pexels.com/photos/90946/pexels-photo-90946.jpeg?auto=compress&cs=tinysrgb&w=600',
    },
    {
      'name': 'Product 4',
      'price': '99.99',
      'image':
          'https://images.pexels.com/photos/2533266/pexels-photo-2533266.jpeg?auto=compress&cs=tinysrgb&w=600',
    },
    {
      'name': 'Men High Quality',
      'image':
          'https://images.pexels.com/photos/2533266/pexels-photo-2533266.jpeg?auto=compress&cs=tinysrgb&w=600',
      'price': '1,399',
      'oldPrice': '2,799',
      'rating': '4.1',
      'sold': '3.5K',
      'delivery': 'Guaranteed by 9-12 Dec',
      'returnPolicy': '14 days easy return',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 1200
        ? 6
        : screenWidth > 800
            ? 4
            : screenWidth > 600
                ? 3
                : 3;

    final childAspectRatio = screenWidth > 600 ? 0.7 : 0.7;

    // Set responsive font sizes
    double headingFontSize = screenWidth > 800 ? 18.0 : 10.0;
    double priceFontSize = screenWidth > 800 ? 16.0 : 8.0;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: childAspectRatio,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailScreen(
                    product: product,
                  ),
                ),
              );
            },
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: AspectRatio(
                      aspectRatio: 1, // Ensures the image is square
                      child: Image.network(
                        product['image']!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey,
                            child: Center(
                              child: Icon(
                                Icons.broken_image,
                                size: 48,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      product['name']!,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: headingFontSize,
                          ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      product['price'] != null
                          ? 'Rs. ${product['price']}'
                          : 'Rs. 0.00', // Fallback for null price
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Colors.blue,
                            fontSize: priceFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
