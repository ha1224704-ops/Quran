
import 'package:flutter/material.dart';

void main() {
  runApp(const NoorAlAyatApp());
}

const green = Color(0xFF087F5B);
const darkGreen = Color(0xFF073B2E);
const gold = Color(0xFFE8C875);

class NoorAlAyatApp extends StatelessWidget {
  const NoorAlAyatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'نور الآيات',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F8F5),
        colorScheme: ColorScheme.fromSeed(
          seedColor: green,
          primary: green,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: darkGreen,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
      ),
      home: const LoadingScreen(),
    );
  }
}

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();

    Future.delayed(const Duration(milliseconds: 1800), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkGreen,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.menu_book_rounded,
                  size: 90, color: gold),
              const SizedBox(height: 20),
              const Text(
                'نور الآيات',
                style: TextStyle(
                  fontSize: 34,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'رفيقك مع القرآن الكريم',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 35),
              AnimatedBuilder(
                animation: controller,
                builder: (context, child) {
                  return LinearProgressIndicator(
                    value: null,
                    minHeight: 5,
                    color: Color.lerp(
                      green, gold, controller.value)!,
                    backgroundColor: Colors.white12,
                    borderRadius: BorderRadius.circular(10),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selected = 0;

  final pages = const [
    QuranScreen(),
    RecitersScreen(),
    DuasScreen(),
    QuizScreen(),
    SettingsScreen(),
  ];

  final titles = const [
    'القرآن الكريم',
    'القرّاء',
    'الأدعية والأذكار',
    'المسابقة الإسلامية',
    'الإعدادات',
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(titles[selected]),
          actions: [
            IconButton(
              tooltip: 'الإعدادات',
              onPressed: () => setState(() => selected = 4),
              icon: const Icon(Icons.settings_outlined),
            ),
          ],
        ),
        body: pages[selected],
        bottomNavigationBar: NavigationBar(
          selectedIndex: selected,
          onDestinationSelected: (index) {
            setState(() => selected = index);
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.menu_book_outlined),
              selectedIcon: Icon(Icons.menu_book),
              label: 'القرآن',
            ),
            NavigationDestination(
              icon: Icon(Icons.headphones),
              label: 'القرّاء',
            ),
            NavigationDestination(
              icon: Icon(Icons.favorite_outline),
              label: 'الأذكار',
            ),
            NavigationDestination(
              icon: Icon(Icons.quiz_outlined),
              label: 'المسابقة',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              label: 'الإعدادات',
            ),
          ],
        ),
      ),
    );
  }
}

class QuranScreen extends StatelessWidget {
  const QuranScreen({super.key});

  static const verses = [
    'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
    'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
    'الرَّحْمَٰنِ الرَّحِيمِ',
    'مَالِكِ يَوْمِ الدِّينِ',
    'إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ',
    'اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ',
    'صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ '
        'غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ',
  ];

  void showVerse(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Wrap(
            runSpacing: 14,
            children: [
              Text(
                'الآية ${index + 1}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: green,
                ),
              ),
              Text(
                verses[index],
                style: const TextStyle(fontSize: 23, height: 1.9),
              ),
              const Divider(),
              const Text(
                'التفسير',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'سيُعرض هنا تفسير موثوق للآية بعد ربط التطبيق '
                'بقاعدة بيانات تفسير معتمدة.',
                style: TextStyle(fontSize: 16, height: 1.7),
              ),
              if (index < 7)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      'إهداء إلى روح المرحوم ناصر عزيز، '
                      'رحمه الله وأسكنه فسيح جناته.',
                      style: TextStyle(height: 1.7),
                    ),
                  ),
                ),
              Wrap(
                spacing: 8,
                children: [
                  ActionChip(
                    avatar: const Icon(Icons.copy),
                    label: const Text('نسخ الآية'),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'أضف خدمة النسخ إلى المشروع لنسخ النص.',
                          ),
                        ),
                      );
                    },
                  ),
                  ActionChip(
                    avatar: const Icon(Icons.volume_up),
                    label: const Text('استماع'),
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'يلزم ربط ملفات التلاوة لتشغيل الصوت.',
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [darkGreen, green],
            ),
            borderRadius: BorderRadius.circular(22),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.auto_stories, color: gold, size: 38),
              SizedBox(height: 10),
              Text(
                'اقرأ وارتقِ',
                style: TextStyle(
                  fontSize: 26,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'سورة الفاتحة',
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        const Text(
          'سورة الفاتحة',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ...List.generate(verses.length, (index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 5),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => showVerse(context, index),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 15,
                          backgroundColor: green,
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            verses[index],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 21,
                              height: 2,
                            ),
                          ),
                        ),
                        const Icon(Icons.more_vert, color: green),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'إهداء إلى روح المرحوم ناصر عزيز',
                      style: TextStyle(
                        color: green,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
        const SizedBox(height: 12),
        const Text(
          'هذه نسخة أولية لعرض الفاتحة. أضف ملف القرآن الكامل '
          'من مصدر موثوق قبل نشر التطبيق.',
          style: TextStyle(color: Colors.black54),
        ),
      ],
    );
  }
}

class RecitersScreen extends StatelessWidget {
  const RecitersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const reciters = [
      'مشاري العفاسي',
      'عبدالرحمن السديس',
      'ماهر المعيقلي',
      'عبدالباسط عبدالصمد',
      'محمود خليل الحصري',
      'محمد صديق المنشاوي',
      'ياسر الدوسري',
      'أبو بكر الشاطري',
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'اختر القارئ',
          style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        for (final reciter in reciters)
          Card(
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: green,
                child: Icon(Icons.person, color: Colors.white),
              ),
              title: Text(reciter),
              subtitle: const Text('التلاوات تحتاج إلى ربط مصدر صوت'),
              trailing: const Icon(Icons.play_circle_outline),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'اخترنا القارئ. التشغيل يحتاج إلى ملفات صوت.',
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}

class DuasScreen extends StatelessWidget {
  const DuasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const items = [
      'أذكار الصباح',
      'أذكار المساء',
      'أذكار النوم',
      'أدعية من القرآن الكريم',
      'أدعية من السنة النبوية',
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        for (final item in items)
          Card(
            child: ListTile(
              leading: const Icon(Icons.spa, color: green),
              title: Text(item),
              subtitle: const Text('قسم الأذكار والأدعية'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(item),
                    content: const Text(
                      'تُضاف النصوص المعتمدة لهذا القسم '
                      'عند تجهيز قاعدة بيانات الأدعية.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('إغلاق'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int? answer;
  int score = 0;

  final options = const [
    '7 آيات',
    '5 آيات',
    '10 آيات',
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        const Icon(Icons.groups, size: 65, color: green),
        const Text(
          'غرفة المسابقة',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        const Text(
          'كم عدد آيات سورة الفاتحة؟',
          style: TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 12),
        for (int i = 0; i < options.length; i++)
          Card(
            child: ListTile(
              title: Text(options[i]),
              leading: Radio<int>(
                value: i,
                groupValue: answer,
                onChanged: (value) {
                  setState(() => answer = value);
                },
              ),
              onTap: () => setState(() => answer = i),
            ),
          ),
        FilledButton(
          onPressed: answer == null
              ? null
              : () {
                  setState(() {
                    if (answer == 0) score++;
                  });
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('نتيجة السؤال'),
                      content: Text(
                        answer == 0
                            ? 'إجابة صحيحة! نقاطك: $score'
                            : 'حاول مرة أخرى. نقاطك: $score',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            setState(() => answer = null);
                          },
                          child: const Text('متابعة'),
                        ),
                      ],
                    ),
                  );
                },
          child: const Text('تأكيد الإجابة'),
        ),
        const SizedBox(height: 12),
        const Text(
          'هذه مسابقة محلية تجريبية. اللعب الحقيقي بين '
          'ثلاثة أشخاص يحتاج إلى خادم واتصال مشترك.',
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool darkMode = false;
  bool notifications = true;
  double fontSize = 22;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const ListTile(
          leading: Icon(Icons.info_outline, color: green),
          title: Text('نور الآيات'),
          subtitle: Text('الإصدار 1.0.0'),
        ),
        SwitchListTile(
          value: darkMode,
          title: const Text('الوضع الليلي'),
          onChanged: (value) => setState(() => darkMode = value),
        ),
        SwitchListTile(
          value: notifications,
          title: const Text('التنبيهات'),
          onChanged: (value) => setState(() => notifications = value),
        ),
        const SizedBox(height: 12),
        const Text('حجم خط القرآن'),
        Slider(
          value: fontSize,
          min: 18,
          max: 36,
          divisions: 9,
          label: fontSize.round().toString(),
          onChanged: (value) => setState(() => fontSize = value),
        ),
        ListTile(
          leading: const Icon(Icons.email_outlined, color: green),
          title: const Text('التواصل مع المطوّر'),
          subtitle: const Text('أضف بريدك الإلكتروني هنا'),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('التواصل مع المطوّر'),
                content: const Text(
                  'ضع بريد الدعم أو رابط التواصل الرسمي '
                  'بعد إنشائه.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('إغلاق'),
                  ),
                ],
              ),
            );
          },
        ),
        const ListTile(
          leading: Icon(Icons.privacy_tip_outlined, color: green),
          title: Text('الخصوصية'),
          subtitle: Text('أضف سياسة الخصوصية قبل النشر'),
        ),
      ],
    );
  }
}
