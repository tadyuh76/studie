import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studie/providers/user_provider.dart';
import 'package:studie/screens/home_screen/home_screen.dart';

class RootScreen extends ConsumerStatefulWidget {
  const RootScreen({super.key});

  @override
  ConsumerState<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends ConsumerState<RootScreen> {
  bool loading = true;
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    await ref.read(userProvider).updateUser();
    loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Center(child: CircularProgressIndicator())
        : const HomeScreen();
  }
}
