import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:provider/provider.dart';

import '../commom/my_color.dart';
import '../res/app.dart';

class SelectThemeColorDialog {
  BuildContext context;

  SelectThemeColorDialog({required this.context});

  // 居中弹窗
  void show() {
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
            'Select Theme Color',
            textAlign: TextAlign.center,
            style: TextStyle(color: context.watch<MyColor>().colorPrimary),
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildColorTheme(0),
              buildColorTheme(1),
              buildColorTheme(2),
              buildColorTheme(3),
              buildColorTheme(4),
              buildColorTheme(5),
              buildColorTheme(6),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, 'CANCEL'),
              child: Text('CANCEL',style: TextStyle(color: context.watch<MyColor>().colorPrimary),),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: Text('OK',style: TextStyle(color: context.watch<MyColor>().colorPrimary),),
            ),
          ],
        );
      },
    );
  }

  GestureDetector buildColorTheme(int index) {
    return GestureDetector(
      onTap: () {
        context.read<MyColor>().setColor(index);
      },
      child: Container(
        height: 30,
        width: 30,
        margin: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: colors[index],
          borderRadius: BorderRadius.all(
            Radius.circular(360),
          ),
        ),
      ),
    );
  }
}
