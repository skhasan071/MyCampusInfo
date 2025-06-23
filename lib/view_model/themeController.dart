import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_campus_info/constants/customTheme.dart';

class ThemeController extends GetxController {
  static ThemeController get to => Get.find();

  RxInt selectedThemeIndex = 0.obs;

  List<CustomTheme> allThemes = [
    AppThemes.emeraldTheme,
    AppThemes.blackWhiteTheme,
    AppThemes.coloredTheme,
    AppThemes.sunsetTheme,
    AppThemes.coolBlueTheme,
  ];

  CustomTheme get currentTheme => allThemes[selectedThemeIndex.value];

  static const _themeKey = 'selectedThemeIndex';

  @override
  void onInit() {
    super.onInit();
    _loadThemeFromPrefs();
  }

  void changeTheme(int index) {
    selectedThemeIndex.value = index;
    _saveThemeToPrefs(index);
    update();
  }

  Future<void> _saveThemeToPrefs(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, value);
  }

  Future<void> _loadThemeFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    selectedThemeIndex.value = prefs.getInt(_themeKey) ?? 0;
  }
}
