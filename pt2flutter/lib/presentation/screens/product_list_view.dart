import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pt2flutter/presentation/product_list_vm.dart';
import 'package:pt2flutter/presentation/login_vm.dart';

class ProductListView extends StatefulWidget {
  const ProductListView({super.key});

  @override
  State<ProductListView> createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final loginVm = context.read<LoginViewModel>();
      final token = loginVm.currentUser?.accessToken ?? '';
      context.read<ProductListViewModel>().fetchProducts(token);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProductListViewModel>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text('My Products'),
        backgroundColor: Colors.transparent,
      ),
      body: vm.isLoading
          ? Center(child: CircularProgressIndicator())
          : vm.errorMessage != null
          ? Center(child: Text(vm.errorMessage!))
          : vm.products.isEmpty
          ? Center(child: Text('No products found'))
          : ListView.builder(
              itemCount: vm.products.length,
              itemBuilder: (context, index) {
                final product = vm.products[index];
                return ListTile(
                  title: Text(product.title),
                  subtitle: Text(
                    '${product.description}\n\$${product.price.toStringAsFixed(2)}',
                  ),
                  isThreeLine: true,
                );
              },
            ),
    );
  }
}
