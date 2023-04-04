import 'dart:math';

import 'package:voicegpt/data/config_app/config_audio.dart';
import 'package:voicegpt/view/chat_view/controllers/chat_view_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

class BottomSheetVoice extends StatefulWidget {
  const BottomSheetVoice({super.key});

  @override
  State<BottomSheetVoice> createState() => _BottomSheetVoiceState();
}

class _BottomSheetVoiceState extends State<BottomSheetVoice> {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  double level = 0.0;

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  bool get isTextEmpty => _lastWords == '';


  void _initSpeech() async {
    await Permission.microphone.request();
    _speechEnabled = await _speechToText.initialize(onStatus: (v) => debugPrint(v), onError: (v) => debugPrint(v.errorMsg));
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(
        onResult: _onSpeechResult,
        onSoundLevelChange: soundLevelListener,
        localeId: ConfigAudio().currentLanguageSpeak.locale);

    setState(() {});
  }

  void soundLevelListener(double level) {
    minSoundLevel = min(minSoundLevel, level);
    maxSoundLevel = max(maxSoundLevel, level);
    setState(() {
      this.level = level;
    });
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });
  }

  void _onClear() {
    setState(() {
      _lastWords = '';
    });
  }

  void _onCopy() {
    Clipboard.setData(ClipboardData(text: _lastWords));
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    SnackBar snackBar = const SnackBar(
      content: Text('Copied into storage'),
      backgroundColor: Colors.black,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _onSend() {
    context.read<ChatViewController>().send(msg: _lastWords);
    Navigator.pop(context);
  }

  @override
  void initState() {
    _initSpeech();
    super.initState();
  }

  Widget body() {
    return _speechEnabled
        ? Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: isTextEmpty
                    ? hintText()
                    : SelectableText(
                  _lastWords,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _iconMic(),
            const Divider(
              height: 16,
              color: Colors.black,
              thickness: 0.2,
            ),
            rowButton()
          ],
        ))
        : _speechIsNotActive();
  }

  Widget hintText() {
    return const Text(
      '..................',
      style: TextStyle(
        fontSize: 16,
        color: Colors.grey,
      ),
    );
  }

  Widget _iconMic() {
    return Container(
      width: 50,
      height: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              blurRadius: .26,
              spreadRadius: level * 2,
              color: Colors.white.withOpacity(.05))
        ],
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(50)),
      ),
      child: IconButton(
        color: Colors.blue,
        onPressed:
        _speechToText.isNotListening ? _startListening : _stopListening,
        tooltip: 'Listen',
        icon: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic),
      ),
    );
  }

  Widget _speechIsNotActive() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.mic_off,
              color: Colors.white,
              size: 32,
            ),
            SizedBox(width: 8),
            Text(
              'You have not provided permission for this application',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buttonBase(
            text: 'Provide permission',
            onPressed: _initSpeech,
            colour: Colors.blue,
            isCheckTextEmpty: false)
      ],
    );
  }

  Widget rowButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buttonClear(),
        _buttonCopy(),
        _buttonSend(),
      ],
    );
  }

  Widget _buttonClear() {
    return _buttonBase(text: 'Xóa', onPressed: _onClear, colour: Colors.red);
  }

  Widget _buttonCopy() {
    return _buttonBase(
        text: 'Sao chép', onPressed: _onCopy, colour: Colors.blue);
  }

  Widget _buttonSend() {
    return _buttonBase(text: 'Gửi', onPressed: _onSend, colour: Colors.green);
  }

  Widget _buttonClose() {
    return Positioned(
      right: 15,
      top: -20,
      child: CircleAvatar(
        backgroundColor: Colors.blue,
        radius: 25,
        child: IconButton(
          icon: const Icon(Icons.close),
          color: Colors.white,
          focusColor: Colors.blue.shade500,
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  Widget _buttonBase({required String text, required VoidCallback onPressed, bool isCheckTextEmpty = true, required Color colour}) {
    return MaterialButton(
      color: colour,
      elevation: 3,
      onPressed: isCheckTextEmpty ? isTextEmpty || _speechToText.isListening ? null : onPressed : onPressed,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Colors.grey, width: 0.2)),
      child: Text(text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          body(),
          _buttonClose(),
        ],
      ),
    );
  }



  
}