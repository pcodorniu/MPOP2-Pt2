import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pt2flutter/presentation/login_vm.dart';

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
