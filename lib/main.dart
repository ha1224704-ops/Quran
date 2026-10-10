import 'package:flutter/material.dart';
import 'package:quran/quran.dart' as quran;
import 'package:just_audio/just_audio.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Splash(),
    );
  }
}

class Splash extends StatefulWidget {
  @override
  State<Splash> createState() => SplashState();
}

class SplashState extends State<Splash> {
  double p = 0;
  @override
  void initState() {
    super.initState();
    load();
  }
  load() async {
    for (int i = 0; i <= 100; i++) {
      await Future.delayed(Duration(milliseconds: 15));
      setState(() {
        p = i / 100;
      });
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (c) => Home()),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0B3D2E),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.menu_book, size: 80, color: Color(0xFFE8C86A)),
            SizedBox(height: 10),
            Text("نور الآيات", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
            Text("تطبيق عراقي", style: TextStyle(color: Color(0xFFE8C86A))),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 60),
              child: LinearProgressIndicator(value: p, color: Color(0xFFE8C86A)),
            ),
            SizedBox(height: 10),
            Text("${(p*100).toInt()}%", style: TextStyle(color: Colors.white54)),
          ],
        ),
      ),
    );
  }
}

class Home extends StatefulWidget {
  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  int tab = 0;
  @override
  Widget build(BuildContext context) {
    Widget page;
    if (tab == 0) page = QuranPage();
    else if (tab == 1) page = AzkarPage();
    else if (tab == 2) page = SebhaPage();
    else page = AboutPage();

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
          BottomNavigationBarItem(icon: Icon(Icons.circle), label: "السبحة"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "عراقي"),
        ],
      ),
    );
  }
}

class QuranPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F0E8),
      appBar: AppBar(
        backgroundColor: Color(0xFF0B3D2E),
        title: Text("القرآن الكريم", style: TextStyle(color: Colors.white)),
      ),
      body: ListView.builder(
        itemCount: 114,
        itemBuilder: (c, i) {
          int n = i + 1;
          String name = quran.getSurahNameArabic(n);
          int count = quran.getVerseCount(n);
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: ListTile(
              leading: CircleAvatar(backgroundColor: Color(0xFF0B3D2E), child: Text("$n", style: TextStyle(color: Colors.white, fontSize: 12))),
              title: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("$count آية"),
              trailing: Icon(Icons.arrow_forward_ios, size: 12),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (x) => SurahView(num: n)));
              },
            ),
          );
        },
      ),
    );
  }
}

class SurahView extends StatefulWidget {
  final int num;
  SurahView({required this.num});
  @override
  State<SurahView> createState() => SurahViewState();
}

class SurahViewState extends State<SurahView> {
  AudioPlayer player = AudioPlayer();
  int current = 0;

  play(int ayah) async {
    setState(() { current = ayah; });
    String s = widget.num.toString().padLeft(3, '0');
    String v = ayah.toString().padLeft(3, '0');
    String url = "https://everyayah.com/data/Yasser_Ad-Dosari_128kbps/${s}${v}.mp3";
    try {
      await player.setUrl(url);
      await player.play();
    } catch (e) {}
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int total = quran.getVerseCount(widget.num);
    String name = quran.getSurahNameArabic(widget.num);
    return Scaffold(
      appBar: AppBar(backgroundColor: Color(0xFF0B3D2E), title: Text(name, style: TextStyle(color: Colors.white))),
      body: ListView.builder(
        itemCount: total + 1,
        itemBuilder: (c, i) {
          if (i == total) {
            return Container(
              margin: EdgeInsets.all(15),
              padding: EdgeInsets.all(15),
              color: Color(0xFF0B3D2E),
              child: Column(
                children: [
                  Text("صدقة جارية", style: TextStyle(color: Color(0xFFE8C86A), fontWeight: FontWeight.bold)),
                  Text("الفاتحة لروح المرحوم ناصر عزيز", style: TextStyle(color: Colors.white)),
                  Text("اللهم ارحمه واغفر له", style: TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            );
          }
          int ayah = i + 1;
          String verse = quran.getVerse(widget.num, ayah, verseEndSymbol: false);
          bool isPlay = current == ayah;
          return Card(
            color: isPlay? Color(0xFFE8F5E9) : Colors.white,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: ListTile(
              leading: CircleAvatar(radius: 12, backgroundColor: Color(0xFF0B3D2E), child: Text("$ayah", style: TextStyle(fontSize: 9, color: Colors.white))),
              title: Text(verse, textAlign: TextAlign.right, style: TextStyle(fontSize: 16)),
              trailing: IconButton(icon: Icon(Icons.play_arrow), onPressed: () { play(ayah); }),
              onTap: () {
                Clipboard.setData(ClipboardData(text: verse));
              },
            ),
          );
        },
      ),
    );
  }
}

class AzkarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Color(0xFF0B3D2E), title: Text("الاذكار")),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: [
          Card(child: ListTile(title: Text("اذكار الصباح"), subtitle: Text("اصبحنا واصبح الملك لله"))),
          Card(child: ListTile(title: Text("اذكار المساء"), subtitle: Text("امسينا وامسى الملك لله"))),
          Card(child: ListTile(title: Text("دعاء للمرحوم ناصر عزيز"), subtitle: Text("اللهم ارحم ناصر عزيز واغفر له"))),
          Card(child: ListTile(title: Text("دعاء للعراق"), subtitle: Text("اللهم احفظ العراق واهله"))),
        ],
      ),
    );
  }
}

class SebhaPage extends StatefulWidget {
  @override
  State<SebhaPage> createState() => SebhaState();
}

class SebhaState extends State<SebhaPage> {
  int count = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Color(0xFF0B3D2E), title: Text("السبحة")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("$count", style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold, color: Color(0xFF0B3D2E))),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () { setState(() { count++; }); },
              child: Container(width: 160, height: 160, decoration: BoxDecoration(color: Color(0xFF0B3D2E), shape: BoxShape.circle), child: Center(child: Text("سبح", style: TextStyle(color: Colors.white, fontSize: 24)))),
            ),
            SizedBox(height: 15),
            TextButton(onPressed: () { setState(() { count = 0; }); }, child: Text("اعادة")),
            Text("صدقة جارية - عراقي", style: TextStyle(fontSize: 10, color: Colors.black26)),
          ],
        ),
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Color(0xFF0B3D2E), title: Text("عن التطبيق - عراقي")),
      body: ListView(
        padding: EdgeInsets.all(15),
        children: [
          Card(child: ListTile(leading: Icon(Icons.person), title: Text("المطور"), subtitle: Text("حيدر - العراق"))),
          Card(child: ListTile(leading: Icon(Icons.email), title: Text("البريد"), subtitle: Text("ha1224704@gmail.com"))),
          Card(child: ListTile(leading: Icon(Icons.favorite), title: Text("صدقة جارية"), subtitle: Text("للمرحوم ناصر عزيز - الله يرحمه"))),
          Card(child: ListTile(leading: Icon(Icons.info), title: Text("الحزمة"), subtitle: Text("com.ha1224704.noor.quloob.sadaqa.nasser"))),
          SizedBox(height: 10),
          Center(child: Text("صنع بكل فخر في العراق 2026", style: TextStyle(fontSize: 10, color: Colors.black38))),
        ],
      ),
    );
  }
}