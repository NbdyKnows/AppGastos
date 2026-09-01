import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Notifier para gestionar booleanos persistidos en SharedPreferences.
class SettingsBoolNotifier extends StateNotifier<bool> {
  final String key;

  SettingsBoolNotifier({required this.key, bool defaultValue = true})
      : super(defaultValue) {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey(key)) {
        final savedValue = prefs.getBool(key);
        if (savedValue != null && savedValue != state) {
          super.state = savedValue;
        }
      }
    } catch (_) {
      // Si falla la lectura, se mantiene el valor por defecto
    }
  }

  @override
  set state(bool value) {
    super.state = value;
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool(key, value);
    }).catchError((_) {});
  }

  Future<void> update(bool value) async {
    state = value;
  }

  Future<void> toggle() async {
    state = !state;
  }
}

/// Provider para activar/desactivar haptic feedback y vibración (por defecto true).
final hapticsEnabledProvider =
    StateNotifierProvider<SettingsBoolNotifier, bool>((ref) {
  return SettingsBoolNotifier(key: 'haptics_enabled', defaultValue: true);
});

/// Provider para activar/desactivar modo oscuro (por defecto true).
final isDarkModeProvider =
    StateNotifierProvider<SettingsBoolNotifier, bool>((ref) {
  return SettingsBoolNotifier(key: 'is_dark_mode', defaultValue: true);
});

/// Notifier para gestionar strings persistidos en SharedPreferences.
class SettingsStringNotifier extends StateNotifier<String> {
  final String key;

  SettingsStringNotifier({required this.key, String defaultValue = 'Lemon'})
      : super(defaultValue) {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey(key)) {
        final savedValue = prefs.getString(key);
        if (savedValue != null && savedValue.isNotEmpty && savedValue != state) {
          super.state = savedValue;
        }
      }
    } catch (_) {}
  }

  @override
  set state(String value) {
    super.state = value;
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString(key, value);
    }).catchError((_) {});
  }

  Future<void> update(String value) async {
    state = value;
  }
}

/// Provider para la paleta de colores activa ('Lemon', 'Dracula', 'Emerald', 'Indigo').
final selectedThemePaletteProvider =
    StateNotifierProvider<SettingsStringNotifier, String>((ref) {
  return SettingsStringNotifier(key: 'selected_theme_palette', defaultValue: 'Lemon');
});
