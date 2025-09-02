// import 'package:flutter/material.dart';
// import 'package:giffy_dialog/giffy_dialog.dart';
//
// import 'package:rush_audio_chat/res/app.dart';
// import 'package:rush_audio_chat/router/fluro_navigator.dart';
//
// import '../commom/my_color.dart';
//
// class SignInDialog {
//   BuildContext context;
//
//   SignInDialog({required this.context});
//
//   //底部弹窗
//   void show() {
//     showModalBottomSheet(
//         backgroundColor: dialogBackground,
//         context: context,
//         builder: (BuildContext context) {
//           return GiffyBottomSheet.image(
//             Image.asset(
//               height: 120,
//               width: 120,
//               logo,
//             ),
//             title: Text(
//               'Sign In',
//               textAlign: TextAlign.center,
//             ),
//             content: Container(
//               height: 190,
//               width: MediaQuery.of(context).size.width,
//               child: Column(
//                 children: [
//                   _buildItem(MdiIcons.facebook, "Facebook Login", 0),
//                   _buildItem(MdiIcons.google, "Google Login", 1),
//                   _buildItem(MdiIcons.faceManShimmer, "Visitor Login", 2),
//                   // _buildItem(MdiIcons.cellphone, "Account Login", 3),
//                   // Text(
//                   //   'Create Account',
//                   //   style: TextStyle(color: colorPrimary.withOpacity(0.6)),
//                   // ),
//                 ],
//               ),
//             ),
//           );
//         });
//   }
//
//   Widget _buildItem(IconData icon, String title, int go2) {
//     return GestureDetector(
//       onTap: () async {
//         switch (go2) {
//           case 0:
//             var user = LoginUtil.signInWithFacebook();
//             debugPrint(user.toString());
//             break;
//           case 1:
//             // signInWithGoogle();
//             var user = LoginUtil.currentUser();
//             if (user != null) {
//               print(user);
//               await LoginUtil.signOut();
//             }
//             String? token = await LoginUtil.signInWithGoogle();
//             print(token);
//
//             break;
//           case 2:
//             break;
//           case 3:
//             NavigatorUtils.push(context, LoginRouter.verificationLoginPage,
//                 replace: true);
//             break;
//           default:
//             break;
//         }
//       },
//       child: Container(
//         margin: EdgeInsets.symmetric(vertical: 5),
//         padding: EdgeInsets.all(15),
//         decoration: svBoxDecoration.white,
//         child: Stack(
//           children: [
//             Positioned(
//                 left: 25,
//                 child: Icon(
//                   icon,
//                   size: 25,
//                 )),
//             Center(
//                 child: Text(
//               title,
//               style: TextStyle(fontSize: 16),
//             )),
//           ],
//         ),
//       ),
//     );
//   }
// }
