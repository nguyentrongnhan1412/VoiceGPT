import 'package:voicegpt/data/config_app/config_audio.dart';
import 'package:voicegpt/data/constant.dart';
import 'package:voicegpt/view/chat_view/controllers/chat_view_controller.dart';
import 'package:voicegpt/view/flash_view/flash_view.dart';
import 'package:voicegpt/view/setting_page/controller/setting_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ConfigAudio().initAudio();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ChatViewController(),
        ),
        ChangeNotifierProvider(
          create: (_) => SettingPageController(),
        ),
      ],
      child: MaterialApp(
        title: 'VoiceGPT',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            scaffoldBackgroundColor: scaffoldBackgroundColor,
            appBarTheme: AppBarTheme(
              color: cardColor,
            )),
        home: const FlashView(),
      ),
    );
  }
}