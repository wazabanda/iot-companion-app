import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:csc_4130_iot_application/Handlers/share_preferences/shared_preferences_constants.dart';
import 'package:csc_4130_iot_application/Handlers/share_preferences/shared_preferences_utils.dart';
import 'package:csc_4130_iot_application/Constants/BrandColors.dart';

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
    bool foundNull = false;
    if (serverAddress != null) {
      _serverIpController.text = serverAddress;
    }else{
      serverAddress = "https://iotcloudserver-production.up.railway.app";
      _serverIpController.text = serverAddress;
      foundNull = true;
    }
    if (username != null) {
      _usernameController.text = username;
    }else{
      username="waza";
      _usernameController.text=username;
      foundNull = true;
    }
    if (password != null) {
      _passwordController.text = password;

    }else{
      password="7test@123";
      _passwordController.text=password;
      foundNull = true;
    }

    if(foundNull)
      {
        _submitForm();
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

  Widget _buildInputField(
    TextEditingController controller,
    String label,
    bool isPassword,
    String? Function(String?) validator,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: BrandColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        style: TextStyle(color: BrandColors.textPrimary),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: BrandColors.textSecondary),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: BrandColors.primary.withOpacity(0.3)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: BrandColors.primary.withOpacity(0.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: BrandColors.primary),
          ),
          filled: true,
          fillColor: BrandColors.cardBackground,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        validator: validator,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BrandColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: BrandColors.cardBackground,
        title: Text(
          'Settings',
          style: TextStyle(
            color: BrandColors.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Server Configuration',
                  style: TextStyle(
                    color: BrandColors.primary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                _buildInputField(
                  _serverIpController,
                  'Server IP',
                  false,
                  (value) => value?.isEmpty ?? true ? 'Please enter the server IP' : null,
                ),
                SizedBox(height: 30),
                Text(
                  'Server Credentials',
                  style: TextStyle(
                    color: BrandColors.primary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                _buildInputField(
                  _usernameController,
                  'Username',
                  false,
                  (value) => value?.isEmpty ?? true ? 'Please enter the username' : null,
                ),
                _buildInputField(
                  _passwordController,
                  'Password',
                  true,
                  (value) => value?.isEmpty ?? true ? 'Please enter the password' : null,
                ),
                SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: BrandColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Save Settings',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: BrandColors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
