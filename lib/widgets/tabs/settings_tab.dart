import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../providers/theme_provider.dart';
import '../settings/account_settings.dart';
import '../settings/privacy_settings.dart';
import '../settings/premium_settings.dart';
import '../settings/notification_settings.dart';
import '../settings/help_support.dart';
import '../settings/about_app.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  // ✅ REUSED from Phase 2 & 3: 
  // - State management for all toggle switches
  // - AppConstants for animations
  String _defaultTone = 'brutal'; // Default tone like React
  bool _voiceToggle = false;
  bool _lieDetectorEnabled = false;
  bool _deepScanUnlocked = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section - EXACTLY like React
              _buildHeader(),
              const SizedBox(height: 24),
              
              // Analysis Preferences - EXACTLY like React section
              _buildAnalysisPreferences(),
              const SizedBox(height: 32),
              
              // Theme Settings - NEW section
              _buildThemeSection(themeProvider),
              const SizedBox(height: 24),
              
              // Account & Subscription - EXACTLY like React section
              _buildAccountSection(),
              const SizedBox(height: 32),
              
              // Support & Legal - EXACTLY like React section
              _buildSupportSection(),
              const SizedBox(height: 32),
              
              // Version Info - EXACTLY like React footer
              _buildVersionInfo(),
              
              const SizedBox(height: 100), // Bottom padding for tab bar
            ],
          ),
        );
      },
    );
  }

  // ✅ HEADER - Matches React: Simple "Settings" title
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          'Settings',
          style: TextStyle(
            color: Theme.of(context).textTheme.titleLarge?.color ?? Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // ✅ THEME SETTINGS - New section for theme controls
  Widget _buildThemeSection(ThemeProvider themeProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('APPEARANCE'),
        const SizedBox(height: 16),
        _buildToggleCard(
          'Dark Mode',
          'Switch between light and dark themes',
          Icons.dark_mode,
          themeProvider.isDarkMode,
          (value) => themeProvider.setTheme(value),
        ),
      ],
    );
  }

  // ✅ ANALYSIS PREFERENCES - Matches React: All analysis toggles
  Widget _buildAnalysisPreferences() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('ANALYSIS PREFERENCES'),
        const SizedBox(height: 16),
        _buildToggleCard(
          'Voice Analysis',
          'Enable voice message analysis',
          Icons.mic,
          _voiceToggle,
          (value) => setState(() => _voiceToggle = value),
        ),
        const SizedBox(height: 12),
        _buildToggleCard(
          'Lie Detector',
          'Enable advanced lie detection',
          Icons.psychology,
          _lieDetectorEnabled,
          (value) => setState(() => _lieDetectorEnabled = value),
        ),
        const SizedBox(height: 12),
        _buildToggleCard(
          'Deep Scan',
          'Enable deep pattern analysis',
          Icons.search,
          _deepScanUnlocked,
          (value) => setState(() => _deepScanUnlocked = value),
        ),
        const SizedBox(height: 16),
        _buildActionCard(
          'Default Tone',
          'Set your preferred comeback tone',
          Icons.tune,
          () {
            _showToneSelector();
          },
        ),
      ],
    );
  }

  // ✅ ACCOUNT SECTION - Matches React: Account management cards
  Widget _buildAccountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('ACCOUNT & SUBSCRIPTION'),
        const SizedBox(height: 16),
        _buildActionCard(
          'Account Settings',
          'Manage your account and profile',
          Icons.person,
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AccountSettings(),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        _buildActionCard(
          'Premium Settings',
          'Manage your subscription and billing',
          Icons.star,
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PremiumSettings(),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        _buildActionCard(
          'Privacy Settings',
          'Control your data and privacy',
          Icons.privacy_tip,
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PrivacySettings(),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        _buildActionCard(
          'Notification Settings',
          'Manage push notifications',
          Icons.notifications,
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NotificationSettings(),
              ),
            );
          },
        ),
      ],
    );
  }

  // ✅ SUPPORT SECTION - Matches React: Support and legal links
  Widget _buildSupportSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('SUPPORT & LEGAL'),
        const SizedBox(height: 16),
        _buildActionCard(
          'Help & Support',
          'Get help and find answers',
          Icons.help,
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HelpSupport(),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        _buildActionCard(
          'About MySnitch AI',
          'Learn about the app and team',
          Icons.info,
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AboutApp(),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        _buildActionCard(
          'Contact Support',
          'Get in touch with our team',
          Icons.support_agent,
          () {
            // TODO: Open contact support
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Contact support coming soon!')),
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
        const SizedBox(height: 12),
        _buildActionCard(
          'Privacy Policy',
          'Read our privacy policy',
          Icons.privacy_tip,
          () {
            // TODO: Open privacy policy
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Privacy policy coming soon!')),
            );
          },
        ),
      ],
    );
  }

  // ✅ VERSION INFO - Matches React: App version footer
  Widget _buildVersionInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('ABOUT'),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
            border: Border.all(
              color: Theme.of(context).brightness == Brightness.dark 
                  ? AppColors.borderGray600 
                  : AppColors.borderGray700,
              width: 0.5,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info,
                color: Theme.of(context).brightness == Brightness.dark 
                    ? AppColors.textGray400 
                    : AppColors.textGray500,
                size: 20,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MySnitch AI',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Version 1.0.0',
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark 
                            ? AppColors.textGray400 
                            : AppColors.textGray500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ✅ HELPER METHODS - Reused from Phase 3
  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        color: Theme.of(context).brightness == Brightness.dark 
            ? AppColors.textGray400 
            : AppColors.textGray500,
        fontSize: 12,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.0,
      ),
    );
  }

  Widget _buildToggleCard(String title, String subtitle, IconData icon, bool value, ValueChanged<bool> onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark 
              ? AppColors.borderGray600 
              : AppColors.borderGray700,
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
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark 
                        ? AppColors.textGray400 
                        : AppColors.textGray500,
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
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
          border: Border.all(
            color: Theme.of(context).brightness == Brightness.dark 
                ? AppColors.borderGray600 
                : AppColors.borderGray700,
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
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark 
                          ? AppColors.textGray400 
                          : AppColors.textGray500,
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

  void _showToneSelector() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundGray800,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
        ),
        title: const Text(
          'Select Default Tone',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildToneOption('brutal', 'Brutal'),
            _buildToneOption('clinical', 'Clinical'),
            _buildToneOption('petty', 'Petty'),
            _buildToneOption('playful', 'Playful'),
          ],
        ),
      ),
    );
  }

  Widget _buildToneOption(String tone, String displayName) {
    return ListTile(
      title: Text(
        displayName,
        style: const TextStyle(color: Colors.white),
      ),
      trailing: _defaultTone == tone
          ? Icon(Icons.check, color: AppColors.primaryPink)
          : null,
      onTap: () {
        setState(() => _defaultTone = tone);
        Navigator.pop(context);
      },
    );
  }
} 