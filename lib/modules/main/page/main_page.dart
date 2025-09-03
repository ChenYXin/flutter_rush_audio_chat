import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:circular_bottom_navigation/tab_item.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import '../../../commom/my_color.dart';
import '../../../commom/my_language.dart';
import '../../../generated/l10n.dart';
import '../fragment/chat_fragment.dart';
import '../fragment/home_fragment.dart';
import '../fragment/profile_fragment.dart';

import '../viewmodel/main_page_viewmodel.dart';

/// 主页面
class MainPage extends StatefulWidget {
  const MainPage({
    super.key,
    this.title,
  });
  final String? title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  /// 底部导航栏高度
  double bottomNavBarHeight = 60;

  /// 标签页项目列表
  List<TabItem> tabItems = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 确保ViewModel已初始化
    context.read<MainPageViewModel>().initialize();
  }



  // ==================== UI构建方法 ====================

  /// 缓存的颜色索引，用于避免频繁重建
  int? _cachedColorIndex;

  /// 缓存的语言代码，用于避免频繁重建
  String? _cachedLanguage;

  /// 更新标签页项目
  void _updateTabItems() {
    final currentColorIndex = context.read<MyColor>().currentColorIndex;
    final currentLanguage = context.read<MyLanguage>().language;

    // 只有颜色或语言真正改变时才重建标签页项目
    if (_cachedColorIndex == currentColorIndex &&
        _cachedLanguage == currentLanguage &&
        tabItems.isNotEmpty) {
      return;
    }

    _cachedColorIndex = currentColorIndex;
    _cachedLanguage = currentLanguage;
    final primaryColor = context.read<MyColor>().colorPrimary;

    tabItems = List.of([
      TabItem(
        Icons.home,
        S.of(context).title_home,
        primaryColor,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.normal,
        ),
      ),
      TabItem(
        Icons.chat,
        S.of(context).title_chat,
        primaryColor,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.normal,
        ),
      ),
      TabItem(
        Icons.person,
        S.of(context).title_profile,
        primaryColor,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.normal,
        ),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<MainPageViewModel, MyColor, MyLanguage>(
      builder: (context, viewModel, colorProvider, languageProvider, child) {
        // 在颜色或语言变化时更新标签页项目
        _updateTabItems();

        return WillPopScope(
          onWillPop: () async {
            final shouldExit = viewModel.onWillPop();
            // 显示退出提示
            if (viewModel.exitMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(viewModel.exitMessage!),
                  duration: const Duration(seconds: 2),
                  backgroundColor: Colors.black87,
                ),
              );
            }
            return shouldExit;
          },
          child: Scaffold(
            body: Stack(
              children: <Widget>[
                Padding(
                  child: bodyContainer(viewModel),
                  padding: EdgeInsets.only(bottom: bottomNavBarHeight),
                ),
                if (viewModel.showBottomNavigation)
                  Align(alignment: Alignment.bottomCenter, child: bottomNav(viewModel))
              ],
            ),
          ),
        );
      },
    );
  }

  /// 构建主体容器
  Widget bodyContainer(MainPageViewModel viewModel) {
    switch (viewModel.selectedIndex) {
      case 0:
        return const HomeFragment();
      case 1:
        return const ChatFragment();
      case 2:
        return const ProfileFragment();
      default:
        return const HomeFragment();
    }
  }

  /// 构建底部导航栏
  Widget bottomNav(MainPageViewModel viewModel) {
    return CircularBottomNavigation(
      tabItems,
      controller: viewModel.navigationController,
      selectedPos: viewModel.selectedIndex,
      barHeight: bottomNavBarHeight,
      barBackgroundColor: background,
      backgroundBoxShadow: const <BoxShadow>[
        BoxShadow(color: Colors.black45, blurRadius: 10.0),
      ],
      animationDuration: const Duration(milliseconds: 300),
      selectedCallback: (int? selectedPos) {
        viewModel.onTabTap(selectedPos ?? 0);
      },
    );
  }

}