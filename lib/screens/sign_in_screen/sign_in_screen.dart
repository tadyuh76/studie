import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';
import 'package:studie/screens/sign_in_screen/widgets/login_button.dart';
import 'package:studie/services/auth_methods.dart';
import 'package:studie/widgets/custom_text_button.dart';
import 'package:studie/widgets/custom_text_field.dart';

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

  void onSubmit(BuildContext context, [bool mounted = true]) async {
    setState(() => _isSigningIn = true);
    await AuthMethods().signInWithEmailAndPassworrd(
      email: _emailController.text,
      password: _passwordController.text,
    );

    setState(() => _isSigningIn = false);
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
      body: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          children: [
            const Text(
              'Chào mừng bạn đến với Studie!',
              style: TextStyle(
                color: kTextColor,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Expanded(
              child: SvgPicture.asset(
                'assets/svgs/studying.svg',
                fit: BoxFit.contain,
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
            ),
            const SizedBox(height: kDefaultPadding),
            CustomTextButton(
              text: 'Đăng nhập',
              onTap: () => onSubmit(context),
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
                  onTap: () => AuthMethods().signUp(
                    email: _emailController.text,
                    password: _passwordController.text,
                  ),
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
                LoginButton(iconName: 'google', onTap: () {}),
              ],
            ),
            const SizedBox(height: kDefaultPadding),
          ],
        ),
      ),
    );
  }
}
