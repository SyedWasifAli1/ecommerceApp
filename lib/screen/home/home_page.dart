import 'package:ecommerce/screen/home/widgets/categories_section.dart';
import 'package:ecommerce/screen/home/widgets/hero_section.dart';
import 'package:ecommerce/screen/home/widgets/hero_section_slider.dart';
import 'package:ecommerce/screen/home/widgets/products_list.dart';
import 'package:ecommerce/screen/home/widgets/seacrh_field.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchField(),
          // HeroSection(),
          HeroSectionSlider(),
          CategoriesSection(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Products',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          ProductList(),
        ],
      ),
    );
  }
}
