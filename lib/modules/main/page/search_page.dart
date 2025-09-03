import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../commom/my_color.dart';
import '../../../generated/l10n.dart';
import '../../../router/fluro_navigator.dart';
import '../../../widget/cache_image.dart';
import '../viewmodel/search_viewmodel.dart';
import '../main_router.dart';

/// 搜索页面
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  /// 搜索控制器
  final TextEditingController _searchController = TextEditingController();
  
  /// 焦点节点
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // 自动获取焦点
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SearchViewModel(),
      child: Consumer<SearchViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            backgroundColor: const Color(0xFFF8F9FA),
            body: SafeArea(
              child: Column(
                children: [
                  // 自定义搜索头部
                  _buildSearchHeader(viewModel),
                  // 搜索结果或默认内容
                  Expanded(
                    child: viewModel.showResults
                        ? _buildSearchResults(viewModel)
                        : _buildDefaultContent(viewModel),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// 构建搜索头部
  Widget _buildSearchHeader(SearchViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // 返回按钮
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black87,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // 搜索框
          Expanded(
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: _focusNode.hasFocus
                      ? context.watch<MyColor>().colorPrimary.withOpacity(0.3)
                      : Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: TextField(
                controller: _searchController,
                focusNode: _focusNode,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
                decoration: InputDecoration(
                  hintText: '搜索用户、昵称',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 16,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey.shade400,
                    size: 22,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            _searchController.clear();
                            viewModel.clearResults();
                          },
                          child: Icon(
                            Icons.clear,
                            color: Colors.grey.shade400,
                            size: 20,
                          ),
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                textInputAction: TextInputAction.search,
                onSubmitted: (value) => viewModel.search(value),
                onChanged: (value) {
                  setState(() {}); // 更新清除按钮显示
                  if (value.isEmpty) {
                    viewModel.clearResults();
                  }
                },
              ),
            ),
          ),
          const SizedBox(width: 12),

          // 搜索按钮
          GestureDetector(
            onTap: () => viewModel.search(_searchController.text),
            child: Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    context.watch<MyColor>().colorPrimary,
                    context.watch<MyColor>().colorPrimary.withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: context.watch<MyColor>().colorPrimary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  '搜索',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建默认内容（搜索历史和热门搜索）
  Widget _buildDefaultContent(SearchViewModel viewModel) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 搜索历史
          if (viewModel.searchHistory.isNotEmpty) ...[
            _buildSectionCard(
              title: '搜索历史',
              onClear: () => viewModel.clearSearchHistory(),
              child: _buildHistoryTags(viewModel),
            ),
            const SizedBox(height: 20),
          ],

          // 热门搜索
          _buildSectionCard(
            title: '热门搜索',
            child: _buildHotSearchTags(viewModel),
          ),

          const SizedBox(height: 20),

          // 搜索建议
          _buildSectionCard(
            title: '搜索建议',
            child: _buildSearchSuggestions(),
          ),
        ],
      ),
    );
  }

  /// 构建区域卡片
  Widget _buildSectionCard({
    required String title,
    required Widget child,
    VoidCallback? onClear,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题行
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              if (onClear != null)
                GestureDetector(
                  onTap: onClear,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.clear_all,
                      size: 18,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  /// 构建历史搜索标签
  Widget _buildHistoryTags(SearchViewModel viewModel) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: viewModel.searchHistory.map((keyword) {
        return GestureDetector(
          onTap: () {
            _searchController.text = keyword;
            viewModel.onHistorySearchTap(keyword);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.grey.shade200,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.history,
                  size: 16,
                  color: Colors.grey.shade500,
                ),
                const SizedBox(width: 6),
                Text(
                  keyword,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => viewModel.removeHistoryItem(keyword),
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      size: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  /// 构建热门搜索标签
  Widget _buildHotSearchTags(SearchViewModel viewModel) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: viewModel.hotSearches.asMap().entries.map((entry) {
        final index = entry.key;
        final keyword = entry.value;
        final isTop3 = index < 3;

        return GestureDetector(
          onTap: () {
            _searchController.text = keyword;
            viewModel.onHotSearchTap(keyword);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              gradient: isTop3
                  ? LinearGradient(
                      colors: [
                        context.watch<MyColor>().colorPrimary.withOpacity(0.8),
                        context.watch<MyColor>().colorPrimary.withOpacity(0.6),
                      ],
                    )
                  : null,
              color: isTop3 ? null : context.watch<MyColor>().colorPrimary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              boxShadow: isTop3 ? [
                BoxShadow(
                  color: context.watch<MyColor>().colorPrimary.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ] : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isTop3) ...[
                  Icon(
                    Icons.local_fire_department,
                    size: 16,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 4),
                ],
                Text(
                  keyword,
                  style: TextStyle(
                    fontSize: 14,
                    color: isTop3 ? Colors.white : context.watch<MyColor>().colorPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  /// 构建搜索建议
  Widget _buildSearchSuggestions() {
    final suggestions = [
      {'icon': Icons.person_search, 'text': '按昵称搜索', 'desc': '输入用户昵称快速查找'},
      {'icon': Icons.location_on, 'text': '按地区搜索', 'desc': '查找同城用户'},
      {'icon': Icons.tag, 'text': '按标签搜索', 'desc': '根据兴趣标签匹配'},
    ];

    return Column(
      children: suggestions.map((suggestion) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.shade200,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: context.watch<MyColor>().colorPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  suggestion['icon'] as IconData,
                  size: 20,
                  color: context.watch<MyColor>().colorPrimary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      suggestion['text'] as String,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      suggestion['desc'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  /// 构建搜索结果
  Widget _buildSearchResults(SearchViewModel viewModel) {
    if (viewModel.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (viewModel.searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              '没有找到相关用户',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: viewModel.searchResults.length,
      itemBuilder: (context, index) {
        final user = viewModel.searchResults[index];
        return _buildUserItem(user);
      },
    );
  }

  /// 构建用户项
  Widget _buildUserItem(SearchUserItem user) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _onUserItemTap(user),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // 头像
                Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: SvCacheImage(
                        imageUrl: user.avatar,
                        width: 70,
                        height: 70,
                        radius: 20,
                        fit: BoxFit.cover,
                      ),
                    ),
                    if (user.isOnline)
                      Positioned(
                        right: 2,
                        bottom: 2,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: const Color(0xFF4CAF50),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 16),

                // 用户信息
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 昵称和等级
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              user.nickname,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.amber.shade400,
                                  Colors.amber.shade600,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'Lv.${user.level}',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // 年龄、性别、位置
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 14,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${user.age}岁 · ${user.gender} · ${user.location}',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // 标签
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: user.tags.take(3).map((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  context.watch<MyColor>().colorPrimary.withOpacity(0.1),
                                  context.watch<MyColor>().colorPrimary.withOpacity(0.05),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: context.watch<MyColor>().colorPrimary.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              tag,
                              style: TextStyle(
                                fontSize: 11,
                                color: context.watch<MyColor>().colorPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),

                // 查看按钮
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            context.watch<MyColor>().colorPrimary,
                            context.watch<MyColor>().colorPrimary.withOpacity(0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: context.watch<MyColor>().colorPrimary.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Text(
                        '查看',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${user.fansCount}粉丝',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 处理用户项点击
  void _onUserItemTap(SearchUserItem user) {
    // 导航到用户详情页
    NavigatorUtils.push(context, '${MainRouter.userDetailPage}?userId=${user.id}');
  }
}
