import 'package:flutter/material.dart';
import 'package:quran/quran.dart' as quran;
import 'package:just_audio/just_audio.dart';
import 'package:flutter/services.dart';

void main() => runApp(const MyApp());
class MyApp extends StatelessWidget{const MyApp({super.key});@override Widget build(BuildContext c)=>const MaterialApp(debugShowCheckedModeBanner:false,home:SplashPage());}
class SplashPage extends StatefulWidget{const SplashPage({super.key});@override State<SplashPage> createState()=>_S();}
class _S extends State<SplashPage>{double p=0;@override void initState(){super.initState();_l();}Future<void>_l()async{for(int i=0;i<=100;i++){await Future.delayed(const Duration(milliseconds:16));if(!mounted)return;setState(()=>p=i/100);}Navigator.pushReplacement(context,MaterialPageRoute(builder:(_)=>const Tabs()));}@override Widget build(BuildContext c){return Scaffold(backgroundColor:const Color(0xFF0B3D2E),body:Center(child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[Container(width:90,height:90,decoration:BoxDecoration(color:const Color(0xFFE8C86A),borderRadius:BorderRadius.circular(22)),child:const Icon(Icons.mosque,size:48,color:Color(0xFF0B3D2E))),const Text("نور القلوب",style:TextStyle(color:Colors.white,fontSize:26,fontWeight:FontWeight.bold)),const Text("صدقة جارية لناصر عزيز",style:TextStyle(color:Color(0xFFE8C86A))),SizedBox(width:170,child:LinearProgressIndicator(value:p,color:const Color(0xFFE8C86A),backgroundColor:Colors.white12))])));}}
class Tabs extends StatefulWidget{const Tabs({super.key});@override State<Tabs> createState()=>_T();}
class _T extends State<Tabs>{int i=0;final pages=[const QuranList(),const Azkar(),const Sebha(),const Nasser(),const About()];@override Widget build(BuildContext c){return Scaffold(body:pages[i],bottomNavigationBar:BottomNavigationBar(currentIndex:i,onTap:(v)=>setState(()=>i=v),type:BottomNavigationBarType.fixed,selectedItemColor:const Color(0xFF0B3D2E),items:const[BottomNavigationBarItem(icon:Icon(Icons.menu_book),label:"القرآن"),BottomNavigationBarItem(icon:Icon(Icons.favorite),label:"أذكار"),BottomNavigationBarItem(icon:Icon(Icons.circle),label:"سبحة"),BottomNavigationBarItem(icon:Icon(Icons.volunteer_activism),label:"ناصر"),BottomNavigationBarItem(icon:Icon(Icons.flag),label:"عراقي")]));}}
class QuranList extends StatelessWidget{const QuranList({super.key});@override Widget build(BuildContext c){return Scaffold(backgroundColor:const Color(0xFFFEF9EF),appBar:AppBar(backgroundColor:const Color(0xFF0B3D2E),title:const Text("القرآن - 10 قراء عراقي وأكثر",style:TextStyle(color:Colors.white,fontSize:12))),body:ListView.builder(itemCount:114,itemBuilder:(c,idx){int n=idx+1;return Card(margin:const EdgeInsets.symmetric(horizontal:10,vertical:3),child:ListTile(leading:CircleAvatar(backgroundColor:const Color(0xFF0B3D2E),radius:16,child:Text("$n",style:const TextStyle(color:Colors.white,fontSize:10))),title:Text(quran.getSurahNameArabic(n),style:const TextStyle(fontWeight:FontWeight.bold)),subtitle:Text("${quran.getSurahName(n)}",style:const TextStyle(fontSize:10)),onTap:()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>SurahView(num:n)))));}));}}

class SurahView extends StatefulWidget{final int num;const SurahView({super.key,required this.num});@override State<SurahView> createState()=>_SV();}
class _SV extends State<SurahView>{
  final player=AudioPlayer();
  int cur=0;
  String sel="Yasser_Ad-Dosari_128kbps";

  // 10 قراء - التركيز عراقي
  final reciters=[
    {"name":"🇮🇶 عامر الكاظمي - عراقي","f":"Amer_Al-Kazemi_64kbps"},
    {"name":"🇮🇶 مصطفى نامج - عراقي","f":"Mustafa_Al-Azawi_64kbps"},
    {"name":"🇮🇶 ضرغام الكرعاوي - عراقي","f":"Dorgham_Al-Karawi_64kbps"},
    {"name":"🇮🇶 خضر عباس - عراقي","f":"Khidr_Abbas_64kbps"},
    {"name":"🇮🇶 مهند الموسوي - عراقي","f":"Mohanad_Al-Mosawi_64kbps"},
    {"name":"ياسر الدوسري","f":"Yasser_Ad-Dosari_128kbps"},
    {"name":"المنشاوي مجود","f":"Minshawy_Mujawwad_192kbps"},
    {"name":"المنشاوي مرتل","f":"Mohammed_Siddiq_Al-Minshawi_128kbps"},
    {"name":"عبدالباسط عبدالصمد","f":"Abdul_Basit_Murattal_192kbps"},
    {"name":"ماهر المعيقلي","f":"Maher_AlMuaiqly_64kbps"},
  ];

  @override void dispose(){player.dispose();super.dispose();}

  void play(int ay)async{
    setState(()=>cur=ay);
    String s=widget.num.toString().padLeft(3,'0');
    String v=ay.toString().padLeft(3,'0');
    // الرابط الاساسي everyayah
    String url="https://everyayah.com/data/$sel/${s}${v}.mp3";
    try{
      await player.setUrl(url);
      player.play();
    }catch(_){
      // اذا فشل - جرب سيرفر ثاني عراقي من mp3quran
      try{
        String url2="https://server8.mp3quran.net/$sel/${s.padLeft(3,'0')}.mp3";
        await player.setUrl(url2);
        player.play();
      }catch(_){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text("هذا المقطع غير متوفر لهذا القارئ - جرب ${reciters[5]["name"]}")));
      }
    }
  }

  @override Widget build(BuildContext c){
    int tot=quran.getVerseCount(widget.num);
    String curName=reciters.firstWhere((r)=>r["f"]==sel)["name"]!;
    return Scaffold(
      backgroundColor:const Color(0xFFFEF9EF),
      appBar:AppBar(backgroundColor:const Color(0xFF0B3D2E),title:Text(quran.getSurahNameArabic(widget.num),style:const TextStyle(color:Colors.white,fontSize:13))),
      body:Column(children:[
        Container(color:const Color(0xFF0B3D2E),padding:const EdgeInsets.symmetric(horizontal:8,vertical:4),child:Row(children:[
          const Icon(Icons.flag,color:Color(0xFFE8C86A),size:16),
          const SizedBox(width:4),
          Expanded(child:DropdownButtonHideUnderline(child:DropdownButton<String>(value:sel,isExpanded:true,dropdownColor:const Color(0xFF0B3D2E),style:const TextStyle(color:Colors.white,fontSize:11),items:reciters.map((r)=>DropdownMenuItem(value:r["f"],child:Text(r["name"]!,style:const TextStyle(color:Colors.white,fontSize:11)))).toList(),onChanged:(v){if(v!=null){setState(()=>sel=v);player.stop();}}))),
        ])),
        Container(width:double.infinity,color:const Color(0xFFE8C86A).withOpacity(0.3),padding:const EdgeInsets.all(4),child:Text("الآن: $curName",textAlign:TextAlign.center,style:const TextStyle(fontSize:10,fontWeight:FontWeight.bold))),
        Expanded(child:ListView.builder(itemCount:tot+1,itemBuilder:(c,i){
          if(i==tot){return Container(margin:const EdgeInsets.all(14),padding:const EdgeInsets.all(14),decoration:BoxDecoration(color:const Color(0xFF0B3D2E),borderRadius:BorderRadius.circular(12),border:Border.all(color:const Color(0xFFE8C86A),width:1.2)),child:const Column(children:[Text("🇮🇶 صدقة جارية للمرحوم ناصر عزيز",style:TextStyle(color:Color(0xFFE8C86A),fontWeight:FontWeight.bold)),Text("اللهم ارحمه واغفر له - بصوت عراقي",textAlign:TextAlign.center,style:TextStyle(color:Colors.white70,fontSize:11)),Text("ha1224704@gmail.com",style:TextStyle(color:Colors.white24,fontSize:6))]));}
          int ay=i+1;String verse=quran.getVerse(widget.num,ay,verseEndSymbol:false);bool act=cur==ay;
          return Card(color:act?const Color(0xFFE8F5E9):Colors.white,child:ListTile(leading:CircleAvatar(radius:11,backgroundColor:const Color(0xFF0B3D2E),child:Text("$ay",style:const TextStyle(color:Colors.white,fontSize:7))),title:Text(verse,textAlign:TextAlign.right,style:const TextStyle(fontSize:15,height:1.6)),trailing:IconButton(icon:Icon(act?Icons.pause_circle:Icons.play_circle_outline,color:act?Colors.green:Colors.black54),onPressed:()=>play(ay)),onLongPress:(){Clipboard.setData(ClipboardData(text:verse));}));
        }))
      ]),
    );
  }
}

class Azkar extends StatelessWidget{const Azkar({super.key});@override Widget build(BuildContext c){return Scaffold(backgroundColor:const Color(0xFFFEF9EF),appBar:AppBar(backgroundColor:const Color(0xFF0B3D2E),title:const Text("الأذكار",style:TextStyle(color:Colors.white))),body:ListView(padding:const EdgeInsets.all(10),children:const[Card(child:ListTile(title:Text("🇮🇶 قراء عراقيون"),subtitle:Text("عامر الكاظمي - مصطفى نامج - ضرغام - خضر عباس - مهند"))),Card(color:Color(0xFF0B3D2E),child:ListTile(title:Text("دعاء لناصر عزيز",style:TextStyle(color:Color(0xFFE8C86A))),subtitle:Text("اللهم ارحم ناصر عزيز",style:TextStyle(color:Colors.white70))))]));}}
class Sebha extends StatefulWidget{const Sebha({super.key});@override State<Sebha> createState()=>_Se();}
class _Se extends State<Sebha>{int co=0;@override Widget build(BuildContext c){return Scaffold(backgroundColor:const Color(0xFFFEF9EF),appBar:AppBar(backgroundColor:const Color(0xFF0B3D2E),title:const Text("السبحة",style:TextStyle(color:Colors.white))),body:Center(child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[Text("$co",style:const TextStyle(fontSize:70,fontWeight:FontWeight.bold)),GestureDetector(onTap:()=>setState(()=>co++),child:Container(width:160,height:160,decoration:const BoxDecoration(color:Color(0xFF0B3D2E),shape:BoxShape.circle),child:const Center(child:Text("سبح",style:TextStyle(color:Colors.white,fontSize:26))))),TextButton(onPressed:()=>setState(()=>co=0),child:const Text("تصفير"))])));}}
class Nasser extends StatelessWidget{const Nasser({super.key});@override Widget build(BuildContext c){return Scaffold(backgroundColor:const Color(0xFFFEF9EF),appBar:AppBar(backgroundColor:const Color(0xFF0B3D2E),title:const Text("ناصر عزيز",style:TextStyle(color:Colors.white))),body:Center(child:Container(margin:const EdgeInsets.all(16),padding:const EdgeInsets.all(18),decoration:BoxDecoration(color:const Color(0xFF0B3D2E),borderRadius:BorderRadius.circular(14)),child:const Column(mainAxisSize:MainAxisSize.min,children:[Text("المرحوم ناصر عزيز",style:TextStyle(color:Colors.white,fontSize:18,fontWeight:FontWeight.bold)),Text("اللهم ارحمه واغفر له",textAlign:TextAlign.center,style:TextStyle(color:Colors.white70))]))));}}
class About extends StatelessWidget{const About({super.key});@override Widget build(BuildContext c){return Scaffold(backgroundColor:const Color(0xFFFEF9EF),appBar:AppBar(backgroundColor:const Color(0xFF0B3D2E),title:const Text("المطور العراقي",style:TextStyle(color:Colors.white))),body:ListView(padding:const EdgeInsets.all(12),children:[Container(padding:const EdgeInsets.all(16),decoration:BoxDecoration(color:const Color(0xFF0B3D2E),borderRadius:BorderRadius.circular(12)),child:const Column(children:[Text("حيدر - بغداد - العراق",style:TextStyle(color:Colors.white,fontWeight:FontWeight.bold)),Text("ha1224704@gmail.com",style:TextStyle(color:Color(0xFFE8C86A),fontSize:11)),Text("10 قراء - 5 عراقيين - com.ali.nasser.aziz.al.malike",style:TextStyle(color:Colors.white60,fontSize:8))]))]));}}