import 'package:easy_refresh/easy_refresh.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/cupertino.dart';

var _defaultClassicHeader = ClassicHeader(
  dragText: 'Pull to refresh',
  armedText: 'Release ready',
  readyText: 'Refreshing...',
  processingText: 'Refreshing...',
  processedText: 'Succeeded',
  noMoreText: 'No more',
  failedText: 'Failed',
  messageText: 'Last updated at %T',
  safeArea: false,
);

var _defaultClassicFooter = ClassicFooter(
  position: IndicatorPosition.locator,
  dragText: 'Pull to load',
  armedText: 'Release ready',
  readyText: 'Loading...',
  processingText: 'Loading...',
  processedText: 'Succeeded',
  noMoreText: 'No more',
  failedText: 'Failed',
  messageText: 'Last updated at %T',
);

//通用的下拉刷新，上拉加载
Widget buildRefreshList(
    {required String uniqueKey,
    EasyRefreshController? controller,
    int? count,
    Widget? item,
    Function()? onRefresh,
    Function()? onLoad}) {
  return ExtendedVisibilityDetector(
    uniqueKey: Key(uniqueKey),
    child: EasyRefresh(
      controller: controller,
      header: _defaultClassicHeader,
      footer: _defaultClassicFooter,
      child: CustomScrollView(
        slivers: [
          SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
            // return const SkeletonItem();
            return item;
          }, childCount: count)),
          const FooterLocator.sliver(),
        ],
      ),
      onRefresh: onRefresh,
      onLoad: onLoad,
    ),
  );
}

/// buildRefreshList
Widget buildHorizontalRefreshList(
    {required String uniqueKey,
    EasyRefreshController? controller,
    int? count,
    Widget? item,
    double? childAspectRatio,
    Function()? onRefresh,
    Function()? onLoad}) {
  return ExtendedVisibilityDetector(
    uniqueKey: Key(uniqueKey),
    child: EasyRefresh(
      header: _defaultClassicHeader,
      footer: _defaultClassicFooter,
      child: CustomScrollView(
        slivers: [
          SliverGrid(
              delegate: SliverChildBuilderDelegate((context, index) {
                return item;
              }, childCount: count),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: childAspectRatio ?? 1.89 / 3,
              )),
          const FooterLocator.sliver(),
        ],
      ),
      onRefresh: onRefresh,
      onLoad: onLoad,
    ),
  );
}
