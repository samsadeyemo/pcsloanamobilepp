import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pcsloan/features/onboarding/data/onboarding_data.dart';
import 'package:pcsloan/features/onboarding/domain/onboarding_controller.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final pageController = PageController();
    final currentPage = ref.watch(onboardingPageIndexProvider);

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: pageController,
              onPageChanged: (index) {
                ref.read(onboardingPageIndexProvider.notifier).state = index;
              },
              itemCount: onboardingPages.length,
              itemBuilder: (context, index){
                final data = onboardingPages[index];
                return Padding(
                  padding:  const EdgeInsets.all(24.0),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.
                    children: [
                      const SizedBox(height: 80), 
                      Image.asset(data['image']!, height: 250),
                      const SizedBox(height: 40),

                      Text(
                        data['title']!,
                         style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600, fontFamily: 'Inter', fontSize: 23),
                         textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 16),
                      Text(
                        data['subtitle']!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontFamily: 'Inter', fontWeight: FontWeight.w400, fontSize: 15),
                        textAlign: TextAlign.center,
                        
                      ),
                      
                    ],
                  ),
                );
              }
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
               onboardingPages.length,
               (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: currentPage == index ? 30 : 30,
                height: 7,
                decoration: BoxDecoration(
                  color: currentPage == index ? Colors.deepPurple : Colors.grey[400],
                  borderRadius: BorderRadius.circular(8),
                ),
                ),
               ),
               ),

               const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: currentPage == onboardingPages.length - 1
                ? Center(
                  child: ElevatedButton(
                  onPressed: () async {
                  await _completeOnboarding(context);
                  },
                  style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff7C70DF),
                        foregroundColor: const Color(0xffE5E7EB),
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 13),
                  ),
                  child: const Text("Get Started",
                    style: TextStyle(color: Color(0xffE5E7EB), fontFamily: 'Inter',)
                  ),
                  ),
                )
                : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  TextButton(
                  onPressed: () async {
                    await _completeOnboarding(context);
                  },
                    child: const Text("Skip", style: TextStyle(fontFamily: 'Inter',),),
                  ),
                  ElevatedButton(
                    onPressed: () {
                    pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                  
                   style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff7C70DF),
                        foregroundColor: const Color(0xffE5E7EB),
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 13),
                    ),
                      child: const Text("Next",
                        style: TextStyle(color: Color(0xffE5E7EB), fontFamily: 'Inter',),
                      ),

                  ),
                  ],
                ),
              ),

                const SizedBox(height: 40),
        ],
      ),
    );
  }

  Future<void> _completeOnboarding(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('onboarding_done', true);
  context.go('/home');
}

}
