import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:system_tray/system_tray.dart';
import 'package:window_manager/window_manager.dart';

class PlatformService {
  static bool get isDesktop =>
      !kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS);

  static Future<void> initialize() async {
    if (isDesktop) {
      await _initializeDesktop();
    }
  }

  static Future<void> _initializeDesktop() async {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = const WindowOptions(
      size: Size(350, 400),
      minimumSize: Size(100, 100),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.hidden,
    );
    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
      await windowManager.setAlwaysOnTop(true);
    });

    // await initSystemTray();
  }

  static Future<void> initSystemTray() async {
    final SystemTray systemTray = SystemTray();
    final Menu menu = Menu();

    String path = 'windows/runner/resources/app_icon.ico';

    await systemTray.initSystemTray(
      title: "MyTasks",
      iconPath: path,
    );

    await menu.buildFrom([
      MenuItemLabel(
          label: 'Show', onClicked: (menuItem) => windowManager.show()),
      MenuItemLabel(
          label: 'Hide', onClicked: (menuItem) => windowManager.hide()),
      MenuItemLabel(
          label: 'Exit', onClicked: (menuItem) => windowManager.close()),
    ]);

    await systemTray.setContextMenu(menu);

    systemTray.registerSystemTrayEventHandler((eventName) {
      debugPrint("eventName: $eventName");
      if (eventName == kSystemTrayEventClick) {
        windowManager.isVisible().then((visible) {
          if (visible) {
            windowManager.hide();
          } else {
            windowManager.show();
          }
        });
      } else if (eventName == kSystemTrayEventRightClick) {
        systemTray.popUpContextMenu();
      }
    });
  }

  static Future<void> hideWindow() async {
    if (isDesktop) {
      await windowManager.hide();
    }
  }

  static Future<void> showWindow() async {
    if (isDesktop) {
      await windowManager.show();
    }
  }

  static Future<void> closeWindow() async {
    if (isDesktop) {
      await windowManager.close();
    }
  }
}
