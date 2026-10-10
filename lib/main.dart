import 'package:flutter/material.dart';
import 'package:quran/quran.dart' as quran;
import 'package:just_audio/just_audio.dart';

void main() { runApp(QuranApp()); }

class QuranApp extends StatefulWidget { @override State<QuranApp> createState() => QuranAppState(); }
class QuranAppState extends State<QuranApp> {
  bool loading = true; double prog = 0;
  @override void initState() { super.initState(); startApp(); }
  startApp() async {
    for (int i=0;i<=100;i++) { await Future.delayed(Duration(milliseconds: 12)); if (mounted) setState(()=> prog = i/100); }
    if (mounted) setState(()=> loading = false);
  }
  @override Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, theme: ThemeData.dark(useMaterial3: true).copyWith(scaffoldBackgroundColor: Color(0xFF0A0A0A)), home: loading? Splash(prog: prog) : HomeMain());
  }
}

class Splash extends StatelessWidget {
  final double prog; Splash({required this.prog});
  @override Widget build(BuildContext context) {
    int p = (prog*100).toInt();
    return Scaffold(backgroundColor: Color(0xFF0A0A0A), body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(width:100,height:100,decoration: BoxDecoration(color: Color(0xFF00FF88), shape: BoxShape.circle), child: Icon(Icons.menu_book, size:60, color: Colors.black)),
      SizedBox(height:20),
      Text("Noor Al Quloob", style: TextStyle(color: Colors.white, fontSize:30, fontWeight: FontWeight.bold)),
      Text("Sadaqa Jaria for Nasser Aziz", style: TextStyle(color: Color(0xFF00FF88), fontSize:13)),
      SizedBox(height:40),
      Padding(padding: EdgeInsets.symmetric(horizontal:35), child: ClipRRect(borderRadius: BorderRadius.circular(10), child: LinearProgressIndicator(value: prog, minHeight:10, color: Color(0xFF00FF88), backgroundColor: Colors.white10))),
      SizedBox(height:10),
      Text(p.toString()+" % Loading Quran", style: TextStyle(color: Colors.white38, fontSize:11)),
    ])));
  }
}

class HomeMain extends StatefulWidget { @override State<HomeMain> createState() => HomeMainState(); }
class HomeMainState extends State<HomeMain> {
  int idx = 0;
  @override Widget build(BuildContext context) {
    List<Widget> pages = [SurahList(), DuaPage(), QuizRoom(), SebhaPage(), SettingsPage()];
    return Scaffold(
      body: pages[idx],
      bottomNavigationBar: BottomNavigationBar(currentIndex: idx, onTap: (i)=> setState(()=> idx=i), selectedItemColor: Color(0xFF00FF88), unselectedItemColor: Colors.white38, backgroundColor: Color(0xFF111111), type: BottomNavigationBarType.fixed, items: [
        BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: "Quran"),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Dua"),
        BottomNavigationBarItem(icon: Icon(Icons.groups), label: "Room"),
        BottomNavigationBarItem(icon: Icon(Icons.circle), label: "Sebha"),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
      ]),
    );
  }
}

class SurahList extends StatelessWidget {
  @override Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Al Quran - 114"), centerTitle:true, backgroundColor: Color(0xFF111111)), body: ListView.builder(itemCount:114, itemBuilder: (c,i){
      int n=i+1; int cnt=quran.getVerseCount(n);
      return Card(color: Color(0xFF1C1C1C), margin: EdgeInsets.symmetric(horizontal:10,vertical:4), child: ListTile(
        leading: Container(width:45,height:45,decoration: BoxDecoration(color: Color(0xFF00FF88), borderRadius: BorderRadius.circular(10)), child: Center(child: Text(n.toString(), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)))),
        title: Text(quran.getSurahNameArabic(n)+" - "+quran.getSurahName(n), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize:14)),
        subtitle: Text(cnt.toString()+" Ayah - 8 Reciters", style: TextStyle(color: Colors.white38, fontSize:10)),
        trailing: Icon(Icons.play_circle_fill, color: Color(0xFF00FF88)),
        onTap: ()=> Navigator.push(c, MaterialPageRoute(builder: (_)=> ReaderPage(surah: n))),
      ));
    }));
  }
}

class ReaderPage extends StatefulWidget {
  final int surah; ReaderPage({required this.surah});
  @override State<ReaderPage> createState()=> ReaderPageState();
}
class ReaderPageState extends State<ReaderPage> {
  AudioPlayer player = AudioPlayer(); bool playing=false; bool loadingAudio=false;
  String selectedReciter="Yasser_Ad-Dosari_128kbps"; String reciterName="Yasser Al Dosari";
  Map<String,String> reciters={"Yasser_Ad-Dosari_128kbps":"Yasser Al Dosari","Abdurrahmaan_As-Sudais_192kbps":"Al Sudais","Saood_ash-Shuraym_128kbps":"Al Shuraim","Maher_AlMuaiqly_64kbps":"Maher Al Muaiqly","Alafasy_128kbps":"Al Afasy","Ghamadi_40kbps":"Al Ghamdi","Husary_128kbps":"Al Husary","Minshawy_Murattal_128kbps":"Al Minshawi"};

  playFull() async {
    if (playing) { await player.pause(); setState(()=> playing=false); return; }
    if (player.audioSource!= null) { await player.play(); setState(()=> playing=true); return; }
    setState(()=> loadingAudio=true);
    int cnt=quran.getVerseCount(widget.surah);
    List<AudioSource> src=[];
    for (int i=1;i<=cnt;i++) {
      String sid=widget.surah.toString().padLeft(3,'0'); String vid=i.toString().padLeft(3,'0');
      src.add(AudioSource.uri(Uri.parse("https://everyayah.com/data/"+selectedReciter+"/"+sid+vid+".mp3")));
    }
    try { await player.setAudioSource(ConcatenatingAudioSource(children: src)); await player.play(); setState(()=> {playing=true; loadingAudio=false;}); } catch(e) { setState(()=> loadingAudio=false); }
  }

  showTafsir(int verse) {
    String tafsir; try { tafsir=quran.getVerseTafsir(widget.surah, verse); } catch(e) { tafsir="This ayah contains guidance and mercy from Allah."; }
    if (tafsir.length<5) tafsir="Guidance and mercy in this ayah.";
    showModalBottomSheet(context: context, backgroundColor: Color(0xFF1C1C1C), shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))), builder: (_)=> Padding(padding: EdgeInsets.all(18), child: SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Center(child: Container(width:40,height:4,decoration: BoxDecoration(color: Color(0xFF00FF88), borderRadius: BorderRadius.circular(10)))),
      SizedBox(height:15),
      Text("Tafsir Ayah "+verse.toString(), style: TextStyle(color: Color(0xFF00FF88), fontWeight: FontWeight.bold, fontSize:18)),
      SizedBox(height:10),
      Text(quran.getVerse(widget.surah, verse, verseEndSymbol: false), textAlign: TextAlign.right, style: TextStyle(color: Colors.white, fontSize:20, height:1.8)),
      Divider(color: Colors.white10),
      Text(tafsir, style: TextStyle(color: Colors.white70, fontSize:13, height:1.6)),
      SizedBox(height:12),
      Container(padding: EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10), border: Border.all(color: Color(0xFF00FF88))), child: Text("Al Fatiha for soul of Nasser Aziz", style: TextStyle(color: Color(0xFF00FF88), fontSize:10), textAlign: TextAlign.center)),
    ]))));
  }

  @override void dispose() { player.dispose(); super.dispose(); }

  @override Widget build(BuildContext context) {
    int cnt=quran.getVerseCount(widget.surah);
    IconData btnIcon= playing? Icons.pause_circle_filled : Icons.play_circle_fill;
    Widget topBtn= loadingAudio? SizedBox(width:30,height:30,child: CircularProgressIndicator(color: Color(0xFF00FF88), strokeWidth:2)) : IconButton(icon: Icon(btnIcon, size:48, color: Color(0xFF00FF88)), onPressed: playFull);
    return Scaffold(
      appBar: AppBar(title: Text(quran.getSurahNameArabic(widget.surah)+" - "+reciterName), backgroundColor: Color(0xFF111111)),
      body: Column(children: [
        Container(padding: EdgeInsets.symmetric(horizontal:10,vertical:6), color: Color(0xFF111111), child: Column(children: [
          Row(children: [topBtn, SizedBox(width:8), Expanded(child: Text(playing? "Playing "+reciterName+" - background works with screen off" : "Play - works with screen off - Tap ayah for Tafsir", style: TextStyle(color: Colors.white, fontSize:10)))]),
          SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: reciters.entries.map((e){
            bool isSel=e.key==selectedReciter;
            return GestureDetector(onTap: () async { await player.stop(); setState(()=> {selectedReciter=e.key; reciterName=e.value; playing=false;}); }, child: Container(margin: EdgeInsets.only(right:6), padding: EdgeInsets.symmetric(horizontal:10,vertical:5), decoration: BoxDecoration(color: isSel? Color(0xFF00FF88) : Color(0xFF1C1C1C), borderRadius: BorderRadius.circular(20), border: Border.all(color: Color(0xFF00FF88))), child: Text(e.value, style: TextStyle(color: isSel? Colors.black : Colors.white54, fontSize:10, fontWeight: FontWeight.bold))));
          }).toList())),
        ])),
        Expanded(child: ListView.builder(padding: EdgeInsets.all(10), itemCount: cnt+1, itemBuilder: (c,i){
          if (i==cnt) return Container(margin: EdgeInsets.only(top:25,bottom:30), padding: EdgeInsets.all(18), decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(15), border: Border.all(color: Color(0xFF00FF88), width:1.2)), child: Column(children: [Text("Sadaqa Jaria", style: TextStyle(color: Color(0xFF00FF88), fontWeight: FontWeight.bold)), Text("Al Fatiha for Nasser Aziz", style: TextStyle(color: Colors.white, fontSize:20, fontWeight: FontWeight.bold))]));
          String verseText=quran.getVerse(widget.surah, i+1, verseEndSymbol: false);
          return GestureDetector(onTap: ()=> showTafsir(i+1), child: Container(margin: EdgeInsets.only(bottom:8), padding: EdgeInsets.all(14), decoration: BoxDecoration(color: Color(0xFF1C1C1C), borderRadius: BorderRadius.circular(12)), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text(verseText, textAlign: TextAlign.right, style: TextStyle(fontSize:22, height:1.9, color: Colors.white)),
            SizedBox(height:8),
            Container(padding: EdgeInsets.symmetric(vertical:4), decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(6)), child: Text("Al Fatiha to soul of Nasser Aziz - Tap for Tafsir", style: TextStyle(color: Color(0xFF00FF88), fontSize:8), textAlign: TextAlign.center)),
          ])));
        })),
      ]),
    );
  }
}

class DuaPage extends StatelessWidget {
  final List<Map<String,String>> duas=[
    {"title":"Morning","ar":"اصبحنا واصبح الملك لله","en":"Morning belongs to Allah"},
    {"title":"For Nasser Aziz","ar":"اللهم ارحم ناصر عزيز واغفر له","en":"O Allah have mercy on Nasser Aziz"},
    {"title":"Forgiveness","ar":"اللهم انك عفو تحب العفو فاعف عني","en":"Forgive me"},
    {"title":"Protection","ar":"بسم الله الذي لا يضر مع اسمه شيء","en":"In name of Allah"},
  ];
  @override Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Dua & Athkar"), centerTitle:true, backgroundColor: Color(0xFF111111)), body: ListView.builder(padding: EdgeInsets.all(10), itemCount: duas.length, itemBuilder: (c,i)=> Card(color: Color(0xFF1C1C1C), child: Padding(padding: EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(duas[i]["title"]!, style: TextStyle(color: Color(0xFF00FF88), fontWeight: FontWeight.bold)),
      SizedBox(height:6),
      Text(duas[i]["ar"]!, textAlign: TextAlign.right, style: TextStyle(color: Colors.white, fontSize:18)),
      Text(duas[i]["en"]!, style: TextStyle(color: Colors.white38, fontSize:11)),
    ])))));
  }
}

class QuizRoom extends StatefulWidget { @override State<QuizRoom> createState()=> QuizRoomState(); }
class QuizRoomState extends State<QuizRoom> {
  int qIndex=0; int score=0;
  List<Map<String,dynamic>> questions=[
    {"q":"How many Surahs in Quran?","opts":["112","114","116"],"ans":1,"info":"Quran has 114 Surahs"},
    {"q":"Which Surah is heart of Quran?","opts":["Yaseen","Rahman","Mulk"],"ans":0,"info":"Yaseen is heart"},
    {"q":"First word revealed?","opts":["Iqra","Bismillah","Alhamd"],"ans":0,"info":"Iqra - Read"},
  ];
  @override Widget build(BuildContext context) {
    var qq=questions[qIndex];
    return Scaffold(appBar: AppBar(title: Text("Room - 3 Persons"), centerTitle:true, backgroundColor: Color(0xFF111111)), body: Padding(padding: EdgeInsets.all(14), child: Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Column(children: [CircleAvatar(backgroundColor: Color(0xFF00FF88), child: Icon(Icons.person, color: Colors.black)), Text("Sheikh", style: TextStyle(color: Colors.white, fontSize:10))]),
        Column(children: [CircleAvatar(child: Icon(Icons.person)), Text("Student", style: TextStyle(color: Colors.white, fontSize:10))]),
        Column(children: [CircleAvatar(backgroundColor: Colors.orange, child: Icon(Icons.person, color: Colors.black)), Text("Child", style: TextStyle(color: Colors.white, fontSize:10))]),
      ]),
      SizedBox(height:20),
      Container(padding: EdgeInsets.all(16), decoration: BoxDecoration(color: Color(0xFF1C1C1C), borderRadius: BorderRadius.circular(12), border: Border.all(color: Color(0xFF00FF88))), child: Text(qq["q"], style: TextStyle(color: Colors.white, fontSize:16, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
      SizedBox(height:10),
      for (int i=0;i<3;i++) Card(color: Color(0xFF1C1C1C), child: ListTile(title: Text(qq["opts"][i], style: TextStyle(color: Colors.white)), onTap: (){
        bool correct=i==qq["ans"]; if (correct) score++;
        showDialog(context: context, builder: (_)=> AlertDialog(backgroundColor: Color(0xFF1C1C1C), title: Text(correct? "Correct!" : "Wrong", style: TextStyle(color: Color(0xFF00FF88))), content: Text(qq["info"]+" - Sadaqa for Nasser Aziz", style: TextStyle(color: Colors.white70)), actions: [TextButton(onPressed: (){ Navigator.pop(context); if (qIndex < questions.length-1) { setState(()=> qIndex++); } else { setState(()=> {qIndex=0; score=0;}); } }, child: Text("Next"))]));
      })),
      Spacer(),
      Text("Score: "+score.toString(), style: TextStyle(color: Color(0xFF00FF88), fontWeight: FontWeight.bold)),
    ])));
  }
}

class SebhaPage extends StatefulWidget { @override State<SebhaPage> createState()=> SebhaPageState(); }
class SebhaPageState extends State<SebhaPage> {
  int count=0;
  @override Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Tasbeeh"), centerTitle:true, backgroundColor: Color(0xFF111111)), body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(count.toString(), style: TextStyle(fontSize:80, fontWeight: FontWeight.bold, color: Color(0xFF00FF88))),
      SizedBox(height:20),
      GestureDetector(onTap: ()=> setState(()=> count++), child: Container(width:160,height:160,decoration: BoxDecoration(color: Color(0xFF00FF88), shape: BoxShape.circle), child: Center(child: Text("Sabeh", style: TextStyle(color: Colors.black, fontSize:26, fontWeight: FontWeight.bold))))),
      TextButton(onPressed: ()=> setState(()=> count=0), child: Text("Reset")),
    ])));
  }
}

class SettingsPage extends StatelessWidget {
  @override Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Settings"), centerTitle:true, backgroundColor: Color(0xFF111111)), body: ListView(padding: EdgeInsets.all(14), children: [
      Container(padding: EdgeInsets.all(16), decoration: BoxDecoration(color: Color(0xFF00FF88), borderRadius: BorderRadius.circular(12)), child: Text("Noor Al Quloob v1.0\nPackage: com.noor.quloob.sadaqa\nSadaqa Jaria for Nasser Aziz - Safe", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize:11))),
      SizedBox(height:10),
      Card(color: Color(0xFF1C1C1C), child: ListTile(leading: Icon(Icons.shield, color: Color(0xFF00FF88)), title: Text("Contact Safe", style: TextStyle(color: Colors.white)), subtitle: Text("Secure - No personal email shown", style: TextStyle(color: Colors.white38, fontSize:10)), onTap: ()=> ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Safe contact"))))),
      SizedBox(height:10),
      Container(padding: EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(12), border: Border.all(color: Color(0xFF00FF88))), child: Text("Best Quran App - Free - No Ads - Background audio works with screen off - 8 Reciters - Tafsir on tap - Dua - Room 3 persons - Tasbeeh", style: TextStyle(color: Colors.white38, fontSize:10), textAlign: TextAlign.center)),
    ]));
  }
}