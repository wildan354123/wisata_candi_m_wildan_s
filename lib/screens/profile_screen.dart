import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key,});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Todo 1 Deklarasikan variabel yang dibutuhkan
  bool isSignedIn = true;
  String fullName = "";
  String userName = "";
  int favoriteCandiCount = 0;
  late Color iconColor;
  String _imageFile = '';
  final picker = ImagePicker();

  Future<void> _saveImageToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('imagePath', _imageFile);
  }
  Future<void> _loadImageFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _imageFile = prefs.getString('imagePath') ?? '';
    });
  }

  Future<void> _getImage(ImageSource source) async {
    if (kIsWeb && source == ImageSource.camera) {
      return;
    }
    final pickedFile = await picker.pickImage(
      source: source,
      maxHeight: 720,
      maxWidth: 720,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile.path;
      });
      _saveImageToPrefs();
    }
  }
  void _showPicker(){
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context){
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  'Image Source',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Gallery'),
                onTap: (){
                  Navigator.of(context).pop();
                  _getImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Camera'),
                onTap: (){
                  Navigator.of(context).pop();
                  _getImage(ImageSource.camera);
                },
              ),
            ],
          );
        });
  }

  // Todo 5 Implementasi Fungsi Sign In
  void signIn(){
    // setState(() {
    //   isSignedIn = 'true';
    //   userName = 'budi';
    //   fullName = 'Budi Santoso';
    //   favoriteCandiCount = 3;
    // });
    Navigator.pushNamed(context, '/signin');
  }
  // Todo 6 Implementasi Fungsi Sign Out
  void signOut(){
    setState(() {
      isSignedIn = !isSignedIn;
    });
  }

  Future<Map<String, String>> _retrieveAndDecryptDataFromPrefs(
      SharedPreferences prefs) async {
    final encryptedUsername = prefs.getString('username') ?? '';
    final encryptedName = prefs.getString('fullname') ?? '';
    final keyString = prefs.getString('key') ?? '';
    final ivString = prefs.getString('iv') ?? '';

    if (keyString.isEmpty || ivString.isEmpty || encryptedUsername.isEmpty || encryptedName.isEmpty) {
      throw Exception('Data terenkripsi tidak ditemukan!');
    }

    try {
      final key = encrypt.Key.fromBase64(keyString);
      final iv = encrypt.IV.fromBase64(ivString);
      final encrypter = encrypt.Encrypter(encrypt.AES(key));
      final decryptedUsername = encrypter.decrypt64(encryptedUsername, iv: iv);
      final decryptedName = encrypter.decrypt64(encryptedName, iv: iv);

      return {'username': decryptedUsername, 'fullname' : decryptedName};
    } catch (e) {
      return {'username': 'Gagal Dekripsi'};
    }
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    final data = await _retrieveAndDecryptDataFromPrefs(prefs);
    setState(() {
      userName = data['username'] ?? '';
      fullName = data ['fullname'] ?? '';
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadImageFromPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: 200,
            width: double.infinity,
            color: Colors.deepPurple,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                //   TODO 2 Buat bagian Profile header yang berisi gambar profile
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 200-50),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.deepPurple, width: 2),
                              shape: BoxShape.circle
                          ),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: _imageFile.isNotEmpty
                                ? (kIsWeb
                                ? NetworkImage(_imageFile)
                                : FileImage(File(_imageFile))) as ImageProvider
                                : AssetImage('images/placeholder_image.png'),
                          ),
                        ),
                        if (isSignedIn)
                          IconButton(
                            onPressed: (){
                              _showPicker();
                            },
                            icon: Icon(Icons.camera_alt, color: Colors.deepPurple[50],),),
                      ],
                    ),
                  ),
                ),
                //   TODO 3. buat bagian profile info yang berisi info profile
                SizedBox(height: 20,),
                Divider(color: Colors.deepPurple[100]),
                SizedBox(height: 4,),
                Row(
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width/3,
                      child: Row(
                        children: [
                          Icon(Icons.lock, color: Colors.amber,),
                          SizedBox(width: 8,),
                          Text('Pengguna', style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold,
                          ),),
                        ],
                      ),),
                    Expanded(
                      child: Text(': $userName' , style: TextStyle(
                          fontSize: 18),),),
                  ],
                ),
                SizedBox(height: 4,),
                Divider(color: Colors.deepPurple[100],),
                SizedBox(height: 4,),
                Row(
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width/3,
                      child: Row(
                        children: [
                          Icon(Icons.person, color: Colors.blue),
                          SizedBox(width: 8,),
                          Text('Nama' , style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold,
                          ),)
                        ],
                      ),),
                    Expanded(
                      child: Text(': $fullName', style: TextStyle(
                          fontSize: 18),),),
                  ],
                ),
                SizedBox(height: 4,),
                Divider(color: Colors.deepPurple[100],),
                SizedBox(height: 4,),
                Row(
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width/3,
                      child: Row(
                        children: [
                          Icon(Icons.favorite, color: Colors.red),
                          SizedBox(width: 8,),
                          Text('Favorite' , style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold,
                          ),)
                        ],
                      ),),
                    Expanded(
                      child: Text(': $favoriteCandiCount', style: TextStyle(
                          fontSize: 18),),),
                  ],
                ),
                //   TODO 4 buat profileAction yang berisi text Button sign in /out
                SizedBox(height: 4,),
                Divider(color: Colors.deepPurple[100],),
                SizedBox(height: 20,),
                isSignedIn ? TextButton(onPressed: signOut, child: Text('Sign Out'))
                    :TextButton(onPressed: signIn, child: Text('Sign In'))
              ],
            ),
          )
        ],
      ),
    );
  }
}