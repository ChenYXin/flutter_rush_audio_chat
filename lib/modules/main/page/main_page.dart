import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:circular_bottom_navigation/tab_item.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import '../../../commom/my_color.dart';
import '../../../generated/l10n.dart';
import '../fragment/chat_fragment.dart';
import '../fragment/home_fragment.dart';
import '../fragment/profile_fragment.dart';
import '../fragment/recommend_fragment.dart';

class MainPage extends StatefulWidget {
  MainPage({
    Key? key,
    this.title,
  }) : super(key: key);
  final String? title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedPos = 0;

  double bottomNavBarHeight = 60;

  late CircularBottomNavigationController _navigationController;

  @override
  void initState() {
    super.initState();
    _navigationController = CircularBottomNavigationController(selectedPos);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    tabItems = List.of([
      TabItem(
        Icons.home,
        S.of(context).title_home,
        context.watch<MyColor>().colorPrimary,
        labelStyle: TextStyle(
          fontWeight: FontWeight.normal,
        ),
      ),
      TabItem(
        Icons.recommend,
        S.of(context).title_Recommend,
        context.watch<MyColor>().colorPrimary,
        labelStyle: TextStyle(
          fontWeight: FontWeight.normal,
        ),
      ),
      TabItem(
        // Icons.chat_rounded,
        MdiIcons.chatProcessing,
        S.of(context).title_chat,
        context.watch<MyColor>().colorPrimary,
        labelStyle: TextStyle(
          fontWeight: FontWeight.normal,
        ),
      ),
      TabItem(
        Icons.settings,
        S.of(context).title_profile,
        context.watch<MyColor>().colorPrimary,
        labelStyle: TextStyle(
          fontWeight: FontWeight.normal,
        ),
      ),
    ]);
  }

  late List<TabItem> tabItems;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Padding(
            child: bodyContainer(),
            padding: EdgeInsets.only(bottom: bottomNavBarHeight),
          ),
          Align(alignment: Alignment.bottomCenter, child: bottomNav())
        ],
      ),
    );
  }

  Widget bodyContainer() {
    if (selectedPos == 0) {
      return HomeFragment();
    } else if (selectedPos == 1) {
      return RecommendFragment();
    } else if (selectedPos == 2) {
      // return PlayVideoPage(url: "https://mp4.nymaite.cn/s/%E7%97%85%E5%A8%87%E6%91%84%E6%94%BF%E7%8E%8B2979/2.mp4");
      return ChatFragment();
    } else if (selectedPos == 3) {
      return ProfileFragment();
    }
    return HomeFragment();
  }

  Widget bottomNav() {
    return CircularBottomNavigation(
      tabItems,
      controller: _navigationController,
      selectedPos: selectedPos,
      barHeight: bottomNavBarHeight,
      barBackgroundColor: background,
      backgroundBoxShadow: <BoxShadow>[
        BoxShadow(color: Colors.black45, blurRadius: 10.0),
      ],
      animationDuration: Duration(milliseconds: 300),
      selectedCallback: (int? selectedPos) {
        setState(() {
          this.selectedPos = selectedPos ?? 0;
        });
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _navigationController.dispose();
  }
}