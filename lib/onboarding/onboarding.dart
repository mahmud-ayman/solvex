import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:lppm/home_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int currentIndex = 0;

  final List<_OnboardingItem> items = [
    _OnboardingItem(
      title: "welcome to the solver",
      description:
          "تطبيق هيساعدك تفهم نظريه الاضطراب بطريقه سهله وبسيطه، وكمان هيساعدك تحل المعادلات وتطلع المطلوب .",
      icon: Lottie.asset(
        "assets/lottie/Web Inspection.json",
        repeat: false,
        width: 200,
        height: 200,
      ),
      color: Color(0xffF9F6EE),
    ),
    _OnboardingItem(
      title: "LPPM Solver",
      description:
          "العب بالسلايدر وشوف الجراف وهو بيقارنلك الحل الحقيقي والحل التقريبي",
      icon: Column(
        children: [
          Lottie.asset("assets/lottie/wave.json", repeat: false),
          SizedBox(height: 10),
          Lottie.asset(
            repeat: true,
            "assets/lottie/slider.json",
            width: 300,
            height: 150,
            fit: BoxFit.fill,
          ),
        ],
      ),
      color: Color(0xffF9F6EE),
    ),
    _OnboardingItem(
      title: "Time Delay - Theta",
      description:
          "اكتب المعادله واختار المعاملات وهيطلعلك السيتا الي بتدور عليها\n (θ) ",
      icon: Lottie.asset(
        "assets/lottie/time.json",
        repeat: true,
        width: 200,
        height: 200,
      ),
      color: Color(0xffF9F6EE),
    ),
    _OnboardingItem(
      title: "تقدر تحل اكتر من نوع معادلات خش واكتشف بنفسك ",

      description: "تحت اشراف دكتور/ اميره مسعود  ",
      icon: Column(
        children: [
          Spacer(flex: 1),
          SizedBox(
            height: 300,
            child: Lottie.asset(
              "assets/lottie/Accounting.json",
              repeat: true,
              width: double.infinity,
              fit: BoxFit.fill,
            ),
          ),
          const SizedBox(height: 20),
          DefaultTextStyle(
            style: const TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
            child: AnimatedTextKit(
              animatedTexts: [
                WavyAnimatedText(
                  'Solve Another Equations',
                  textStyle: TextStyle(
                    color: const Color.fromARGB(255, 154, 2, 249),
                  ),
                ),
                WavyAnimatedText(
                  'take a look at the graph',
                  textStyle: TextStyle(
                    color: const Color.fromARGB(255, 3, 179, 233),
                  ),
                ),
              ],
              isRepeatingAnimation: true,
            ),
          ),
          SizedBox(height: 20),
          Spacer(flex: 2),

          // Text(
          //   "Solve Another Equations",
          //   style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          // ).animate().fadeIn(duration: const Duration(milliseconds: 500)),
        ],
      ),
      color: Color(0xffF9F6EE),
    ),
  ];

  void _finishOnboarding() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomePage()),
    );
  }

  void _nextPage() {
    if (currentIndex == items.length - 1) {
      _finishOnboarding();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skip() {
    _finishOnboarding();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLastPage = currentIndex == items.length - 1;

    return Scaffold(
      backgroundColor: Color(0xffF9F6EE),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: TextButton(
                  onPressed: _skip,
                  child: const Text("تخطي", style: TextStyle(fontSize: 16)),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: items.length,
                  onPageChanged: (index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return _OnboardingCard(item: item);
                  },
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  items.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: currentIndex == index ? 22 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: currentIndex == index
                          ? Colors.blue
                          : Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 60,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        side: const BorderSide(color: Colors.blue),
                        backgroundColor: const Color.fromARGB(255, 0, 153, 255),
                        padding: const EdgeInsets.symmetric(vertical: 9),
                      ),
                      child: Text(
                        isLastPage ? "ابدأ الآن" : "التالي",
                        style: const TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingCard extends StatelessWidget {
  final _OnboardingItem item;

  const _OnboardingCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 1000,
          height: 500,
          decoration: BoxDecoration(
            color: item.color,
            borderRadius: BorderRadius.circular(10),
          ),
          child: item.icon,
        ),
        Text(
          item.title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Text(
          item.description,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 17,
            color: Colors.grey.shade700,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class _OnboardingItem {
  final String title;
  final String description;
  final Widget icon;
  final Color color;

  const _OnboardingItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}
