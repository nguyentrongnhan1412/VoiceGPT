import 'package:voicegpt/data/constant.dart';
import 'package:voicegpt/model/language_listen_model.dart';
import 'package:voicegpt/model/language_speak_model.dart';
import 'package:voicegpt/model/models_model.dart';
import 'package:voicegpt/view/login_view/login_view.dart';
import 'package:voicegpt/view/setting_page/components/bottom_sheet_setting.dart';
import 'package:voicegpt/view/setting_page/components/setting_button_logout.dart';
import 'package:voicegpt/view/setting_page/components/setting_dropdown.dart';
import 'package:voicegpt/view/setting_page/components/setting_slider.dart';
import 'package:voicegpt/view/setting_page/components/setting_switch.dart';
import 'package:voicegpt/view/setting_page/controller/setting_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingPage extends ModalRoute {
  @override
  Color? get barrierColor => Colors.black.withOpacity(0.6);

  @override
  bool get barrierDismissible => false;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => false;

  @override
  bool get opaque => false;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 500);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    List<Widget> list = _listWidget(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: list.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (_, index) {
            return list[index];
          }),
      bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
          child: bottom(context)),
    );
  }

  Widget bottom(BuildContext context) {
    return SettingButton(
        text: 'Log out',
        color: Colors.red,
        onPressed: () {
          context.read<SettingPageController>().logout().whenComplete(() {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginView()),
                    (Route<dynamic> route) => false);
          });
        });
  }

  List<Widget> _listWidget(BuildContext context) {
    final controller = Provider.of<SettingPageController>(context);
    return [
      SettingDropdown<ModelsModel>(
          label: 'Choose your Model:',
          onChanged: (p0) {
            if (p0 != null) {
              controller.currentModel = p0;
            }
          },
          list: controller.listModelsModel,
          value: controller.currentModel,
          textDropdown: (v) => v.root),
      SettingDropdown<LanguageListenModel>(
        label: 'Choose language for listening:',
        list: controller.listLanguageListen,
        value: controller.currentLanguageListen,
        onChanged: ((p0) {
          if (p0 != null) {
            controller.currentLanguageListen = p0;
          }
        }),
        textDropdown: (model) => model.displayName,
      ),
      SettingDropdown<LanguageSpeakModel>(
        label: 'Choose language for speaking:',
        list: controller.listLanguageSpeak,
        value: controller.currentLanguageSpeak,
        onChanged: ((p0) {
          if (p0 != null) {
            controller.currentLanguageSpeak = p0;
          }
        }),
        textDropdown: (model) => model.name,
      ),
      SettingSlider(
          label: 'Pitch:',
          value: controller.pitch,
          onchanged: (v) => controller.pitch = v),
      SettingSlider(
          label: 'Volume:',
          value: controller.volumn,
          onchanged: (v) => controller.volumn = v),
      SettingSlider(
          label: 'Rate:',
          value: controller.rate,
          onchanged: (v) => controller.rate = v),
      SettingSwitch(
          initValue: controller.autoChatReponse,
          onChanged: (v) {
            controller.autoChatReponse = v;
          },
          label: 'Auto Response in Audio:'),
      support(context)
    ];
  }

  Widget support(BuildContext context) {
    return SettingButton(
        onPressed: () {
          showBottom(context);
        },
        text: 'Support');
  }



  void showBottom(BuildContext context) {

    showModalBottomSheet<void>(
        context: context,
        backgroundColor: scaffoldBackgroundColor,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16))),
        builder: (context) {
          return const BottomSheetSetting();
        });
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // add fade animation
    return FadeTransition(
      opacity: animation,
      // add slide animation
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
    );
  }
}