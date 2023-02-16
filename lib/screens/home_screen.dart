import 'package:authentication/screens/login_screen.dart';
import 'package:authentication/provider/sign_in_provider.dart';
import 'package:authentication/utils/next_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final sp = context.read<SignInProvider>();
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: const Text("SignOut"),
          onPressed: () {
            sp.userSignout();
            nextScreenReplace(context, const LoginScreen());
          },
        ),
      ),
    );
  }
}
