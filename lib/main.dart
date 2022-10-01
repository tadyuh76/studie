import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studie/constants/colors.dart';
import 'package:studie/firebase_options.dart';
import 'package:studie/screens/create_room_screen/create_room_screen.dart';
import 'package:studie/screens/sign_in_screen/sign_in_screen.dart';
import 'package:studie/screens/sign_up_screen/sign_up_screen.dart';
import 'package:studie/screens/home_screen/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: App()));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown,
        },
      ),
      theme: ThemeData(
        fontFamily: 'Quicksand',
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ThemeData().colorScheme.copyWith(primary: kPrimaryColor),
      ),
      routes: {
        SignInScreen.routeName: ((context) => const SignInScreen()),
        SignUpScreen.routeName: ((context) => const SignUpScreen()),
        HomeScreen.routeName: ((context) => const HomeScreen()),
        CreateRoomScreen.routeName: ((context) => CreateRoomScreen())
      },
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const HomeScreen();
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return const SignInScreen();
        },
      ),
    );
  }
}
