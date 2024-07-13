import 'package:flutter/material.dart';
import 'ToDoPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _imagePath = 'images/mark.png';

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  void _loadSavedCredentials() async {
    // Dummy data for saved credentials
    String? savedUsername = 'username';
    String? savedPassword = 'password';

    if (savedUsername != null && savedUsername.isNotEmpty && savedPassword != null && savedPassword.isNotEmpty) {
      setState(() {
        _usernameController.text = savedUsername;
        _passwordController.text = savedPassword;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Previous login name and password have been loaded.'),
          action: SnackBarAction(
            label: 'Clear Saved Data',
            onPressed: _clearSavedCredentials,
          ),
        ),
      );
    }
  }

  void _handleLogin() {
    setState(() {
      if (_passwordController.text == 'QWERTY123') {
        _imagePath = 'images/idea.png';
      } else if (_passwordController.text == 'qwerty123') {
        _imagePath = 'images/alg.jpg';
      } else {
        _imagePath = 'images/stop.png';
      }
    });

    _showSaveCredentialsDialog();

    if (_passwordController.text == 'QWERTY123' || _passwordController.text == 'qwerty123') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ToDoPage(),
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Welcome Back ${_usernameController.text}'),
        ),
      );
    }
  }

  void _showSaveCredentialsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Save Credentials'),
          content: const Text('Would you like to save your username and password for the next time you run the application?'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                _clearSavedCredentials();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                _saveCredentials();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _saveCredentials() async {
    // Save credentials logic here
  }

  void _clearSavedCredentials() async {
    // Clear credentials logic here

    setState(() {
      _usernameController.text = '';
      _passwordController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Login name',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _handleLogin,
              child: const Text('Login'),
            ),
            const SizedBox(height: 16),
            Image.asset(
              _imagePath,
              width: 300,
              height: 300,
            ),
          ],
        ),
      ),
    );
    }
}
