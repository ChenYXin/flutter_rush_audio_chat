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

class HomeFragment extends StatefulWidget {
  const HomeFragment({super.key});

  @override
  State<HomeFragment> createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  int _listCount = 20;
  late EasyRefreshController _homeController;

  @override
  void initState() {
    super.initState();
    _homeController = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _homeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                background: _buildBanner(),
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.search,
                      color: context.watch<MyColor>().colorPrimary),
                  onPressed: () {
                    // print("搜索");
                    NavigatorUtils.push(context, MainRouter.searchPage);
                  },
                ),
              ],
            ),
          ];
        },
        body: buildRefreshList(
          uniqueKey: "home",
          controller: _homeController,
          count: _listCount,
          item: _buildItem(0),
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 2), () {
              if (mounted) {
                setState(() {
                  _listCount = 20;
                });
              }
              _homeController.finishRefresh();
            });
          },
          onLoad: () async {
            await Future.delayed(const Duration(seconds: 2), () {
              if (mounted) {
                setState(() {
                  _listCount += 10;
                });
              }
              _homeController.finishLoad(_listCount >= 20
                  ? IndicatorResult.noMore
                  : IndicatorResult.success);
            });
          },
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return GestureDetector(
      onTap: () {},
      child: SizedBox(
        height: 300,
        child: Swiper(
          itemBuilder: (BuildContext context, int index) {
            return SvCacheImage(
              imageUrl: "https://via.placeholder.com/400x300",
              fit: BoxFit.fill,
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

  Widget _buildItem(int tag) {
    return Container(
      decoration: svBoxDecoration.white,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        // direction: Axis.horizontal,
        children: [
          const SizedBox(
            width: 10,
          ),
          Container(
            height: 90,
            child: SvCacheImage(
              imageUrl: "https://via.placeholder.com/100x100",
              fit: BoxFit.fill,
              radius: 360,
            ),
          ),
          const SizedBox(
            width: 20,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  maxLines: 1,
                  "Nickname ",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  "描述-",
                  // style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          Container(height: 100,child: Icon(MdiIcons.chat)),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }
}
