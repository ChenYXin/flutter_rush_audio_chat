import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rush_audio_chat/generated/l10n.dart';
import 'package:rush_audio_chat/commom/my_language.dart';
import '../../../commom/my_color.dart';
import '../../../router/fluro_navigator.dart';
import '../viewmodel/language_viewmodel.dart';

/// 语言选择页面
class LanguageSelectionPage extends StatefulWidget {
  @override
  _LanguageSelectionPageState createState() => _LanguageSelectionPageState();
}

class _LanguageSelectionPageState extends State<LanguageSelectionPage> {
  late LanguageViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    // 获取当前语言并初始化ViewModel
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentLanguage = context.read<MyLanguage>().language;
      _viewModel = LanguageViewModel(currentLanguage);
    });
  }

  // ==================== UI构建方法 ====================

  @override
  Widget build(BuildContext context) {
    final currentLanguage = context.read<MyLanguage>().language;
    return ChangeNotifierProvider(
      create: (context) => LanguageViewModel(currentLanguage),
      child: Consumer<LanguageViewModel>(
        builder: (context, viewModel, child) {
          return WillPopScope(
            onWillPop: () async => _onWillPop(viewModel),
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: context.watch<MyColor>().colorPrimary,
                iconTheme: const IconThemeData(color: Colors.white),
                title: Text(
                  S.of(context).language_selection,
                  style: const TextStyle(color: Colors.white),
                ),
                actions: [
                  if (viewModel.isLoading)
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    ),
                ],
              ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: viewModel.supportedLanguages.length,
                itemBuilder: (context, index) {
                  LanguageConfig languageConfig = viewModel.supportedLanguages[index];
                  bool isSelected = viewModel.isLanguageSelected(languageConfig.code);

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: isSelected
                  ? context.watch<MyColor>().colorPrimary.withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: isSelected
                  ? Border.all(color: context.watch<MyColor>().colorPrimary, width: 2)
                  : null,
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isSelected
                      ? context.watch<MyColor>().colorPrimary
                      : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.language,
                  color: isSelected ? Colors.white : Colors.grey.shade600,
                  size: 20,
                ),
              ),
              title: Text(
                languageConfig.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected
                      ? context.watch<MyColor>().colorPrimary
                      : Colors.black87,
                ),
              ),
              subtitle: Text(
                languageConfig.nativeName,
                style: TextStyle(
                  fontSize: 14,
                  color: isSelected
                      ? context.watch<MyColor>().colorPrimary.withOpacity(0.7)
                      : Colors.grey.shade600,
                ),
              ),
              trailing: isSelected
                  ? Icon(
                      Icons.check_circle,
                      color: context.watch<MyColor>().colorPrimary,
                      size: 24,
                    )
                  : Icon(
                      Icons.radio_button_unchecked,
                      color: Colors.grey.shade400,
                      size: 24,
                    ),
              onTap: () => _onLanguageItemTap(viewModel, languageConfig.code),
            ),
          );
                },
              ),
            ),
            // 应用按钮
            if (viewModel.showApplyButton)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: viewModel.isLoading ? null : () => _saveAndExit(viewModel),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.watch<MyColor>().colorPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: viewModel.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        '应用',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                ),
              ),
          ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// 处理返回按键
  bool _onWillPop(LanguageViewModel viewModel) {
    if (viewModel.hasUnsavedChanges()) {
      _showUnsavedChangesDialog(viewModel);
      return false;
    }
    return true;
  }

  /// 处理语言项点击
  void _onLanguageItemTap(LanguageViewModel viewModel, String languageCode) {
    viewModel.onLanguageItemTap(languageCode);

    // 如果是当前语言，直接返回
    if (languageCode == viewModel.originalLanguage) {
      Navigator.pop(context);
      return;
    }
  }

  /// 保存并退出
  Future<void> _saveAndExit(LanguageViewModel viewModel) async {
    await viewModel.applyLanguageChange();
    if (viewModel.languageChanged) {
      // 更新全局语言设置
      context.read<MyLanguage>().changeMode(viewModel.selectedLanguage);
      // 显示成功消息
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(viewModel.getLanguageChangeMessage()),
          backgroundColor: Colors.green,
        ),
      );
      // 等待一下让用户看到成功提示
      await Future.delayed(const Duration(seconds: 1));
    }
    Navigator.pop(context);
  }

  /// 显示未保存更改对话框
  void _showUnsavedChangesDialog(LanguageViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('未保存的更改'),
        content: const Text('您有未保存的语言设置更改，是否要保存？'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              viewModel.resetSelection();
              Navigator.pop(context);
            },
            child: const Text('放弃'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _saveAndExit(viewModel);
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }
}
