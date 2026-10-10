import 'package:flutter/material.dart';
import 'package:quran/quran.dart' as quran;
import 'package:just_audio/just_audio.dart';
import 'package:flutter/services.dart';

void main() { runApp(QuranApp()); }

class QuranApp extends StatefulWidget {
  @override
  State<QuranApp> createState() { return QuranAppState(); }
}

class QuranAppState extends State<QuranApp> {
  bool loading = true;
  double prog = 0;
  @override
  void initState() { super.initState(); startLoading(); }
  startLoading() async {
    for (int i = 0; i <= 100; i++) {
      await Future.delayed(Duration(milliseconds: 20));
      if (mounted) { setState(() { prog = i / 100; }); }
    }
    setState(() { loading = false; });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: loading? LoadingScreen(p: prog) : MainScreen());
  }
}

class LoadingScreen extends StatelessWidget {
  final double p; LoadingScreen({required this.p});
  @override
  Widget build(BuildContext context) {
    int percent = (p * 100).toInt();
    return Scaffold(
      backgroundColor: Color(0xFF0B3D2E),
      body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.menu_book, size: 70, color: Color(0xFFE8C86A)),
        SizedBox(height: 12),
        Text("نور الآيات", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
        Text("رفيقك مع القرآن", style: TextStyle(color: Colors.white54, fontSize: 12)),
        SizedBox(height: 25),
        Padding(padding: EdgeInsets.symmetric(horizontal: 40), child: LinearProgressIndicator(value: p, color: Color(0xFFE8C86A), backgroundColor: Colors.white12, minHeight: 4)),
        SizedBox(height: 8), Text("$percent %", style: TextStyle(color: Colors.white38, fontSize: 10)),
      ])),
    );
  }
}

class QuranListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(backgroundColor: Color(0xFF0B3D2E), title: Text("القرآن الكريم", style: TextStyle(color: Colors.white))),
      body: ListView.builder(itemCount: 114, itemBuilder: (c, i) {
        int n = i + 1; String name = quran.getSurahNameArabic(n);
        return Container(margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)), child: ListTile(leading: Container(width: 28, height: 28, decoration: BoxDecoration(color: Color(0xFF0B3D2E), shape: BoxShape.circle), child: Center(child: Text("$n", style: TextStyle(color: Colors.white, fontSize: 11)))), title: Text(name, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)), trailing: Icon(Icons.more_vert, size: 16), onTap: () { Navigator.push(c, MaterialPageRoute(builder: (context2) { return SurahPage(num: n); })); }));
      }),
    );
  }
}

class SurahPage extends StatefulWidget {
  final int num; SurahPage({required this.num});
  @override
  State<SurahPage> createState() { return SurahPageState(); }
}

class SurahPageState extends State<SurahPage> {
  AudioPlayer player = AudioPlayer(); bool playing = false; int current = 1;
  String reciterCode = "Yasser_Ad-Dosari_128kbps";
  String getUrl(int ayah) { String s = widget.num.toString().padLeft(3, '0'); String v = ayah.toString().padLeft(3, '0'); return "https://everyayah.com/data/$reciterCode/${s}${v}.mp3"; }
  playAyah(int ayah) async { setState(() { current = ayah; playing = true; }); try { await player.setUrl(getUrl(ayah)); await player.play(); } catch (e) { setState(() { playing = false; }); } }
  stopPlay() async { await player.pause(); setState(() { playing = false; }); }
  showTafsir(BuildContext context, int ayah) {
    String verse = quran.getVerse(widget.num, ayah, verseEndSymbol: false);
    String tafsirText; try { tafsirText = quran.getVerseTafsir(widget.num, ayah); } catch (e) { tafsirText = "التفسير"; }
    showModalBottomSheet(context: context, backgroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))), builder: (context2) {
      return Padding(padding: EdgeInsets.all(16), child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text("الآية $ayah", style: TextStyle(fontWeight: FontWeight.bold)), SizedBox(height: 8),
        Text(verse, textAlign: TextAlign.right, style: TextStyle(fontSize: 18)), SizedBox(height: 12),
        Text(tafsirText, style: TextStyle(fontSize: 11, color: Colors.black54)), SizedBox(height: 12),
        Row(children: [
          ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF0B3D2E)), onPressed: () { Clipboard.setData(ClipboardData(text: verse)); Navigator.pop(context); }, child: Text("نسخ", style: TextStyle(color: Colors.white, fontSize: 11))),
          SizedBox(width: 8),
          ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.white, side: BorderSide(color: Color(0xFF0B3D2E))), onPressed: () { Navigator.pop(context); playAyah(ayah); }, child: Text("استماع", style: TextStyle(color: Color(0xFF0B3D2E), fontSize: 11))),
        ]),
      ]));
    });
  }
  Widget reciterChip(String code, String name) { bool sel = code == reciterCode; return GestureDetector(onTap: () async { await player.stop(); setState(() { reciterCode = code; playing = false; }); }, child: Container(margin: EdgeInsets.only(right: 6), padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: sel? Color(0xFF0B3D2E) : Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Color(0xFF0B3D2E))), child: Text(name, style: TextStyle(fontSize: 11, color: sel? Colors.white : Color(0xFF0B3D2E))))); }
  @override
  void dispose() { player.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    int total = quran.getVerseCount(widget.num); String surahName = quran.getSurahNameArabic(widget.num);
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(backgroundColor: Color(0xFF0B3D2E), title: Text(surahName, style: TextStyle(color: Colors.white, fontSize: 16)), actions: [IconButton(icon: Icon(playing? Icons.pause : Icons.play_arrow, color: Colors.white), onPressed: () { if (playing) { stopPlay(); } else { playAyah(current); } })]),
      body: Column(children: [
        Container(color: Colors.white, padding: EdgeInsets.all(8), child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: [
          reciterChip("Yasser_Ad-Dosari_128kbps", "ياسر"), reciterChip("Abdurrahmaan_As-Sudais_192kbps", "السديس"), reciterChip("Saood_ash-Shuraym_128kbps", "الشريم"), reciterChip("Maher_AlMuaiqly_64kbps", "ماهر"), reciterChip("Alafasy_128kbps", "العفاسي"), reciterChip("Ghamadi_40kbps", "الغامدي"), reciterChip("Husary_128kbps", "الحصري"), reciterChip("Minshawy_Murattal_128kbps", "المنشاوي"),
        ]))),
        Expanded(child: ListView.builder(itemCount: total + 1, itemBuilder: (c, i) {
          if (i == total) {
            return Container(margin: EdgeInsets.all(12), padding: EdgeInsets.all(16), decoration: BoxDecoration(color: Color(0xFF0B3D2E), borderRadius: BorderRadius.circular(12)), child: Column(children: [
              Text("صدقة جارية", style: TextStyle(color: Color(0xFFE8C86A), fontWeight: FontWeight.bold)), SizedBox(height: 6),
              Text("الفاتحة الى روح المرحوم ناصر عزيز", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)), SizedBox(height: 4),
              Text("اللهم ارحمه واغفر له", textAlign: TextAlign.center, style: TextStyle(color: Colors.white70, fontSize: 11)),
            ]));
          }
          int ayah = i + 1; String verse = quran.getVerse(widget.num, ayah, verseEndSymbol: false); bool isCur = playing && current == ayah;
          return GestureDetector(onTap: () { showTafsir(c, ayah); }, child: Container(margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4), padding: EdgeInsets.all(12), decoration: BoxDecoration(color: isCur? Color(0xFFE8F5E9) : Colors.white, borderRadius: BorderRadius.circular(12)), child: Row(children: [Container(width: 26, height: 26, decoration: BoxDecoration(color: Color(0xFF0B3D2E), shape: BoxShape.circle), child: Center(child: Text("$ayah", style: TextStyle(color: Colors.white, fontSize: 10)))), SizedBox(width: 8), Expanded(child: Text(verse, textAlign: TextAlign.right, style: TextStyle(fontSize: 16, height: 1.6))), Icon(Icons.more_vert, size: 14)])));
        })),
      ]),
    );
  }
}

class AzkarPage extends StatelessWidget { @override Widget build(BuildContext context) { return Scaffold(backgroundColor: Color(0xFFF5F5F5), appBar: AppBar(title: Text("الاذكار"), backgroundColor: Color(0xFF0B3D2E)), body: ListView(padding: EdgeInsets.all(10), children: [Card(child: ListTile(title: Text("اذكار الصباح"), subtitle: Text("اصبحنا واصبح الملك لله"))), Card(child: ListTile(title: Text("للمرحوم ناصر"), subtitle: Text("اللهم ارحم ناصر عزيز")))])); } }
class TasbeehPage extends StatefulWidget { @override State<TasbeehPage> createState() { return TasbeehPageState(); } }
class TasbeehPageState extends State<TasbeehPage> { int count = 0; @override Widget build(BuildContext context) { return Scaffold(backgroundColor: Color(0xFFF5F5F5), appBar: AppBar(title: Text("السبحة"), backgroundColor: Color(0xFF0B3D2E)), body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text("$count", style: TextStyle(fontSize: 60, color: Color(0xFF0B3D2E), fontWeight: FontWeight.bold)), SizedBox(height: 20), GestureDetector(onTap: () { setState(() { count++; }); }, child: Container(width: 140, height: 140, decoration: BoxDecoration(color: Color(0xFF0B3D2E), shape: BoxShape.circle), child: Center(child: Text("سبح", style: TextStyle(color: Colors.white, fontSize: 20))))), TextButton(onPressed: () { setState(() { count = 0; }); }, child: Text("اعادة"))]))); } }
class MosabakaPage extends StatefulWidget { @override State<MosabakaPage> createState() { return MosabakaPageState(); } }
class MosabakaPageState extends State<MosabakaPage> { int qIndex = 0; int score = 0; List<String> qs = ["كم عدد سور القرآن؟", "ما هي قلب القرآن؟", "كم عدد اجزاء القرآن؟"]; List<List<String>> opts = [["112", "114", "116"], ["يس", "الرحمن", "الملك"], ["30", "60", "114"]]; List<int> ans = [1, 0, 0]; @override Widget build(BuildContext context) { return Scaffold(backgroundColor: Color(0xFFF5F5F5), appBar: AppBar(title: Text("المسابقة"), backgroundColor: Color(0xFF0B3D2E)), body: Padding(padding: EdgeInsets.all(14), child: Column(children: [Text(qs[qIndex], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), SizedBox(height: 12), Card(child: ListTile(title: Text(opts[qIndex][0]), onTap: () { check(0); })), Card(child: ListTile(title: Text(opts[qIndex][1]), onTap: () { check(1); })), Card(child: ListTile(title: Text(opts[qIndex][2]), onTap: () { check(2); })), Spacer(), Text("النقاط: $score", style: TextStyle(color: Color(0xFF0B3D2E), fontWeight: FontWeight.bold))]))); } check(int i) { if (i == ans[qIndex]) { score++; } setState(() { if (qIndex < 2) { qIndex++; } else { qIndex = 0; score = 0; } }); } }

class PrivacyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Privacy"), backgroundColor: Color(0xFF0B3D2E)),
      body: ListView(padding: EdgeInsets.all(16), children: [
        Text("Noor Al Ayat Privacy", style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Text("1. No data collected"),
        Text("2. No login required"),
        Text("3. Audio from everyayah.com"),
        Text("4. Sadaqa for Nasser Aziz"),
        Text("5. Contact ha1224704@gmail.com"),
        SizedBox(height: 8),
        Text("Package com.ha1224704.noor.quloob.sadaqa.nasser"),
        Text("Safe 100 percent"),
        SizedBox(height: 16),
        Text("سياسة الخصوصية", style: TextStyle(fontWeight: FontWeight.bold)),
        Text("لا يجمع بيانات"),
        Text("صدقة للمرحوم ناصر عزيز"),
      ]),
    );
  }
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(title: Text("الاعدادات"), backgroundColor: Color(0xFF0B3D2E)),
      body: ListView(padding: EdgeInsets.all(12), children: [
        Card(child: ListTile(leading: Icon(Icons.email), title: Text("البريد"), subtitle: Text("ha1224704@gmail.com"))),
        Card(child: ListTile(leading: Icon(Icons.security), title: Text("سياسة الخصوصية"), trailing: Icon(Icons.arrow_forward_ios, size: 14), onTap: () { Navigator.push(context, MaterialPageRoute(builder: (c2) { return PrivacyPage(); })); })),
        Card(child: ListTile(leading: Icon(Icons.info), title: Text("عن التطبيق"), subtitle: Text("com.ha1224704.noor.quloob.sadaqa.nasser - حيدر"))),
      ]),
    );
  }
}

class MainScreen extends StatefulWidget { @override State<MainScreen> createState() { return MainScreenState(); } }
class MainScreenState extends State<MainScreen> {
  int tab = 0;
  @override
  Widget build(BuildContext context) {
    Widget page;
    if (tab == 0) { page = QuranListPage(); }
    else if (tab == 1) { page = AzkarPage(); }
    else if (tab == 2) { page = MosabakaPage(); }
    else if (tab == 3) { page = TasbeehPage(); }
    else { page = SettingsPage(); }
    return Scaffold(
      body: page,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: tab,
        onTap: (i) { setState(() { tab = i; }); },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xFF0B3D2E),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: "القرآن"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "الاذكار"),
          BottomNavigationBarItem(icon: Icon(Icons.emoji_events), label: "المسابقة"),
          BottomNavigationBarItem(icon: Icon(Icons.circle), label: "السبحة"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "الاعدادات"),
        ],
      ),
    );
  }
}