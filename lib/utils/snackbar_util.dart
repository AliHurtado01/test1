import 'package:flutter/material.dart';

// Creamos un Enum para definir los tipos de mensajes y automatizar los colores
enum SnackBarType { success, error, info }

class SnackBarUtil {
  static void show(
    BuildContext context, {
    required String message,
    SnackBarType type = SnackBarType.info,
    Duration duration = const Duration(seconds: 4), // Duración por defecto
  }) {
    Color backgroundColor;
    IconData icon;

    // Asignamos colores e iconos según el tipo de mensaje
    switch (type) {
      case SnackBarType.success:
        backgroundColor = Colors.green.shade700;
        icon = Icons.check_circle_outline;
        break;
      case SnackBarType.error:
        backgroundColor = Colors.red.shade800;
        icon = Icons.error_outline;
        break;
      case SnackBarType.info:
      default:
        backgroundColor = Theme.of(context).colorScheme.primary;
        icon = Icons.info_outline;
        break;
    }

    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating, // Flotante para diseño moderno
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      duration: duration,
      // Añadimos una "X" para que el usuario pueda cerrarlo manualmente si no quiere esperar
      action: SnackBarAction(
        label: 'X',
        textColor: Colors.white,
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );

    //Si ya hay un SnackBar mostrándose, lo ocultamos antes de mostrar el nuevo
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
