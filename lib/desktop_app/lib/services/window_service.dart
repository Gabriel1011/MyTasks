import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class WindowService {
  static Future<void> initialize() async {
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
    });
  }

  static Widget buildTitleBar(String title) {
    return GestureDetector(
      onPanStart: (_) => windowManager.startDragging(),
      child: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: const Icon(Icons.minimize),
            onPressed: () => windowManager.minimize(),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => windowManager.close(),
          ),
        ],
      ),
    );
  }
}
