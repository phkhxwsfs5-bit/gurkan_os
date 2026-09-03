import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.dark);
final ValueNotifier<bool> isTurkishNotifier = ValueNotifier(true);

void main() {
  runApp(const GurkanPremiumPortfolio());
}

class MouseDragScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}

class GurkanPremiumPortfolio extends StatelessWidget {
  const GurkanPremiumPortfolio({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return ValueListenableBuilder<bool>(
          valueListenable: isTurkishNotifier,
          builder: (_, bool isTr, __) {
            return MaterialApp(
              title: 'Gürkan Cihaner',
              debugShowCheckedModeBanner: false,
              scrollBehavior: MouseDragScrollBehavior(),
              builder: (context, child) => SelectionArea(child: child!),
              themeMode: currentMode,
              theme: ThemeData(
                brightness: Brightness.light,
                scaffoldBackgroundColor: const Color(0xFFF7F7F7),
                fontFamily: 'Helvetica Neue',
                colorScheme: const ColorScheme.light(
                  primary: Colors.black,
                  surface: Colors.white,
                  onSurface: Colors.black,
                ),
              ),
              darkTheme: ThemeData(
                brightness: Brightness.dark,
                scaffoldBackgroundColor: const Color(0xFF070707),
                fontFamily: 'Helvetica Neue',
                colorScheme: const ColorScheme.dark(
                  primary: Colors.white,
                  surface: Color(0xFF0A0A0A),
                  onSurface: Colors.white,
                ),
              ),
              home: const IndieDevBootScreen(),
            );
          },
        );
      },
    );
  }
}

class IndieDevBootScreen extends StatefulWidget {
  const IndieDevBootScreen({super.key});

  @override
  State<IndieDevBootScreen> createState() => _IndieDevBootScreenState();
}

class _IndieDevBootScreenState extends State<IndieDevBootScreen> {
  bool _showBoot = true;
  int _currentStep = 0;

  final List<String> _bootStepsEn = ['Loading assets...', 'Preparing environment...', 'Ready.'];
  final List<String> _bootStepsTr = ['Veriler yükleniyor...', 'Ortam hazırlanıyor...', 'Hazır.'];

  @override
  void initState() {
    super.initState();
    _startBootSequence();
  }

  void _startBootSequence() async {
    for (int i = 0; i < _bootStepsEn.length - 1; i++) {
      await Future.delayed(const Duration(milliseconds: 400));
      if (!mounted) return;
      setState(() => _currentStep++);
    }
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) setState(() => _showBoot = false);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isTr = isTurkishNotifier.value;
    final steps = isTr ? _bootStepsTr : _bootStepsEn;

    return Scaffold(
      body: Stack(
        children: [
          AnimatedOpacity(
            opacity: _showBoot ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 800),
            child: const CarouselPortfolioScreen(),
          ),
          if (_showBoot)
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              width: double.infinity,
              height: double.infinity,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: isDark ? Colors.white : Colors.black, strokeWidth: 2),
                    const SizedBox(height: 32),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Text(
                        steps[_currentStep],
                        key: ValueKey<int>(_currentStep),
                        style: TextStyle(fontFamily: 'Courier', fontSize: 14, color: isDark ? const Color(0xFFAAAAAA) : const Color(0xFF666666), letterSpacing: 1.5),
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

class CarouselPortfolioScreen extends StatefulWidget {
  const CarouselPortfolioScreen({super.key});

  @override
  State<CarouselPortfolioScreen> createState() => _CarouselPortfolioScreenState();
}

class _CarouselPortfolioScreenState extends State<CarouselPortfolioScreen> with SingleTickerProviderStateMixin {
  late Timer _clockTimer;
  final ValueNotifier<String> _currentDateTimeNotifier = ValueNotifier('');

  late PageController _pageController;
  bool _isMobile = false;
  final ValueNotifier<double> _currentPageNotifier = ValueNotifier(1000.0);
  late AnimationController _progressController;

  final List<Map<String, dynamic>> _projects = [
    {
      'title': 'Vertical\nEscape',
      'category_en': 'Mobile Game',
      'category_tr': 'MOBİL OYUN',
      'status_en': 'Live on Google Play',
      'status_tr': 'Google Play\'de Yayında',
      'url': 'https://play.google.com/store/apps/details?id=com.gurkanc.verticalescape&hl=tr',
      'desc_en': 'A fast-paced, reflex-based vertical 2D mobile platformer where you overcome challenging obstacles.',
      'desc_tr': 'Zorlu engelleri aştığın, refleks tabanlı ve yüksek tempolu dikey 2D mobil platform oyunu.',
      'isReview': false,
      'action_btn_en': 'VIEW IN STORE',
      'action_btn_tr': 'MAĞAZADA GÖR',
      'qr_msg_en': 'Scan with mobile to download.',
      'qr_msg_tr': 'İndirmek için telefonunla tara.',
    },
    {
      'title': 'Mood\nMixer',
      'category_en': 'Mobile App',
      'category_tr': 'MOBİL UYGULAMA',
      'status_en': 'Live on Google Play',
      'status_tr': 'Google Play\'de Yayında',
      'url': 'https://play.google.com/store/apps/details?id=com.gurkanc.moodmixer',
      'desc_en': 'A smart mobile assistant providing dynamic content and suggestions based on users\' current moods.',
      'desc_tr': 'Kullanıcıların o anki ruh hallerine göre dinamik içerikler ve öneriler sunan akıllı mobil asistan.',
      'isReview': false,
      'action_btn_en': 'VIEW IN STORE',
      'action_btn_tr': 'MAĞAZADA GÖR',
      'qr_msg_en': 'Scan with mobile to download.',
      'qr_msg_tr': 'İndirmek için telefonunla tara.',
    },
    {
      'title': 'Shaman\nSurvivor',
      'category_en': 'Mobile Game',
      'category_tr': 'MOBİL OYUN',
      'status_en': 'In Review',
      'status_tr': 'İncelemede',
      'url': '',
      'desc_en': 'An action game featuring rogue-lite elements, built around mystic runes and survival mechanics.',
      'desc_tr': 'Mistik rünler ve hayatta kalma mekanikleri üzerine kurulu, rogue-lite ögeleri barındıran aksiyon oyunu.',
      'isReview': true,
      'action_btn_en': 'VIEW IN STORE',
      'action_btn_tr': 'MAĞAZADA GÖR',
      'qr_msg_en': 'Scan with mobile to download.',
      'qr_msg_tr': 'İndirmek için telefonunla tara.',
    },
    {
      'title': 'Gündem\nRadarı',
      'category_en': 'Automated Bot',
      'category_tr': 'OTONOM BOT',
      'status_en': 'Live on X',
      'status_tr': 'X\'te Yayında',
      'url': 'https://x.com/GundemRadariBot',
      'desc_en': 'An automated system that scans, analyzes real-time agenda data, and posts autonomously on X (Twitter).',
      'desc_tr': 'Gündemdeki verileri anlık olarak tarayan, analiz eden ve X (Twitter) üzerinde otonom paylaşımlar yapan sistem.',
      'isReview': false,
      'action_btn_en': 'VIEW ON X',
      'action_btn_tr': 'X\'TE GÖR',
      'qr_msg_en': 'Scan to view profile on X.',
      'qr_msg_tr': 'X profiline gitmek için tara.',
    },
    {
      'title': 'Dialed',
      'category_en': 'Mobile App',
      'category_tr': 'MOBİL UYGULAMA',
      'status_en': 'In Review',
      'status_tr': 'İncelemede',
      'url': '',
      'desc_en': 'A comprehensive companion app for home baristas, designed to meticulously track dial-in recipes, extraction logs, grinder settings, and bean stash to consistently achieve the perfect cup.',
      'desc_tr': 'Ev baristaları için tasarlanmış kapsamlı bir yardımcı uygulama. Mükemmel fincanı yakalamak için dial-in reçetelerini, ekstraksiyon günlüklerini, öğütücü ayarlarını ve çekirdek stoğunu detaylıca takip etmenizi sağlar.',
      'isReview': true,
      'action_btn_en': 'VIEW IN STORE',
      'action_btn_tr': 'MAĞAZADA GÖR',
      'qr_msg_en': 'Scan with mobile to download.',
      'qr_msg_tr': 'İndirmek için telefonunla tara.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.28, initialPage: 1000);
    _updateTime();
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (timer) => _updateTime());

    _pageController.addListener(() {
      _currentPageNotifier.value = _pageController.page ?? 1000.0;
    });

    _progressController = AnimationController(vsync: this, duration: const Duration(seconds: 10));
    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (_pageController.hasClients) {
          _pageController.nextPage(duration: const Duration(milliseconds: 1000), curve: Curves.easeOutQuart);
        }
      }
    });

    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) _progressController.forward();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final isMob = MediaQuery.of(context).size.width < 900;
    if (_isMobile != isMob) {
      _isMobile = isMob;
      _pageController.dispose();
      _pageController = PageController(viewportFraction: _isMobile ? 0.85 : 0.28, initialPage: _currentPageNotifier.value.round());
      _pageController.addListener(() {
        _currentPageNotifier.value = _pageController.page ?? 1000.0;
      });
    }
  }

  String _formatDate(DateTime date) {
    final isTr = isTurkishNotifier.value;
    final monthsEn = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final monthsTr = ['Oca', 'Şub', 'Mar', 'Nis', 'May', 'Haz', 'Tem', 'Ağu', 'Eyl', 'Eki', 'Kas', 'Ara'];
    String day = date.day.toString().padLeft(2, '0');
    String month = isTr ? monthsTr[date.month - 1] : monthsEn[date.month - 1];
    String year = date.year.toString();
    return '$day $month $year';
  }

  void _updateTime() {
    final now = DateTime.now();
    final dateStr = _formatDate(now);
    final timeStr = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
    if (mounted) {
      _currentDateTimeNotifier.value = '$dateStr • $timeStr';
    }
  }

  @override
  void dispose() {
    _clockTimer.cancel();
    _pageController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  void _goToPreviousPage() {
    if (_pageController.hasClients) {
      _pageController.previousPage(duration: const Duration(milliseconds: 600), curve: Curves.easeInOutCubic);
      _progressController.forward(from: 0.0);
    }
  }

  void _goToNextPage() {
    if (_pageController.hasClients) {
      _pageController.nextPage(duration: const Duration(milliseconds: 600), curve: Curves.easeInOutCubic);
      _progressController.forward(from: 0.0);
    }
  }

  void _showProjectDetails(Map<String, dynamic> project) {
    _progressController.stop();
    final slug = project['title'].toString().replaceAll('\n', '-').toLowerCase();
    showGeneralDialog(
      context: context,
      routeSettings: RouteSettings(name: '/project/$slug'),
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: ProjectDetailsModal(project: project, isMobile: _isMobile),
        );
      },
    ).then((_) {
      if (mounted) _progressController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isTurkishNotifier,
      builder: (context, isTr, _) {
        final isMobileView = MediaQuery.of(context).size.width < 900;
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final primaryColor = isDark ? Colors.white : Colors.black;
        final secondaryColor = isDark ? const Color(0xFF888888) : const Color(0xFF666666);
        final borderColor = isDark ? const Color(0xFF222222) : const Color(0xFFE2E2E2);
        final surfaceColor = Theme.of(context).colorScheme.surface;
        final screenHeight = MediaQuery.of(context).size.height;
        final isShortScreen = screenHeight < 750;

        return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: isShortScreen ? const BouncingScrollPhysics() : const NeverScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(isMobileView ? 20.0 : 40.0, isMobileView ? 30.0 : 50.0, isMobileView ? 20.0 : 40.0, 10.0),
                      child: isMobileView
                          ? Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(horizontal: 55),
                                  child: Column(
                                    children: [
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          'Gürkan Cihaner',
                                          style: TextStyle(fontSize: 36, fontWeight: FontWeight.w400, letterSpacing: -1.5, color: primaryColor),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          MagneticButton(
                                            size: 42,
                                            onTap: () => launchUrl(Uri.parse('https://x.com/grcihanercs')),
                                            builder: (isHovered, color) => FaIcon(FontAwesomeIcons.xTwitter, size: 18, color: color),
                                          ),
                                          const SizedBox(width: 16),
                                          MagneticButton(
                                            size: 42,
                                            onTap: () => launchUrl(Uri.parse('https://www.instagram.com/grcihaner/')),
                                            builder: (isHovered, color) => FaIcon(FontAwesomeIcons.instagram, size: 18, color: color),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  left: 0,
                                  top: 8,
                                  child: MagneticButton(
                                    size: 38,
                                    onTap: () => isTurkishNotifier.value = !isTr,
                                    builder: (isHovered, color) => Text(
                                      isTr ? 'EN' : 'TR',
                                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  top: 6,
                                  child: MagneticButton(
                                    size: 38,
                                    onTap: () => themeNotifier.value = isDark ? ThemeMode.light : ThemeMode.dark,
                                    builder: (isHovered, color) => Icon(
                                      isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                                      size: 16,
                                      color: color,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: Column(
                                    children: [
                                      Text(
                                        'Gürkan Cihaner',
                                        style: TextStyle(fontSize: 52, fontWeight: FontWeight.w400, letterSpacing: -1.5, color: primaryColor),
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          MagneticButton(
                                            onTap: () => launchUrl(Uri.parse('https://x.com/grcihanercs')),
                                            builder: (isHovered, color) => FaIcon(FontAwesomeIcons.xTwitter, size: 20, color: color),
                                          ),
                                          const SizedBox(width: 16),
                                          MagneticButton(
                                            onTap: () => launchUrl(Uri.parse('https://www.instagram.com/grcihaner/')),
                                            builder: (isHovered, color) => FaIcon(FontAwesomeIcons.instagram, size: 20, color: color),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: Row(
                                    children: [
                                      MagneticButton(
                                        onTap: () => isTurkishNotifier.value = !isTr,
                                        builder: (isHovered, color) => Text(
                                          isTr ? 'EN' : 'TR',
                                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: color),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      MagneticButton(
                                        onTap: () => themeNotifier.value = isDark ? ThemeMode.light : ThemeMode.dark,
                                        builder: (isHovered, color) => Icon(
                                          isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                                          size: 20,
                                          color: color,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: isMobileView ? 50 : 70),
                          SizedBox(
                            height: isMobileView ? 400 : 450,
                            width: double.infinity,
                            child: Stack(
                              alignment: Alignment.center,
                              clipBehavior: Clip.none,
                              children: [
                                PageView.builder(
                                  controller: _pageController,
                                  onPageChanged: (index) {
                                    _progressController.forward(from: 0.0);
                                  },
                                  itemBuilder: (context, index) {
                                    final projectIndex = index % _projects.length;
                                    final project = _projects[projectIndex];
                                    
                                    return ValueListenableBuilder<double>(
                                      valueListenable: _currentPageNotifier,
                                      builder: (context, currentPageValue, child) {
                                        final cardDiff = index - currentPageValue;
                                        final absDiff = cardDiff.abs();
                                        final scale = (1 - (absDiff * (isMobileView ? 0.10 : 0.15))).clamp(0.75, 1.0);
                                        final opacity = (1 - (absDiff * 0.35)).clamp(0.3, 1.0);

                                        return Center(
                                          child: Transform.scale(
                                            scale: scale,
                                            child: Opacity(
                                              opacity: opacity,
                                              child: SizedBox(
                                                width: isMobileView ? 260 : 280,
                                                height: isMobileView ? 370 : 400,
                                                child: PremiumProjectCard(
                                                  title: project['title']!,
                                                  category: isTr ? project['category_tr']! : project['category_en']!,
                                                  status: isTr ? project['status_tr']! : project['status_en']!,
                                                  isReview: project['isReview'],
                                                  isCenter: absDiff < 0.3,
                                                  isTr: isTr,
                                                  onTap: () => _showProjectDetails(project),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                                Positioned(
                                  top: isMobileView ? -75 : -95,
                                  child: IgnorePointer(
                                    child: AnimatedBuilder(
                                      animation: _progressController,
                                      builder: (context, child) {
                                        double t = _progressController.value;
                                        String image = 'assets/tity.png';
                                        double dx = 0.0;
                                        double dy = 0.0;
                                        double rotate = 0.0;

                                        if (t < 0.85) {
                                          image = 'assets/tity.png';
                                        } else if (t < 0.90) {
                                          double localT = ((t - 0.85) / 0.05).clamp(0.0, 1.0);
                                          image = 'assets/tity_push.png';
                                          dx = -12.0 * localT;
                                          dy = -4.0 * localT;
                                          rotate = -0.05 * localT;
                                        } else if (t < 0.97) {
                                          double localT = ((t - 0.90) / 0.07).clamp(0.0, 1.0);
                                          image = 'assets/tity_push.png';
                                          dx = -12.0 + (8.0 * localT);
                                          dy = -4.0 + (4.0 * localT);
                                          rotate = -0.05 + (0.02 * localT);
                                        } else {
                                          double localT = ((t - 0.97) / 0.03).clamp(0.0, 1.0);
                                          double curveT = Curves.easeInExpo.transform(localT);
                                          image = 'assets/tity_push.png';
                                          dx = -4.0 + (28.0 * curveT);
                                          dy = 0.0 + (12.0 * curveT);
                                          rotate = -0.03 + (0.12 * curveT);
                                        }

                                        return Transform.translate(
                                          offset: Offset(dx, dy),
                                          child: Transform.rotate(
                                            angle: rotate,
                                            child: Image.asset(
                                              image,
                                              height: isMobileView ? 120 : 160,
                                              alignment: Alignment.bottomCenter,
                                              fit: BoxFit.fitHeight,
                                              gaplessPlayback: true,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: isMobileView ? 8 : 60,
                                  child: NavigationArrowButton(
                                    icon: Icons.chevron_left,
                                    size: isMobileView ? 38 : 48,
                                    iconSize: isMobileView ? 20 : 24,
                                    onTap: _goToPreviousPage
                                  )
                                ),
                                Positioned(
                                  right: isMobileView ? 8 : 60,
                                  child: NavigationArrowButton(
                                    icon: Icons.chevron_right,
                                    size: isMobileView ? 38 : 48,
                                    iconSize: isMobileView ? 20 : 24,
                                    onTap: _goToNextPage
                                  )
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: isMobileView ? 30 : 40),
                          ValueListenableBuilder<double>(
                            valueListenable: _currentPageNotifier,
                            builder: (context, currentPageValue, child) {
                              final activeIndex = (currentPageValue.round()) % _projects.length;
                              return Text(
                                '[ 0${activeIndex + 1} / 0${_projects.length} ]',
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, fontFamily: 'Courier', color: secondaryColor, letterSpacing: 4),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(isMobileView ? 20.0 : 40.0, 10.0, isMobileView ? 20.0 : 40.0, isMobileView ? 20.0 : 40.0),
                      child: Container(
                        padding: EdgeInsets.all(isMobileView ? 16 : 24),
                        decoration: BoxDecoration(border: Border.all(color: borderColor), color: surfaceColor),
                        child: isMobileView
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(isTr ? 'DURUM: ÇEVRİMİÇİ\nKONUM: ANKARA, TR' : 'STATUS: ONLINE\nLOCATION: ANKARA, TR', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 2, color: secondaryColor, height: 1.6)),
                                const SizedBox(height: 16),
                                ValueListenableBuilder<String>(
                                  valueListenable: _currentDateTimeNotifier,
                                  builder: (context, currentDateTime, child) {
                                    return Text(currentDateTime, textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Courier', fontSize: 14, color: primaryColor, fontWeight: FontWeight.bold, letterSpacing: 1.0));
                                  },
                                ),
                              ],
                            )
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(child: Text(isTr ? 'DURUM: ÇEVRİMİÇİ\nKONUM: ANKARA, TR' : 'STATUS: ONLINE\nLOCATION: ANKARA, TR', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 2, color: secondaryColor, height: 1.6))),
                                ValueListenableBuilder<String>(
                                  valueListenable: _currentDateTimeNotifier,
                                  builder: (context, currentDateTime, child) {
                                    return Text(currentDateTime, textAlign: TextAlign.right, style: TextStyle(fontFamily: 'Courier', fontSize: 14, color: primaryColor, fontWeight: FontWeight.bold, letterSpacing: 1.5));
                                  },
                                ),
                              ],
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
      },
    );
  }
}

class ProjectDetailsModal extends StatefulWidget {
  final Map<String, dynamic> project;
  final bool isMobile;
  const ProjectDetailsModal({super.key, required this.project, required this.isMobile});

  @override
  State<ProjectDetailsModal> createState() => _ProjectDetailsModalState();
}

class _ProjectDetailsModalState extends State<ProjectDetailsModal> {
  double _dragYOffset = 0.0;
  bool showQR = false;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isTurkishNotifier,
      builder: (context, isTr, _) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final primaryColor = isDark ? Colors.white : Colors.black;
        final secondaryColor = isDark ? const Color(0xFF888888) : const Color(0xFF666666);

        return AnimatedContainer(
      duration: _dragYOffset == 0 ? const Duration(milliseconds: 250) : Duration.zero,
      curve: Curves.easeOutCubic,
      transform: Matrix4.translationValues(0, _dragYOffset, 0),
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: widget.isMobile ? MediaQuery.of(context).size.width * 0.9 : 500,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border.all(color: isDark ? const Color(0xFF333333) : const Color(0xFFDDDDDD)),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(isDark ? 0.8 : 0.1), blurRadius: 40, offset: const Offset(0, 20))],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onVerticalDragUpdate: (details) {
                  setState(() {
                    if (details.delta.dy > 0) {
                      _dragYOffset += details.delta.dy;
                    }
                  });
                },
                onVerticalDragEnd: (details) {
                  if (_dragYOffset > 100 || (details.primaryVelocity ?? 0) > 300) {
                    Navigator.pop(context);
                  } else {
                    setState(() => _dragYOffset = 0.0);
                  }
                },
                child: Container(
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      Center(
                        child: Container(
                          margin: const EdgeInsets.only(top: 12),
                          width: 40,
                          height: 5,
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white24 : Colors.black26,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(40, 20, 30, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              (isTr ? widget.project['category_tr'] : widget.project['category_en']).toString().toUpperCase(),
                              style: TextStyle(fontSize: 12, letterSpacing: 2, color: secondaryColor, fontWeight: FontWeight.bold),
                            ),
                            ModalCloseButton(onTap: () => Navigator.pop(context)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(40, 0, 40, 40),
                child: AnimatedCrossFade(
                  duration: const Duration(milliseconds: 300),
                  crossFadeState: showQR ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                  firstChild: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.project['title'].toString().replaceAll('\n', ' '),
                        style: TextStyle(fontSize: 32, color: primaryColor, fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        isTr ? widget.project['desc_tr'] : widget.project['desc_en'],
                        style: TextStyle(fontSize: 15, color: isDark ? const Color(0xFFAAAAAA) : const Color(0xFF444444), height: 1.5),
                      ),
                      const SizedBox(height: 40),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                if (widget.project['url'].toString().isNotEmpty) {
                                  launchUrl(Uri.parse(widget.project['url']));
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                decoration: BoxDecoration(
                                  color: widget.project['isReview']
                                      ? (isDark ? const Color(0xFF222222) : const Color(0xFFEEEEEE))
                                      : primaryColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  widget.project['isReview']
                                      ? (isTr ? 'ONAY BEKLİYOR' : 'PENDING REVIEW')
                                      : (isTr ? widget.project['action_btn_tr'] : widget.project['action_btn_en']),
                                  style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1.5,
                                    color: widget.project['isReview'] ? secondaryColor : Theme.of(context).colorScheme.surface,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (!widget.project['isReview'] && !widget.isMobile) ...[
                            const SizedBox(width: 12),
                            InkWell(
                              onTap: () => setState(() => showQR = true),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  border: Border.all(color: isDark ? const Color(0xFF444444) : const Color(0xFFCCCCCC)),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(Icons.qr_code_scanner, color: primaryColor, size: 20),
                              ),
                            ),
                          ]
                        ],
                      )
                    ],
                  ),
                  secondChild: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFEEEEEE)),
                        ),
                        child: const Icon(Icons.qr_code_2, color: Colors.black, size: 140),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        isTr ? widget.project['qr_msg_tr'] : widget.project['qr_msg_en'],
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: secondaryColor),
                      ),
                      const SizedBox(height: 32),
                      InkWell(
                        onTap: () => setState(() => showQR = false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: isDark ? const Color(0xFF444444) : const Color(0xFFCCCCCC)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            isTr ? 'GERİ DÖN' : 'GO BACK',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: primaryColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
      },
    );
  }
}

class MagneticButton extends StatefulWidget {
  final Widget Function(bool isHovered, Color color) builder;
  final VoidCallback onTap;
  final double size;

  const MagneticButton({super.key, required this.builder, required this.onTap, this.size = 48});

  @override
  State<MagneticButton> createState() => _MagneticButtonState();
}

class _MagneticButtonState extends State<MagneticButton> {
  bool isHovered = false;
  bool isPressed = false;
  double offsetX = 0;
  double offsetY = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hoverColor = isDark ? Colors.black : Colors.white;
    final defaultColor = isDark ? Colors.white : Colors.black;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() {
        isHovered = false;
        isPressed = false;
        offsetX = 0;
        offsetY = 0;
      }),
      onHover: (event) {
        setState(() {
          offsetX = ((event.localPosition.dx - 24) / 24) * 8;
          offsetY = ((event.localPosition.dy - 24) / 24) * 8;
        });
      },
      child: Listener(
        onPointerDown: (_) => setState(() => isPressed = true),
        onPointerUp: (_) => setState(() => isPressed = false),
        child: GestureDetector(
          onTap: () {
            widget.onTap();
          },
          child: AnimatedScale(
            scale: isPressed ? 0.90 : 1.0,
            duration: const Duration(milliseconds: 100),
            child: AnimatedContainer(
              duration: isHovered ? const Duration(milliseconds: 50) : const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              transform: Matrix4.translationValues(offsetX, offsetY, 0),
              width: widget.size,
              height: widget.size,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isHovered ? defaultColor : Colors.transparent,
                border: Border.all(color: isHovered ? Colors.transparent : (isDark ? const Color(0xFF444444) : const Color(0xFFCCCCCC))),
                shape: BoxShape.circle,
              ),
              child: widget.builder(isHovered, isHovered ? hoverColor : defaultColor),
            ),
          ),
        ),
      ),
    );
  }
}

class PremiumProjectCard extends StatefulWidget {
  final String title;
  final String category;
  final String status;
  final bool isReview;
  final bool isCenter;
  final bool isTr;
  final VoidCallback onTap;

  const PremiumProjectCard({
    super.key, required this.title, required this.category, required this.status, required this.isReview, required this.isCenter, required this.isTr, required this.onTap,
  });

  @override
  State<PremiumProjectCard> createState() => _PremiumProjectCardState();
}

class _PremiumProjectCardState extends State<PremiumProjectCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      cursor: widget.isCenter ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: widget.isCenter ? () {
          widget.onTap();
        } : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border.all(
              color: widget.isCenter
                  ? (isHovered ? (isDark ? Colors.white : Colors.black) : (isDark ? const Color(0xFF666666) : const Color(0xFFB0B0B0)))
                  : (isDark ? const Color(0xFF222222) : const Color(0xFFE5E5E5)),
              width: widget.isCenter ? 1.5 : 1.0,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              if (widget.isCenter)
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.6 : 0.08),
                  offset: const Offset(0, 15),
                  blurRadius: 30,
                ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.category.toUpperCase(),
                style: TextStyle(
                  fontSize: 11,
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                  color: widget.isCenter
                      ? (isDark ? const Color(0xFF888888) : const Color(0xFF666666))
                      : (isDark ? const Color(0xFF555555) : const Color(0xFF9E9E9E)),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w300,
                      height: 1.15,
                      color: widget.isCenter
                          ? (isDark ? Colors.white : Colors.black)
                          : (isDark ? const Color(0xFF555555) : const Color(0xFF8E8E8E)),
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: (widget.isCenter && !widget.isReview) ? 1.0 : 0.0,
                    child: Icon(Icons.add, color: isDark ? Colors.white : Colors.black, size: 20),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.isCenter ? (widget.isTr ? 'DETAYLARI GÖR' : 'VIEW DETAILS') : widget.status,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: widget.isCenter
                          ? (isDark ? const Color(0xFF888888) : const Color(0xFF666666))
                          : (isDark ? const Color(0xFF555555) : const Color(0xFF9E9E9E)),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class NavigationArrowButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final double size;
  final double iconSize;

  const NavigationArrowButton({super.key, required this.icon, required this.onTap, this.size = 48, this.iconSize = 24});

  @override
  State<NavigationArrowButton> createState() => _NavigationArrowButtonState();
}

class _NavigationArrowButtonState extends State<NavigationArrowButton> {
  bool isHovered = false;
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() {
        isHovered = false;
        isPressed = false;
      }),
      child: Listener(
        onPointerDown: (_) => setState(() => isPressed = true),
        onPointerUp: (_) => setState(() => isPressed = false),
        child: GestureDetector(
          onTap: () {
            widget.onTap();
          },
          child: AnimatedScale(
            scale: isPressed ? 0.90 : 1.0,
            duration: const Duration(milliseconds: 100),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: widget.size,
              height: widget.size,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isHovered ? (isDark ? Colors.white : Colors.black) : Theme.of(context).colorScheme.surface.withOpacity(0.8),
                border: Border.all(color: isHovered ? Colors.transparent : (isDark ? const Color(0xFF333333) : const Color(0xFFDDDDDD))),
                shape: BoxShape.circle,
              ),
              child: Icon(
                widget.icon,
                size: widget.iconSize,
                color: isHovered ? (isDark ? Colors.black : Colors.white) : (isDark ? Colors.white : Colors.black),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ModalCloseButton extends StatefulWidget {
  final VoidCallback onTap;
  const ModalCloseButton({super.key, required this.onTap});

  @override
  State<ModalCloseButton> createState() => _ModalCloseButtonState();
}

class _ModalCloseButtonState extends State<ModalCloseButton> {
  bool isHovered = false;
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() {
        isHovered = false;
        isPressed = false;
      }),
      child: Listener(
        onPointerDown: (_) => setState(() => isPressed = true),
        onPointerUp: (_) => setState(() => isPressed = false),
        child: GestureDetector(
          onTap: () {
            widget.onTap();
          },
          child: AnimatedScale(
            scale: isPressed ? 0.85 : 1.0,
            duration: const Duration(milliseconds: 100),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                Icons.close,
                color: isHovered ? (isDark ? Colors.white : Colors.black) : const Color(0xFF888888),
                size: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }
}