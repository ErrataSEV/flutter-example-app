import 'package:flutter/material.dart';
import 'package:form_validation/models/models.dart';
import 'package:form_validation/screens/screens.dart';
import 'package:form_validation/services/services.dart';
import 'package:form_validation/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsServices = Provider.of<ProductsService>(context);
    final authService = Provider.of<AuthService>(context, listen: false);

    if (productsServices.isLoading) return const LoadingScreen();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_outlined),
            onPressed: () {
              authService.logOut();
              Navigator.popAndPushNamed(context, 'login');
            },
          )
        ],
      ),
      body: ListView.builder(
        itemCount: productsServices.products.length,
        itemBuilder: (context, index) => GestureDetector(
            onTap: () {
              productsServices.selectedProduct =
                  productsServices.products[index].copy();
              Navigator.pushNamed(context, 'product');
            },
            child: ProductCard(
              product: productsServices.products[index],
            )),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          productsServices.selectedProduct =
              Product(available: false, name: '', price: 80);
          Navigator.pushNamed(context, 'product');
        },
      ),
    );
  }
}
