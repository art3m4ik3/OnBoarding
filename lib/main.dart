import 'package:flutter/material.dart';

void main() {
  runApp(const OnBoardingApp());
}

class OnBoardingApp extends StatelessWidget {
  const OnBoardingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Onboarding Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const OnboardingScreen(),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const _kAnimationDuration = Duration(milliseconds: 300);
  static const _kPageIndicatorSize = 21.0;
  static const _kPageIndicatorSpacing = 4.0;

  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = const [
    OnboardingPage(
      image: 'assets/adventure.png',
      title: 'Great\nadventure\nstarts here',
      buttonText: 'Skip',
    ),
    OnboardingPage(
      image: 'assets/bed.png',
      title: 'The most\ncomfortable bed\nin the world',
      buttonText: 'Skip',
    ),
    OnboardingPage(
      image: 'assets/luxury.png',
      title: 'Welcome to an\noasis of luxury\nand tranquility',
      buttonText: 'Start',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handleNextPage() {
    if (_currentPage == _pages.length - 1) {
      return;
    }

    _pageController.nextPage(
      duration: _kAnimationDuration,
      curve: Curves.easeIn,
    );
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildPageView(),
          _buildBottomControls(),
        ],
      ),
    );
  }

  Widget _buildPageView() {
    return PageView.builder(
      controller: _pageController,
      itemCount: _pages.length,
      onPageChanged: _onPageChanged,
      itemBuilder: (context, index) => OnboardingPageView(page: _pages[index]),
    );
  }

  Widget _buildBottomControls() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildPageIndicators(),
            ),
            Positioned(
              right: 0,
              child: TextButton(
                onPressed: _handleNextPage,
                child: Text(
                  _pages[_currentPage].buttonText,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPageIndicators() {
    return List.generate(
      _pages.length,
      (index) => PageIndicator(
        isActive: index == _currentPage,
        size: _kPageIndicatorSize,
        margin: const EdgeInsets.symmetric(horizontal: _kPageIndicatorSpacing),
      ),
    );
  }
}

class OnboardingPage {
  final String image;
  final String title;
  final String buttonText;

  const OnboardingPage({
    required this.image,
    required this.title,
    required this.buttonText,
  });
}

class OnboardingPageView extends StatelessWidget {
  final OnboardingPage page;

  const OnboardingPageView({
    super.key,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: _buildImage(),
        ),
        _buildTitle(),
      ],
    );
  }

  Widget _buildImage() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(page.image),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.white.withOpacity(0.5),
              Colors.white
            ],
            stops: const [0.7, 0.9, 1.0],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(30, 20, 20, 160),
      alignment: Alignment.centerLeft,
      child: Text(
        page.title,
        style: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}

class PageIndicator extends StatelessWidget {
  final bool isActive;
  final double size;
  final EdgeInsetsGeometry? margin;

  const PageIndicator({
    super.key,
    required this.isActive,
    required this.size,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      margin: margin,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? Colors.black : Colors.white,
        border: Border.all(color: Colors.black),
      ),
    );
  }
}
