import 'dart:async';
import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';

class Background {
  @pragma('vm:entry-point')
  static Future<void> scheduleDailyBackgroundTask({
    required int hour,
    required int minute,
    required String taskId,
    required Function() taskFunction,
  }) async {
    try {
      final config = BackgroundFetchConfig(
          minimumFetchInterval: 15,
          stopOnTerminate: false,
          enableHeadless: true);
      await BackgroundFetch.configure(config, (String taskId) async {
        final now = DateTime.now();

        debugPrint(
            "🔔 [Background] Evento recibido a las ${now.hour}:${now.minute}");

        try {
          await taskFunction();
          debugPrint("✅ [Background] Tarea $taskId completada");
        } catch (e) {
          debugPrint("❌ [Background] Error en tarea $taskId: $e");
        }

        BackgroundFetch.finish(taskId);
      });

      // Programar la tarea específica
      await BackgroundFetch.scheduleTask(TaskConfig(
        taskId: taskId,
        delay: _calculateInitialDelay(hour, minute),
        periodic: true,
        forceAlarmManager: true, // Forzar exactitud en Android
        stopOnTerminate: false,
        enableHeadless: true,
      ));

      debugPrint(
          "📅 [Background] Tarea $taskId programada para las ${_formatTime(hour, minute)}");
    } catch (e) {
      debugPrint("❌ [Background] Error al programar $taskId: $e");
    }
  }

// Calcula el delay inicial en milisegundos
  static int _calculateInitialDelay(int hour, int minute) {
    final now = DateTime.now();
    final targetToday = DateTime(now.year, now.month, now.day, hour, minute);

    if (now.isBefore(targetToday)) {
      return targetToday.difference(now).inMilliseconds;
    } else {
      final targetTomorrow = targetToday.add(Duration(days: 1));
      return targetTomorrow.difference(now).inMilliseconds;
    }
  }

  /// Cancela una tarea programada
  static Future<void> cancelBackgroundTask(String taskId) async {
    try {
      await BackgroundFetch.stop(taskId);
      debugPrint('🛑 [Background Task] Tarea $taskId cancelada');
    } catch (e) {
      debugPrint('❌ [Background Task] Error al cancelar: $e');
      rethrow;
    }
  }

  /// Formatea hora y minuto como HH:MM
  static String _formatTime(int hour, int minute) {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }
}
