import 'package:flutter/material.dart';
import 'package:quran/quran.dart' as quran;
import 'package:just_audio/just_audio.dart';
import 'package:flutter/services.dart';

void main() { runApp(NoorIraqiApp()); }

class NoorIraqiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: SplashIraqi());
  }
}

class SplashIraqi extends StatefulWidget {
  @override
  State<SplashIraqi> createState() => SplashIraqiState();
}

class SplashIraqiState extends State<SplashIraqi> {
  double p = 0;
  @override
  void initState() { super.initState(); start(); }
  start() async {
    for (int i = 0; i <= 100; i++) {
      await Future.delayed(Duration(milliseconds: 20));
      setState(() { p = i / 100; });
    }
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => MainIraqi()));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0B3D2E),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(width: 100, height: 100, decoration: BoxDecoration(color: Color(0xFFE8C86A), shape: BoxShape.circle), child: Icon(Icons.mosque, size: 60, color: Color(0xFF0B3D2E))),
            SizedBox(height: 14),
            Text("نور الآيات", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
            Text("النسخة العراقية الفاخرة", style: TextStyle(color: Color(0xFFE8C86A), fontSize: 13, fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text("صدقة جارية لروح المرحوم", style: TextStyle(color: Colors.white60, fontSize: 11)),
            Text("ناصر عزيز - رحمه الله", style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
            SizedBox(height: 25),
            Padding(padding: EdgeInsets.symmetric(horizontal: 70), child: LinearProgressIndicator(value: p, color: Color(0xFFE8C86A), backgroundColor: Colors.white12)),
            SizedBox(height: 8),
            Text("${(p*100).toInt()}% يحمل...", style: TextStyle(color: Colors.white38, fontSize: 10)),
            SizedBox(height: 25),
            Container(padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(20)), child: Text("صنع بكل فخر في العراق - حيدر", style: TextStyle(color: Colors.white24, fontSize: 9))),
          ],
        ),
      ),
    );
  }
}

class MainIraqi extends StatefulWidget {
  @override
  State<MainIraqi> createState() => MainIraqiState();
}

class MainIraqiState extends State<MainIraqi> {
  int tab = 0;
  @override
  Widget build(BuildContext context) {
    Widget page;
    if (tab == 0) page = QuranIraqi();
    else if (tab == 1) page = AzkarIraqi();
    else if (tab == 2) page = SebhaIraqi();
    else if (tab == 3) page = QiblaIraqi();
    else page = DevIraqiPage();
    return Scaffold(
      body: page,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: tab,
        onTap: (i) { setState(() { tab = i; }); },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xFF0B3D2E),
        unselectedItemColor: Colors.black38,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: "القرآن"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "اذكار"),
          BottomNavigationBarItem(icon: Icon(Icons.circle), label: "سبحة"),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: "القبلة"),
          BottomNavigationBarItem(icon: Icon(Icons.flag), label: "المطور"),
        ],
      ),
    );
  }
}

// ========== قرآن عراقي مع بحث و آية اليوم ==========
class QuranIraqi extends StatefulWidget {
  @override
  State<QuranIraqi> createState() => QuranIraqiState();
}

class QuranIraqiState extends State<QuranIraqi> {
  String search = "";
  @override
  Widget build(BuildContext context) {
    String dailyVerse = quran.getVerse(2, 255, verseEndSymbol: false);
    return Scaffold(
      backgroundColor: Color(0xFFFEF9EF),
      appBar: AppBar(backgroundColor: Color(0xFF0B3D2E), title: Text("القرآن الكريم - عراقي", style: TextStyle(color: Colors.white, fontSize: 15))),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(12),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(color: Color(0xFF0B3D2E), borderRadius: BorderRadius.circular(14)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [Icon(Icons.auto_awesome, color: Color(0xFFE8C86A), size: 16), SizedBox(width: 6), Text("آية اليوم", style: TextStyle(color: Color(0xFFE8C86A), fontSize: 11, fontWeight: FontWeight.bold))]),
                SizedBox(height: 6),
                Text(dailyVerse, textAlign: TextAlign.right, style: TextStyle(color: Colors.white, fontSize: 12, height: 1.5)),
                SizedBox(height: 4),
                Text("سورة البقرة - 255 - آية الكرسي", style: TextStyle(color: Colors.white38, fontSize: 9)),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: TextField(
              decoration: InputDecoration(hintText: "ابحث عن سورة...", prefixIcon: Icon(Icons.search, size: 18), filled: true, fillColor: Colors.white, contentPadding: EdgeInsets.symmetric(vertical: 8), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
              onChanged: (v) { setState(() { search = v; }); },
            ),
          ),
          SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: 114,
              itemBuilder: (c, i) {
                int n = i + 1;
                String name = quran.getSurahNameArabic(n);
                String en = quran.getSurahName(n);
                if (search.isNotEmpty) {
                  if (!name.contains(search) &&!en.toLowerCase().contains(search.toLowerCase())) return SizedBox();
                }
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                  child: ListTile(
                    leading: CircleAvatar(backgroundColor: Color(0xFF0B3D2E), radius: 15, child: Text("$n", style: TextStyle(color: Colors.white, fontSize: 10))),
                    title: Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    subtitle: Text("$en - ${quran.getVerseCount(n)} آية - ${quran.getPlaceOfRevelation(n) == "Makkah"? "مكية" : "مدنية"}", style: TextStyle(fontSize: 9, color: Colors.black45)),
                    trailing: Icon(Icons.arrow_forward_ios, size: 10),
                    onTap: () { Navigator.push(context, MaterialPageRoute(builder: (x) => SurahIraqiView(num: n))); },
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

class SurahIraqiView extends StatefulWidget {
  final int num;
  SurahIraqiView({required this.num});
  @override
  State<SurahIraqiView> createState() => SurahIraqiViewState();
}

class SurahIraqiViewState extends State<SurahIraqiView> {
  AudioPlayer player = AudioPlayer();
  int cur = 0;
  play(int ayah) async {
    setState(() { cur = ayah; });
    String s = widget.num.toString().padLeft(3, '0');
    String v = ayah.toString().padLeft(3, '0');
    String url = "https://everyayah.com/data/Yasser_Ad-Dosari_128kbps/${s}${v}.mp3";
    try { await player.setUrl(url); await player.play(); } catch (e) {}
  }
  @override
  void dispose() { player.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    int total = quran.getVerseCount(widget.num);
    String name = quran.getSurahNameArabic(widget.num);
    return Scaffold(
      backgroundColor: Color(0xFFFEF9EF),
      appBar: AppBar(backgroundColor: Color(0xFF0B3D2E), title: Text(name, style: TextStyle(color: Colors.white))),
      body: ListView.builder(
        itemCount: total + 1,
        itemBuilder: (c, i) {
          if (i == total) {
            return Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(18),
              decoration: BoxDecoration(color: Color(0xFF0B3D2E), borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  Icon(Icons.favorite, color: Color(0xFFE8C86A)),
                  SizedBox(height: 8),
                  Text("صدقة جارية", style: TextStyle(color: Color(0xFFE8C86A), fontWeight: FontWeight.bold)),
                  SizedBox(height: 6),
                  Text("الفاتحة الى روح المرحوم", style: TextStyle(color: Colors.white70, fontSize: 12)),
                  Text("ناصر عزيز", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text("اللهم ارحمه واغفر له واجعل قبره روضة من رياض الجنة ونقه من الذنوب كما ينقى الثوب الابيض من الدنس", textAlign: TextAlign.center, style: TextStyle(color: Colors.white60, fontSize: 11, height: 1.4)),
                  SizedBox(height: 10),
                  Container(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(20)), child: Text("من العراق - حيدر - اهداء خاص", style: TextStyle(color: Colors.white24, fontSize: 8))),
                ],
              ),
            );
          }
          int ayah = i + 1;
          String verse = quran.getVerse(widget.num, ayah, verseEndSymbol: false);
          bool active = cur == ayah;
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(color: active? Color(0xFFE8F5E9) : Colors.white, borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              leading: CircleAvatar(radius: 11, backgroundColor: active? Color(0xFF0B3D2E) : Colors.black26, child: Text("$ayah", style: TextStyle(fontSize: 8, color: Colors.white))),
              title: Text(verse, textAlign: TextAlign.right, style: TextStyle(fontSize: 15, height: 1.6)),
              trailing: IconButton(icon: Icon(active? Icons.pause_circle_filled : Icons.play_circle_outline, color: Color(0xFF0B3D2E)), onPressed: () { play(ayah); }),
              onLongPress: () { Clipboard.setData(ClipboardData(text: verse)); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("تم نسخ الآية"))); },
            ),
          );
        },
      ),
    );
  }
}

class AzkarIraqi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFEF9EF),
      appBar: AppBar(backgroundColor: Color(0xFF0B3D2E), title: Text("الاذكار العراقية", style: TextStyle(color: Colors.white))),
      body: ListView(
        padding: EdgeInsets.all(12),
        children: [
          Card(child: ListTile(leading: Icon(Icons.wb_sunny, color: Colors.orange), title: Text("اذكار الصباح"), subtitle: Text("اصبحنا واصبح الملك لله والحمد لله"))),
          Card(child: ListTile(leading: Icon(Icons.nightlight, color: Colors.indigo), title: Text("اذكار المساء"), subtitle: Text("امسينا وامسى الملك لله والحمد لله"))),
          Card(color: Color(0xFF0B3D2E), child: ListTile(leading: Icon(Icons.favorite, color: Color(0xFFE8C86A)), title: Text("دعاء للمرحوم ناصر عزيز", style: TextStyle(color: Color(0xFFE8C86A), fontWeight: FontWeight.bold)), subtitle: Text("اللهم ارحم ناصر عزيز واغفر له واجعل قبره روضة من رياض الجنة اللهم نقه من الخطايا كما ينقى الثوب الابيض من الدنس", style: TextStyle(color: Colors.white70, fontSize: 11)))),
          Card(child: ListTile(leading: Icon(Icons.flag, color: Colors.green), title: Text("دعاء للعراق"), subtitle: Text("اللهم احفظ العراق واهله وشعبه من كل سوء"))),
          Card(child: ListTile(leading: Icon(Icons.self_improvement), title: Text("استغفار"), subtitle: Text("استغفر الله العظيم واتوب اليه - 100 مرة"))),
          Card(child: ListTile(leading: Icon(Icons.mosque), title: Text("الصلاة على النبي"), subtitle: Text("اللهم صل على محمد وآل محمد"))),
          Card(child: ListTile(leading: Icon(Icons.volunteer_activism), title: Text("دعاء الرزق"), subtitle: Text("اللهم ارزقنا رزقا حلالا طيبا مباركا فيه"))),
        ],
      ),
    );
  }
}

class SebhaIraqi extends StatefulWidget {
  @override
  State<SebhaIraqi> createState() => SebhaIraqiState();
}

class SebhaIraqiState extends State<SebhaIraqi> {
  int count = 0;
  int totalHasant = 0;
  String zikr = "سبحان الله";
  List<String> list = ["سبحان الله", "الحمد لله", "الله اكبر", "استغفر الله", "لا اله الا الله", "اللهم صل على محمد"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFEF9EF),
      appBar: AppBar(backgroundColor: Color(0xFF0B3D2E), title: Text("السبحة العراقية", style: TextStyle(color: Colors.white))),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(12),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(color: Color(0xFF0B3D2E), borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("عداد الحسنات", style: TextStyle(color: Color(0xFFE8C86A), fontSize: 10)), Text("$totalHasant حسنة", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]),
                Spacer(),
                Text("لروح ناصر عزيز", style: TextStyle(color: Colors.white54, fontSize: 10)),
              ],
            ),
          ),
          Container(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 12),
              itemCount: list.length,
              itemBuilder: (c,i) {
                bool sel = list[i] == zikr;
                return GestureDetector(
                  onTap: () { setState(() { zikr = list[i]; count = 0; }); },
                  child: Container(margin: EdgeInsets.only(right: 6), padding: EdgeInsets.symmetric(horizontal: 14), decoration: BoxDecoration(color: sel? Color(0xFF0B3D2E) : Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Color(0xFF0B3D2E))), child: Center(child: Text(list[i], style: TextStyle(color: sel? Colors.white : Color(0xFF0B3D2E), fontSize: 11)))),
                );
              },
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(zikr, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0B3D2E))),
                  SizedBox(height: 10),
                  Text("$count / 33", style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: Color(0xFF0B3D2E))),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        count++;
                        totalHasant++;
                        if (count >= 33) count = 0;
                      });
                    },
                    child: Container(width: 170, height: 170, decoration: BoxDecoration(color: Color(0xFF0B3D2E), shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)]), child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.touch_app, color: Colors.white30), Text("سبح", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold))]))),
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(onPressed: () { setState(() { count = 0; }); }, child: Text("تصفير")),
                      SizedBox(width: 10),
                      Text("كل تسبيحة صدقة لناصر", style: TextStyle(fontSize: 9, color: Colors.black26)),
                    ],
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

class QiblaIraqi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFEF9EF),
      appBar: AppBar(backgroundColor: Color(0xFF0B3D2E), title: Text("القبلة والمواقيت - عراقي", style: TextStyle(color: Colors.white, fontSize: 14))),
      body: ListView(
        padding: EdgeInsets.all(14),
        children: [
          Container(
            padding: EdgeInsets.all(18),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Color(0xFF0B3D2E))),
            child: Column(
              children: [
                Icon(Icons.explore, size: 60, color: Color(0xFF0B3D2E)),
                SizedBox(height: 8),
                Text("اتجاه القبلة من العراق", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("200° جنوب غرب", style: TextStyle(color: Color(0xFFE8C86A), fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 8),
                Text("ضع الهاتف مسطح واتجه للسهم", style: TextStyle(fontSize: 10, color: Colors.black45)),
              ],
            ),
          ),
          SizedBox(height: 12),
          Text("مواقيت الصلاة - 6 محافظات عراقية", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          SizedBox(height: 8),
          Card(child: ListTile(leading: Icon(Icons.location_on, color: Color(0xFF0B3D2E)), title: Text("بغداد", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)), subtitle: Text("فجر 04:22 - ظهر 12:05 - عصر 15:30 - مغرب 18:35 - عشاء 20:00", style: TextStyle(fontSize: 10)))),
          Card(child: ListTile(leading: Icon(Icons.location_on), title: Text("البصرة", style: TextStyle(fontSize: 12)), subtitle: Text("فجر 04:10 - ظهر 11:58 - عصر 15:25 - مغرب 18:28 - عشاء 19:50", style: TextStyle(fontSize: 10)))),
          Card(child: ListTile(leading: Icon(Icons.location_on), title: Text("الموصل", style: TextStyle(fontSize: 12)), subtitle: Text("فجر 04:30 - ظهر 12:12 - عصر 15:40 - مغرب 18:45 - عشاء 20:10", style: TextStyle(fontSize: 10)))),
          Card(child: ListTile(leading: Icon(Icons.location_on), title: Text("اربيل", style: TextStyle(fontSize: 12)), subtitle: Text("فجر 04:32 - ظهر 12:14 - عصر 15:42 - مغرب 18:47 - عشاء 20:12", style: TextStyle(fontSize: 10)))),
          Card(child: ListTile(leading: Icon(Icons.location_on), title: Text("النجف", style: TextStyle(fontSize: 12)), subtitle: Text("فجر 04:20 - ظهر 12:04 - عصر 15:29 - مغرب 18:33 - عشاء 19:58", style: TextStyle(fontSize: 10)))),
          Card(child: ListTile(leading: Icon(Icons.location_on), title: Text("كربلاء", style: TextStyle(fontSize: 12)), subtitle: Text("فجر 04:21 - ظهر 12:04 - عصر 15:30 - مغرب 18:34 - عشاء 19:59", style: TextStyle(fontSize: 10)))),
        ],
      ),
    );
  }
}

class AllahNamesPage extends StatelessWidget {
  final List<String> names = ["الرحمن","الرحيم","الملك","القدوس","السلام","المؤمن","المهيمن","العزيز","الجبار","المتكبر","الخالق","البارئ","المصور","الغفار","القهار","الوهاب","الرزاق","الفتاح","العليم","القابض","الباسط","الخافض","الرافع","المعز","المذل","السميع","البصير","الحكم","العدل","اللطيف","الخبير","الحليم","العظيم","الغفور","الشكور","العلي","الكبير","الحفيظ","المقيت","الحسيب","الجليل","الكريم","الرقيب","المجيب","الواسع","الحكيم","الودود","المجيد","الباعث","الشهيد","الحق","الوكيل","القوي","المتين","الولي","الحميد","المحصي","المبدئ","المعيد","المحيي","المميت","الحي","القيوم","الواجد","الماجد","الواحد","الصمد","القادر","المقتدر","المقدم","المؤخر","الاول","الاخر","الظاهر","الباطن","الوالي","المتعالي","البر","التواب","المنتقم","العفو","الرؤوف","مالك الملك","ذو الجلال والاكرام","المقسط","الجامع","الغني","المغني","المانع","الضار","النافع","النور","الهادي","البديع","الباقي","الوارث","الرشيد","الصبور"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Color(0xFF0B3D2E), title: Text("اسماء الله الحسنى - 99", style: TextStyle(color: Colors.white, fontSize: 14))),
      body: GridView.builder(
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 1.5),
        itemCount: names.length,
        itemBuilder: (c,i) {
          return Card(color: Color(0xFF0B3D2E), child: Center(child: Text(names[i], style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))));
        },
      ),
    );
  }
}

class DevIraqiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFEF9EF),
      appBar: AppBar(backgroundColor: Color(0xFF0B3D2E), title: Text("المطور العراقي", style: TextStyle(color: Colors.white))),
      body: ListView(
        padding: EdgeInsets.all(14),
        children: [
          Container(
            padding: EdgeInsets.all(18),
            decoration: BoxDecoration(color: Color(0xFF0B3D2E), borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                CircleAvatar(radius: 35, backgroundColor: Color(0xFFE8C86A), child: Icon(Icons.person, size: 40, color: Color(0xFF0B3D2E))),
                SizedBox(height: 10),
                Text("حيدر", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                Text("مطور تطبيقات عراقي", style: TextStyle(color: Color(0xFFE8C86A), fontSize: 12)),
                SizedBox(height: 8),
                Container(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(20)), child: Text("العراق - بغداد", style: TextStyle(color: Colors.white70, fontSize: 10))),
                SizedBox(height: 10),
                Text("هذا التطبيق صدقة جارية لروح المرحوم ناصر عزيز اسأل الله ان يجعله في ميزان حسناته", textAlign: TextAlign.center, style: TextStyle(color: Colors.white60, fontSize: 11, height: 1.4)),
              ],
            ),
          ),
          SizedBox(height: 12),
          Card(child: ListTile(leading: Icon(Icons.email, color: Color(0xFF0B3D2E)), title: Text("البريد الالكتروني", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)), subtitle: Text("ha1224704@gmail.com", style: TextStyle(fontSize: 11)))),
          Card(child: ListTile(leading: Icon(Icons.flag, color: Colors.green), title: Text("الجنسية", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)), subtitle: Text("عراقي - من بغداد الحبيبة", style: TextStyle(fontSize: 11)))),
          Card(child: ListTile(leading: Icon(Icons.code, color: Color(0xFF0B3D2E)), title: Text("الاختصاص", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)), subtitle: Text("مطور Flutter - تطبيقات اسلامية عراقية", style: TextStyle(fontSize: 11)))),
          Card(child: ListTile(leading: Icon(Icons.favorite, color: Colors.red), title: Text("الهدف من التطبيق", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)), subtitle: Text("صدقة جارية للمرحوم ناصر عزيز - الله يرحمه ويغفر له", style: TextStyle(fontSize: 11)))),
          Card(
            child: ListTile(
              leading: Icon(Icons.grid_view, color: Color(0xFF0B3D2E)),
              title: Text("اسماء الله الحسنى", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              subtitle: Text("99 اسم مع عرض عراقي"),
              trailing: Icon(Icons.arrow_forward_ios, size: 12),
              onTap: () { Navigator.push(context, MaterialPageRoute(builder: (c) => AllahNamesPage())); },
            ),
          ),
          Card(child: ListTile(leading: Icon(Icons.info), title: Text("اسم الحزمة", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)), subtitle: Text("com.ha1224704.noor.quloob.sadaqa.nasser", style: TextStyle(fontSize: 9)))),
          Card(child: ListTile(leading: Icon(Icons.security), title: Text("الخصوصية", style: TextStyle(fontSize: 12)), subtitle: Text("التطبيق لا يجمع اي بيانات - آمن 100% - صنع في العراق", style: TextStyle(fontSize: 10)))),
          SizedBox(height: 10),
          Center(child: Text("صنع بكل فخر في العراق", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0B3D2E)))),
          Center(child: Text("2026 - جميع الحقوق محفوظة - حيدر العراقي", style: TextStyle(fontSize: 9, color: Colors.black38))),
          SizedBox(height: 6),
          Center(child: Text("8 قراء - 114 سورة - يعمل بدون انترنت للقراءة", style: TextStyle(fontSize: 8, color: Colors.black26))),
        ],
      ),
    );
  }
}