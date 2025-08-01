import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';

class PremiumSettings extends StatefulWidget {
  const PremiumSettings({super.key});

  @override
  State<PremiumSettings> createState() => _PremiumSettingsState();
}

class _PremiumSettingsState extends State<PremiumSettings> {
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
          'Premium Settings',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPremiumStatus(),
            const SizedBox(height: 24),
            
            _buildSectionHeader('SUBSCRIPTION'),
            const SizedBox(height: 16),
            _buildSubscriptionCard(),
            const SizedBox(height: 24),
            
            _buildSectionHeader('PREMIUM FEATURES'),
            const SizedBox(height: 16),
            _buildFeatureCard(
              'Unlimited Analysis',
              'No daily limits on message analysis',
              Icons.all_inclusive,
              true,
            ),
            const SizedBox(height: 12),
            _buildFeatureCard(
              'Advanced AI Models',
              'Access to GPT-4 and advanced analysis',
              Icons.psychology,
              true,
            ),
            const SizedBox(height: 12),
            _buildFeatureCard(
              'Priority Support',
              'Get help faster with priority support',
              Icons.support_agent,
              true,
            ),
            const SizedBox(height: 12),
            _buildFeatureCard(
              'Custom Comebacks',
              'Generate personalized comebacks',
              Icons.auto_awesome,
              true,
            ),
            const SizedBox(height: 12),
            _buildFeatureCard(
              'Pattern Recognition',
              'Advanced communication pattern analysis',
              Icons.pattern,
              true,
            ),
            const SizedBox(height: 24),
            
            _buildSectionHeader('BILLING'),
            const SizedBox(height: 16),
            _buildActionCard(
              'Manage Subscription',
              'Update payment method or cancel subscription',
              Icons.payment,
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Billing management coming soon!')),
                );
              },
            ),
            const SizedBox(height: 12),
            _buildActionCard(
              'Billing History',
              'View your past invoices and payments',
              Icons.receipt,
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Billing history coming soon!')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumStatus() {
    return Container(
      padding: const EdgeInsets.all(20),
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
          Icon(
            Icons.star,
            color: Colors.white,
            size: 48,
          ),
          const SizedBox(height: 12),
          const Text(
            'Premium Member',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Active until January 2025',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
        ],
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

  Widget _buildSubscriptionCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundGray800.withOpacity(0.6),
        borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
        border: Border.all(
          color: AppColors.borderGray600,
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.verified,
                color: AppColors.primaryPink,
                size: 20,
              ),
              const SizedBox(width: 12),
              const Text(
                'Premium Plan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildSubscriptionRow('Plan', 'Premium Monthly'),
          _buildSubscriptionRow('Price', '\$9.99/month'),
          _buildSubscriptionRow('Next Billing', 'January 15, 2025'),
          _buildSubscriptionRow('Status', 'Active'),
        ],
      ),
    );
  }

  Widget _buildSubscriptionRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            '$label:',
            style: TextStyle(
              color: AppColors.textGray400,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(String title, String subtitle, IconData icon, bool isEnabled) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundGray800.withOpacity(0.6),
        borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
        border: Border.all(
          color: isEnabled ? AppColors.primaryPink.withOpacity(0.3) : AppColors.borderGray600,
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: isEnabled ? AppColors.primaryPink : AppColors.textGray500,
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
                    color: isEnabled ? Colors.white : AppColors.textGray400,
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
          if (isEnabled)
            Icon(
              Icons.check_circle,
              color: AppColors.primaryPink,
              size: 20,
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
} 