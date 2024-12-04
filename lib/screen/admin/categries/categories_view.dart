import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:ecommerce/models/categories.dart';
import 'package:ecommerce/services/categories_service.dart';

class CategoryListScreen extends StatefulWidget {
  @override
  _CategoryListScreenState createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  final CategoriesService _categoriesService = CategoriesService();
  late Future<List<Category>> _categories;
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _categories = _categoriesService.getCategories();
  }

  // Pick image from gallery
  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // Show dialog to add category
  void _showAddCategoryDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Category'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              SizedBox(height: 10),
              _selectedImage != null
                  ? Image.file(_selectedImage!)
                  : IconButton(
                      icon: Icon(Icons.add_a_photo),
                      onPressed: _pickImage,
                    ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final String name = nameController.text.trim();
                final String description = descriptionController.text.trim();
                if (name.isNotEmpty && description.isNotEmpty) {
                  Category newCategory = Category(
                    id: '',
                    name: name,
                    description: description,
                    thumbnail: '',
                  );
                  await _categoriesService.createCategory(newCategory,
                      imageFile: _selectedImage);
                  setState(() {
                    _categories = _categoriesService.getCategories();
                    _selectedImage = null;
                  });
                  Navigator.pop(context);
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  // Show dialog to update category
  void _showUpdateCategoryDialog(Category category) {
    final TextEditingController nameController =
        TextEditingController(text: category.name);
    final TextEditingController descriptionController =
        TextEditingController(text: category.description);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update Category'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              SizedBox(height: 10),
              _selectedImage != null
                  ? Image.file(_selectedImage!)
                  : IconButton(
                      icon: Icon(Icons.add_a_photo),
                      onPressed: _pickImage,
                    ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final String name = nameController.text.trim();
                final String description = descriptionController.text.trim();
                if (name.isNotEmpty && description.isNotEmpty) {
                  Category updatedCategory = Category(
                    id: category.id,
                    name: name,
                    description: description,
                    thumbnail: category.thumbnail,
                  );
                  await _categoriesService.updateCategory(updatedCategory,
                      imageFile: _selectedImage);
                  setState(() {
                    _categories = _categoriesService.getCategories();
                    _selectedImage = null;
                  });
                  Navigator.pop(context);
                }
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  // Delete category
  void _deleteCategory(String categoryId) async {
    await _categoriesService.deleteCategory(categoryId);
    setState(() {
      _categories = _categoriesService.getCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Categories')),
      body: FutureBuilder<List<Category>>(
        future: _categories,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No categories found'));
          }

          final categories = snapshot.data!;

          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return ListTile(
                title: Text(category.name),
                subtitle: Text(category.description),
                leading: (category.thumbnail != null &&
                        category.thumbnail!.isNotEmpty)
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          'https://firebasestorage.googleapis.com/v0/b/authwithfirebase-20a41.appspot.com/o/categories%2FScreenshot%20(7).png?alt=media&token=25a423aa-3204-4bd9-b615-b5d01d30cf75',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            print('Error loading image: $error');
                            return Icon(Icons.broken_image,
                                size: 50, color: Colors.grey);
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                        ))
                    : Icon(Icons.image, size: 50, color: Colors.grey),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteCategory(category.id),
                ),
                onTap: () {
                  _showUpdateCategoryDialog(category);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddCategoryDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
