import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';
import 'package:studie/screens/sign_in_screen/widgets/login_button.dart';
import 'package:studie/services/db_methods.dart';
import 'package:studie/widgets/auth_text_button.dart';
import 'package:studie/widgets/auth_text_field.dart';

class SignInScreen extends StatefulWidget {
  static const routeName = '/signin';
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _isSigningIn = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> onSubmit() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      return;
    }

    setState(() => _isSigningIn = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
    } catch (e) {
      print('error signing in: $e');
    }
    setState(() => _isSigningIn = false);
  }

  Future<void> onSignUp() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      return;
    }

    try {
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (cred.user == null) return;
      await DBMethods().addUserToDB(cred.user!);
    } catch (e) {
      print('error signing up: $e');
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      if (userCredential.user != null) {
        print(userCredential.additionalUserInfo);
        if (userCredential.additionalUserInfo!.isNewUser) {
          await DBMethods().addUserToDB(userCredential.user!);
        }
      }
    } catch (e) {
      print('error signing in with google: $e');
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
    final size = MediaQuery.of(context).size;
    final isLongDevice = size.height >= 2 * size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Image.asset(
                'assets/images/login.png',
                fit: BoxFit.cover,
                width: double.infinity,
                height: 320,
              ),
            ),
            const Positioned(
              top: 100,
              left: 0,
              right: 0,
              child: Text(
                'Studie!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: kWhite,
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                ),
              ),
            ),
            Container(
              height: size.height,
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Đăng nhập',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: kBlack,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: kDefaultPadding),
                  CustomTextField(
                    iconData: Icons.email,
                    hintText: 'Email',
                    controller: _emailController,
                    inputType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: kMediumPadding),
                  CustomTextField(
                    iconData: Icons.lock,
                    hintText: 'Mật khẩu',
                    controller: _passwordController,
                    inputType: TextInputType.text,
                    toggleVisible: true,
                    onEnter: onSubmit,
                  ),
                  const SizedBox(height: kDefaultPadding),
                  CustomTextButton(
                    text: 'Đăng nhập',
                    onTap: onSubmit,
                    primary: true,
                    loading: _isSigningIn,
                    disabled: _isSigningIn,
                    large: true,
                  ),
                  const SizedBox(height: kDefaultPadding),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Chưa có tài khoản? ',
                        style: TextStyle(
                          color: kDarkGrey,
                          fontSize: 12,
                        ),
                      ),
                      GestureDetector(
                        onTap: onSignUp,
                        child: const Text(
                          'Đăng kí',
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: 12,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: kMediumPadding),
                  Row(children: const [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: kMediumPadding),
                      child: Text(
                        "Hoặc",
                        style: TextStyle(fontSize: 12, color: kDarkGrey),
                      ),
                    ),
                    Expanded(child: Divider()),
                  ]),
                  const SizedBox(height: kMediumPadding),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LoginButton(iconName: "facebook", onTap: () {}),
                      const SizedBox(width: kDefaultPadding),
                      LoginButton(
                        iconName: 'google',
                        onTap: () {
                          signInWithGoogle();
                        },
                      ),
                    ],
                  ),
                  if (isLongDevice) const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
