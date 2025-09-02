import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';

import '../../../commom/my_color.dart';
import '../../../commom/my_language.dart';
import '../../../dialog/select_theme_color_dialog.dart';
import '../../../generated/l10n.dart';
import '../../../res/app.dart';
import '../../../router/fluro_navigator.dart';
import '../../../widget/cache_image.dart';
import '../../settings/setting_router.dart';

class ProfileFragment extends StatefulWidget {
  const ProfileFragment({super.key});

  @override
  State<ProfileFragment> createState() => _ProfileFragmentState();
}

class _ProfileFragmentState extends State<ProfileFragment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: CustomScrollView(
        slivers: [
          // 自定义AppBar和头部区域
          SliverAppBar(
            expandedHeight: 280,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: context.watch<MyColor>().colorPrimary,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildProfileHeader(),
            ),
            title: Text(
              S.of(context).title_profile,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // 统计数据卡片
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: const Offset(0, -10),
              child: _buildStatsCard(),
            ),
          ),
          // 功能菜单
          SliverToBoxAdapter(
            child: _buildMenuSection(),
          ),
        ],
      ),
    );
  }

  // 个人资料头部区域
  Widget _buildProfileHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            context.watch<MyColor>().colorPrimary,
            context.watch<MyColor>().colorPrimary.shade700,
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 60),
            // 头像
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: SvCacheImage(
                imageUrl: "https://via.placeholder.com/120x120/FF6B6B/FFFFFF?text=Avatar",
                width: 120,
                height: 120,
                radius: 60,
                fit: BoxFit.cover,
                placeholder: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.grey.shade600,
                  ),
                ),
                errorWidget: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // 用户名
            const Text(
              "用户昵称",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            // 用户ID或状态
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "ID: 123456789",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 统计数据卡片
  Widget _buildStatsCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              icon: Icons.monetization_on,
              value: "9,999",
              label: "金币",
              color: Colors.amber,
            ),
          ),
          Container(
            height: 50,
            width: 1,
            color: Colors.grey.shade300,
          ),
          Expanded(
            child: _buildStatItem(
              icon: MdiIcons.diamond,
              value: "7,777",
              label: "钻石",
              color: Colors.blue,
            ),
          ),
          Container(
            height: 50,
            width: 1,
            color: Colors.grey.shade300,
          ),
          Expanded(
            child: _buildStatItem(
              icon: Icons.favorite,
              value: "1,234",
              label: "获赞",
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  // 统计项目组件
  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 28,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  // 功能菜单区域
  Widget _buildMenuSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // 快捷功能网格
          _buildQuickActionsGrid(),
          const SizedBox(height: 20),
          // 设置菜单列表
          _buildSettingsMenu(),
        ],
      ),
    );
  }

  // 快捷功能网格
  Widget _buildQuickActionsGrid() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "快捷功能",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildQuickActionItem(
                  icon: Icons.wallet,
                  label: "我的钱包",
                  color: Colors.green,
                  onTap: () {
                    // 导航到钱包页面
                  },
                ),
              ),
              Expanded(
                child: _buildQuickActionItem(
                  icon: Icons.photo_library,
                  label: "我的相册",
                  color: Colors.purple,
                  onTap: () {
                    // 导航到相册页面
                  },
                ),
              ),
              Expanded(
                child: _buildQuickActionItem(
                  icon: MdiIcons.video,
                  label: "我的视频",
                  color: Colors.orange,
                  onTap: () {
                    // 导航到视频页面
                  },
                ),
              ),
              Expanded(
                child: _buildQuickActionItem(
                  icon: Icons.favorite,
                  label: "我的收藏",
                  color: Colors.red,
                  onTap: () {
                    // 导航到收藏页面
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 快捷功能项目
  Widget _buildQuickActionItem({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // 设置菜单列表
  Widget _buildSettingsMenu() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildMenuTile(
            icon: Icons.person_outline,
            title: "个人信息",
            subtitle: "编辑个人资料",
            onTap: () {
              // 导航到个人信息页面
            },
          ),
          _buildDivider(),
          _buildMenuTile(
            icon: Icons.security,
            title: "账号安全",
            subtitle: "密码、隐私设置",
            onTap: () {
              // 导航到安全设置页面
            },
          ),
          _buildDivider(),
          _buildMenuTile(
            icon: Icons.notifications_outlined,
            title: "消息通知",
            subtitle: "推送、提醒设置",
            onTap: () {
              // 导航到通知设置页面
            },
          ),
          _buildDivider(),
          _buildMenuTile(
            icon: Icons.language,
            title: "语言设置",
            subtitle: "切换应用语言",
            onTap: () {
              // 导航到语言设置页面
            },
          ),
          _buildDivider(),
          _buildMenuTile(
            icon: Icons.settings,
            title: S.of(context).settings,
            subtitle: "更多设置选项",
            onTap: () {
              NavigatorUtils.push(context, SettingRouter.settingsDetailPage);
            },
          ),
          _buildDivider(),
          _buildMenuTile(
            icon: Icons.help_outline,
            title: "帮助与反馈",
            subtitle: "常见问题、意见反馈",
            onTap: () {
              // 导航到帮助页面
            },
          ),
        ],
      ),
    );
  }

  // 菜单项组件
  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: context.watch<MyColor>().colorPrimary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: context.watch<MyColor>().colorPrimary,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey.shade600,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey.shade400,
      ),
      onTap: onTap,
    );
  }

  // 分割线
  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Divider(
        height: 1,
        color: Colors.grey.shade200,
      ),
    );
  }
}
