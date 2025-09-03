import 'package:flutter/material.dart';

/// ProfileFragment的ViewModel
class ProfileViewModel with ChangeNotifier {
  /// 用户资料数据
  UserProfile _userProfile = UserProfile(
    id: '123456789',
    nickname: '用户昵称',
    avatar: 'https://picsum.photos/120/120?random=1',
    coins: 9999,
    diamonds: 7777,
    likes: 1234,
  );
  UserProfile get userProfile => _userProfile;

  /// 加载状态
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// 错误信息
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// 更新用户昵称
  Future<void> updateNickname(String newNickname) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
      
      // 模拟网络请求
      await Future.delayed(const Duration(seconds: 1));
      
      _userProfile = _userProfile.copyWith(nickname: newNickname);
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = '更新昵称失败: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 更新头像
  Future<void> updateAvatar(String newAvatarUrl) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
      
      // 模拟头像上传
      await Future.delayed(const Duration(seconds: 2));
      
      _userProfile = _userProfile.copyWith(avatar: newAvatarUrl);
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = '更新头像失败: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 刷新用户数据
  Future<void> refreshUserData() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
      
      // 模拟网络请求
      await Future.delayed(const Duration(seconds: 1));
      
      // 模拟数据更新
      _userProfile = _userProfile.copyWith(
        coins: _userProfile.coins + 100,
        diamonds: _userProfile.diamonds + 50,
        likes: _userProfile.likes + 10,
      );
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = '刷新失败: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 模拟签到获得奖励
  Future<void> dailyCheckIn() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
      
      await Future.delayed(const Duration(seconds: 1));
      
      // 随机奖励
      final coinsReward = 50 + (DateTime.now().millisecond % 100);
      final diamondsReward = 10 + (DateTime.now().millisecond % 20);
      
      _userProfile = _userProfile.copyWith(
        coins: _userProfile.coins + coinsReward,
        diamonds: _userProfile.diamonds + diamondsReward,
      );
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = '签到失败: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 获取格式化的数字显示
  String getFormattedNumber(int number) {
    if (number >= 10000) {
      return '${(number / 10000).toStringAsFixed(1)}万';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}k';
    }
    return number.toString();
  }

  /// 显示错误信息
  void showError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  /// 清除错误信息
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// 显示成功信息
  void showSuccess(String message) {
    // 这里可以添加成功消息的处理逻辑
    notifyListeners();
  }
}

/// 用户资料数据模型
class UserProfile {
  final String id;
  final String nickname;
  final String avatar;
  final int coins;
  final int diamonds;
  final int likes;

  UserProfile({
    required this.id,
    required this.nickname,
    required this.avatar,
    required this.coins,
    required this.diamonds,
    required this.likes,
  });

  UserProfile copyWith({
    String? id,
    String? nickname,
    String? avatar,
    int? coins,
    int? diamonds,
    int? likes,
  }) {
    return UserProfile(
      id: id ?? this.id,
      nickname: nickname ?? this.nickname,
      avatar: avatar ?? this.avatar,
      coins: coins ?? this.coins,
      diamonds: diamonds ?? this.diamonds,
      likes: likes ?? this.likes,
    );
  }
}
