import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  // TODO: 1. Deklarasikan variabel
  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  String _errorText = '';

  bool _isSignedIn = false;

  bool _obsucurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    //   TODO: 2. Pasang AppBar
      appBar: AppBar(title: Text('Sign In'),),
    //   TODO: 3. Pasang body
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              child: Column(
              //   todo: 4. Atur mainAxisAlignment dan crossAxisAlignment
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // todo: 5. Pasang TextFormField Nama Pengguna
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: "Nama Pengguna",
                    border: OutlineInputBorder(),
                  ),
                ),

                // todo: 6. Pasamg TextFormFiled kata sandi
                SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: "Kata Sandi",
                    errorText: _errorText.isNotEmpty ? _errorText : null,
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      onPressed: (){
                        setState(() {
                          _obsucurePassword = !_obsucurePassword;
                        });
                      },
                      icon: Icon(
                        _obsucurePassword ? Icons.visibility_off
                          : Icons.visibility,)
                    ),
                  ),
                  obscureText: _obsucurePassword,
                ),

                // todo: 7. Pasang ElevatedButton Sign In
                SizedBox(height: 20),
                ElevatedButton(onPressed: (){}, child: Text('Sign In')),
                // todo: 8. Pasang TextButton Sign Up
                SizedBox(height: 10),
                TextButton(onPressed: (){}, child: Text('Belum punya akun? Daftar di sini')),
                RichText(text: TextSpan(text: 'Belum Punya Akun? ',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                  fontSize: 16
                ),
                recognizer: TapGestureRecognizer()
                    ..onTap = () {},
                ),)
              ],
            )),
          ),
        ),
      ),
    );
  }
}

