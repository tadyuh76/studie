import 'package:flutter/material.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';
import 'package:studie/screens/sign_in_screen/widgets/login_button.dart';
import 'package:studie/services/auth_methods.dart';
import 'package:studie/utils/show_snack_bar.dart';
import 'package:studie/widgets/auth_text_button.dart';
import 'package:studie/widgets/auth_text_field.dart';

class SignInScreen extends StatefulWidget {
  static const routeName = '/signin';
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _authMethods = AuthMethods();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String get email => _emailController.text.trim();
  String get password => _passwordController.text;

  bool _loading = false;

  Future<void> onSignIn() async {
    setState(() => _loading = true);
    final result = await _authMethods.signIn(email: email, password: password);
    if (result != "success" && mounted) showSnackBar(context, result);
    setState(() => _loading = false);
  }

  Future<void> onSignUp() async {
    setState(() => _loading = true);
    final result = await _authMethods.signUp(email: email, password: password);
    if (result != "success" && mounted) showSnackBar(context, "result");
    setState(() => _loading = false);
  }

  Future<void> signInWithGoogle() async {
    setState(() => _loading = true);
    final result = await _authMethods.signInWithGoogle();
    if (result != "success" && mounted) showSnackBar(context, "result");
    setState(() => _loading = false);
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
                    onEnter: onSignIn,
                  ),
                  const SizedBox(height: kDefaultPadding),
                  CustomTextButton(
                    text: 'Đăng nhập',
                    onTap: onSignIn,
                    primary: true,
                    loading: _loading,
                    disabled: _loading,
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
                      LoginButton(iconName: 'google', onTap: signInWithGoogle),
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
