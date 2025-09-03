import 'package:flutter/material.dart';

/// 用户详情页的ViewModel
class UserDetailViewModel with ChangeNotifier {
  /// 用户ID
  String _userId = '';
  String get userId => _userId;

  /// 用户详情信息
  UserDetailInfo? _userDetail;
  UserDetailInfo? get userDetail => _userDetail;

  /// 加载状态
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// 是否已关注
  bool _isFollowed = false;
  bool get isFollowed => _isFollowed;

  /// 错误信息
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// 用户相册列表
  List<UserPhoto> _photoList = [];
  List<UserPhoto> get photoList => _photoList;

  /// 用户动态列表
  List<UserMoment> _momentList = [];
  List<UserMoment> get momentList => _momentList;

  /// 当前选中的标签页索引
  int _selectedTabIndex = 0;
  int get selectedTabIndex => _selectedTabIndex;

  /// 构造函数
  UserDetailViewModel(String userId) {
    _userId = userId;
    loadUserDetail();
  }

  /// 加载用户详情
  Future<void> loadUserDetail() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // 模拟网络请求
      await Future.delayed(const Duration(seconds: 1));

      // 生成模拟用户数据
      _userDetail = _generateUserDetail(_userId);
      _photoList = _generatePhotoList();
      _momentList = _generateMomentList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = '加载用户信息失败: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 生成模拟用户详情
  UserDetailInfo _generateUserDetail(String userId) {
    final random = DateTime.now().millisecond;
    return UserDetailInfo(
      id: userId,
      nickname: '用户${userId.replaceAll('user_', '')}',
      avatar: 'https://picsum.photos/200/200?random=$random',
      coverImage: 'https://picsum.photos/400/200?random=${random + 1}',
      age: 18 + (random % 30),
      gender: random % 2 == 0 ? '女' : '男',
      location: _getRandomLocation(),
      signature: _getRandomSignature(),
      level: (random % 50) + 1,
      fansCount: (random % 10000) + 100,
      followCount: (random % 1000) + 50,
      likeCount: (random % 50000) + 500,
      tags: _getRandomTags(),
      isOnline: random % 3 == 0,
      lastActiveTime: DateTime.now().subtract(Duration(minutes: random % 60)),
      joinDate: DateTime.now().subtract(Duration(days: random % 365)),
      constellation: _getRandomConstellation(),
      profession: _getRandomProfession(),
    );
  }

  /// 生成模拟相册列表
  List<UserPhoto> _generatePhotoList() {
    final photos = <UserPhoto>[];
    for (int i = 0; i < 12; i++) {
      photos.add(UserPhoto(
        id: 'photo_$i',
        imageUrl: 'https://picsum.photos/300/400?random=${i + 200}',
        likeCount: (i + 1) * 10,
        uploadTime: DateTime.now().subtract(Duration(days: i)),
      ));
    }
    return photos;
  }

  /// 生成模拟动态列表
  List<UserMoment> _generateMomentList() {
    final moments = <UserMoment>[];
    final contents = [
      '今天天气真好，心情也很棒！',
      '分享一下今天的美食',
      '和朋友们一起出去玩',
      '工作中的小确幸',
      '看了一部很棒的电影',
      '学习新技能中...',
      '生活就是要充满阳光',
      '感谢大家的支持和关注',
    ];

    for (int i = 0; i < 8; i++) {
      moments.add(UserMoment(
        id: 'moment_$i',
        content: contents[i],
        images: i % 3 == 0 ? [
          'https://picsum.photos/300/300?random=${i + 300}',
          'https://picsum.photos/300/300?random=${i + 301}',
        ] : [],
        likeCount: (i + 1) * 5,
        commentCount: (i + 1) * 2,
        publishTime: DateTime.now().subtract(Duration(hours: i * 6)),
      ));
    }
    return moments;
  }

  /// 获取随机位置
  String _getRandomLocation() {
    final locations = ['北京', '上海', '广州', '深圳', '杭州', '成都', '重庆', '西安'];
    return locations[DateTime.now().millisecond % locations.length];
  }

  /// 获取随机签名
  String _getRandomSignature() {
    final signatures = [
      '生活不止眼前的苟且，还有诗和远方',
      '做最好的自己',
      '每天都要开心呀',
      '热爱生活，热爱自己',
      '愿你眼中总有光芒',
      '简单生活，快乐每一天',
      '保持热爱，奔赴山海',
      '温柔且坚定',
    ];
    return signatures[DateTime.now().millisecond % signatures.length];
  }

  /// 获取随机标签
  List<String> _getRandomTags() {
    final allTags = ['颜值', '才艺', '游戏', '音乐', '舞蹈', '搞笑', '知识', '生活', '旅行', '美食'];
    final tagCount = 2 + (DateTime.now().millisecond % 4);
    final tags = <String>[];

    for (int i = 0; i < tagCount; i++) {
      final tag = allTags[(DateTime.now().millisecond + i) % allTags.length];
      if (!tags.contains(tag)) {
        tags.add(tag);
      }
    }

    return tags;
  }

  /// 格式化数字显示
  String formatNumber(int number) {
    if (number >= 10000) {
      return '${(number / 10000).toStringAsFixed(1)}万';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}k';
    }
    return number.toString();
  }

  /// 获取随机星座
  String _getRandomConstellation() {
    final constellations = ['白羊座', '金牛座', '双子座', '巨蟹座', '狮子座', '处女座', 
                           '天秤座', '天蝎座', '射手座', '摩羯座', '水瓶座', '双鱼座'];
    return constellations[DateTime.now().millisecond % constellations.length];
  }

  /// 获取随机职业
  String _getRandomProfession() {
    final professions = ['学生', '设计师', '程序员', '教师', '医生', '销售', '自由职业', '创业者'];
    return professions[DateTime.now().millisecond % professions.length];
  }

  /// 切换关注状态
  Future<void> toggleFollow() async {
    try {
      // 模拟网络请求
      await Future.delayed(const Duration(milliseconds: 500));
      
      _isFollowed = !_isFollowed;
      
      // 更新粉丝数
      if (_userDetail != null) {
        final newFansCount = _isFollowed 
            ? _userDetail!.fansCount + 1 
            : _userDetail!.fansCount - 1;
        
        _userDetail = _userDetail!.copyWith(fansCount: newFansCount);
      }
      
      notifyListeners();
    } catch (e) {
      showError('操作失败: ${e.toString()}');
    }
  }

  /// 切换标签页
  void switchTab(int index) {
    _selectedTabIndex = index;
    notifyListeners();
  }

  /// 点赞相册
  void likePhoto(String photoId) {
    final index = _photoList.indexWhere((photo) => photo.id == photoId);
    if (index != -1) {
      _photoList[index] = _photoList[index].copyWith(
        likeCount: _photoList[index].likeCount + 1,
      );
      notifyListeners();
    }
  }

  /// 点赞动态
  void likeMoment(String momentId) {
    final index = _momentList.indexWhere((moment) => moment.id == momentId);
    if (index != -1) {
      _momentList[index] = _momentList[index].copyWith(
        likeCount: _momentList[index].likeCount + 1,
      );
      notifyListeners();
    }
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
}

/// 用户详情信息数据模型
class UserDetailInfo {
  final String id;
  final String nickname;
  final String avatar;
  final String coverImage;
  final int age;
  final String gender;
  final String location;
  final String signature;
  final int level;
  final int fansCount;
  final int followCount;
  final int likeCount;
  final List<String> tags;
  final bool isOnline;
  final DateTime lastActiveTime;
  final DateTime joinDate;
  final String constellation;
  final String profession;

  UserDetailInfo({
    required this.id,
    required this.nickname,
    required this.avatar,
    required this.coverImage,
    required this.age,
    required this.gender,
    required this.location,
    required this.signature,
    required this.level,
    required this.fansCount,
    required this.followCount,
    required this.likeCount,
    required this.tags,
    required this.isOnline,
    required this.lastActiveTime,
    required this.joinDate,
    required this.constellation,
    required this.profession,
  });

  UserDetailInfo copyWith({
    String? id,
    String? nickname,
    String? avatar,
    String? coverImage,
    int? age,
    String? gender,
    String? location,
    String? signature,
    int? level,
    int? fansCount,
    int? followCount,
    int? likeCount,
    List<String>? tags,
    bool? isOnline,
    DateTime? lastActiveTime,
    DateTime? joinDate,
    String? constellation,
    String? profession,
  }) {
    return UserDetailInfo(
      id: id ?? this.id,
      nickname: nickname ?? this.nickname,
      avatar: avatar ?? this.avatar,
      coverImage: coverImage ?? this.coverImage,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      location: location ?? this.location,
      signature: signature ?? this.signature,
      level: level ?? this.level,
      fansCount: fansCount ?? this.fansCount,
      followCount: followCount ?? this.followCount,
      likeCount: likeCount ?? this.likeCount,
      tags: tags ?? this.tags,
      isOnline: isOnline ?? this.isOnline,
      lastActiveTime: lastActiveTime ?? this.lastActiveTime,
      joinDate: joinDate ?? this.joinDate,
      constellation: constellation ?? this.constellation,
      profession: profession ?? this.profession,
    );
  }
}

/// 用户相册数据模型
class UserPhoto {
  final String id;
  final String imageUrl;
  final int likeCount;
  final DateTime uploadTime;

  UserPhoto({
    required this.id,
    required this.imageUrl,
    required this.likeCount,
    required this.uploadTime,
  });

  UserPhoto copyWith({
    String? id,
    String? imageUrl,
    int? likeCount,
    DateTime? uploadTime,
  }) {
    return UserPhoto(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      likeCount: likeCount ?? this.likeCount,
      uploadTime: uploadTime ?? this.uploadTime,
    );
  }
}

/// 用户动态数据模型
class UserMoment {
  final String id;
  final String content;
  final List<String> images;
  final int likeCount;
  final int commentCount;
  final DateTime publishTime;

  UserMoment({
    required this.id,
    required this.content,
    required this.images,
    required this.likeCount,
    required this.commentCount,
    required this.publishTime,
  });

  UserMoment copyWith({
    String? id,
    String? content,
    List<String>? images,
    int? likeCount,
    int? commentCount,
    DateTime? publishTime,
  }) {
    return UserMoment(
      id: id ?? this.id,
      content: content ?? this.content,
      images: images ?? this.images,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      publishTime: publishTime ?? this.publishTime,
    );
  }
}
