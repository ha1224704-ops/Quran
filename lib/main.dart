import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran/quran.dart' as quran;

void main() => runApp(QuranApp());

class QuranApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String reciterCode = 'Abdul_Basit_Murattal_64kbps';
  Map<String, String> reciters = {
    'عبد الباسط': 'Abdul_Basit_Murattal_64kbps',
    'المنشاوي': 'Minshawy_Murattal_128kbps',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black, centerTitle: true, title: Text('نور القلوب', style: TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold))),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(color: Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(10), border: Border.all(color: Color(0xFFD4AF37))),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: reciterCode,
                dropdownColor: Colors.black,
                isExpanded: true,
                style: TextStyle(color: Colors.white),
                items: reciters.entries.map((e) => DropdownMenuItem(value: e.value, child: Text(e.key))).toList(),
                onChanged: (v) => setState(() => reciterCode = v!),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 114,
              itemBuilder: (c, i) {
                int n = i + 1;
                return ListTile(
                  title: Text(quran.getSurahNameArabic(n), style: TextStyle(color: Colors.white)),
                  trailing: Icon(Icons.play_circle_fill, color: Color(0xFFD4AF37)),
                  onTap: () => Navigator.push(c, MaterialPageRoute(builder: (_) => SurahPage(num: n, reciter: reciterCode))),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SurahPage extends StatefulWidget {
  final int num;
  final String reciter;
  SurahPage({required this.num, required this.reciter});
  @override
  _SurahPageState createState() => _SurahPageState();
}

class _SurahPageState extends State<SurahPage> {
  final player = AudioPlayer();
  int currentAya = 0;

  Future<void> playAll() async {
    try {
      List<AudioSource> sources = [];
      for (int a = 1; a <= quran.getVerseCount(widget.num); a++) {
        String s = widget.num.toString().padLeft(3, '0');
        String ay = a.toString().padLeft(3, '0');
        String url = 'https://everyayah.com/data/${widget.reciter}/$s$ay.mp3';
        sources.add(AudioSource.uri(Uri.parse(url)));
      }
      await player.setAudioSource(ConcatenatingAudioSource(children: sources));
      player.currentIndexStream.listen((index) {
        if (index != null) setState(() => currentAya = index + 1);
      });
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
    return Scaffold(
      backgroundColor: Color(0xFFFDF6E3),
      appBar: AppBar(
        backgroundColor: Color(0xFFFDF6E3),
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(quran.getSurahNameArabic(widget.num), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        actions: [IconButton(icon: Icon(Icons.play_arrow, color: Colors.black), onPressed: playAll)],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: quran.getVerseCount(widget.num) + 1,
        itemBuilder: (c, i) {
          if (i < quran.getVerseCount(widget.num)) {
            int aya = i + 1;
            bool active = currentAya == aya;
            return Container(
              margin: EdgeInsets.only(bottom: 8),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: active ? Color(0xFFD4AF37).withOpacity(0.3) : Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(quran.getVerse(widget.num, aya, verseEndSymbol: true), textAlign: TextAlign.right, style: TextStyle(fontSize: 22, height: 1.8)),
            );
          } else {
            return Container(
              margin: EdgeInsets.only(top: 20),
              padding: EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Color(0xFFD4AF37), width: 2),
              ),
              child: Column(
                children: [
                  Text('الفاتحة الى روح المرحوم', style: TextStyle(color: Color(0xFFD4AF37), fontSize: 14)),
                  SizedBox(height: 6),
                  Text('ناصر عزيز', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  Divider(color: Color(0xFFD4AF37), thickness: 1, height: 24),
                  Text(
                    'بسم الله الرحمن الرحيم\nالحمد لله رب العالمين\nالرحمن الرحيم\nمالك يوم الدين\nاياك نعبد واياك نستعين\nاهدنا الصراط المستقيم\nصراط الذين انعمت عليهم غير المغضوب عليهم ولا الضالين\nآمين',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 18, height: 1.8),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}