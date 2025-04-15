import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gymify/utils/custom_appbar.dart';

class HelpFAQsScreen extends StatefulWidget {
  const HelpFAQsScreen({super.key});

  @override
  State<HelpFAQsScreen> createState() => _HelpFAQsScreenState();
}

class _HelpFAQsScreenState extends State<HelpFAQsScreen> {
  // List of FAQ items with questions and answers
  final List<Map<String, String>> _faqItems = [
    {
      'question': 'How do I sign up for a membership?',
      'answer':
          'You can sign up for a membership by going to the Profile screen and selecting the "Manage" button under the Membership section. From there, you can view available plans and follow the steps to purchase a membership.'
    },
    {
      'question': 'How do I create a custom workout?',
      'answer':
          'Navigate to the Workout tab and tap on "Custom Workouts". From there, you can create a new custom workout by tapping the plus button. Add exercises from our exercise library to build your personalized workout routine.'
    },
    {
      'question': 'How do I track my progress?',
      'answer':
          'Your progress is tracked in multiple ways: weight logs in your profile, personal bests in the Personal Best section, workout history logs, and attendance tracking. You can view detailed reports in each corresponding section.'
    },
    {
      'question': 'How do I contact a trainer?',
      'answer':
          'You can contact trainers through the Chat section. Select a trainer from the list and start a conversation to get personalized advice and support for your fitness journey.'
    },
    {
      'question': 'How do I log my meals?',
      'answer':
          'Go to the Diet tab and select "Meal Logs". From there you can log your daily meals by selecting items from your diet plan or by adding custom meals.'
    },
    {
      'question': 'How do I change my password?',
      'answer':
          'Go to your Profile, tap on "Reset Password" under the Security section. You\'ll receive an OTP on your registered email which you can use to set a new password.'
    },
    {
      'question': 'How do I mark my attendance?',
      'answer':
          'When you visit the gym, your attendance will be marked automatically using your membership card. You can view your attendance history in the Attendance Calendar section.'
    },
    {
      'question': 'What if I have a problem with a payment?',
      'answer':
          'For payment-related issues, you can contact support through the "Contact Support" option in your Profile or speak with an administrator at the gym.'
    },
    {
      'question': 'How do I update my profile information?',
      'answer':
          'Go to Profile and tap "Edit Profile". You can update your personal information, including name, contact details, and fitness preferences.'
    },
    {
      'question': 'Can I freeze my membership?',
      'answer':
          'Membership freezes must be done through the gym admin. Please contact the gym administration directly to request a membership freeze.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Help & FAQs'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.colorScheme.primary.withOpacity(0.2),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      CupertinoIcons.question_circle,
                      size: 60,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'How can we help you?',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Find answers to common questions about using Gymify.',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // App Features Section
              Text(
                'App Features',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 16),

              _buildFeatureCard(
                theme,
                icon: CupertinoIcons.person_crop_circle,
                title: 'Profile Management',
                description:
                    'Update your personal information, fitness goals, and track your progress.',
              ),

              _buildFeatureCard(
                theme,
                icon: CupertinoIcons.flame,
                title: 'Workout Tracking',
                description:
                    'Follow pre-defined workouts or create your own custom routines.',
              ),

              _buildFeatureCard(
                theme,
                icon: CupertinoIcons.chart_bar,
                title: 'Personal Bests',
                description:
                    'Record and track your personal records for various exercises.',
              ),

              _buildFeatureCard(
                theme,
                icon: CupertinoIcons.calendar,
                title: 'Attendance',
                description:
                    'Track your gym attendance and maintain your workout streak.',
              ),

              _buildFeatureCard(
                theme,
                icon: CupertinoIcons.cart,
                title: 'Memberships',
                description: 'Purchase and manage your gym membership plans.',
              ),

              const SizedBox(height: 24),

              // FAQ Section
              Text(
                'Frequently Asked Questions',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 16),

              ...List.generate(
                _faqItems.length,
                (index) => _buildExpandableFAQItem(
                  context,
                  question: _faqItems[index]['question'] ?? '',
                  answer: _faqItems[index]['answer'] ?? '',
                ),
              ),

              const SizedBox(height: 24),

              // Contact Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? theme.colorScheme.surface
                      : theme.colorScheme.secondaryContainer.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDarkMode
                        ? theme.colorScheme.onSurface.withOpacity(0.1)
                        : theme.colorScheme.secondary.withOpacity(0.2),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      'Still need help?',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Contact our support team for assistance',
                      style: theme.textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildContactMethod(
                          context,
                          icon: CupertinoIcons.mail,
                          title: 'Email',
                          subtitle: 'support@gymify.com',
                        ),
                        const SizedBox(width: 20),
                        _buildContactMethod(
                          context,
                          icon: CupertinoIcons.phone,
                          title: 'Phone',
                          subtitle: '+977 9806754600',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    ThemeData theme, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: theme.colorScheme.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableFAQItem(
    BuildContext context, {
    required String question,
    required String answer,
  }) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      child: ExpansionTile(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        collapsedShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        title: Text(
          question,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        iconColor: theme.colorScheme.primary,
        collapsedIconColor: theme.colorScheme.primary,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              answer,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactMethod(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: theme.colorScheme.primary,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          subtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}
