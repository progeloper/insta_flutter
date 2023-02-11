import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_flutter/utils/colors.dart';
import 'package:insta_flutter/widgets/text_field_input.dart';
import 'package:insta_flutter/resources/auth_methods.dart';
import 'package:insta_flutter/utils/utils.dart';
import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/web_screen_layout.dart';
import '../utils/global_variables.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _bioController = TextEditingController();
  Uint8List? _image;
  bool isLoading = false;

  void selectImage() async {
    Uint8List imgSource = await pickImage(ImageSource.gallery);
    setState(() {
      _image = imgSource;
    });
  }

  void signupUser() async {
    setState(() {
      isLoading = true;
    });
    String res = 'No image selected';
    if (_image != null) {
      res = await AuthMethods().signUpUser(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        bio: _bioController.text,
        file: _image!,
      );
    }

    setState(() {
      isLoading = false;
    });
    if (res != 'success') {
      showSnackBar(context, 'An error occured');
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResponsiveLayout(
            mobileScreenLayout: MobileScreenLayout(),
            webScreenLayout: WebScreenLayout(),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: MediaQuery.of(context).size.width > webScreenSize
              ? EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 3)
              : const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Flexible(
                flex: 1,
                child: Container(),
              ),
              Hero(
                tag: 'logo',
                child: SvgPicture.asset(
                  'assets/ic_instagram.svg',
                  color: primaryColor,
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Stack(
                children: [
                  (_image != null)
                      ? CircleAvatar(
                          radius: 64.0,
                          backgroundImage: MemoryImage(_image!),
                        )
                      : const CircleAvatar(
                          radius: 64.0,
                          backgroundImage: NetworkImage(
                              'https://i.pinimg.com/originals/4a/cf/16/4acf16a2999a4c6dfdfe03f198b95b13.jpg'),
                        ),
                  Positioned(
                      bottom: -10,
                      left: 80,
                      child: IconButton(
                        onPressed: () {
                          selectImage();
                        },
                        icon: const Icon(
                          Icons.add_a_photo_rounded,
                          color: primaryColor,
                        ),
                      ))
                ],
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextFieldInput(
                controller: _usernameController,
                hintText: 'Enter your username',
                keyboardType: TextInputType.text,
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextFieldInput(
                controller: _emailController,
                hintText: 'Enter your email address',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextFieldInput(
                controller: _passwordController,
                hintText: 'Enter your password',
                keyboardType: TextInputType.text,
                isPassword: true,
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextFieldInput(
                controller: _bioController,
                hintText: 'Enter your bio',
                keyboardType: TextInputType.text,
              ),
              const SizedBox(
                height: 20.0,
              ),
              GestureDetector(
                onTap: signupUser,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  color: blueColor,
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: primaryColor,
                        )
                      : const Text('Sign up.'),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Flexible(
                flex: 1,
                child: Container(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: const Text(
                      'Already have an account?',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 3.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: const Text(
                        'Login.',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: blueColor,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
