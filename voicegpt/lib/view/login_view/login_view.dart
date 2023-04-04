import 'package:voicegpt/data/api_service.dart';
import 'package:voicegpt/data/prefs/data_local.dart';
import 'package:voicegpt/view/chat_view/chat_view.dart';
import 'package:voicegpt/view/resources/widget/snack_bar_error.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final ApiService _api = ApiServiceIpml();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  String? textApiKey;
  bool _isLoading = false;

  void updateStatus(bool status) {
    setState(() {
      _isLoading = status;
    });
  }

  void _submit() async {
    FocusScope.of(context).unfocus();
    if (_key.currentState!.validate()) {
      _key.currentState!.save();
      updateStatus(true);
      bool isValid = await _api.checkApiKeyValid(textApiKey ?? '');
      updateStatus(false);
      if (isValid) {
        saveApiKeyLocal();
      } else {
        showSnackBarError('Invalid API Key');
      }
    }
  }

  void showSnackBarError(String textError) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBarError(content: textError));
  }

  void saveApiKeyLocal() async {
    DataLocalIpml local = DataLocalIpml();
    await local.saveApiKey(textApiKey ?? '').whenComplete(() =>
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const ChatView())));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: _form(),
        ),
      ),
    );
  }

  Widget _form() {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: _key,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          textFormField(),
          const SizedBox(
            height: 16,
          ),
          buttonCheck(),
        ],
      ),
    );
  }

  Widget buttonCheck() {
    return MaterialButton(
      onPressed: _isLoading ? null : _submit,
      color: Colors.blue,
      child: _isLoading ? Column(
        children: const [
          CircularProgressIndicator(),
          SizedBox(height: 8),
          Text('Checking')
        ],
      )
          : const Text('Confirm'),
    );
  }

  Widget textFormField() {
    return TextFormField(
      style: const TextStyle(color: Colors.white),
      readOnly: _isLoading,
      onEditingComplete: _submit,
      decoration: InputDecoration(
          enabledBorder: _inputBorder(),
          hintText: 'Enter your API Key',
          prefixIcon: const Icon(
            Icons.key_rounded,
            color: Colors.white,
          ),
          label: const Text(
            'Enter your key',
            style: TextStyle(color: Colors.white70),
          ),
          hintStyle: const TextStyle(color: Colors.white24),
          focusColor: Colors.black26,
          helperStyle: const TextStyle(color: Colors.white),
          enabled: true,
          focusedBorder: _inputBorder(),
          border: _inputBorder()),
      onSaved: (newValue) {
        textApiKey = newValue;
      },
      validator: (v) {
        if (v!.length < 6) {
          return 'Invalid API Key';
        }
        return null;
      },
    );
  }

  InputBorder _inputBorder() {
    return OutlineInputBorder(
        borderSide:
        const BorderSide(width: 3, color: Colors.black),
        borderRadius: BorderRadius.circular(16));
  }
}