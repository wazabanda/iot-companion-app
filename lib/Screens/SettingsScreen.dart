import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:csc_4130_iot_application/Handlers/share_preferences/shared_preferences_constants.dart';
import 'package:csc_4130_iot_application/Handlers/share_preferences/shared_preferences_utils.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // TextEditingControllers to manage the input fields
  final TextEditingController _serverIpController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // GlobalKey to manage the form state
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Dispose the controllers when the widget is disposed
    _serverIpController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  // Asynchronous method to load saved settings
  Future<void> _loadSettings() async {
    String? serverAddress = await SharedPrefrencesUtils().getString(keyServerAddress);
    String? username = await SharedPrefrencesUtils().getString(keyUsername);
    String? password = await SharedPrefrencesUtils().getString(keyPassword);

    if (serverAddress != null) {
      _serverIpController.text = serverAddress;
    }
    if (username != null) {
      _usernameController.text = username;
    }
    if (password != null) {
      _passwordController.text = password;
    }
  }

  // Function to handle form submission
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Access the form data
      String serverIp = _serverIpController.text;
      String username = _usernameController.text;
      String password = _passwordController.text;

      // Perform your data manipulation or API call here
      print('Server IP: $serverIp');
      print('Username: $username');
      print('Password: $password');

      // Save the settings using SharedPreferences
      SharedPrefrencesUtils().setString(keyServerAddress, serverIp);
      SharedPrefrencesUtils().setString(keyUsername, username);
      SharedPrefrencesUtils().setString(keyPassword, password);

      // Example: Show a Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Settings saved successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TextFormField for Server IP
              TextFormField(
                controller: _serverIpController,
                decoration: const InputDecoration(
                  labelText: 'Server IP',
                ),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the server IP';
                  }
                  // Add additional validation if needed
                  return null;
                },
              ),
              const SizedBox(height: 40),
              Text("Server Credentials"),
              const SizedBox(height: 20,),
              // TextFormField for Username
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                ),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the username';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // TextFormField for Password
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true, // To obscure the text for passwords
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // Submit Button
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
