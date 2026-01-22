import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pt2flutter/data/repositories/login_repository.dart';
import 'package:pt2flutter/data/services/authentication_services.dart';
import 'package:pt2flutter/data/repositories/product_repository.dart';
import 'package:pt2flutter/data/services/product_services.dart';
import 'package:pt2flutter/presentation/login_vm.dart';
import 'package:pt2flutter/presentation/creation_product_vm.dart';
import 'package:pt2flutter/presentation/product_list_vm.dart';
import 'package:pt2flutter/presentation/screens/login_view.dart';
import 'package:pt2flutter/presentation/screens/creation_product_view.dart';
import 'package:pt2flutter/presentation/screens/product_list_view.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<IAuthenticationService>(
          create: (context) => AuthenticationService(),
        ),
        Provider<IProductService>(create: (context) => ProductService()),
        Provider<ILoginRepository>(
          create: (context) =>
              LoginRepository(authenticationService: context.read()),
        ),
        Provider<IProductRepository>(
          create: (context) =>
              ProductRepository(productService: context.read()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LoginViewModel(loginRepository: context.read()),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              CreationProductViewModel(productRepository: context.read()),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              ProductListViewModel(productRepository: context.read()),
        ),
      ],
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final loginVm = context.watch<LoginViewModel>();
    final isLoggedIn = loginVm.currentUser != null;

    Widget page;
    switch (selectedIndex) {
      case 0:
        page = LoginView();
        break;
      case 1:
        page = CreationProductView();
        break;
      case 2:
        page = ProductListView();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 450) {
          return Scaffold(
            body: Row(children: [MainArea(page: page)]),
            bottomNavigationBar: NavigationBar(
              destinations: [
                NavigationDestination(
                  icon: Icon(Icons.login),
                  label: isLoggedIn ? 'Logout' : 'Login',
                ),
                if (isLoggedIn) ...[
                  NavigationDestination(
                    icon: Icon(Icons.add),
                    label: 'Add Product',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.list),
                    label: 'Products',
                  ),
                ],
              ],
              selectedIndex: selectedIndex,
              onDestinationSelected: (value) {
                setState(() {
                  selectedIndex = value;
                });
              },
            ),
          );
        } else {
          return Scaffold(
            body: Row(
              children: [
                SafeArea(
                  child: NavigationRail(
                    extended: constraints.maxWidth >= 800,
                    destinations: [
                      NavigationRailDestination(
                        icon: Icon(Icons.login),
                        label: Text(isLoggedIn ? 'Logout' : 'Login'),
                      ),
                      if (isLoggedIn) ...[
                        NavigationRailDestination(
                          icon: Icon(Icons.add),
                          label: Text('Add Product'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.list),
                          label: Text('Products'),
                        ),
                      ],
                    ],
                    selectedIndex: selectedIndex,
                    onDestinationSelected: (value) {
                      setState(() {
                        selectedIndex = value;
                      });
                    },
                  ),
                ),
                MainArea(page: page),
              ],
            ),
          );
        }
      },
    );
  }
}

class MainArea extends StatelessWidget {
  const MainArea({super.key, required this.page});

  final Widget page;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: page,
      ),
    );
  }
}
