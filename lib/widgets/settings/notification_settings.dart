import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';

class NotificationSettings extends StatefulWidget {
  const NotificationSettings({super.key});

  @override
  State<NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  bool _pushNotifications = true;
  bool _analysisComplete = true;
  bool _newFeatures = false;
  bool _promotional = false;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray900,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundGray900,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notification Settings',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('PUSH NOTIFICATIONS'),
            const SizedBox(height: 16),
            _buildToggleCard(
              'Push Notifications',
              'Receive notifications on your device',
              _pushNotifications,
              (value) => setState(() => _pushNotifications = value),
            ),
            const SizedBox(height: 24),
            
            _buildSectionHeader('NOTIFICATION TYPES'),
            const SizedBox(height: 16),
            _buildToggleCard(
              'Analysis Complete',
              'Get notified when your analysis is ready',
              _analysisComplete,
              (value) => setState(() => _analysisComplete = value),
            ),
            const SizedBox(height: 12),
            _buildToggleCard(
              'New Features',
              'Learn about new features and updates',
              _newFeatures,
              (value) => setState(() => _newFeatures = value),
            ),
            const SizedBox(height: 12),
            _buildToggleCard(
              'Promotional',
              'Receive special offers and promotions',
              _promotional,
              (value) => setState(() => _promotional = value),
            ),
            const SizedBox(height: 24),
            
            _buildSectionHeader('NOTIFICATION SOUNDS'),
            const SizedBox(height: 16),
            _buildToggleCard(
              'Sound',
              'Play sound for notifications',
              _soundEnabled,
              (value) => setState(() => _soundEnabled = value),
            ),
            const SizedBox(height: 12),
            _buildToggleCard(
              'Vibration',
              'Vibrate device for notifications',
              _vibrationEnabled,
              (value) => setState(() => _vibrationEnabled = value),
            ),
            const SizedBox(height: 24),
            
            _buildSectionHeader('QUIET HOURS'),
            const SizedBox(height: 16),
            _buildActionCard(
              'Set Quiet Hours',
              'Choose when to receive notifications',
              Icons.schedule,
              () {
                _showQuietHoursDialog();
              },
            ),
            const SizedBox(height: 12),
            _buildActionCard(
              'Test Notification',
              'Send a test notification to your device',
              Icons.notifications,
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Test notification sent!'),
                    backgroundColor: AppColors.primaryPink,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        color: AppColors.textGray400,
        fontSize: 12,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.0,
      ),
    );
  }

  Widget _buildToggleCard(String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundGray800.withOpacity(0.6),
        borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
        border: Border.all(
          color: AppColors.borderGray600,
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: AppColors.textGray400,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primaryPink,
            activeTrackColor: AppColors.primaryPink.withOpacity(0.3),
            inactiveThumbColor: AppColors.textGray500,
            inactiveTrackColor: AppColors.backgroundGray700,
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(String title, String subtitle, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.backgroundGray800.withOpacity(0.6),
          borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
          border: Border.all(
            color: AppColors.borderGray600,
            width: 0.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.primaryPink,
              size: 20,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: AppColors.textGray400,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.textGray500,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  void _showQuietHoursDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundGray800,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
        ),
        title: const Text(
          'Quiet Hours',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Quiet hours feature coming soon! You\'ll be able to set specific times when you don\'t want to receive notifications.',
          style: TextStyle(color: AppColors.textGray300),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
} 