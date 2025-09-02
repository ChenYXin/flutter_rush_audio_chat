import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';

import '../res/app.dart';

class SvBottomSheet {
  BuildContext context;
  SvBottomSheet({required this.context});
  //底部弹窗
  void show(){
    showModalBottomSheet(context: context, builder: (BuildContext context){
      return GiffyBottomSheet.image(
        Image.network(
          "https://raw.githubusercontent.com/Shashank02051997/FancyGifDialog-Android/master/GIF's/gif14.gif",
          height: 200,
          fit: BoxFit.cover,
        ),
        title: Text(
          'Image Animation',
          textAlign: TextAlign.center,
        ),
        content: Text(
          'This is a image animation bottom sheet. This library helps you easily create fancy giffy bottom sheet.',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'CANCEL'),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],);
    });
  }
}

class SvDialog{
  BuildContext context;

  SvDialog({required this.context});
  // 居中弹窗
  void show(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GiffyDialog.image(
          // Image.network(
          //   "https://raw.githubusercontent.com/Shashank02051997/FancyGifDialog-Android/master/GIF's/gif14.gif",
          //   height: 200,
          //   fit: BoxFit.cover,
          // ),
          Image.asset(
            height: 120,
            width: 120,
            logo,
          ),
          title: Text(
            'Image Animation',
            textAlign: TextAlign.center,
          ),
          content: Text(
            'This is a image animation dialog box. This library helps you easily create fancy giffy dialog.',
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, 'CANCEL'),
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}