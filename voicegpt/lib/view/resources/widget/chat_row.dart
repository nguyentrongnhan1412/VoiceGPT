import 'package:voicegpt/data/constant.dart';
import 'package:voicegpt/model/chat_model.dart';
import 'package:voicegpt/view/resources/assets_manager.dart';
import 'package:flutter/material.dart';
import 'text_widget.dart';

class ChatRow extends StatelessWidget {
  const ChatRow({super.key, required this.chatModel, required this.onPressed});
  final ChatModel chatModel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: chatModel.isUserChat ? scaffoldBackgroundColor : cardColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Image.asset(chatModel.isUserChat ? AssetsManager.userImage : AssetsManager.botImage, height: 30, width: 30,),

            const SizedBox(width: 8),

            Expanded(child: TextWidget(label: chatModel.msg,)),

            IconButton(onPressed: onPressed, icon: const Icon(Icons.volume_down))
          ],
        ),
      ),
    );
  }
}