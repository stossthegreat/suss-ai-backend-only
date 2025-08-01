import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';

class AboutApp extends StatefulWidget {
  const AboutApp({super.key});

  @override
  State<AboutApp> createState() => _AboutAppState();
}

class _AboutAppState extends State<AboutApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).appBarTheme.iconTheme?.color),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'About MySnitch AI',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAppInfo(),
            const SizedBox(height: 24),
            
            _buildSectionHeader('APP INFORMATION'),
            const SizedBox(height: 16),
            _buildInfoCard('Version', '1.0.0'),
            _buildInfoCard('Build Number', '1'),
            _buildInfoCard('Release Date', 'January 2024'),
            _buildInfoCard('Platform', 'Flutter Web'),
            const SizedBox(height: 24),
            
            _buildSectionHeader('DEVELOPMENT TEAM'),
            const SizedBox(height: 16),
            _buildTeamCard(
              'Lead Developer',
              'AI & Flutter Expert',
              Icons.person,
            ),
            const SizedBox(height: 12),
            _buildTeamCard(
              'UI/UX Designer',
              'Creative Design Lead',
              Icons.design_services,
            ),
            const SizedBox(height: 12),
            _buildTeamCard(
              'AI Engineer',
              'Machine Learning Specialist',
              Icons.psychology,
            ),
            const SizedBox(height: 24),
            
            _buildSectionHeader('TECHNOLOGIES'),
            const SizedBox(height: 16),
            _buildTechCard('Flutter', 'Cross-platform framework'),
            const SizedBox(height: 12),
            _buildTechCard('OpenAI GPT-4', 'Advanced AI analysis'),
            const SizedBox(height: 12),
            _buildTechCard('Dart', 'Programming language'),
            const SizedBox(height: 12),
            _buildTechCard('Material Design', 'UI/UX framework'),
            const SizedBox(height: 24),
            
            _buildSectionHeader('LEGAL'),
            const SizedBox(height: 16),
            _buildActionCard(
              'Terms of Service',
              'Read our terms and conditions',
              Icons.description,
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Terms of service coming soon!')),
                );
              },
            ),
            const SizedBox(height: 12),
            _buildActionCard(
              'Privacy Policy',
              'Learn about data protection',
              Icons.privacy_tip,
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Privacy policy coming soon!')),
                );
              },
            ),
            const SizedBox(height: 12),
            _buildActionCard(
              'Open Source Licenses',
              'View third-party licenses',
              Icons.code,
              () {
                _showLicensesDialog();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppInfo() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.pinkPurpleGradient,
        borderRadius: BorderRadius.circular(AppConstants.largeRadius),
        border: Border.all(
          color: AppColors.primaryPink.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.visibility,
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'MySnitch AI',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Advanced Social Media Analysis',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Empowering users with AI-powered insights to navigate complex social interactions with confidence and clarity.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 12,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

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

  Widget _buildInfoCard(String label, String value) {
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark 
                        ? AppColors.textGray400 
                        : AppColors.textGray500,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamCard(String name, String role, IconData icon) {
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
                  name,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  role,
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
    );
  }

  Widget _buildTechCard(String name, String description) {
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
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

  void _showLicensesDialog() {
    showLicensePage(
      context: context,
      applicationName: 'MySnitch AI',
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.visibility,
          color: Colors.white,
          size: 25,
        ),
      ),
    );
  }
} 