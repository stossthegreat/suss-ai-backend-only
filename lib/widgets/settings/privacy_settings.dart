import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';

class PrivacySettings extends StatefulWidget {
  const PrivacySettings({super.key});

  @override
  State<PrivacySettings> createState() => _PrivacySettingsState();
}

class _PrivacySettingsState extends State<PrivacySettings> {
  bool _dataCollection = true;
  bool _analyticsEnabled = true;
  bool _crashReporting = false;
  bool _personalizedAds = false;

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
          'Privacy Settings',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('DATA COLLECTION'),
            const SizedBox(height: 16),
            _buildToggleCard(
              'Data Collection',
              'Allow MySnitch AI to collect usage data to improve the service',
              _dataCollection,
              (value) => setState(() => _dataCollection = value),
            ),
            const SizedBox(height: 12),
            _buildToggleCard(
              'Analytics',
              'Help us improve by sharing anonymous usage statistics',
              _analyticsEnabled,
              (value) => setState(() => _analyticsEnabled = value),
            ),
            const SizedBox(height: 12),
            _buildToggleCard(
              'Crash Reporting',
              'Automatically send crash reports to help fix issues',
              _crashReporting,
              (value) => setState(() => _crashReporting = value),
            ),
            const SizedBox(height: 12),
            _buildToggleCard(
              'Personalized Ads',
              'Show ads based on your interests and usage',
              _personalizedAds,
              (value) => setState(() => _personalizedAds = value),
            ),
            const SizedBox(height: 24),
            
            _buildSectionHeader('DATA CONTROL'),
            const SizedBox(height: 16),
            _buildActionCard(
              'Download My Data',
              'Get a copy of all data we have about you',
              Icons.download,
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Data download feature coming soon!')),
                );
              },
            ),
            const SizedBox(height: 12),
            _buildActionCard(
              'Request Data Deletion',
              'Permanently delete all your data from our servers',
              Icons.delete_forever,
              () {
                _showDataDeletionDialog();
              },
            ),
            const SizedBox(height: 24),
            
            _buildSectionHeader('PRIVACY POLICY'),
            const SizedBox(height: 16),
            _buildActionCard(
              'View Privacy Policy',
              'Read our complete privacy policy',
              Icons.privacy_tip,
              () {
                // TODO: Open privacy policy
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Privacy policy coming soon!')),
                );
              },
            ),
            const SizedBox(height: 12),
            _buildActionCard(
              'Terms of Service',
              'Read our terms and conditions',
              Icons.description,
              () {
                // TODO: Open terms of service
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Terms of service coming soon!')),
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

  void _showDataDeletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundGray800,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
        ),
        title: const Text(
          'Request Data Deletion?',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'This will permanently delete all your data from our servers. This action cannot be undone.',
          style: TextStyle(color: AppColors.textGray300),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Data deletion request submitted!'),
                  backgroundColor: AppColors.primaryPink,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.dangerRed,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
} 