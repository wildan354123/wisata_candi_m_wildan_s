import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class SignInScreen extends StatefulWidget {

  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  // TODO:1. Deklarasikan variabel
  final TextEditingController _usernamecontroller = TextEditingController();

  final TextEditingController _passwordcontroller = TextEditingController();

  String _errorText = '';

  bool _isSignedIn = false;

  bool _obscurePassword = true;



  Future<Map<String, String>> _retrieveAndDecryptDataFromPrefs(
      Future<SharedPreferences> prefs,
      ) async {
    final SharedPreferences = await prefs;
    final encryptedUsername = SharedPreferences.getString('username') ?? '';
    final encryptedpassword = SharedPreferences.getString('password') ?? '';
    final keyString = SharedPreferences.getString('key') ?? '';
    final ivString = SharedPreferences.getString('iv') ?? '';


    final encrypt.Key key = encrypt.Key.fromBase64(keyString);
    final iv = encrypt.IV.fromBase64(ivString);

    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final decryptedUsername = encrypter.decrypt64(encryptedUsername, iv : iv);
    final decryptedPassword = encrypter.decrypt64(encryptedpassword, iv : iv);

    return {'username' : decryptedUsername, 'password' : decryptedPassword};

  }

  void _signIn() async {
    try {
      final Future<SharedPreferences> prefsFuture =
      SharedPreferences.getInstance();
      final String username = _usernamecontroller.text;
      final String password = _passwordcontroller.text;
      print('Sign in attempt');
      if (username.isNotEmpty && password.isNotEmpty) {
        final SharedPreferences prefs = await prefsFuture;
        final data = await _retrieveAndDecryptDataFromPrefs(prefsFuture);
        if (data.isNotEmpty) {
          final decryptedUsername = data['username'];
          final decryptedPassword = data['password'];
          if (username == decryptedUsername && password == decryptedPassword) {
            _errorText = '';
            _isSignedIn = true;
            prefs.setBool('isSignedIn', true);
// Pemanggilan untuk menghapus semua halaman dalam tumpukan navigasi
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).popUntil((route) => route.isFirst);
            });
// Sign in berhasil, navigasikan ke layar utama
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacementNamed(context, '/');
            });
            print('Sign in succeeded');
          } else {
            print('Username or password is incorrect');
          }
        } else {
          print('No stored credentials found');
        }
      } else {
        print('Username and password cannot be empty');
// Tambahkan pesan untuk kasus ketika username atau password kosong
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //   TODO: 2. pasang appbar
      appBar: AppBar(title: Text('Sign In'),),
      //   TODO: 3. Pasang body
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
                child: Column(
                  // TODO:4 ATUR MAINXISALIGNMENT DAN CROSSASISALIGNMENT
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //   Todo:5. pasang textformfield nama pengguna
                    TextFormField(
                      controller: _usernamecontroller,
                      decoration: InputDecoration(
                        labelText: "Nama pengguna",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    //   TODO 6. Pasang textform kata sandi
                    SizedBox(height: 20,),
                    TextFormField(
                      controller: _passwordcontroller,
                      decoration: InputDecoration(
                        labelText: "kata sandi",
                        errorText: _errorText.isNotEmpty ? _errorText : null,
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          onPressed: (){
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off
                                :Icons.visibility,
                          ),),
                      ),
                      obscureText: _obscurePassword,
                    ),
                    //   Todo 7. pasang elevated sign in
                    SizedBox(height: 20,),
                    ElevatedButton(
                        onPressed: (){
                          _signIn();
                        },
                        child: Text("Sign In")),
                    //   TODO 8. PASANG TEXT BUTTON SIGN UP
                    SizedBox(height: 10,),
                    // TextButton(
                    //     onPressed: (){},
                    //     child: Text("Belum punya akun? daftar di sini")),
                    RichText(
                        text: TextSpan(
                          text: "Belum Punya Akun?",
                          style: TextStyle(fontSize: 16, color: Colors.deepPurple),
                          children: <TextSpan>[
                            TextSpan(
                              text: "Dafatar disini",
                              style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                  fontSize: 16
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = (){
                                  Navigator.pushNamed(context, '/signup');
                                },
                            ),
                          ],
                        )),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
