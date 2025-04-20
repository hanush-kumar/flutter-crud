import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  Map<String, dynamic>? product;
  final _formKey = GlobalKey<FormState>();
  String? name;
  String? description;
  double? price;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    final provider = Provider.of<ProductProvider>(context, listen: false);
    final data = await provider.getProductById(widget.productId);
    setState(() {
      product = data;
      name = data['name'];
      description = data['description'];
      price = double.tryParse(data['price'].toString());
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Details"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final shouldDelete = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Product'),
                  content: const Text(
                      'Are you sure you want to delete this product?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );

              if (shouldDelete == true) {
                await provider.deleteProduct(widget.productId);
                if (context.mounted) {
                  Navigator.pop(context);
                }
              }
            },
          )
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: name,
                      decoration: const InputDecoration(labelText: "Name"),
                      onSaved: (val) => name = val,
                      validator: (val) =>
                          val == null || val.isEmpty ? "Enter name" : null,
                    ),
                    TextFormField(
                      initialValue: description,
                      decoration:
                          const InputDecoration(labelText: "Description"),
                      onSaved: (val) => description = val,
                    ),
                    TextFormField(
                      initialValue: price.toString(),
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Price"),
                      onSaved: (val) =>
                          price = double.tryParse(val ?? '0') ?? 0,
                      validator: (val) =>
                          val == null || double.tryParse(val) == null
                              ? "Enter valid price"
                              : null,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();

                          await provider.updateProduct(widget.productId, {
                            'name': name,
                            'description': description,
                            'price': price,
                          });

                          if (context.mounted) {
                            Navigator.of(context).pop();
                          }
                        }
                      },
                      child: const Text("Save Changes"),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
