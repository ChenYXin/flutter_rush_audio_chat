import 'package:card_swiper/card_swiper.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import '../../../commom/my_color.dart';
import '../../../generated/l10n.dart';
import '../../../res/app.dart';
import '../../../router/fluro_navigator.dart';
import '../../../widget/cache_image.dart';
import '../../../widget/refresh_list.dart';
import '../main_router.dart';
import '../viewmodel/home_viewmodel.dart';

/// 首页Fragment
class HomeFragment extends StatefulWidget {
  const HomeFragment({super.key});

  @override
  State<HomeFragment> createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  @override
  void initState() {
    super.initState();
    // 初始化ViewModel数据
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeViewModel>().initData();
    });
  }

  // ==================== UI构建方法 ====================

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: background,
          body: ExtendedNestedScrollView(
            // scrollDirection: Axis.vertical,
            onlyOneScrollInBody: true,
            pinnedHeaderSliverHeightBuilder: () {
              return MediaQuery.of(context).padding.top + kToolbarHeight;
            },
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  backgroundColor: background,
                  expandedHeight: 300,
                  title: Text(
                    S.of(context).title_home,
                  ),
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: _buildBanner(viewModel),
                  ),
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(Icons.search,
                          color: context.watch<MyColor>().colorPrimary),
                      onPressed: () {
                        viewModel.onSearchTap();
                        NavigatorUtils.push(context, MainRouter.searchPage);
                      },
                    ),
                  ],
                ),
              ];
            },
            body: buildRefreshList(
              uniqueKey: "home",
              controller: viewModel.refreshController,
              count: viewModel.listCount,
              item: _buildItem(0, viewModel),
              onRefresh: () => viewModel.onRefresh(),
              onLoad: () => viewModel.onLoad(),
            ),
          ),
        );
      },
    );
  }

  /// 构建轮播图组件
  Widget _buildBanner(HomeViewModel viewModel) {
    return GestureDetector(
      onTap: () => viewModel.onBannerTap(0),
      child: SizedBox(
        height: 300,
        child: Swiper(
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () => viewModel.onBannerTap(index),
              child: SvCacheImage(
                imageUrl: viewModel.getBannerImageUrl(index),
                fit: BoxFit.fill,
              ),
            );
          },
          itemCount: 3,
          pagination: SwiperPagination(
              alignment: Alignment.bottomRight,
              builder: DotSwiperPaginationBuilder(
                  activeColor: context.watch<MyColor>().colorPrimary)),
          autoplay: true,
          // control: SwiperControl(),
        ),
      ),
    );
  }



  /// 构建列表项组件
  Widget _buildItem(int tag, HomeViewModel viewModel) {
    return GestureDetector(
      onTap: () {
        viewModel.onUserItemTap(tag);
        // 导航到用户详情页
        NavigatorUtils.push(context, '${MainRouter.userDetailPage}?userId=${viewModel.getUserId(tag)}');
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // 头像
            SvCacheImage(
              imageUrl: viewModel.getUserAvatarUrl(tag),
              width: 70,
              height: 70,
              radius: 35,
              fit: BoxFit.cover,
              placeholder: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person,
                  size: 35,
                  color: Colors.grey.shade600,
                ),
              ),
              errorWidget: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person,
                  size: 35,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
            const SizedBox(width: 16),
            // 内容区域
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    viewModel.getUserNickname(tag, S.of(context).nickname),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // 使用用户标签替代在线状态
                  Row(
                    children: [
                      // 用户标签
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: viewModel.getUserTagColor(tag).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: viewModel.getUserTagColor(tag).withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              viewModel.getUserTagIcon(tag),
                              size: 14,
                              color: viewModel.getUserTagColor(tag),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              viewModel.getUserTagText(tag),
                              style: TextStyle(
                                fontSize: 12,
                                color: viewModel.getUserTagColor(tag),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // 等级显示
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star,
                              size: 12,
                              color: Colors.amber.shade700,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              "Lv.${viewModel.getUserLevel(tag)}",
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.amber.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // 聊天图标
            GestureDetector(
              onTap: () {
                viewModel.onChatButtonTap(tag);
                // 导航到音频聊天页面
                final channelName = 'room_${viewModel.getUserId(tag)}';
                NavigatorUtils.push(context, '${MainRouter.audioChatPage}?channelName=$channelName&userName=用户$tag');
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: context.watch<MyColor>().colorPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  MdiIcons.chat,
                  color: context.watch<MyColor>().colorPrimary,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


}
