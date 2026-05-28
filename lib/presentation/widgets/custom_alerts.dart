import 'package:flutter/material.dart';

// CUSTOM ALERT HELPER CLASS
class CinematicAlerts {

  // SUCCESS ALERT
  static void showSuccess(
      BuildContext context, {
        required String title,
        required String message,
        VoidCallback? onConfirm,
        String confirmText = 'Great!',
      }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _CinematicAlert(
        type: AlertType.success,
        title: title,
        message: message,
        confirmText: confirmText,
        onConfirm: onConfirm ?? () => Navigator.pop(context),
      ),
    );
  }

  // ERROR ALERT
  static void showError(
      BuildContext context, {
        required String title,
        required String message,
        VoidCallback? onConfirm,
        String confirmText = 'Try Again',
      }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _CinematicAlert(
        type: AlertType.error,
        title: title,
        message: message,
        confirmText: confirmText,
        onConfirm: onConfirm ?? () => Navigator.pop(context),
      ),
    );
  }

  // WARNING ALERT
  static void showWarning(
      BuildContext context, {
        required String title,
        required String message,
        VoidCallback? onConfirm,
        String confirmText = 'Understood',
      }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _CinematicAlert(
        type: AlertType.warning,
        title: title,
        message: message,
        confirmText: confirmText,
        onConfirm: onConfirm ?? () => Navigator.pop(context),
      ),
    );
  }

  // CONFIRMATION ALERT (DELETE/DESTRUCTIVE ACTIONS)
  static void showConfirmation(
      BuildContext context, {
        required String title,
        required String message,
        required VoidCallback onConfirm,
        VoidCallback? onCancel,
        String confirmText = 'Delete',
        String cancelText = 'Cancel',
        bool isDestructive = true,
      }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _CinematicConfirmationAlert(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        isDestructive: isDestructive,
        onConfirm: onConfirm,
        onCancel: onCancel ?? () => Navigator.pop(context),
      ),
    );
  }

  // LOADING ALERT
  static void showLoading(
      BuildContext context, {
        String message = 'Loading...',
      }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _CinematicLoadingAlert(message: message),
    );
  }

  // CUSTOM SNACKBAR
  static void showSnackBar(
      BuildContext context, {
        required String message,
        required AlertType type,
        Duration duration = const Duration(seconds: 3),
        VoidCallback? onAction,
        String? actionText,
      }) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: _CinematicSnackBarContent(
          message: message,
          type: type,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        action: onAction != null && actionText != null
            ? SnackBarAction(
          label: actionText,
          textColor: _getAlertColor(type),
          onPressed: onAction,
        )
            : null,
      ),
    );
  }

  // BOTTOM SHEET ALERT (FOR MOBILE-FRIENDLY ACTIONS)
  static void showBottomSheet(
      BuildContext context, {
        required String title,
        String? message,
        required List<AlertAction> actions,
      }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _CinematicBottomSheet(
        title: title,
        message: message,
        actions: actions,
      ),
    );
  }

  // HELPER METHOD TO GET ALERT COLORS
  static Color _getAlertColor(AlertType type) {
    switch (type) {
      case AlertType.success:
        return const Color(0xFF00C853); // Success green
      case AlertType.error:
        return const Color(0xFFE50914); // Netflix red
      case AlertType.warning:
        return const Color(0xFFFFD600); // Amber warning
      case AlertType.info:
        return const Color(0xFF2196F3); // Info blue
    }
  }

  // HELPER METHOD TO GET ALERT ICONS
  static IconData _getAlertIcon(AlertType type) {
    switch (type) {
      case AlertType.success:
        return Icons.check_circle_rounded;
      case AlertType.error:
        return Icons.error_rounded;
      case AlertType.warning:
        return Icons.warning_rounded;
      case AlertType.info:
        return Icons.info_rounded;
    }
  }
}

// ALERT TYPES ENUM
enum AlertType { success, error, warning, info }

// ACTION MODEL FOR BOTTOM SHEET
class AlertAction {
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isDestructive;

  AlertAction({
    required this.label,
    required this.onPressed,
    this.icon,
    this.isDestructive = false,
  });
}

// MAIN ALERT DIALOG WIDGET
class _CinematicAlert extends StatelessWidget {
  final AlertType type;
  final String title;
  final String message;
  final String confirmText;
  final VoidCallback onConfirm;

  const _CinematicAlert({
    required this.type,
    required this.title,
    required this.message,
    required this.confirmText,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final color = CinematicAlerts._getAlertColor(type);
    final icon = CinematicAlerts._getAlertIcon(type);

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF1F1F1F),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon with animated background
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(color: color.withOpacity(0.3), width: 2),
              ),
              child: Icon(
                icon,
                size: 40,
                color: color,
              ),
            ),

            const SizedBox(height: 24),

            // Title
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            // Message
            Text(
              message,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 16,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            // Action button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onConfirm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  confirmText,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// CONFIRMATION ALERT DIALOG
class _CinematicConfirmationAlert extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final bool isDestructive;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const _CinematicConfirmationAlert({
    required this.title,
    required this.message,
    required this.confirmText,
    required this.cancelText,
    required this.isDestructive,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final confirmColor = isDestructive
        ? const Color(0xFFE50914)
        : const Color(0xFF00C853);

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF1F1F1F),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Warning icon for destructive actions
            if (isDestructive) ...[
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: confirmColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: confirmColor.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.warning_rounded,
                  size: 40,
                  color: confirmColor,
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Title
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            // Message
            Text(
              message,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 16,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            // Action buttons
            Row(
              children: [
                // Cancel button
                Expanded(
                  child: OutlinedButton(
                    onPressed: onCancel,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white.withOpacity(0.8),
                      side: BorderSide(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      cancelText,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // Confirm button
                Expanded(
                  child: ElevatedButton(
                    onPressed: onConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: confirmColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      confirmText,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// LOADING ALERT DIALOG
class _CinematicLoadingAlert extends StatelessWidget {
  final String message;

  const _CinematicLoadingAlert({required this.message});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: const Color(0xFF1F1F1F),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE50914)),
              strokeWidth: 3,
            ),
            const SizedBox(height: 24),
            Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// CUSTOM SNACKBAR CONTENT
class _CinematicSnackBarContent extends StatelessWidget {
  final String message;
  final AlertType type;

  const _CinematicSnackBarContent({
    required this.message,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final color = CinematicAlerts._getAlertColor(type);
    final icon = CinematicAlerts._getAlertIcon(type);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// BOTTOM SHEET ALERT
class _CinematicBottomSheet extends StatelessWidget {
  final String title;
  final String? message;
  final List<AlertAction> actions;

  const _CinematicBottomSheet({
    required this.title,
    this.message,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1F1F1F),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              const SizedBox(height: 20),

              // Title
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              // Message if provided
              if (message != null) ...[
                const SizedBox(height: 12),
                Text(
                  message!,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],

              const SizedBox(height: 24),

              // Actions
              ...actions.map((action) => Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 12),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    action.onPressed();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: action.isDestructive
                        ? const Color(0xFFE50914)
                        : const Color(0xFF2D2D2D),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (action.icon != null) ...[
                        Icon(action.icon!, size: 20),
                        const SizedBox(width: 12),
                      ],
                      Text(
                        action.label,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              )),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

// EXAMPLE USAGE CLASS (FOR DEMONSTRATION)
class AlertExamples {

  // Success examples
  static void showFolderCreated(BuildContext context, String folderName) {
    CinematicAlerts.showSuccess(
      context,
      title: 'Folder Created!',
      message: 'Your "$folderName" folder is ready for movies!',
      confirmText: 'Start Adding',
    );
  }

  static void showMovieAdded(BuildContext context, String movieTitle, String folderName) {
    CinematicAlerts.showSnackBar(
      context,
      message: '"$movieTitle" added to $folderName',
      type: AlertType.success,
    );
  }

  // Error examples
  static void showNetworkError(BuildContext context) {
    CinematicAlerts.showError(
      context,
      title: 'Connection Failed',
      message: 'Please check your internet connection and try again.',
      confirmText: 'Retry',
    );
  }

  static void showMovieNotFound(BuildContext context) {
    CinematicAlerts.showSnackBar(
      context,
      message: 'Movie not found. Try a different search term.',
      type: AlertType.error,
    );
  }

  // Warning examples
  static void showStorageWarning(BuildContext context) {
    CinematicAlerts.showWarning(
      context,
      title: 'Storage Almost Full',
      message: 'You have saved 95+ movies. Consider organizing your folders.',
      confirmText: 'Manage Storage',
    );
  }

  // Confirmation examples
  static void confirmDeleteFolder(BuildContext context, String folderName, int movieCount, VoidCallback onConfirm) {
    CinematicAlerts.showConfirmation(
      context,
      title: 'Delete Folder',
      message: 'Are you sure you want to delete "$folderName"? This will remove $movieCount movies from this folder.',
      confirmText: 'Delete',
      cancelText: 'Keep It',
      isDestructive: true,
      onConfirm: onConfirm,
    );
  }

  // Bottom sheet examples
  static void showFolderOptions(BuildContext context, String folderName) {
    CinematicAlerts.showBottomSheet(
      context,
      title: folderName,
      message: 'What would you like to do with this folder?',
      actions: [
        AlertAction(
          label: 'Edit Folder',
          icon: Icons.edit,
          onPressed: () {
            // Handle edit
          },
        ),
        AlertAction(
          label: 'Share Folder',
          icon: Icons.share,
          onPressed: () {
            // Handle share
          },
        ),
        AlertAction(
          label: 'Delete Folder',
          icon: Icons.delete,
          isDestructive: true,
          onPressed: () {
            // Handle delete
          },
        ),
      ],
    );
  }

  // Loading examples
  static void showSaving(BuildContext context) {
    CinematicAlerts.showLoading(
      context,
      message: 'Saving your movie...',
    );
  }
}