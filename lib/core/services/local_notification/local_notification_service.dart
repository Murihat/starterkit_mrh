import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/routes/app_router.dart';
import '../../network/api_client.dart';
import 'notification_const.dart';

class LocalNotificationService {
  final ApiClient apiClient;

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Map<String, dynamic>? _pendingNotificationData;

  LocalNotificationService({required this.apiClient});

  // ========================================
  // INITIALIZE
  // ========================================

  Future<void> init() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const iosSettings = DarwinInitializationSettings();

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: _handleNotificationResponse,
    );

    await _createChannels();

    await _cleanupNotificationImages();

    await _handleTerminatedState();
  }

  // ========================================
  // CHANNEL
  // ========================================

  Future<void> _createChannels() async {
    if (!Platform.isAndroid) {
      return;
    }

    const channel = AndroidNotificationChannel(
      NotificationConst.channelId,
      NotificationConst.channelName,
      description: NotificationConst.channelDescription,
      importance: Importance.high,
    );

    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await android?.createNotificationChannel(channel);
  }

  // ========================================
  // TERMINATED STATE
  // ========================================

  Future<void> _handleTerminatedState() async {
    final details = await _plugin.getNotificationAppLaunchDetails();

    if (!(details?.didNotificationLaunchApp ?? false)) {
      return;
    }

    final payload = details?.notificationResponse?.payload;

    if (payload == null || payload.isEmpty) {
      return;
    }

    try {
      _pendingNotificationData = jsonDecode(payload) as Map<String, dynamic>;
    } catch (_) {
      debugPrint('Invalid notification payload');
    }
  }

  // ========================================
  // NOTIFICATION RESPONSE
  // ========================================

  Future<void> _handleNotificationResponse(
    NotificationResponse response,
  ) async {
    final payload = response.payload;

    if (payload == null || payload.isEmpty) {
      return;
    }

    try {
      final json = jsonDecode(payload) as Map<String, dynamic>;

      final data = json['data'] is Map<String, dynamic>
          ? json['data'] as Map<String, dynamic>
          : json;

      await _handleNavigation(data);
    } catch (e) {
      debugPrint('Invalid notification payload: $e');
    }
  }

  // ========================================
  // NAVIGATION
  // ========================================

  Future<void> _handleNavigation(Map<String, dynamic> data) async {
    final context = rootNavigatorKey.currentContext;

    if (context == null) {
      _pendingNotificationData = data;
      return;
    }

    final action = (data['action'] ?? 'SELF').toString().toUpperCase();

    switch (action) {
      case 'SELF':
        await _handleSelfNavigation(context, data);
        break;

      case 'REDIRECT':
        await _handleRedirect(data);
        break;

      default:
        debugPrint('Unknown notification action: $action');
    }
  }

  Future<void> _handleSelfNavigation(
    BuildContext context,
    Map<String, dynamic> data,
  ) async {
    final screen = data['screen']?.toString();

    if (screen == null || screen.isEmpty) {
      return;
    }

    context.pushNamed(screen, extra: data);
  }

  Future<void> _handleRedirect(Map<String, dynamic> data) async {
    final path = data['path']?.toString();

    if (path == null || path.isEmpty) {
      return;
    }

    final uri = Uri.tryParse(path);

    if (uri == null) {
      return;
    }

    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  // ========================================
  // PENDING NOTIFICATION
  // ========================================

  void setPendingNotification(Map<String, dynamic> data) {
    _pendingNotificationData = data;
  }

  Future<void> handlePendingNavigation(BuildContext context) async {
    final data = _pendingNotificationData;

    if (data == null) {
      return;
    }

    _pendingNotificationData = null;

    final action = (data['action'] ?? 'SELF').toString().toUpperCase();

    switch (action) {
      case 'SELF':
        await _handleSelfNavigation(context, data);
        break;

      case 'REDIRECT':
        await _handleRedirect(data);
        break;

      default:
        debugPrint('Unknown notification action: $action');
    }
  }

  // ========================================
  // PERMISSION
  // ========================================

  Future<bool> requestPermission() async {
    if (Platform.isAndroid) {
      final android = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

      return await android?.requestNotificationsPermission() ?? true;
    }

    if (Platform.isIOS) {
      final ios = _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();

      return await ios?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          ) ??
          true;
    }

    return true;
  }

  // ========================================
  // BASIC NOTIFICATION
  // ========================================

  Future<void> show({
    required String title,
    required String body,
    Map<String, dynamic>? payloadData,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      NotificationConst.channelId,
      NotificationConst.channelName,
      channelDescription: NotificationConst.channelDescription,
      importance: Importance.high,
      priority: Priority.high,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    final payload = payloadData == null ? null : jsonEncode(payloadData);

    await _plugin.show(
      id: _generateNotificationId(),
      title: title,
      body: body,
      notificationDetails: details,
      payload: payload,
    );
  }

  // ========================================
  // NOTIFICATION WITH IMAGE
  // ========================================

  Future<void> showWithImage({
    required String title,
    required String body,
    required String imageUrl,
    Map<String, dynamic>? payloadData,
  }) async {
    final directory = await getApplicationDocumentsDirectory();

    final filePath =
        '${directory.path}/notification_${DateTime.now().millisecondsSinceEpoch}.jpg';

    String? imagePath;

    try {
      imagePath = await apiClient.downloadFile(
        url: imageUrl,
        savePath: filePath,
      );
    } catch (e) {
      debugPrint('Notification image download failed: $e');
    }

    final style = imagePath == null
        ? null
        : BigPictureStyleInformation(
            FilePathAndroidBitmap(imagePath),
            contentTitle: title,
            summaryText: body,
          );

    final androidDetails = AndroidNotificationDetails(
      NotificationConst.channelId,
      NotificationConst.channelName,
      channelDescription: NotificationConst.channelDescription,
      styleInformation: style,
      importance: Importance.high,
      priority: Priority.high,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: const DarwinNotificationDetails(),
    );

    final payload = payloadData == null ? null : jsonEncode(payloadData);

    try {
      await _plugin.show(
        id: _generateNotificationId(),
        title: title,
        body: body,
        notificationDetails: details,
        payload: payload,
      );
    } finally {
      if (imagePath != null) {
        Future.delayed(const Duration(minutes: 1), () async {
          try {
            final file = File(imagePath!);

            if (await file.exists()) {
              await file.delete();

              debugPrint('Notification image deleted: $imagePath');
            }
          } catch (e) {
            debugPrint('Failed to delete notification image: $e');
          }
        });
      }
    }
  }

  Future<void> _cleanupNotificationImages() async {
    try {
      final directory = await getApplicationDocumentsDirectory();

      final files = directory.listSync();

      for (final entity in files) {
        if (entity is! File) {
          continue;
        }

        final fileName = entity.uri.pathSegments.last;

        if (!fileName.startsWith('notification_') ||
            !fileName.endsWith('.jpg')) {
          continue;
        }

        try {
          await entity.delete();

          debugPrint('Old notification image deleted: ${entity.path}');
        } catch (e) {
          debugPrint('Failed to delete old notification image: $e');
        }
      }
    } catch (e) {
      debugPrint('Notification image cleanup failed: $e');
    }
  }

  // ========================================
  // NOTIFICATION ID
  // ========================================

  int _generateNotificationId() {
    return DateTime.now().millisecondsSinceEpoch.remainder(2147483647);
  }
}
