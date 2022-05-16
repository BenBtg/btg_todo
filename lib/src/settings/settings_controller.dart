import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'settings_service.dart';

final settingControllerProvider =
    StateNotifierProvider<SettingsController, ThemeMode>(
        (ref) => SettingsController(ref));

/// A class that many Widgets can interact with to read user settings, update
/// user settings, or listen to user settings changes.
///
/// Controllers glue Data Services to Flutter Widgets. The SettingsController
/// uses the SettingsService to store and retrieve user settings.
class SettingsController extends StateNotifier<ThemeMode> {
  SettingsController(this.ref) : super(ThemeMode.system);

  final Ref ref;

  // Make ThemeMode a private variable so it is not updated directly without
  // also persisting the changes with the SettingsService.
  //late ThemeMode _themeMode;

  // Allow Widgets to read the user's preferred ThemeMode.
  
  /// Load the user's settings from the SettingsService. It may load from a
  /// local database or the internet. The controller only knows it can load the
  /// settings from the service.
  Future<void> loadSettings() async {
    final settingsService = ref.read(settingServiceProvider);

    state = await settingsService.themeMode();
    //    _themeMode = await settingsService.themeMode();
  }

  /// Update and persist the ThemeMode based on the user's selection.
  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null) return;

    // Do not perform any work if new and old ThemeMode are identical
    if (newThemeMode == state) return;

    // Otherwise, store the new ThemeMode in memory
    state = newThemeMode;

    // Important! Inform listeners a change has occurred.

    // Persist the changes to a local database or the internet using the
    // SettingService.
    final settingsService = ref.read(settingServiceProvider);
    await settingsService.updateThemeMode(newThemeMode);
  }
}
