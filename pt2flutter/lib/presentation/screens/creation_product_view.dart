import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pt2flutter/presentation/creation_product_vm.dart';
import 'package:pt2flutter/presentation/login_vm.dart';

class CreationProductView extends StatefulWidget {
  const CreationProductView({super.key});

  @override
  State<CreationProductView> createState() => _CreationProductViewState();
}

class _CreationProductViewState extends State<CreationProductView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CreationProductViewModel>();
    final loginVm = context.read<LoginViewModel>();
    final token = loginVm.currentUser?.accessToken ?? '';
    final userId = loginVm.currentUser?.id ?? '';

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Add New Product',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Product Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              if (vm.isLoading)
                CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final success = await vm.createProduct(
                        title: _titleController.text,
                        price: double.parse(_priceController.text),
                        description: _descriptionController.text,
                        userId: userId,
                        token: token,
                      );
                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(vm.successMessage!)),
                        );
                        _titleController.clear();
                        _priceController.clear();
                        _descriptionController.clear();
                      }
                    }
                  },
                  child: Text('Create Product'),
                ),
              if (vm.errorMessage != null) ...[
                SizedBox(height: 20),
                Text(vm.errorMessage!, style: TextStyle(color: Colors.red)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
