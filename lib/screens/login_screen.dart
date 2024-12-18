import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orbit/colors.dart';
import 'package:orbit/screens/home_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../UserData.dart';
import '../mongodb.dart';
import '../responsive.dart';
import '../utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _passwordVisible = false;

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      var user = await MongoDatabase.getUser(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (user != null) {
        String managerName = user['username'];
        String floorNumber = await MongoDatabase.getFloorForManager(managerName) ?? 'N/A';
        UserData().username = managerName;
        UserData().floor = floorNumber;
        UserData().setEmail = _emailController.text.trim();

        setState(() => _isLoading = false);
        showSnackbar(context, 'Login Successful', backgroundColor: Colors.green);

        _emailController.clear();
        _passwordController.clear();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const homeScreen()),
        );
      } else {
        setState(() => _isLoading = false);
        toastMessage("Invalid credentials or role is not Floor Manager");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: SizedBox(
            height: getheight(context),
            width: getwidth(context),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Login To Your Account",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontSize: 26,
                    ),
                  ),
                  SizedBox(height: getheight(context) * 0.02),
                  const Text(
                    "Provide email and password to continue",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.black87,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: getheight(context) * 0.05),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: getwidth(context) * 0.05),
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Field required';
                        } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$').hasMatch(value)) {
                          return 'Enter a valid Gmail address (e.g., example@gmail.com)';
                        }
                        return null;
                      },

                      style: const TextStyle(color: Colors.black),
                      controller: _emailController,
                      cursorColor: AppColors.primaryColor,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.mail_outline_rounded),
                        errorStyle: const TextStyle(color: Colors.red),
                        border: const OutlineInputBorder(),
                        label: const Text("Email Address"),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black87),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black87),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: getheight(context) * 0.02),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: getwidth(context) * 0.05),
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Field required';
                        }
                        return null;
                      },
                      style: const TextStyle(color: Colors.black),
                      controller: _passwordController,
                      cursorColor: AppColors.primaryColor,
                      obscureText: !_passwordVisible,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock_open_rounded),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible ? Icons.visibility : Icons.visibility_off,
                            color: Colors.black87,
                          ),
                          onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
                        ),
                        errorStyle: const TextStyle(color: Colors.red),
                        border: const OutlineInputBorder(),
                        label: const Text("Password"),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black87),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black87),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: getheight(context) * 0.05),
                  GestureDetector(
                    onTap: _isLoading ? null : _handleLogin,
                    child: Container(
                      height: getheight(context) * 0.055,
                      width: getwidth(context) * 0.55,
                      decoration: BoxDecoration(
                        color: _isLoading ? Colors.grey : AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Center(
                        child: _isLoading
                            ? const SpinKitFadingCircle(
                          color: Colors.white,
                          size: 30.0,
                        )
                            : const Text(
                          "Verify",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
