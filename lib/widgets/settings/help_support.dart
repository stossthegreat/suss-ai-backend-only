import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';

class HelpSupport extends StatefulWidget {
  const HelpSupport({super.key});

  @override
  State<HelpSupport> createState() => _HelpSupportState();
}

class _HelpSupportState extends State<HelpSupport> {
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
          'Help & Support',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('FREQUENTLY ASKED QUESTIONS'),
            const SizedBox(height: 16),
            _buildFAQItem(
              'How does MySnitch AI work?',
              'MySnitch AI uses advanced AI models to analyze text messages and detect patterns, motives, and potential red flags in communication.',
            ),
            const SizedBox(height: 12),
            _buildFAQItem(
              'Is my data private?',
              'Yes, we take privacy seriously. All analysis is done securely and your data is never shared with third parties.',
            ),
            const SizedBox(height: 12),
            _buildFAQItem(
              'How accurate is the analysis?',
              'Our AI models are trained on millions of conversations and provide highly accurate insights, though results should be used as guidance.',
            ),
            const SizedBox(height: 24),
            
            _buildSectionHeader('CONTACT SUPPORT'),
            const SizedBox(height: 16),
            _buildActionCard(
              'Email Support',
              'Get help via email',
              Icons.email,
              () {
                // TODO: Open email client
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Email support coming soon!')),
                );
              },
            ),
            const SizedBox(height: 12),
            _buildActionCard(
              'Live Chat',
              'Chat with our support team',
              Icons.chat,
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Live chat coming soon!')),
                );
              },
            ),
            const SizedBox(height: 12),
            _buildActionCard(
              'Report a Bug',
              'Help us improve by reporting issues',
              Icons.bug_report,
              () {
                _showBugReportDialog();
              },
            ),
            const SizedBox(height: 24),
            
            _buildSectionHeader('RESOURCES'),
            const SizedBox(height: 16),
            _buildActionCard(
              'User Guide',
              'Learn how to use MySnitch AI',
              Icons.book,
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('User guide coming soon!')),
                );
              },
            ),
            const SizedBox(height: 12),
            _buildActionCard(
              'Video Tutorials',
              'Watch step-by-step tutorials',
              Icons.play_circle,
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Video tutorials coming soon!')),
                );
              },
            ),
            const SizedBox(height: 12),
            _buildActionCard(
              'Community Forum',
              'Connect with other users',
              Icons.forum,
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Community forum coming soon!')),
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
        color: Theme.of(context).brightness == Brightness.dark 
            ? AppColors.textGray400 
            : AppColors.textGray500,
        fontSize: 12,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.0,
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return ExpansionTile(
      title: Text(
        question,
        style: TextStyle(
          color: Theme.of(context).textTheme.bodyLarge?.color,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Text(
            answer,
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark 
                  ? AppColors.textGray300 
                  : AppColors.textGray500,
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ),
      ],
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

  void _showBugReportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
        ),
        title: Text(
          'Report a Bug',
          style: TextStyle(color: Theme.of(context).textTheme.titleLarge?.color),
        ),
        content: const Text(
          'Help us improve MySnitch AI by reporting any issues you encounter. Our team will investigate and fix the problem.',
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
                  content: Text('Bug report submitted! Thank you.'),
                  backgroundColor: AppColors.primaryPink,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryPink,
            ),
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
} 