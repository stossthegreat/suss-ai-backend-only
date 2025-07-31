import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
// import 'package:provider/provider.dart';
// import '../../providers/theme_provider.dart';
// import 'settings/theme_settings.dart';
// import 'settings/account_settings.dart';
// import 'settings/privacy_settings.dart';
// import 'settings/premium_settings.dart';
// import 'settings/notification_settings.dart';

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
          
          // Theme Settings - Temporarily disabled
          // _buildThemeSection(),
          // const SizedBox(height: 24),
          
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
  }

  // ✅ HEADER - Matches React: Simple "Settings" title
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // ✅ THEME SETTINGS - New section for theme controls (temporarily disabled)
  /*
  Widget _buildThemeSection() {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('APPEARANCE'),
            const SizedBox(height: 16),
            _buildActionCard(
              title: 'Theme Settings',
              subtitle: 'Customize light and dark mode',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ThemeSettings(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            _buildSettingsCard(
              title: 'Dark Mode',
              subtitle: 'Switch between light and dark themes',
              child: Switch(
                value: themeProvider.isDarkMode,
                onChanged: (value) => themeProvider.toggleTheme(),
                activeColor: AppColors.primaryPink,
              ),
            ),
          ],
        );
      },
    );
  }
  */

  // ✅ ANALYSIS PREFERENCES - Matches React: First section with toggles
  Widget _buildAnalysisPreferences() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ✅ EXACT React: Section header
        _buildSectionHeader('ANALYSIS PREFERENCES'),
        const SizedBox(height: 16),
        
        // ✅ EXACT React: Default Tone dropdown card
        _buildSettingsCard(
          title: 'Default Tone Preference',
          subtitle: 'Choose your analysis style',
          child: DropdownButton<String>(
            value: _defaultTone,
            dropdownColor: AppColors.backgroundGray800,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            underline: Container(), // Remove default underline
            items: const [
              DropdownMenuItem(value: 'brutal', child: Text('🔥 Brutal')),
              DropdownMenuItem(value: 'soft', child: Text('💭 Soft')),
              DropdownMenuItem(value: 'clinical', child: Text('🧠 Clinical')),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _defaultTone = value;
                });
              }
            },
          ),
        ),
        const SizedBox(height: 12),
        
        // ✅ EXACT React: Voice Toggle card
        _buildToggleCard(
          title: 'Voice Toggle',
          subtitle: 'For SoulMirror integration',
          value: _voiceToggle,
          onChanged: (value) {
            setState(() {
              _voiceToggle = value;
            });
          },
        ),
        const SizedBox(height: 12),
        
        // ✅ EXACT React: Lie Detector special card (blue)
        _buildSpecialToggleCard(
          title: '🔍 Lie Detector Mode',
          subtitle: 'Detect dishonesty patterns',
          value: _lieDetectorEnabled,
          color: AppColors.primaryBlue,
          onChanged: (value) {
            setState(() {
              _lieDetectorEnabled = value;
            });
          },
        ),
        const SizedBox(height: 12),
        
        // ✅ EXACT React: Deep Scan special card (purple)
        _buildSpecialToggleCard(
          title: '🚀 Unlock Deep Scan',
          subtitle: 'GPT-4 Turbo analysis',
          value: _deepScanUnlocked,
          color: AppColors.primaryPurple,
          onChanged: (value) {
            setState(() {
              _deepScanUnlocked = value;
            });
          },
        ),
      ],
    );
  }

  // ✅ ACCOUNT SECTION - Matches React: Subscription and account settings
  Widget _buildAccountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('ACCOUNT & SUBSCRIPTION'),
        const SizedBox(height: 16),
        
        // Account Settings - EXACTLY like React
        _buildActionCard(
          title: 'Account Settings',
          subtitle: 'Manage your profile and preferences',
          onTap: () {
            // Temporarily disabled
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Account settings coming soon!')),
            );
          },
        ),
        const SizedBox(height: 12),
        
        // Premium Features - EXACTLY like React
        _buildActionCard(
          title: 'Premium Features',
          subtitle: 'Unlock advanced analysis tools',
          onTap: () {
            // Temporarily disabled
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Premium features coming soon!')),
            );
          },
        ),
        const SizedBox(height: 12),
        
        // Notification Settings - EXACTLY like React
        _buildActionCard(
          title: 'Notification Settings',
          subtitle: 'Configure push notifications',
          onTap: () {
            // Temporarily disabled
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Notification settings coming soon!')),
            );
          },
        ),
      ],
    );
  }

  // ✅ SUPPORT SECTION - Matches React: Help and legal links
  Widget _buildSupportSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('SUPPORT & LEGAL'),
        const SizedBox(height: 16),
        
        // Privacy Policy - EXACTLY like React
        _buildActionCard(
          title: 'Privacy Policy',
          subtitle: 'Read our privacy policy',
          onTap: () {
            // Temporarily disabled
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Privacy policy coming soon!')),
            );
          },
        ),
        const SizedBox(height: 12),
        
        // Terms of Service - EXACTLY like React
        _buildActionCard(
          title: 'Terms of Service',
          subtitle: 'Read our terms of service',
          onTap: () {
            // Temporarily disabled
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Terms of service coming soon!')),
            );
          },
        ),
        const SizedBox(height: 12),
        
        // Contact Support - EXACTLY like React
        _buildActionCard(
          title: 'Contact Support',
          subtitle: 'Get help from our team',
          onTap: () {
            // Temporarily disabled
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Contact support coming soon!')),
            );
          },
        ),
      ],
    );
  }

  // ✅ VERSION INFO - Matches React: Footer with app version
  Widget _buildVersionInfo() {
    return Column(
      children: [
        Text(
          'Suss AI v2.1.3',
          style: TextStyle(
            color: AppColors.textGray500,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Made with 💜 for emotional clarity',
          style: TextStyle(
            color: AppColors.textGray500.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  // ✅ Helper: Section header styling
  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        color: AppColors.textGray300,
        fontSize: 14,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
    );
  }

  // ✅ Helper: Standard settings card with custom child widget
  Widget _buildSettingsCard({
    required String title,
    required String subtitle,
    required Widget child,
    Color? titleColor,
    Color? subtitleColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // ✅ REUSED: Same glassmorphism styling as other cards
        color: AppColors.backgroundGray800.withOpacity(0.6),
        borderRadius: BorderRadius.circular(AppConstants.xlRadius),
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
                  style: TextStyle(
                    color: titleColor ?? Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: subtitleColor ?? AppColors.textGray400,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          child,
        ],
      ),
    );
  }

  // ✅ Helper: Toggle card (standard gray background)
  Widget _buildToggleCard({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return _buildSettingsCard(
      title: title,
      subtitle: subtitle,
      child: _buildToggleSwitch(value, onChanged),
    );
  }

  // ✅ Helper: Special toggle card with colored gradient background
  Widget _buildSpecialToggleCard({
    required String title,
    required String subtitle,
    required bool value,
    required Color color,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // ✅ REUSED: Gradient backgrounds from Phase 1
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.1),
            color.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.xlRadius),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
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
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          _buildToggleSwitch(value, onChanged, activeColor: color),
        ],
      ),
    );
  }

  // ✅ Helper: Clickable action card
  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? titleColor,
    Color? subtitleColor,
    Color? backgroundColor,
    Color? borderColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppConstants.fastAnimation, // ✅ REUSED: Animation timing
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.backgroundGray800.withOpacity(0.6),
          borderRadius: BorderRadius.circular(AppConstants.xlRadius),
          border: Border.all(
            color: borderColor ?? AppColors.borderGray600,
            width: 0.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: titleColor ?? Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                color: subtitleColor ?? AppColors.textGray400,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Helper: Animated toggle switch
  Widget _buildToggleSwitch(bool value, ValueChanged<bool> onChanged, {Color? activeColor}) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: AppConstants.fastAnimation, // ✅ REUSED: 200ms animation
        width: 48, // Same size as React (w-12 h-6)
        height: 24,
        decoration: BoxDecoration(
          color: value 
              ? (activeColor ?? AppColors.primaryPink) 
              : AppColors.textGray500,
          borderRadius: BorderRadius.circular(12),
        ),
        child: AnimatedAlign(
          duration: AppConstants.fastAnimation,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 20, // Inner circle (h-5 w-5)
            height: 20,
            margin: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
} 