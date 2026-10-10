import 'package:flutter/material.dart';
import 'package:quran/quran.dart' as quran;
import 'package:just_audio/just_audio.dart';
import 'package:flutter/services.dart';

void main() => runApp(DiwanNoorApp());

class DiwanNoorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Cairo'),
      home: DiwanSplash(),
    );
  }
}

// سبلاش ديوان عراقي
class DiwanSplash extends StatefulWidget {
  @override
  State<DiwanSplash> createState() => _DiwanSplashState();
}

class _DiwanSplashState extends State<DiwanSplash> with SingleTickerProviderStateMixin {
  late AnimationController ctrl;
  double prog = 0;
  @override
  void initState() {
    super.initState();
    ctrl = AnimationController(vsync: this, duration: Duration(seconds: 2))..repeat();
    boot();
  }
  boot() async {
    for (int i = 0; i <= 100; i++) {
      await Future.delayed(Duration(milliseconds: 25));
      setState(() => prog = i / 100);
    }
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => DiwanHome()));
  }
  @override
  void dispose() { ctrl.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121B22),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RotationTransition(
              turns: ctrl,
              child: Container(
                width: 110, height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Color(0xFFD4AF37), width: 3),
                ),
                child: Icon(Icons.auto_stories, size: 55, color: Color(0xFFD4AF37)),
              ),
            ),
            SizedBox(height: 18),
            Text("ديوان نور القلوب", style: TextStyle(color: Colors.white, fontSize: 27, fontWeight: FontWeight.bold, letterSpacing: 1)),
            Text("النسخة العراقية - ما مطروقة", style: TextStyle(color: Color(0xFFD4AF37), fontSize: 11, fontWeight: FontWeight.bold)),
            SizedBox(height: 6),
            Text("وقف للمرحوم ناصر عزيز", style: TextStyle(color: Colors.white54, fontSize: 11)),
            SizedBox(height: 30),
            SizedBox(width: 180, child: LinearProgressIndicator(value: prog, color: Color(0xFFD4AF37), backgroundColor: Colors.white10)),
            SizedBox(height: 8),
            Text("ديوان عراقي ${ (prog*100).toInt()}%", style: TextStyle(color: Colors.white24, fontSize: 9)),
            SizedBox(height: 20),
            Text("تأليف المطور العراقي حيدر", style: TextStyle(color: Colors.white10, fontSize: 9)),
          ],
        ),
      ),
    );
  }
}

class DiwanHome extends StatefulWidget {
  @override
  State<DiwanHome> createState() => _DiwanHomeState();
}

class _DiwanHomeState extends State<DiwanHome> {
  int currentTab = 0;
  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [DiwanQuran(), DiwanKhatma(), DiwanTasbeeh(), DiwanIraqiDev()];
    return Scaffold(
      body: pages[currentTab],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentTab,
        onTap: (i) => setState(() => currentTab = i),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xFF121B22),
        selectedItemColor: Color(0xFFD4AF37),
        unselectedItemColor: Colors.white38,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.menu_book_outlined), label: "الديوان"),
          BottomNavigationBarItem(icon: Icon(Icons.check_circle_outline), label: "ختمتي"),
          BottomNavigationBarItem(icon: Icon(Icons.grain_outlined), label: "سبحتي"),
          BottomNavigationBarItem(icon: Icon(Icons.person_pin_circle_outlined), label: "عراقي"),
        ],
      ),
    );
  }
}

// صفحة القرآن بطريقة ديوان
class DiwanQuran extends StatefulWidget {
  @override
  State<DiwanQuran> createState() => _DiwanQuranState();
}

class _DiwanQuranState extends State<DiwanQuran> {
  String filter = "الكل";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F3E6),
      appBar: AppBar(
        backgroundColor: Color(0xFF121B22),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("ديوان القرآن", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
            Text("114 سورة - 30 جزء - رواية حفص", style: TextStyle(color: Color(0xFFD4AF37), fontSize: 9)),
          ],
        ),
        actions: [IconButton(icon: Icon(Icons.search, color: Colors.white), onPressed: () {})],
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(12),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(color: Color(0xFF121B22), borderRadius: BorderRadius.circular(14)),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("ورد اليوم", style: TextStyle(color: Color(0xFFD4AF37), fontSize: 10, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text(quran.getVerse(55, 1, verseEndSymbol: false) + " ...", style: TextStyle(color: Colors.white, fontSize: 11, height: 1.4), maxLines: 2),
                      Text("سورة الرحمن - 1", style: TextStyle(color: Colors.white38, fontSize: 8)),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                Container(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: Color(0xFFD4AF37), borderRadius: BorderRadius.circular(20)), child: Text("اقرأ الآن", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF121B22)))),
              ],
            ),
          ),
          Container(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 12),
              children: [
                _filterChip("الكل", filter == "الكل", () => setState(() => filter = "الكل")),
                _filterChip("مكية", filter == "مكية", () => setState(() => filter = "مكية")),
                _filterChip("مدنية", filter == "مدنية", () => setState(() => filter = "مدنية")),
                _filterChip("طوال", filter == "طوال", () => setState(() => filter = "طوال")),
                _filterChip("قصار", filter == "قصار", () => setState(() => filter = "قصار")),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 114,
              itemBuilder: (c, i) {
                int n = i + 1;
                String place = quran.getPlaceOfRevelation(n);
                String placeAr = place == "Makkah" ? "مكية" : "مدنية";
                int verses = quran.getVerseCount(n);
                if (filter != "الكل") {
                  if (filter == "مكية" && placeAr != "مكية") return SizedBox();
                  if (filter == "مدنية" && placeAr != "مدنية") return SizedBox();
                  if (filter == "طوال" && verses < 100) return SizedBox();
                  if (filter == "قصار" && verses >= 100) return SizedBox();
                }
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black12)),
                  child: ListTile(
                    leading: Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(Icons.hexagon_outlined, size: 36, color: Color(0xFF121B22)),
                        Text("$n", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    title: Text(quran.getSurahNameArabic(n), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    subtitle: Text("$placeAr - $verses آية - الجزء ${quran.getJuzNumber(n, 1)}", style: TextStyle(fontSize: 9, color: Colors.black54)),
                    trailing: Icon(Icons.arrow_forward_ios, size: 10, color: Colors.black26),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DiwanSurah(num: n))),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  Widget _filterChip(String txt, bool sel, VoidCallback tap) {
    return GestureDetector(
      onTap: tap,
      child: Container(
        margin: EdgeInsets.only(right: 6),
        padding: EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(color: sel ? Color(0xFF121B22) : Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Color(0xFF121B22))),
        child: Center(child: Text(txt, style: TextStyle(color: sel ? Colors.white : Color(0xFF121B22), fontSize: 11, fontWeight: FontWeight.bold))),
      ),
    );
  }
}

class DiwanSurah extends StatefulWidget {
  final int num;
  DiwanSurah({required this.num});
  @override
  State<DiwanSurah> createState() => _DiwanSurahState();
}

class _DiwanSurahState extends State<DiwanSurah> {
  AudioPlayer pl = AudioPlayer();
  int now = 0;
  double speed = 1.0;
  play(int ayah) async {
    setState(() => now = ayah);
    String s = widget.num.toString().padLeft(3, '0');
    String v = ayah.toString().padLeft(3, '0');
    String url = "https://everyayah.com/data/Yasser_Ad-Dosari_128kbps/${s}${v}.mp3";
    try {
      await pl.setUrl(url);
      await pl.setSpeed(speed);
      await pl.play();
    } catch (e) {}
  }
  @override
  void dispose() { pl.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    int total = quran.getVerseCount(widget.num);
    return Scaffold(
      backgroundColor: Color(0xFFF8F3E6),
      appBar: AppBar(
        backgroundColor: Color(0xFF121B22),
        title: Text(quran.getSurahNameArabic(widget.num), style: TextStyle(color: Colors.white)),
        actions: [
          PopupMenuButton<double>(
            icon: Icon(Icons.speed, color: Colors.white),
            onSelected: (v) { setState(() => speed = v); },
            itemBuilder: (_) => [
              PopupMenuItem(value: 0.75, child: Text("بطيء 0.75x")),
              PopupMenuItem(value: 1.0, child: Text("طبيعي 1.0x")),
              PopupMenuItem(value: 1.25, child: Text("سريع 1.25x")),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: total + 2,
        itemBuilder: (c, i) {
          if (i == 0) {
            if (widget.num == 1 || widget.num == 9) return SizedBox();
            return Container(
              margin: EdgeInsets.all(12),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Center(child: Text("بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF121B22)))),
            );
          }
          if (i == total + 1) {
            return Container(
              margin: EdgeInsets.all(14),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(color: Color(0xFF121B22), borderRadius: BorderRadius.circular(14)),
              child: Column(
                children: [
                  Text("ديوان عراقي - وقف", style: TextStyle(color: Color(0xFFD4AF37), fontSize: 10, fontWeight: FontWeight.bold)),
                  SizedBox(height: 6),
                  Text("اللهم اجعل ثواب ما قرأنا نوراً واصلاً الى روح المرحوم ناصر عزيز", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 12, height: 1.5)),
                  SizedBox(height: 8),
                  Text("المطور العراقي حيدر - بغداد - com.ha1224704.noor.quloob.sadaqa.nasser", style: TextStyle(color: Colors.white24, fontSize: 7)),
                ],
              ),
            );
          }
          int ayah = i;
          String verse = quran.getVerse(widget.num, ayah, verseEndSymbol: false);
          bool active = now == ayah;
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(color: active ? Color(0xFFFFF3CD) : Colors.white, borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              title: Text(verse, textAlign: TextAlign.right, style: TextStyle(fontSize: 16, height: 1.7)),
              subtitle: Text("الآية $ayah", style: TextStyle(fontSize: 8, color: Colors.black38)),
              trailing: IconButton(icon: Icon(active ? Icons.pause_circle_filled : Icons.play_circle_outline, color: Color(0xFF121B22)), onPressed: () => play(ayah)),
              onLongPress: () {
                Clipboard.setData(ClipboardData(text: verse));
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("تم نسخ الآية - صدقة لناصر")));
              },
            ),
          );
        },
      ),
    );
  }
}

class DiwanKhatma extends StatefulWidget {
  @override
  State<DiwanKhatma> createState() => _DiwanKhatmaState();
}

class _DiwanKhatmaState extends State<DiwanKhatma> {
  List<bool> done = List.generate(114, (i) => false);
  int get progress => done.where((e) => e).length;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F3E6),
      appBar: AppBar(backgroundColor: Color(0xFF121B22), title: Text("ختمتي العراقية", style: TextStyle(color: Colors.white, fontSize: 14))),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(12),
            padding: EdgeInsets.all(14),
            decoration: BoxDecoration(color: Color(0xFF121B22), borderRadius: BorderRadius.circular(14)),
            child: Column(
              children: [
                Row(children: [Text("تقدم الختمة", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)), Spacer(), Text("$progress / 114 سورة", style: TextStyle(color: Color(0xFFD4AF37), fontSize: 11))]),
                SizedBox(height: 8),
                LinearProgressIndicator(value: progress / 114, color: Color(0xFFD4AF37), backgroundColor: Colors.white12),
                SizedBox(height: 6),
                Text("كل سورة تقرأها صدقة جارية لروح ناصر عزيز", style: TextStyle(color: Colors.white38, fontSize: 9)),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(12),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 1.6),
              itemCount: 114,
              itemBuilder: (c, i) {
                bool d = done[i];
                return GestureDetector(
                  onTap: () => setState(() => done[i] = !done[i]),
                  child: Container(
                    margin: EdgeInsets.all(4),
                    decoration: BoxDecoration(color: d ? Color(0xFF121B22) : Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: d ? Color(0xFFD4AF37) : Colors.black12)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(quran.getSurahNameArabic(i + 1), style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: d ? Colors.white : Colors.black)),
                        Icon(d ? Icons.check_circle : Icons.circle_outlined, size: 14, color: d ? Color(0xFFD4AF37) : Colors.black26),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DiwanTasbeeh extends StatefulWidget {
  @override
  State<DiwanTasbeeh> createState() => _DiwanTasbeehState();
}

class _DiwanTasbeehState extends State<DiwanTasbeeh> {
  int count = 0;
  int total = 0;
  String current = "سبحان الله";
  List<String> azkar = ["سبحان الله", "الحمد لله", "الله اكبر", "لا اله الا الله", "استغفر الله", "اللهم صل على محمد وآل محمد", "سبحان الله وبحمده"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F3E6),
      appBar: AppBar(backgroundColor: Color(0xFF121B22), title: Text("سبحتي العراقية - وقف لناصر", style: TextStyle(color: Colors.white, fontSize: 12))),
      body: Column(
        children: [
          Container(
            height: 42,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 12),
              itemCount: azkar.length,
              itemBuilder: (c, i) {
                bool sel = azkar[i] == current;
                return GestureDetector(
                  onTap: () => setState(() { current = azkar[i]; count = 0; }),
                  child: Container(margin: EdgeInsets.only(right: 6, top: 6, bottom: 6), padding: EdgeInsets.symmetric(horizontal: 14), decoration: BoxDecoration(color: sel ? Color(0xFF121B22) : Colors.white, borderRadius: BorderRadius.circular(20)), child: Center(child: Text(azkar[i], style: TextStyle(fontSize: 10, color: sel ? Color(0xFFD4AF37) : Colors.black)))),
                );
              },
            ),
          ),
          SizedBox(height: 10),
          Text(current, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF121B22))),
          Text("المجموع الكلي: $total تسبيحة - صدقة لناصر", style: TextStyle(fontSize: 10, color: Colors.black45)),
          SizedBox(height: 10),
          Center(
            child: Column(
              children: [
                Text("$count", style: TextStyle(fontSize: 80, fontWeight: FontWeight.bold, color: Color(0xFF121B22))),
                Text("/ 33", style: TextStyle(fontSize: 14, color: Colors.black38)),
                SizedBox(height: 18),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      count++;
                      total++;
                      if (count > 33) count = 1;
                    });
                  },
                  child: Container(
                    width: 190, height: 190,
                    decoration: BoxDecoration(color: Color(0xFF121B22), shape: BoxShape.circle, border: Border.all(color: Color(0xFFD4AF37), width: 4)),
                    child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.touch_app, color: Color(0xFFD4AF37)), Text("سبح", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)), Text("اضغط", style: TextStyle(color: Colors.white24, fontSize: 9))])),
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF121B22)), onPressed: () => setState(() => count = 0), child: Text("تصفير", style: TextStyle(color: Color(0xFFD4AF37)))),
                    SizedBox(width: 10),
                    Text("صنع في العراق", style: TextStyle(fontSize: 9, color: Colors.black26)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DiwanIraqiDev extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F3E6),
      appBar: AppBar(backgroundColor: Color(0xFF121B22), title: Text("المطور العراقي - ما مطروق", style: TextStyle(color: Colors.white, fontSize: 13))),
      body: ListView(
        padding: EdgeInsets.all(14),
        children: [
          Container(
            padding: EdgeInsets.all(18),
            decoration: BoxDecoration(color: Color(0xFF121B22), borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                Container(width: 70, height: 70, decoration: BoxDecoration(color: Color(0xFFD4AF37), shape: BoxShape.circle), child: Icon(Icons.code, size: 35, color: Color(0xFF121B22))),
                SizedBox(height: 10),
                Text("حيدر العراقي", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                Text("مطور ديوان نور القلوب", style: TextStyle(color: Color(0xFFD4AF37), fontSize: 11, fontWeight: FontWeight.bold)),
                SizedBox(height: 6),
                Text("بغداد - العراق - 2026", style: TextStyle(color: Colors.white38, fontSize: 10)),
                SizedBox(height: 10),
                Text("هذا التطبيق ما مطروق - فكرة جديدة كليا - ديوان عراقي يجمع القرآن والختمة والسبحة - صنعته بايدي عراقية خالصة صدقة جارية لروح المرحوم ناصر عزيز الله يرحمه ويجعل مثواه الجنة", textAlign: TextAlign.center, style: TextStyle(color: Colors.white60, fontSize: 11, height: 1.5)),
              ],
            ),
          ),
          SizedBox(height: 12),
          _devCard(Icons.email, "البريد", "ha1224704@gmail.com"),
          _devCard(Icons.flag, "الهوية", "عراقي - بغداد - ابو الخصيب - البصرة"),
          _devCard(Icons.favorite, "الوقف", "صدقة جارية للمرحوم ناصر عزيز - الفاتحة على روحه الطاهرة"),
          _devCard(Icons.code, "التقنية", "Flutter - تصميم ديوان عراقي تراثي - الوان ترابية ذهبية"),
          _devCard(Icons.inventory, "الحزمة", "com.ha1224704.noor.quloob.sadaqa.nasser - اصدار 1.0.0 - ما مطروق"),
          _devCard(Icons.security, "الخصوصية", "لا يجمع اي بيانات - يعمل بدون انترنت - آمن 100%"),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Color(0xFFD4AF37))),
            child: Column(
              children: [
                Text("مميزات النسخة الما مطروقة", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF121B22))),
                SizedBox(height: 6),
                Text("• ديوان بفلترة مكية مدنية طوال قصار\n• ختمة تفاعلية 114 سورة مع حفظ التقدم\n• سبحة ب7 اذكار مع عداد حسنات\n• سرعة صوت 0.75x 1x 1.25x\n• ورد يومي - آية اليوم\n• تصميم تراثي ذهبي اسود - الوان عراقية", style: TextStyle(fontSize: 10, height: 1.6, color: Colors.black87)),
              ],
            ),
          ),
          SizedBox(height: 12),
          Center(child: Text("صنع بكل فخر في العراق - ديوان عراقي اصيل", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF121B22)))),
          Center(child: Text("2026 - حيدر - لا يوجد مثله في المتجر", style: TextStyle(fontSize: 9, color: Colors.black38))),
        ],
      ),
    );
  }
  Widget _devCard(IconData ic, String title, String sub) {
    return Card(
      margin: EdgeInsets.only(bottom: 6),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: Color(0xFF121B22), radius: 16, child: Icon(ic, size: 14, color: Color(0xFFD4AF37))),
        title: Text(title, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
        subtitle: Text(sub, style: TextStyle(fontSize: 10)),
      ),
    );
  }
}