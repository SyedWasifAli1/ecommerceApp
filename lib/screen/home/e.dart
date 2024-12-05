import 'dart:convert';
import 'dart:typed_data';
import 'package:ecommerce/screen/home/l.dart';
import 'package:ecommerce/screen/home/widgets/products_list.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:html' as html;
import 'package:flutter/foundation.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final proController = TextEditingController();
  final desController = TextEditingController();
  final priceController = TextEditingController();
  String? selectCatTitle;
  bool isUploading = false;
  List<String> catTitle = [];
  final ImagePicker _picker = ImagePicker();
  String? _uploadedImageBase64;

  @override
  void initState() {
    super.initState();
    fetchCat(); // Fetch categories
  }

  void fetchCat() async {
    // Assume Firestore collection for categories named 'categories'
    final snapshot =
        await FirebaseFirestore.instance.collection('categories').get();
    setState(() {
      catTitle = snapshot.docs.map((doc) => doc['title'] as String).toList();
    });
  }

  Future<void> pickImage() async {
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
            _uploadedImageBase64 = base64Encode(data);
          });
          Fluttertoast.showToast(msg: "Image selected successfully");
        });
      });
    } else {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        Uint8List data = await image.readAsBytes();
        setState(() {
          _uploadedImageBase64 = base64Encode(data);
        });
        Fluttertoast.showToast(msg: "Image selected successfully");
      }
    }
  }

  Future<void> addProductToFirestore() async {
    if (proController.text.isNotEmpty &&
            desController.text.isNotEmpty &&
            priceController.text.isNotEmpty &&
            _uploadedImageBase64 != null
        // selectCatTitle != null
        ) {
      try {
        await FirebaseFirestore.instance.collection('products').add({
          // 'cattitle': selectCatTitle,
          'protitle': proController.text,
          'Description': desController.text,
          'price': priceController.text,
          'Image': _uploadedImageBase64,
          'thumbnail': _uploadedImageBase64,
        });
        Fluttertoast.showToast(msg: "Product added successfully");

        proController.clear();
        desController.clear();
        priceController.clear();
        setState(() {
          selectCatTitle = null;
          _uploadedImageBase64 = null;
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProductList1()),
        );
      } catch (error) {
        Fluttertoast.showToast(msg: "Error adding product: $error");
      }
    } else {
      Fluttertoast.showToast(msg: "Please fill all fields before submitting");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Product"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // DropdownButtonFormField<String>(
            //   decoration: InputDecoration(
            //     labelText: "Select Category",
            //     border: OutlineInputBorder(),
            //   ),
            //   value: selectCatTitle,
            //   items: catTitle.map((String title) {
            //     return DropdownMenuItem<String>(
            //       value: title,
            //       child: Text(title),
            //     );
            //   }).toList(),
            //   onChanged: (String? newValue) {
            //     setState(() {
            //       selectCatTitle = newValue;
            //     });
            //   },
            // ),
            SizedBox(height: 21),
            TextFormField(
              controller: proController,
              decoration: InputDecoration(
                labelText: "Product Title",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 21),
            TextFormField(
              controller: desController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "Product Description",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 21),
            TextFormField(
              controller: priceController,
              decoration: InputDecoration(
                labelText: "Product Price",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 21),
            ElevatedButton(
              onPressed: pickImage,
              child: Text("Select Image"),
            ),
            SizedBox(height: 21),
            ElevatedButton(
              onPressed: addProductToFirestore,
              child: Text("Add Product"),
            ),
          ],
        ),
      ),
    );
  }
}
