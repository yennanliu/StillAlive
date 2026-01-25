import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../core/theme/app_theme.dart';

/// Widget showing permission status
class PermissionStatusCard extends StatefulWidget {
  const PermissionStatusCard({super.key});

  @override
  State<PermissionStatusCard> createState() => _PermissionStatusCardState();
}

class _PermissionStatusCardState extends State<PermissionStatusCard> {
  PermissionStatus _smsStatus = PermissionStatus.denied;
  PermissionStatus _phoneStatus = PermissionStatus.denied;
  PermissionStatus _notificationStatus = PermissionStatus.denied;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    final sms = await Permission.sms.status;
    final phone = await Permission.phone.status;
    final notification = await Permission.notification.status;

    setState(() {
      _smsStatus = sms;
      _phoneStatus = phone;
      _notificationStatus = notification;
    });
  }

  Future<void> _openSettings() async {
    await openAppSettings();
    // Refresh permissions after returning from settings
    Future.delayed(const Duration(seconds: 1), _checkPermissions);
  }

  @override
  Widget build(BuildContext context) {
    final allGranted =
        _smsStatus.isGranted &&
        _phoneStatus.isGranted &&
        _notificationStatus.isGranted;

    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              allGranted ? Icons.check_circle : Icons.warning,
              color: allGranted ? Colors.green : Colors.orange,
            ),
            title: const Text('App Permissions'),
            subtitle: Text(
              allGranted
                  ? 'All permissions granted'
                  : 'Some permissions need attention',
            ),
            trailing: TextButton(
              onPressed: _openSettings,
              child: const Text('Settings'),
            ),
          ),
          const Divider(height: 1),
          _PermissionItem(
            icon: Icons.sms,
            title: 'SMS',
            status: _smsStatus,
            isRequired: true,
          ),
          const Divider(height: 1),
          _PermissionItem(
            icon: Icons.phone,
            title: 'Phone',
            status: _phoneStatus,
            isRequired: true,
          ),
          const Divider(height: 1),
          _PermissionItem(
            icon: Icons.notifications,
            title: 'Notifications',
            status: _notificationStatus,
            isRequired: false,
          ),
        ],
      ),
    );
  }
}

class _PermissionItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final PermissionStatus status;
  final bool isRequired;

  const _PermissionItem({
    required this.icon,
    required this.title,
    required this.status,
    required this.isRequired,
  });

  @override
  Widget build(BuildContext context) {
    final isGranted = status.isGranted;
    final color = isGranted ? Colors.green : Colors.grey;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Row(
        children: [
          Text(title),
          if (isRequired) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.red[100],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Required',
                style: AppTheme.bodySmall.copyWith(
                  color: Colors.red[900],
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ],
      ),
      trailing: Icon(
        isGranted ? Icons.check_circle : Icons.cancel,
        color: color,
      ),
    );
  }
}
