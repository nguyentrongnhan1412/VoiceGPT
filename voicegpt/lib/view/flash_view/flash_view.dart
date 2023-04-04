import 'package:voicegpt/data/prefs/data_local.dart';
import 'package:voicegpt/view/chat_view/chat_view.dart';
import 'package:voicegpt/view/login_view/login_view.dart';
import 'package:flutter/material.dart';

class FlashView extends StatefulWidget {
  const FlashView({super.key});

  @override
  State<FlashView> createState() => _FlashViewState();
}

class _FlashViewState extends State<FlashView> {
  final DataLocalIpml _dataLocalIpml = DataLocalIpml();

  @override
  void initState() {
    super.initState();
    direction();
  }

  void direction() async {
    bool isLogIn = await _dataLocalIpml.apiKey != null;

    if (isLogIn) {
      bindScreen(const ChatView());
    } else {
      bindScreen(const LoginView());
    }
  }

  void bindScreen(Widget screen) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (__) => screen));
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}