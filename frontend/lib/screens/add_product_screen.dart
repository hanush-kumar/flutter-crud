// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String description = '';
  double price = 0.0;

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white24),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.amberAccent, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      filled: true,
      fillColor: Colors.white.withOpacity(0.05),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: const Color(0xFF1B1B2F),
      appBar: AppBar(
        title: Text(
          "Add Product",
          style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w600),
        ),
      ),
      body: Center(
        child: GlassmorphicContainer(
          width: MediaQuery.of(context).size.width * 0.9,
          height: 430,
          borderRadius: 20,
          blur: 20,
          alignment: Alignment.center,
          border: 1,
          linearGradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.1),
              Colors.white.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderGradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.3),
              Colors.white.withOpacity(0.1),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextFormField(
                    decoration: _inputDecoration("Product Name"),
                    style: const TextStyle(color: Colors.white),
                    onSaved: (val) => name = val ?? '',
                    validator: (val) =>
                        val == null || val.isEmpty ? "Enter a name" : null,
                  ),
                  TextFormField(
                    decoration: _inputDecoration("Description"),
                    style: const TextStyle(color: Colors.white),
                    onSaved: (val) => description = val ?? '',
                  ),
                  TextFormField(
                    decoration: _inputDecoration("Price"),
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    onSaved: (val) =>
                        price = double.tryParse(val ?? '0') ?? 0.0,
                    validator: (val) =>
                        val == null || double.tryParse(val) == null
                            ? "Enter valid price"
                            : null,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amberAccent,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        await provider.addProduct({
                          'name': name,
                          'description': description,
                          'price': price
                        });

                        if (context.mounted) Navigator.pop(context);
                      }
                    },
                    child: const Text("Add Product"),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
