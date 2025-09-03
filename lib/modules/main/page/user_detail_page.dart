import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../commom/my_color.dart';
import '../../../widget/cache_image.dart';
import '../viewmodel/user_detail_viewmodel.dart';

/// 用户详情页面
class UserDetailPage extends StatefulWidget {
  final String userId;
  
  const UserDetailPage({super.key, required this.userId});

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserDetailViewModel(widget.userId),
      child: Consumer<UserDetailViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              body: const Center(child: CircularProgressIndicator()),
            );
          }

          if (viewModel.userDetail == null) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('用户详情'),
              ),
              body: const Center(
                child: Text('用户信息加载失败'),
              ),
            );
          }

          return Scaffold(
            body: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  _buildSliverAppBar(viewModel),
                  _buildUserInfo(viewModel),
                  _buildTabBar(),
                ];
              },
              body: _buildTabBarView(viewModel),
            ),
            bottomNavigationBar: _buildBottomBar(viewModel),
          );
        },
      ),
    );
  }

  /// 构建SliverAppBar
  Widget _buildSliverAppBar(UserDetailViewModel viewModel) {
    final user = viewModel.userDetail!;
    
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: context.watch<MyColor>().colorPrimary,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert, color: Colors.white),
          onPressed: () => _showMoreOptions(context),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // 背景图片
            SvCacheImage(
              imageUrl: user.coverImage,
              fit: BoxFit.cover,
            ),
            // 渐变遮罩
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建用户信息
  Widget _buildUserInfo(UserDetailViewModel viewModel) {
    final user = viewModel.userDetail!;
    
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 头像和基本信息
            Row(
              children: [
                // 头像
                Stack(
                  children: [
                    SvCacheImage(
                      imageUrl: user.avatar,
                      width: 80,
                      height: 80,
                      radius: 40,
                      fit: BoxFit.cover,
                    ),
                    if (user.isOnline)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 16),
                
                // 基本信息
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
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.amber.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Lv.${user.level}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.amber.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      
                      // 年龄、性别、位置
                      Text(
                        '${user.age}岁 · ${user.gender} · ${user.location}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      
                      // 星座和职业
                      Text(
                        '${user.constellation} · ${user.profession}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // 个性签名
            if (user.signature.isNotEmpty) ...[
              Text(
                user.signature,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12),
            ],
            
            // 标签
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: user.tags.map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: context.watch<MyColor>().colorPrimary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(
                      fontSize: 12,
                      color: context.watch<MyColor>().colorPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            
            // 统计数据
            Row(
              children: [
                _buildStatItem('粉丝', viewModel.formatNumber(user.fansCount)),
                _buildStatItem('关注', viewModel.formatNumber(user.followCount)),
                _buildStatItem('获赞', viewModel.formatNumber(user.likeCount)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 构建统计项
  Widget _buildStatItem(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建TabBar
  Widget _buildTabBar() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverTabBarDelegate(
        TabBar(
          controller: _tabController,
          labelColor: context.watch<MyColor>().colorPrimary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: context.watch<MyColor>().colorPrimary,
          tabs: const [
            Tab(text: '动态'),
            Tab(text: '相册'),
            Tab(text: '资料'),
          ],
        ),
      ),
    );
  }

  /// 构建TabBarView
  Widget _buildTabBarView(UserDetailViewModel viewModel) {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildMomentList(viewModel),
        _buildPhotoGrid(viewModel),
        _buildUserProfile(viewModel),
      ],
    );
  }

  /// 构建动态列表
  Widget _buildMomentList(UserDetailViewModel viewModel) {
    if (viewModel.momentList.isEmpty) {
      return const Center(
        child: Text('暂无动态'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: viewModel.momentList.length,
      itemBuilder: (context, index) {
        final moment = viewModel.momentList[index];
        return _buildMomentItem(moment, viewModel);
      },
    );
  }

  /// 构建动态项
  Widget _buildMomentItem(UserMoment moment, UserDetailViewModel viewModel) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 内容
          Text(
            moment.content,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
          
          // 图片
          if (moment.images.isNotEmpty) ...[
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: moment.images.length,
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SvCacheImage(
                    imageUrl: moment.images[index],
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ],
          
          const SizedBox(height: 12),
          
          // 底部操作栏
          Row(
            children: [
              Text(
                _formatTime(moment.publishTime),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => viewModel.likeMoment(moment.id),
                child: Row(
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: 16,
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      moment.likeCount.toString(),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Row(
                children: [
                  Icon(
                    Icons.comment_outlined,
                    size: 16,
                    color: Colors.grey.shade500,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    moment.commentCount.toString(),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建相册网格
  Widget _buildPhotoGrid(UserDetailViewModel viewModel) {
    if (viewModel.photoList.isEmpty) {
      return const Center(
        child: Text('暂无相册'),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: viewModel.photoList.length,
      itemBuilder: (context, index) {
        final photo = viewModel.photoList[index];
        return GestureDetector(
          onTap: () => viewModel.likePhoto(photo.id),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              fit: StackFit.expand,
              children: [
                SvCacheImage(
                  imageUrl: photo.imageUrl,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.favorite,
                          size: 12,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          photo.likeCount.toString(),
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 构建用户资料
  Widget _buildUserProfile(UserDetailViewModel viewModel) {
    final user = viewModel.userDetail!;
    
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildProfileItem('用户ID', user.id),
        _buildProfileItem('年龄', '${user.age}岁'),
        _buildProfileItem('性别', user.gender),
        _buildProfileItem('位置', user.location),
        _buildProfileItem('星座', user.constellation),
        _buildProfileItem('职业', user.profession),
        _buildProfileItem('加入时间', _formatDate(user.joinDate)),
        _buildProfileItem('最后活跃', _formatTime(user.lastActiveTime)),
      ],
    );
  }

  /// 构建资料项
  Widget _buildProfileItem(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建底部操作栏
  Widget _buildBottomBar(UserDetailViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // 私信按钮
          Expanded(
            child: Container(
              height: 44,
              margin: const EdgeInsets.only(right: 8),
              child: OutlinedButton(
                onPressed: () => _showMessage('私信功能开发中...'),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: context.watch<MyColor>().colorPrimary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),
                child: Text(
                  '私信',
                  style: TextStyle(
                    color: context.watch<MyColor>().colorPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          
          // 关注按钮
          Expanded(
            child: Container(
              height: 44,
              margin: const EdgeInsets.only(left: 8),
              child: ElevatedButton(
                onPressed: () => viewModel.toggleFollow(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: viewModel.isFollowed 
                      ? Colors.grey.shade400 
                      : context.watch<MyColor>().colorPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),
                child: Text(
                  viewModel.isFollowed ? '已关注' : '关注',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 显示更多选项
  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('分享'),
              onTap: () {
                Navigator.pop(context);
                _showMessage('分享功能开发中...');
              },
            ),
            ListTile(
              leading: const Icon(Icons.report),
              title: const Text('举报'),
              onTap: () {
                Navigator.pop(context);
                _showMessage('举报功能开发中...');
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 显示消息
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  /// 格式化时间
  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}分钟前';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}小时前';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}天前';
    } else {
      return '${time.month}/${time.day}';
    }
  }

  /// 格式化日期
  String _formatDate(DateTime date) {
    return '${date.year}年${date.month}月${date.day}日';
  }
}

/// SliverTabBar代理
class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _SliverTabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
