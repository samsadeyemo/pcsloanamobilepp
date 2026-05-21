import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  final Color _primary = const Color(0xFF7C70DF);
  int? _expandedIndex;

  final List<Map<String, dynamic>> _faqs = [
    {
      'category': 'About PCS Loan',
      'question': 'What is PCS Loan?',
      'answer':
          'Allverter Public Sector Loan is a short-term digital loan designed for verified public sector employees, accessible via the PCS mobile app for quick and convenient financing.',
    },
    {
      'category': 'Eligibility',
      'question': 'Who is eligible for this loan?',
      'answer':
          'This loan is available to:\n• Federal, State, and Local Government employees\n• Verified salary earners in the public sector\n• Individuals with a valid bank account and consistent income',
    },
    {
      'category': 'Loan Details',
      'question': 'How much can I borrow?',
      'answer':
          'You can borrow between ₦10,000 to ₦1,000,000.\n\nYour approved amount depends on:\n• Your income level\n• Repayment capacity\n• Credit assessment',
    },
    {
      'category': 'Loan Details',
      'question': 'What is the loan tenure?',
      'answer': 'Loan duration ranges from 1 to 12 months.',
    },
    {
      'category': 'Application',
      'question': 'How do I apply for a loan?',
      'answer':
          '1. Download the PCS mobile app\n2. Create an account\n3. Complete your profile and verification\n4. Apply for your preferred loan amount\n5. Receive funds directly into your bank account within 3 minutes',
    },
    {
      'category': 'Application',
      'question': 'How long does approval take?',
      'answer':
          'Loan approval is fast and automated, typically within minutes once your details are verified.',
    },
    {
      'category': 'Application',
      'question': 'How is the loan disbursed?',
      'answer':
          'Once approved, your loan is credited directly to your salary bank account through the app.',
    },
    {
      'category': 'Rates & Fees',
      'question': 'What are the interest rates and fees?',
      'answer':
          'Interest rates are competitive and based on:\n• Loan amount\n• Tenure\n• Risk profile\n\nAll applicable charges will be clearly shown before you accept the loan.',
    },
    {
      'category': 'Repayment',
      'question': 'How do I repay my loan?',
      'answer':
          'Repayment is done via:\n• Direct debit\n• Bank transfer\n• In-app payment options\n\nYou will be notified of your repayment schedule.',
    },
    {
      'category': 'Repayment',
      'question': 'Can I repay before the due date?',
      'answer': 'Yes, you can repay your loan early without any penalties.',
    },
    {
      'category': 'Repayment',
      'question': 'What happens if I miss a repayment?',
      'answer':
          '• Late fees may apply\n• Your credit profile may be affected\n• Future loan access may be restricted\n\nWe encourage timely repayment to maintain a good borrowing record.',
    },
    {
      'category': 'Security',
      'question': 'Is my information secure?',
      'answer':
          'Yes. All customer data is protected using secure encryption and privacy standards.',
    },
    {
      'category': 'After Repayment',
      'question': 'Can I apply for another loan after repayment?',
      'answer':
          'Yes. Customers with good repayment history may:\n• Qualify for higher loan amounts\n• Enjoy faster approvals',
    },
    {
      'category': 'Support',
      'question': 'How can I contact support?',
      'answer':
          'You can reach us via:\n• In-app support\n• Email\n• Customer care line',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: _primary,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new,
                  color: Colors.white, size: 20),
              onPressed: () => context.push('/support-page'),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: _primary,
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.help_outline_rounded,
                            color: Colors.white, size: 32),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Frequently Asked Questions',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Everything you need to know about PCS Loan',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.85),
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: List.generate(_faqs.length, (index) {
                  final faq = _faqs[index];
                  final isExpanded = _expandedIndex == index;

                  // Show category header if it's a new category
                  final showCategory = index == 0 ||
                      _faqs[index - 1]['category'] != faq['category'];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (showCategory) ...[
                        if (index != 0) const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 4),
                          child: Row(
                            children: [
                              Container(
                                width: 3,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: _primary,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                faq['category'],
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: _primary,
                                  fontFamily: 'Inter',
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      // FAQ Card
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _expandedIndex = isExpanded ? null : index;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOut,
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isExpanded
                                  ? _primary.withOpacity(0.4)
                                  : Colors.transparent,
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 14),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 28,
                                      height: 28,
                                      decoration: BoxDecoration(
                                        color: _primary.withOpacity(0.08),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          '${index + 1}',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: _primary,
                                            fontFamily: 'Inter',
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        faq['question'],
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF1A1A2E),
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    AnimatedRotation(
                                      turns: isExpanded ? 0.5 : 0,
                                      duration:
                                          const Duration(milliseconds: 250),
                                      child: Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        color: isExpanded
                                            ? _primary
                                            : const Color(0xFF9CA3AF),
                                        size: 22,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Answer
                              AnimatedCrossFade(
                                firstChild: const SizedBox.shrink(),
                                secondChild: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.only(
                                    left: 56,
                                    right: 16,
                                    bottom: 16,
                                  ),
                                  child: Text(
                                    faq['answer'],
                                    style: const TextStyle(
                                      fontSize: 13,
                                      height: 1.7,
                                      color: Color(0xFF6B7280),
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                crossFadeState: isExpanded
                                    ? CrossFadeState.showSecond
                                    : CrossFadeState.showFirst,
                                duration: const Duration(milliseconds: 250),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),

          // Bottom contact nudge
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 32),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _primary.withOpacity(0.06),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _primary.withOpacity(0.15)),
              ),
              child: Row(
                children: [
                  Icon(Icons.support_agent_outlined, color: _primary, size: 28),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Still have questions?',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: _primary,
                            fontFamily: 'Inter',
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Our support team is happy to help you.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6B7280),
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.go('/support-page'),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      backgroundColor: _primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text(
                      'Contact',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}