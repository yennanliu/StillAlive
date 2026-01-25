import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../core/theme/app_theme.dart';

/// Permissions page - request necessary permissions
class PermissionsPage extends StatefulWidget {
  final VoidCallback onContinue;

  const PermissionsPage({super.key, required this.onContinue});

  @override
  State<PermissionsPage> createState() => _PermissionsPageState();
}

class _PermissionsPageState extends State<PermissionsPage> {
  PermissionStatus _smsStatus = PermissionStatus.denied;
  PermissionStatus _phoneStatus = PermissionStatus.denied;
  PermissionStatus _notificationStatus = PermissionStatus.denied;
  bool _isLoading = false;
  bool _hasRequestedOnce = false;

  @override
  void initState() {
    super.initState();
    _checkAndRequestPermissions();
  }

  Future<void> _checkAndRequestPermissions() async {
    await _checkPermissions();

    // Auto-request permissions on first load
    if (!_hasRequestedOnce) {
      _hasRequestedOnce = true;
      // Small delay to let UI settle
      await Future.delayed(const Duration(milliseconds: 500));
      await _requestAllPermissions();
    }
  }

  Future<void> _checkPermissions() async {
    final smsStatus = await Permission.sms.status;
    final phoneStatus = await Permission.phone.status;
    final notificationStatus = await Permission.notification.status;

    if (mounted) {
      setState(() {
        _smsStatus = smsStatus;
        _phoneStatus = phoneStatus;
        _notificationStatus = notificationStatus;
      });
    }
  }

  Future<void> _requestAllPermissions() async {
    setState(() {
      _isLoading = true;
    });

    // Request only denied permissions
    if (!_smsStatus.isGranted) {
      await Permission.sms.request();
    }
    if (!_phoneStatus.isGranted) {
      await Permission.phone.request();
    }
    if (!_notificationStatus.isGranted) {
      await Permission.notification.request();
    }

    await _checkPermissions();

    setState(() {
      _isLoading = false;
    });
  }

  bool get _canContinue {
    // SMS and Phone are critical, Notifications are optional but recommended
    return _smsStatus.isGranted && _phoneStatus.isGranted;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Text(
            'Permissions',
            style: AppTheme.headlineLarge.copyWith(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'We need these permissions to send emergency alerts:',
            style: AppTheme.bodyLarge,
          ),
          const SizedBox(height: 32),
          _PermissionItem(
            icon: Icons.sms,
            title: 'SMS',
            description: 'Send text messages to emergency contacts',
            status: _smsStatus,
            isRequired: true,
          ),
          const SizedBox(height: 16),
          _PermissionItem(
            icon: Icons.phone,
            title: 'Phone',
            description: 'Make calls to emergency contacts',
            status: _phoneStatus,
            isRequired: true,
          ),
          const SizedBox(height: 16),
          _PermissionItem(
            icon: Icons.notifications,
            title: 'Notifications',
            description: 'Daily reminders to check in',
            status: _notificationStatus,
            isRequired: false,
          ),
          const SizedBox(height: 32),
          if (!_canContinue)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                border: Border.all(color: Colors.orange),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning, color: Colors.orange),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'SMS and Phone permissions are required to send emergency alerts',
                      style: AppTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          const Spacer(),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _requestAllPermissions,
                    child: const Text('Grant Permissions'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _canContinue ? widget.onContinue : null,
                    child: const Text('Continue'),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _PermissionItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final PermissionStatus status;
  final bool isRequired;

  const _PermissionItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.status,
    required this.isRequired,
  });

  @override
  Widget build(BuildContext context) {
    final isGranted = status.isGranted;
    final color = isGranted ? Colors.green : Colors.grey;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: AppTheme.bodyLarge.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (isRequired) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
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
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: AppTheme.bodySmall.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Icon(isGranted ? Icons.check_circle : Icons.cancel, color: color),
          ],
        ),
      ),
    );
  }
}
