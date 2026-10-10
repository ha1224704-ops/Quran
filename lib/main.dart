import 'package:flutter/material.dart';
import 'package:quran/quran.dart' as quran;
import 'package:just_audio/just_audio.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'نور القلوب',
      theme: ThemeData(primaryColor: const Color(0xFF0B3D2E)),
      home: const SplashPage(),
    );
  }
}

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  double p = 0;
  @override
  void initState() {
    super.initState();
    _load();
  }
  Future<void> _load() async {
    for (int i = 0; i <= 100; i++) {
      await Future.delayed(const Duration(milliseconds: 20));
      if (!mounted) return;
      setState(() { p = i / 100; });
    }
    if (!mounted) return;
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B3D2E),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.mosque, size: 70, color: Color(0xFFE8C86A)),
            const SizedBox(height: 12),
            const Text("نور القلوب", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
            const Text("صدقة جارية لروح ناصر عزيز", style: TextStyle(color: Colors.white70, fontSize: 12)),
            const SizedBox(height: 20),
            SizedBox(width: 160, child: LinearProgressIndicator(value: p, color: const Color(0xFFE8C86A), backgroundColor: Colors.white12)),
            const SizedBox(height: 8),
            Text("${(p*100).toInt()}%", style: const TextStyle(color: Colors.white38, fontSize: 12)),
            const SizedBox(height: 20),
            const Text("صنع في العراق - حيدر", style: TextStyle(color: Colors.white24, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int tab = 0;
  @override
  Widget build(BuildContext context) {
    Widget page;
    if (tab == 0) page = const QuranListPage();
    else if (tab == 1) page = const AzkarPage();
    else if (tab == 2) page = const SebhaPage();
    else page = const AboutPage();

    return Scaffold(
      body: page,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: tab,
        onTap: (i) => setState(() => tab = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF0B3D2E),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: "القرآن"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "اذكار"),
          BottomNavigationBarItem(icon: Icon(Icons.circle), label: "سبحة"),
          BottomNavigationBarItem(icon: Icon(Icons.flag), label: "المطور"),
        ],
      ),
    );
  }
}

class QuranListPage extends StatelessWidget {
  const QuranListPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEF9EF),
      appBar: AppBar(backgroundColor: const Color(0xFF0B3D2E), title: const Text("القرآن الكريم - 114 سورة", style: TextStyle(color: Colors.white, fontSize: 14))),
      body: ListView.builder(
        itemCount: 114,
        itemBuilder: (c, i) {
          int n = i + 1;
          String nameAr = quran.getSurahNameArabic(n);
          String nameEn = quran.getSurahName(n);
          int count = quran.getVerseCount(n);
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            child: ListTile(
              leading: CircleAvatar(backgroundColor: const Color(0xFF0B3D2E), radius: 16, child: Text("$n", style: const TextStyle(color: Colors.white, fontSize: 11))),
              title: Text(nameAr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              subtitle: Text("$nameEn - $count آية", style: const TextStyle(fontSize: 10)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 12),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SurahViewPage(num: n))),
            ),
          );
        },
      ),
    );
  }
}

class SurahViewPage extends StatefulWidget {
  final int num;
  const SurahViewPage({super.key, required this.num});
  @override
  State<SurahViewPage> createState() => _SurahViewPageState();
}

class _SurahViewPageState extends State<SurahViewPage> {
  final AudioPlayer player = AudioPlayer();
  int currentAyah = 0;
  @override
  void dispose() { player.dispose(); super.dispose(); }
  Future<void> playAyah(int ayah) async {
    setState(() { currentAyah = ayah; });
    String s = widget.num.toString().padLeft(3, '0');
    String v = ayah.toString().padLeft(3, '0');
    String url = "https://everyayah.com/data/Yasser_Ad-Dosari_128kbps/${s}${v}.mp3";
    try { await player.setUrl(url); await player.play(); } catch (_) {}
  }
  @override
  Widget build(BuildContext context) {
    int total = quran.getVerseCount(widget.num);
    String name = quran.getSurahNameArabic(widget.num);
    return Scaffold(
      backgroundColor: const Color(0xFFFEF9EF),
      appBar: AppBar(backgroundColor: const Color(0xFF0B3D2E), title: Text(name, style: const TextStyle(color: Colors.white))),
      body: ListView.builder(
        itemCount: total + 1,
        itemBuilder: (c, i) {
          if (i == total) {
            return Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFF0B3D2E), borderRadius: BorderRadius.circular(12)),
              child: const Column(
                children: [
                  Text("صدقة جارية", style: TextStyle(color: Color(0xFFE8C86A), fontWeight: FontWeight.bold)),
                  SizedBox(height: 6),
                  Text("الفاتحة لروح المرحوم ناصر عزيز", style: TextStyle(color: Colors.white, fontSize: 13)),
                  SizedBox(height: 6),
                  Text("اللهم ارحمه واغفر له واجعل قبره روضة من رياض الجنة", textAlign: TextAlign.center, style: TextStyle(color: Colors.white60, fontSize: 11)),
                  SizedBox(height: 8),
                  Text("صنع في العراق - حيدر - ha1224704@gmail.com", style: TextStyle(color: Colors.white24, fontSize: 8)),
                ],
              ),
            );
          }
          int ayah = i + 1;
          String verse = quran.getVerse(widget.num, ayah, verseEndSymbol: false);
          bool active = currentAyah == ayah;
          return Card(
            color: active ? const Color(0xFFE8F5E9) : Colors.white,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            child: ListTile(
              leading: CircleAvatar(radius: 11, backgroundColor: const Color(0xFF0B3D2E), child: Text("$ayah", style: const TextStyle(fontSize: 8, color: Colors.white))),
              title: Text(verse, textAlign: TextAlign.right, style: const TextStyle(fontSize: 15, height: 1.6)),
              trailing: IconButton(icon: Icon(active ? Icons.pause_circle : Icons.play_circle_outline, color: const Color(0xFF0B3D2E)), onPressed: () => playAyah(ayah)),
              onLongPress: () { Clipboard.setData(ClipboardData(text: verse)); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("تم نسخ الآية"))); },
            ),
          );
        },
      ),
    );
  }
}

class AzkarPage extends StatelessWidget {
  const AzkarPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEF9EF),
      appBar: AppBar(backgroundColor: const Color(0xFF0B3D2E), title: const Text("الأذكار", style: TextStyle(color: Colors.white))),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: const [
          Card(child: ListTile(title: Text("أذكار الصباح"), subtitle: Text("أصبحنا وأصبح الملك لله"))),
          Card(child: ListTile(title: Text("أذكار المساء"), subtitle: Text("أمسينا وأمسى الملك لله"))),
          Card(color: Color(0xFF0B3D2E), child: ListTile(title: Text("دعاء للمرحوم ناصر عزيز", style: TextStyle(color: Color(0xFFE8C86A), fontWeight: FontWeight.bold)), subtitle: Text("اللهم ارحم ناصر عزيز واغفر له واجعل مثواه الجنة", style: TextStyle(color: Colors.white70)))),
          Card(child: ListTile(title: Text("دعاء للعراق"), subtitle: Text("اللهم احفظ العراق وأهله"))),
        ],
      ),
    );
  }
}

class SebhaPage extends StatefulWidget {
  const SebhaPage({super.key});
  @override
  State<SebhaPage> createState() => _SebhaPageState();
}

class _SebhaPageState extends State<SebhaPage> {
  int count = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEF9EF),
      appBar: AppBar(backgroundColor: const Color(0xFF0B3D2E), title: const Text("السبحة", style: TextStyle(color: Colors.white))),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("$count", style: const TextStyle(fontSize: 70, fontWeight: FontWeight.bold, color: Color(0xFF0B3D2E))),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => setState(() => count++),
              child: Container(width: 160, height: 160, decoration: const BoxDecoration(color: Color(0xFF0B3D2E), shape: BoxShape.circle), child: const Center(child: Text("سبح", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)))),
            ),
            const SizedBox(height: 12),
            TextButton(onPressed: () => setState(() => count = 0), child: const Text("تصفير")),
            const Text("كل تسبيحة صدقة لناصر عزيز", style: TextStyle(fontSize: 10, color: Colors.black38)),
          ],
        ),
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEF9EF),
      appBar: AppBar(backgroundColor: const Color(0xFF0B3D2E), title: const Text("المطور العراقي", style: TextStyle(color: Colors.white))),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(color: const Color(0xFF0B3D2E), borderRadius: BorderRadius.circular(14)),
            child: const Column(
              children: [
                CircleAvatar(radius: 30, backgroundColor: Color(0xFFE8C86A), child: Icon(Icons.person, size: 35, color: Color(0xFF0B3D2E))),
                SizedBox(height: 10),
                Text("حيدر", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                Text("مطور عراقي - بغداد", style: TextStyle(color: Color(0xFFE8C86A), fontSize: 12)),
                SizedBox(height: 8),
                Text("هذا التطبيق صدقة جارية لروح المرحوم ناصر عزيز", textAlign: TextAlign.center, style: TextStyle(color: Colors.white60, fontSize: 11)),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Card(child: ListTile(leading: Icon(Icons.email, color: Color(0xFF0B3D2E)), title: Text("البريد", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)), subtitle: Text("ha1224704@gmail.com", style: TextStyle(fontSize: 11)))),
          const Card(child: ListTile(leading: Icon(Icons.flag, color: Colors.green), title: Text("الجنسية", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)), subtitle: Text("عراقي - بغداد", style: TextStyle(fontSize: 11)))),
          const Card(child: ListTile(leading: Icon(Icons.favorite, color: Colors.red), title: Text("الهدف", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)), subtitle: Text("صدقة جارية للمرحوم ناصر عزيز الله يرحمه", style: TextStyle(fontSize: 11)))),
          const Card(child: ListTile(leading: Icon(Icons.code), title: Text("الحزمة", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)), subtitle: Text("com.ha1224704.noor.quloob.sadaqa.nasser", style: TextStyle(fontSize: 9)))),
          const SizedBox(height: 12),
          const Center(child: Text("صنع بكل فخر في العراق - 2026", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF0B3D2E)))),
        ],
      ),
    );
  }
}