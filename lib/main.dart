import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

void main() {
  runApp(const AnasPortfolioApp());
}

// ============================================================
// APP
// ============================================================

class AnasPortfolioApp extends StatelessWidget {
  const AnasPortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Anas Khabeer | Portfolio',
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF080B1A),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8B5CF6),
          brightness: Brightness.dark,
        ),
        fontFamily: 'Arial',
      ),
      home: const PortfolioShell(),
    );
  }
}

// ============================================================
// MAIN SHELL
// ============================================================

class PortfolioShell extends StatefulWidget {
  const PortfolioShell({super.key});

  @override
  State<PortfolioShell> createState() => _PortfolioShellState();
}

class _PortfolioShellState extends State<PortfolioShell>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<String> _navItems = [
    'Home',
    'About',
    'Experience',
    'Projects',
    'Skills',
    'Education',
    'Certifications',
    'Resume',
    'Contact',
  ];

  final List<IconData> _navIcons = [
    Icons.home_rounded,
    Icons.person_rounded,
    Icons.work_rounded,
    Icons.code_rounded,
    Icons.bar_chart_rounded,
    Icons.school_rounded,
    Icons.workspace_premium_rounded,
    Icons.description_rounded,
    Icons.contact_mail_rounded,
  ];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _selectPage(int index) {
    Navigator.of(context).pop();

    setState(() {
      _selectedIndex = index;
    });

    _animationController
      ..reset()
      ..forward();
  }

  void _openPage(int index) {
    setState(() {
      _selectedIndex = index;
    });

    _animationController
      ..reset()
      ..forward();
  }

  Widget _currentPage() {
    switch (_selectedIndex) {
      case 0:
        return const HomePage();
      case 1:
        return const AboutPage();
      case 2:
        return const ExperiencePage();
      case 3:
        return const ProjectsPage();
      case 4:
        return const SkillsPage();
      case 5:
        return const EducationPage();
      case 6:
        return const CertificationsPage();
      case 7:
        return const ResumePage();
      case 8:
        return const ContactPage();
      default:
        return const HomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(),
      body: Stack(
        children: [
          const Positioned.fill(
            child: BackgroundDecoration(),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildTopBar(),
                Expanded(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: _currentPage(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // TOP BAR
  // ==========================================================

  Widget _buildTopBar() {
    return LayoutBuilder(builder: (context, constraints) {
      final desktop = constraints.maxWidth >= 1050;
      return Container(
        height: 76,
        padding: EdgeInsets.symmetric(horizontal: desktop ? 38 : 16),
        decoration: BoxDecoration(
          color: const Color(0xFF080B1A).withValues(alpha: 0.95),
          border: const Border(bottom: BorderSide(color: Color(0x338B5CF6))),
        ),
        child: Row(children: [
          if (!desktop)
            Builder(builder: (context) => IconButton(
              tooltip: 'Menu',
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: const Icon(Icons.menu_rounded, color: Color(0xFFB99AFF)),
            )),
          const Text('<AK/>', style: TextStyle(
            color: Color(0xFFB99AFF), fontSize: 24, fontWeight: FontWeight.w900,
          )),
          if (desktop) ...[
            const SizedBox(width: 34),
            Expanded(child: Row(mainAxisAlignment: MainAxisAlignment.end,
              children: List.generate(_navItems.length, (index) {
                final selected = index == _selectedIndex;
                return Flexible(child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: TextButton(
                    onPressed: () => _openPage(index),
                    style: TextButton.styleFrom(
                      foregroundColor: selected ? const Color(0xFFB99AFF) : Colors.white70,
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 12),
                    ),
                    child: FittedBox(fit: BoxFit.scaleDown,
                      child: Text(_navItems[index], style: TextStyle(
                        fontSize: 13, fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
                      )),
                    ),
                  ),
                ));
              }),
            )),
          ] else ...[
            const Spacer(),
            Text(_navItems[_selectedIndex].toUpperCase(),
                style: const TextStyle(color: Colors.white60, letterSpacing: 1.4, fontSize: 11)),
          ],
        ]),
      );
    });
  }

  // ==========================================================
  // DRAWER
  // ==========================================================

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: const Color(0xFF111126),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 28),

            Container(
              width: 105,
              height: 105,
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFB99AFF),
                    Color(0xFF5B36D1),
                  ],
                ),
              ),
              child: const CircleAvatar(
                backgroundColor: Color(0xFF080B1A),
                backgroundImage: AssetImage(
                  'assets/profile.png',
                ),
              ),
            ),

            const SizedBox(height: 15),

            const Text(
              'ANAS KHABEER',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              'Software Engineering Student',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 12,
              ),
            ),

            const SizedBox(height: 25),

            const Divider(
              color: Colors.white12,
              indent: 20,
              endIndent: 20,
            ),

            const SizedBox(height: 8),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemCount: _navItems.length,
                itemBuilder: (context, index) {
                  final selected = _selectedIndex == index;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                      leading: Icon(
                        _navIcons[index],
                        color: selected
                            ? const Color(0xFFB99AFF)
                            : Colors.white54,
                      ),
                      title: Text(
                        _navItems[index],
                        style: TextStyle(
                          color: selected
                              ? const Color(0xFFB99AFF)
                              : Colors.white,
                          fontWeight: selected
                              ? FontWeight.w700
                              : FontWeight.w400,
                        ),
                      ),
                      trailing: selected
                          ? const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 13,
                        color: Color(0xFFB99AFF),
                      )
                          : null,
                      selected: selected,
                      selectedTileColor:
                      const Color(0xFFB99AFF).withValues(alpha: 0.08),
                      onTap: () => _selectPage(index),
                    ),
                  );
                },
              ),
            ),

            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                '© 2026 Anas Khabeer',
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// HOME PAGE
// ============================================================

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fade = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _openLinkedIn() async {
    final uri = Uri.parse(
      'https://www.linkedin.com/in/anas-khabeer-5691b233b/',
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  Future<void> _sendEmail() async {
    final uri = Uri(
      scheme: 'mailto',
      path: 'anaskhabeer04@gmail.com',
      queryParameters: {
        'subject': 'Portfolio Contact',
      },
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _callPhone() async {
    final uri = Uri.parse(
      'tel:+923200498021',
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _openResume() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ResumePage(),
      ),
    );
  }

  void _openProjects() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: const Color(0xFF080B1A),
          appBar: AppBar(
            title: const Text('My Projects'),
            backgroundColor: const Color(0xFF080B1A),
            foregroundColor: Colors.white,
            elevation: 0,
          ),

          body: const ProjectsPage(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 700;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 900,
                minHeight: constraints.maxHeight,
              ),
              child: FadeTransition(
                opacity: _fade,
                child: SlideTransition(
                  position: _slide,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isWide ? 40 : 24,
                      vertical: isWide ? 25 : 18,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (isWide)
                          Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                            Expanded(flex: 6, child: _heroIntroduction(false)),
                            const SizedBox(width: 44),
                            Expanded(flex: 4, child: _buildProfileImage(true)),
                          ])
                        else ...[
                          _buildProfileImage(false),
                          const SizedBox(height: 22),
                          _heroIntroduction(true),
                        ],

                        const SizedBox(height: 28),

                        const Text(
                          "LET'S CONNECT",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 7),

                        const Text(
                          'Have a project or opportunity? Let’s connect.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 13,
                          ),
                        ),

                        const SizedBox(height: 17),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _contactIcon(
                              icon: Icons.link_rounded,
                              label: 'LinkedIn',
                              onTap: _openLinkedIn,
                            ),
                            const SizedBox(width: 18),
                            _contactIcon(
                              icon: Icons.email_outlined,
                              label: 'Email',
                              onTap: _sendEmail,
                            ),
                            const SizedBox(width: 18),
                            _contactIcon(
                              icon: Icons.phone_outlined,
                              label: 'Call',
                              onTap: _callPhone,
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _heroIntroduction(bool centered) {
    return Column(
      crossAxisAlignment: centered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        const Text('HELLO, I AM', style: TextStyle(
          color: Color(0xFFB99AFF), fontSize: 15, fontWeight: FontWeight.w800,
          letterSpacing: 3,
        )),
        const SizedBox(height: 13),
        Text('ANAS\nKHABEER', textAlign: centered ? TextAlign.center : TextAlign.left,
            style: TextStyle(fontSize: centered ? 42 : 64, height: 1.05,
                fontWeight: FontWeight.w900, letterSpacing: 1.2)),
        const SizedBox(height: 18),
        Text('Software Engineering Student @ UMT | Flutter Developer | Software Quality Engineering | C++ | QA & Testing',
            textAlign: centered ? TextAlign.center : TextAlign.left,
            style: const TextStyle(color: Color(0xFFB99AFF), fontSize: 16, height: 1.65,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 20),
        _buildRoles(),
        const SizedBox(height: 26),
        _buildMainButtons(!centered),
      ],
    );
  }

  Widget _buildProfileImage(bool isWide) {
    final size = isWide ? 295.0 : 170.0;

    return TweenAnimationBuilder<double>(
      tween: Tween(
        begin: 0.82,
        end: 1.0,
      ),
      duration: const Duration(milliseconds: 1100),
      curve: Curves.elasticOut,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: Container(
        width: size,
        height: size,
        padding: const EdgeInsets.all(5),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              Color(0xFFB99AFF),
              Color(0xFF5B36D1),
            ],
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF080B1A),
          ),
          child: const CircleAvatar(
            backgroundImage: AssetImage(
              'assets/profile.png',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoles() {
    return const Column(
      children: [
        Text(
          'Flutter Mobile Application Developer Intern',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 5),
        Text(
          'Software Quality Engineering Intern',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        SizedBox(height: 5),
        Text(
          'IT Manager',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildMainButtons(bool isWide) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 12,
      runSpacing: 10,
      children: [
        SizedBox(
          width: isWide ? 190 : 175,
          child: ElevatedButton.icon(
            onPressed: _openProjects,
            icon: const Icon(
              Icons.arrow_forward_rounded,
              size: 18,
            ),
            label: const Text('VIEW PROJECTS'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8B5CF6),
              foregroundColor: Colors.black,
              elevation: 0,
              padding: const EdgeInsets.symmetric(
                vertical: 15,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
              ),
            ),
          ),
        ),
        SizedBox(
          width: isWide ? 190 : 175,
          child: OutlinedButton.icon(
            onPressed: _openResume,
            icon: const Icon(
              Icons.description_outlined,
              size: 18,
            ),
            label: const Text('VIEW RESUME'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(
                color: Color(0x558B5CF6),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 15,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _contactIcon({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF15152C),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: const Color(0x338B5CF6),
              ),
            ),
            child: Icon(
              icon,
              color: const Color(0xFFB99AFF),
              size: 21,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// ABOUT PAGE
// ============================================================

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PortfolioPageLayout(
      title: 'About Me',
      subtitle:
      'Software Engineering undergraduate focused on quality software and application development.',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 750;

          final left = _glassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Icon(
                  Icons.person_outline_rounded,
                  color: Color(0xFFB99AFF),
                  size: 38,
                ),
                SizedBox(height: 18),
                Text(
                  'Software Engineering Undergraduate',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 14),
                Text(
                  'I am a Software Engineering undergraduate at the '
                      'University of Management and Technology (UMT), Lahore. '
                      'My interests include software quality engineering, '
                      'software testing, programming, databases, networking '
                      'and application development.',
                  style: TextStyle(
                    color: Colors.white60,
                    height: 1.8,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          );

          final right = _glassCard(
            child: Column(
              children: const [
                InfoRow(
                  icon: Icons.location_on_outlined,
                  title: 'Location',
                  value: 'Lahore, Pakistan',
                ),
                InfoRow(
                  icon: Icons.school_outlined,
                  title: 'University',
                  value: 'University of Management and Technology',
                ),
                InfoRow(
                  icon: Icons.code_outlined,
                  title: 'Focus',
                  value: 'SQE, QA & Mobile App Development',
                ),
                InfoRow(
                  icon: Icons.work_outline_rounded,
                  title: 'Current Role',
                  value: 'IT Manager',
                ),
              ],
            ),
          );

          if (wide) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: left),
                const SizedBox(width: 18),
                Expanded(child: right),
              ],
            );
          }

          return Column(
            children: [
              left,
              const SizedBox(height: 18),
              right,
            ],
          );
        },
      ),
    );
  }
}

// ============================================================
// EXPERIENCE PAGE
// ============================================================

class ExperiencePage extends StatelessWidget {
  const ExperiencePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PortfolioPageLayout(
      title: 'Experience',
      subtitle: 'Professional and internship experience.',
      child: Column(
        children: [
          ExperienceCard(
            icon: Icons.phone_android_rounded,
            title: 'Flutter Mobile Application Developer Intern',
            company: 'Mobile Application Development',
            date: 'Current',
            description:
            'Developing mobile application interfaces and strengthening '
                'Flutter and Dart development skills through application-focused work.',
            tags: [
              'Flutter',
              'Dart',
              'Mobile Development',
              'UI',
            ],
          ),
          const SizedBox(height: 18),
          ExperienceCard(
            icon: Icons.bug_report_rounded,
            title: 'Software Quality Engineering Intern',
            company: 'Big Brains',
            date: 'August 2026 – Present',
            description:
            'Working on software quality engineering activities including '
                'software testing, test case preparation, bug reporting and '
                'quality-focused development tasks.',
            tags: [
              'Software Testing',
              'QA',
              'Test Cases',
              'Bug Reporting',
              'SQE',
            ],
          ),
          const SizedBox(height: 18),
          ExperienceCard(
            icon: Icons.code_rounded,
            title: 'C++ Programming Fundamentals Intern',
            company: 'Big Brains',
            date: 'August 2026 – Present',
            description:
            'Developing programming fundamentals and strengthening '
                'problem-solving and object-oriented programming concepts using C++.',
            tags: [
              'C++',
              'OOP',
              'Programming',
              'Problem Solving',
            ],
          ),
          const SizedBox(height: 18),
          ExperienceCard(
            icon: Icons.business_center_rounded,
            title: 'IT Manager',
            company: 'The National Grammar High School – Lahore',
            date: 'March 2022 – Present',
            description:
            'Managing IT infrastructure, systems administration, '
                'technical support, networking and technology-related operations.',
            tags: [
              'IT Infrastructure',
              'Networking',
              'System Administration',
              'Technical Support',
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================
// PROJECTS PAGE
// ============================================================

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final projects = [
      ProjectData(
        icon: Icons.fact_check_rounded,
        title:
        'Requirement Validation Techniques and Their Impact on Project Success',
        subtitle: 'Research / Software Engineering',
        description:
        'A software engineering project focused on requirement validation '
            'techniques and their relationship with successful project outcomes.',
        tags: [
          'Requirements',
          'Validation',
          'Software Engineering',
        ],
      ),
      ProjectData(
        icon: Icons.directions_car_rounded,
        title: 'Enhanced Ride-Hailing System',
        subtitle: 'Software Engineering Project',
        description:
        'An enhanced ride-hailing system based on Yango Pakistan, featuring '
            'Female Ride Mode and Eco Ride Mode.',
        tags: [
          'SRS',
          'DFD',
          'UML',
          'Software Engineering',
        ],
      ),
      ProjectData(
        icon: Icons.local_parking_rounded,
        title: 'Smart Parking Management System',
        subtitle: 'Arduino Project',
        description:
        'An Arduino-based smart parking system using IR sensors, servo '
            'motors, LCD display, RTC and automated parking status monitoring.',
        tags: [
          'Arduino',
          'C++',
          'Sensors',
          'Embedded Systems',
        ],
      ),
      ProjectData(
        icon: Icons.phone_android_rounded,
        title: 'Flutter Portfolio Application',
        subtitle: 'Personal Portfolio',
        description:
        'A Flutter portfolio application showcasing professional '
            'experience, projects, skills, education and contact information.',
        tags: [
          'Flutter',
          'Dart',
          'UI/UX',
          'Mobile',
        ],
      ),
    ];

    return PortfolioPageLayout(
      title: 'Projects',
      subtitle: 'Selected academic and personal projects.',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columns = constraints.maxWidth >= 900 ? 2 : 1;

          final width = columns == 2
              ? (constraints.maxWidth - 18) / 2
              : constraints.maxWidth;

          return Wrap(
            spacing: 18,
            runSpacing: 18,
            children: projects.map((project) {
              return SizedBox(
                width: width,
                child: ProjectCard(
                  project: project,
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

// ============================================================
// SKILLS PAGE
// ============================================================

class SkillsPage extends StatelessWidget {
  const SkillsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final skills = [
      ['Software Testing & QA', 0.90],
      ['C++ / OOP', 0.88],
      ['Python', 0.78],
      ['SQL / SSMS', 0.82],
      ['Flutter / Dart', 0.76],
      ['Networking', 0.85],
      ['System Administration', 0.90],
      ['Documentation', 0.88],
    ];

    return PortfolioPageLayout(
      title: 'Skills',
      subtitle: 'Technologies and professional areas.',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 750;

          return Wrap(
            spacing: 18,
            runSpacing: 18,
            children: skills.map((skill) {
              return SizedBox(
                width: wide
                    ? (constraints.maxWidth - 18) / 2
                    : constraints.maxWidth,
                child: SkillCard(
                  name: skill[0] as String,
                  value: skill[1] as double,
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

// ============================================================
// EDUCATION PAGE
// ============================================================

class EducationPage extends StatelessWidget {
  const EducationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PortfolioPageLayout(
      title: 'Education',
      subtitle: 'Academic background.',
      child: Column(
        children: [
          EducationCard(
            icon: Icons.school_rounded,
            degree: 'BS Software Engineering',
            institute:
            'University of Management and Technology (UMT)',
            year: '2024 – 2028',
          ),
          const SizedBox(height: 18),
          EducationCard(
            icon: Icons.menu_book_rounded,
            degree: 'Intermediate – Pre-Medical',
            institute: 'Punjab Group of Colleges',
            year: '2022 – 2024',
          ),
          const SizedBox(height: 18),
          EducationCard(
            icon: Icons.auto_stories_rounded,
            degree: 'Matriculation – Science',
            institute: 'The Educators',
            year: '2020 – 2022',
          ),
        ],
      ),
    );
  }
}

// ============================================================
// CERTIFICATIONS PAGE
// ============================================================

class CertificationsPage extends StatelessWidget {
  const CertificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PortfolioPageLayout(
      title: 'Certifications & Achievements',
      subtitle: 'Selected certifications and professional activities.',
      child: Column(
        children: const [
          CertificationCard(
            icon: Icons.workspace_premium_rounded,
            title: 'Career Development Workshop',
            organization: 'Certificate of Completion',
            date: 'March 2026',
          ),
          SizedBox(height: 16),
          CertificationCard(
            icon: Icons.groups_rounded,
            title: 'Team Lead – University Event',
            organization: 'University Activity',
            date: 'December 2025',
          ),
          SizedBox(height: 16),
          CertificationCard(
            icon: Icons.computer_rounded,
            title: 'Software Engineering Workshop',
            organization: 'Certificate of Participation',
            date: 'November 2025',
          ),
          SizedBox(height: 16),
          CertificationCard(
            icon: Icons.support_agent_rounded,
            title: 'Technical Support Volunteer',
            organization: 'Volunteer Experience',
            date: 'October 2024',
          ),
        ],
      ),
    );
  }
}

// ============================================================
// RESUME PAGE
// ============================================================


class ResumePage extends StatelessWidget {
  const ResumePage({super.key});

  Future<void> _openResumeInBrowser() async {
    final uri = Uri.base.resolve('assets/assets/resume.pdf');

    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
      webOnlyWindowName: '_blank',
    )) {
      debugPrint('Could not open resume: $uri');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Scaffold(
        backgroundColor: const Color(0xFF080B1A),
        appBar: AppBar(
          title: const Text('My Resume'),
          backgroundColor: const Color(0xFF15152C),
        ),
        body: Center(
          child: ElevatedButton.icon(
            onPressed: _openResumeInBrowser,
            icon: const Icon(Icons.open_in_new),
            label: const Text('Open Resume PDF'),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF080B1A),
      appBar: AppBar(
        title: const Text('My Resume'),
      ),
      body: SfPdfViewer.asset('assets/resume.pdf'),
    );
  }
}
// ============================================================
// CONTACT PAGE
// ============================================================

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  Future<void> _openLinkedIn() async {
    final uri = Uri.parse(
      'https://www.linkedin.com/in/anas-khabeer-5691b233b/',
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  Future<void> _sendEmail() async {
    final uri = Uri(
      scheme: 'mailto',
      path: 'anaskhabeer04@gmail.com',
      queryParameters: {
        'subject': 'Portfolio Contact',
      },
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _callPhone() async {
    final uri = Uri.parse(
      'tel:+923200498021',
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PortfolioPageLayout(
      title: "Let's Connect",
      subtitle:
      'Interested in collaboration, projects or professional opportunities?',
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 700,
          ),
          child: _glassCard(
            padding: const EdgeInsets.all(35),
            child: Column(
              children: [
                const Icon(
                  Icons.connect_without_contact_rounded,
                  size: 52,
                  color: Color(0xFFB99AFF),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Have a project or opportunity?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Feel free to connect with me through LinkedIn, '
                      'email or phone.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white60,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 28),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _actionButton(
                      'LinkedIn',
                      Icons.link_rounded,
                      _openLinkedIn,
                      primary: true,
                    ),
                    _actionButton(
                      'Email Me',
                      Icons.email_outlined,
                      _sendEmail,
                    ),
                    _actionButton(
                      'Call Me',
                      Icons.phone_outlined,
                      _callPhone,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _actionButton(
      String text,
      IconData icon,
      VoidCallback onPressed, {
        bool primary = false,
      }) {
    if (primary) {
      return ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        label: Text(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF8B5CF6),
          foregroundColor: Colors.black,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
        ),
      );
    }

    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(text),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: const BorderSide(
          color: Color(0x448B5CF6),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
      ),
    );
  }
}

// ============================================================
// COMMON PAGE LAYOUT
// ============================================================

class PortfolioPageLayout extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const PortfolioPageLayout({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 30,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 1100,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 28),
              child,
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// INFO ROW
// ============================================================

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const InfoRow({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFB99AFF).withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: const Color(0xFFB99AFF),
              size: 21,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// EXPERIENCE CARD
// ============================================================

class ExperienceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String company;
  final String date;
  final String description;
  final List<String> tags;

  const ExperienceCard({
    super.key,
    required this.icon,
    required this.title,
    required this.company,
    required this.date,
    required this.description,
    required this.tags,
  });

  @override
  Widget build(BuildContext context) {
    return _HoverCard(
      child: _glassCard(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF8B5CF6),
                    Color(0xFF5B36D1),
                  ],
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                icon,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 17),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    company,
                    style: const TextStyle(
                      color: Color(0xFFB99AFF),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date,
                    style: const TextStyle(
                      color: Colors.white38,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 13),
                  Text(
                    description,
                    style: const TextStyle(
                      color: Colors.white60,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 7,
                    runSpacing: 7,
                    children: tags.map(_tag).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// PROJECT DATA
// ============================================================

class ProjectData {
  final IconData icon;
  final String title;
  final String subtitle;
  final String description;
  final List<String> tags;

  ProjectData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.tags,
  });
}

// ============================================================
// PROJECT CARD
// ============================================================

class ProjectCard extends StatelessWidget {
  final ProjectData project;

  const ProjectCard({
    super.key,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    return _HoverCard(
      child: _glassCard(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF8B5CF6),
                        Color(0xFF5B36D1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    project.icon,
                    size: 26,
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.arrow_outward_rounded,
                  color: Colors.white38,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              project.subtitle.toUpperCase(),
              style: const TextStyle(
                color: Color(0xFFB99AFF),
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              project.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 13),
            Text(
              project.description,
              style: const TextStyle(
                color: Colors.white60,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 17),
            Wrap(
              spacing: 7,
              runSpacing: 7,
              children: project.tags.map(_tag).toList(),
            ),
            const SizedBox(height: 18),
            OutlinedButton.icon(
              onPressed: () {
                _showProjectDialog(
                  context,
                  project,
                );
              },
              icon: const Icon(
                Icons.visibility_outlined,
                size: 17,
              ),
              label: const Text('View Details'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFB99AFF),
                side: const BorderSide(
                  color: Color(0x668B5CF6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _showProjectDialog(
    BuildContext context,
    ProjectData project,
    ) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: const Color(0xFF15152C),
        title: Text(project.title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                project.description,
                style: const TextStyle(
                  color: Colors.white60,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Technologies / Areas',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 7,
                runSpacing: 7,
                children: project.tags.map(_tag).toList(),
              ),
              const SizedBox(height: 20),
              const Text(
                'Project files can be added here later.',
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      );
    },
  );
}

// ============================================================
// SKILL CARD
// ============================================================

class SkillCard extends StatelessWidget {
  final String name;
  final double value;

  const SkillCard({
    super.key,
    required this.name,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return _glassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                '${(value * 100).round()}%',
                style: const TextStyle(
                  color: Color(0xFFB99AFF),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TweenAnimationBuilder<double>(
            tween: Tween(
              begin: 0,
              end: value,
            ),
            duration: const Duration(milliseconds: 1100),
            curve: Curves.easeOutCubic,
            builder: (context, animationValue, child) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: LinearProgressIndicator(
                  value: animationValue,
                  minHeight: 7,
                  backgroundColor: Colors.white10,
                  valueColor:
                  const AlwaysStoppedAnimation<Color>(
                    Color(0xFF8B5CF6),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ============================================================
// EDUCATION CARD
// ============================================================

class EducationCard extends StatelessWidget {
  final IconData icon;
  final String degree;
  final String institute;
  final String year;

  const EducationCard({
    super.key,
    required this.icon,
    required this.degree,
    required this.institute,
    required this.year,
  });

  @override
  Widget build(BuildContext context) {
    return _HoverCard(
      child: _glassCard(
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFFB99AFF).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                icon,
                color: const Color(0xFFB99AFF),
                size: 28,
              ),
            ),
            const SizedBox(width: 17),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    degree,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    institute,
                    style: const TextStyle(
                      color: Color(0xFFB99AFF),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    year,
                    style: const TextStyle(
                      color: Colors.white38,
                      fontSize: 12,
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
}

// ============================================================
// CERTIFICATION CARD
// ============================================================

class CertificationCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String organization;
  final String date;

  const CertificationCard({
    super.key,
    required this.icon,
    required this.title,
    required this.organization,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return _HoverCard(
      child: _glassCard(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFB99AFF).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: const Color(0xFFB99AFF),
                size: 27,
              ),
            ),
            const SizedBox(width: 17),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    organization,
                    style: const TextStyle(
                      color: Color(0xFFB99AFF),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    date,
                    style: const TextStyle(
                      color: Colors.white38,
                      fontSize: 12,
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
}

// ============================================================
// HOVER CARD
// ============================================================

class _HoverCard extends StatefulWidget {
  final Widget child;

  const _HoverCard({
    required this.child,
  });

  @override
  State<_HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<_HoverCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() {
          _hovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          _hovered = false;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(
          0,
          _hovered ? -5 : 0,
          0,
        ),
        child: widget.child,
      ),
    );
  }
}

// ============================================================
// GLASS CARD
// ============================================================

Widget _glassCard({
  required Widget child,
  EdgeInsetsGeometry padding = const EdgeInsets.all(25),
}) {
  return Container(
    width: double.infinity,
    padding: padding,
    decoration: BoxDecoration(
      color: const Color(0xFF15152C).withValues(alpha: 0.82),
      borderRadius: BorderRadius.circular(22),
      border: Border.all(
        color: const Color(0x228B5CF6),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.18),
          blurRadius: 25,
          offset: const Offset(0, 10),
        ),
      ],
    ),
    child: child,
  );
}

// ============================================================
// TAG
// ============================================================

Widget _tag(String text) {
  return Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 10,
      vertical: 6,
    ),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.04),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(
        color: Colors.white12,
      ),
    ),
    child: Text(
      text,
      style: const TextStyle(
        color: Colors.white60,
        fontSize: 11,
      ),
    ),
  );
}

// ============================================================
// BACKGROUND
// ============================================================

class BackgroundDecoration extends StatelessWidget {
  const BackgroundDecoration({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: BackgroundPainter(),
    );
  }
}

class BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF8B5CF6).withValues(alpha: 0.035)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(
        size.width * 0.88,
        size.height * 0.10,
      ),
      180,
      paint,
    );

    canvas.drawCircle(
      Offset(
        size.width * 0.08,
        size.height * 0.48,
      ),
      130,
      paint,
    );

    canvas.drawCircle(
      Offset(
        size.width * 0.75,
        size.height * 0.75,
      ),
      220,
      paint,
    );
  }

  @override
  bool shouldRepaint(
      covariant CustomPainter oldDelegate,
      ) {
    return false;
  }
}
