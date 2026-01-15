import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pt2flutter/data/repositories/login_repository.dart';
import 'package:pt2flutter/data/services/authentication_services.dart';
import 'package:pt2flutter/data/repositories/product_repository.dart';
import 'package:pt2flutter/presentation/login_vm.dart';
import 'package:pt2flutter/presentation/creation_product_vm.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<IAuthenticationService>(
          create: (context) => AuthenticationService(),
        ),
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
  var selectedIndex = 0; // ← Add this property.

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
                if (isLoggedIn)
                  NavigationDestination(
                    icon: Icon(Icons.add),
                    label: 'Creation Product',
                  ),
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
                    extended: constraints.maxWidth >= 800, // ← Here.
                    destinations: [
                      NavigationRailDestination(
                        icon: Icon(Icons.login),
                        label: Text(isLoggedIn ? 'Logout' : 'Login'),
                      ),
                      if (isLoggedIn)
                        NavigationRailDestination(
                          icon: Icon(Icons.add),
                          label: Text('Creation Product'),
                        ),
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

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LoginViewModel>();

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (vm.currentUser != null) ...[
              Text(
                'Welcome, ${vm.currentUser!.username}!',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  vm.logout();
                },
                child: Text('Logout'),
              ),
            ] else ...[
              TextField(
                decoration: InputDecoration(labelText: 'Username'),
                onChanged: (value) => vm.setUsername(value),
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                onChanged: (value) => vm.setPassword(value),
              ),
              SizedBox(height: 20),
              if (vm.isLoading)
                CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: () async {
                    await vm.login();
                  },
                  child: Text('Login'),
                ),
              if (vm.errorMessage != null) ...[
                SizedBox(height: 20),
                Text(vm.errorMessage!, style: TextStyle(color: Colors.red)),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class CreationProductView extends StatelessWidget {
  const CreationProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Creation Product View'));
  }
}
