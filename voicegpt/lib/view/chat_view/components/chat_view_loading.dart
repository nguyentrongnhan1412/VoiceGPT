import 'dart:developer';
import 'package:voicegpt/data/config_app/setting_data.dart';
import 'package:voicegpt/model/chat_model.dart';
import 'package:voicegpt/model/models_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voicegpt/view/chat_view/controllers/chat_view_controller.dart';


class ChatViewLoading extends StatelessWidget {
  const ChatViewLoading({super.key, required this.child});
  final Widget child;

  List<HandleModel> _listModel(BuildContext context) {
    final controller = Provider.of<ChatViewController>(context, listen: false);
    return [
      HandleModel(
        name: 'Model list',
        futureObject: controller.loadModelsModel(),
      ),
      HandleModel(
        name: 'Chat data',
        futureObject: controller.loadLocalChat(),
      )
    ];
  }

  bool get isHaveData {
    return SettingData().listModelsModel.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final list = _listModel(context);
    return isHaveData ? child : FutureBuilder<List<List<Object>>>(
      future: Future.wait<List<Object>>(
          list.map((e) => e.futureObject).toList()),
      builder: (_, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return baseLoading('Loading....');
          case ConnectionState.done:
            if (snapshot.hasError) {
              return baseLoading('Loading failed ...');
            }
            else {
              updateData(snapshot.data!, context);
              return child;
            }
          default:
            return baseLoading('Loading failed ...');
        }
      },
    );
  }

  void updateData(List<List<Object>> data, BuildContext context) {
    final controller = Provider.of<ChatViewController>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.listModelsModel = data[0] as List<ModelsModel>;
      controller.chatList = data[1] as List<ChatModel>;
    });
  }

  Widget baseLoading(String text) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            text,
            style: const TextStyle(color: Colors.white70, fontSize: 17),
          ),
        ],
      ),
    );
  }
}

class HandleModel {
  final String name;
  final Future<List<Object>> futureObject;
  HandleModel({
    required this.name,
    required this.futureObject,
  });
}

extension ConvertListObject<T> on List<Object> {
  List<T> safe({required List<T> Function(List<Object>) onConvert}) {
    onConvert(this);
    try {
      return onConvert(this);
    }
    catch (e) {
      log('Convert error ${T.toString()} $e');
      return [];
    }
  }
}