import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'data/open_backend.dart';

const lime = Color(0xFFBFFF00);
const ink = Color(0xFF111111);
const soft = Color(0xFFF6F6F3);

class OpenConnectedApp extends StatelessWidget {
  const OpenConnectedApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Open',
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.white,
          colorScheme: ColorScheme.fromSeed(seedColor: lime),
          inputDecorationTheme: InputDecorationTheme(filled: true, fillColor: soft, border: OutlineInputBorder(borderRadius: BorderRadius.circular(22), borderSide: BorderSide.none)),
          filledButtonTheme: FilledButtonThemeData(style: FilledButton.styleFrom(backgroundColor: lime, foregroundColor: ink, minimumSize: const Size.fromHeight(56), shape: const StadiumBorder())),
        ),
        home: OpenBackend.instance.isAuthenticated ? const HomeShell() : const AuthScreen(),
      );
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  final phone = TextEditingController();
  final otp = TextEditingController();
  bool register = true, busy = false, phoneMode = false, codeSent = false;
  String? error;

  Future<void> submitEmail() async {
    setState(() { busy = true; error = null; });
    try {
      final r = register ? await OpenBackend.instance.registerEmail(email.text, password.text) : await OpenBackend.instance.loginEmail(email.text, password.text);
      if (!mounted) return;
      if (r.session == null && register) {
        setState(() => error = 'E-posta doğrulaması açıksa gelen kutunu kontrol et.');
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ProfileSetupScreen()));
      }
    } catch (e) { if (mounted) setState(() => error = e.toString()); }
    if (mounted) setState(() => busy = false);
  }

  void submitPhone() {
    if (!codeSent) {
      if (phone.text.replaceAll(RegExp(r'\D'), '').length < 10) { setState(() => error = 'Geçerli telefon numarası gir.'); return; }
      setState(() { codeSent = true; error = null; });
      return;
    }
    if (otp.text.trim() != '123456') { setState(() => error = 'Test kodu: 123456'); return; }
    Navigator.push(context, MaterialPageRoute(builder: (_) => const MockPhoneNoticeScreen()));
  }

  @override
  Widget build(BuildContext context) => Scaffold(body: SafeArea(child: SingleChildScrollView(padding: const EdgeInsets.all(28), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    const SizedBox(height: 60),
    Container(width: 76,height:76,decoration:BoxDecoration(color:lime,borderRadius:BorderRadius.circular(24)),child:const Icon(Icons.lock_open_rounded,size:38)),
    const SizedBox(height: 28), const Text('Open',style:TextStyle(fontSize:46,fontWeight:FontWeight.w900)), const SizedBox(height:8),
    Text(phoneMode ? 'Telefon ile devam et' : (register ? 'Hesabını aç.' : 'Tekrar hoş geldin.'),style:const TextStyle(fontSize:25,fontWeight:FontWeight.w800)), const SizedBox(height:28),
    if (phoneMode) ...[
      TextField(controller:phone,keyboardType:TextInputType.phone,enabled:!codeSent,decoration:const InputDecoration(labelText:'Telefon numarası',prefixText:'+90  ')),
      if (codeSent) ...[const SizedBox(height:14),TextField(controller:otp,keyboardType:TextInputType.number,maxLength:6,decoration:const InputDecoration(labelText:'Onay kodu',counterText:'')),const SizedBox(height:6),const Text('Şimdilik test kodu: 123456')],
      const SizedBox(height:20), FilledButton(onPressed:submitPhone,child:Text(codeSent?'Doğrula':'Onay kodu gönder')),
    ] else ...[
      TextField(controller:email,keyboardType:TextInputType.emailAddress,decoration:const InputDecoration(labelText:'E-posta')),const SizedBox(height:14),
      TextField(controller:password,obscureText:true,decoration:const InputDecoration(labelText:'Şifre')),const SizedBox(height:20),
      FilledButton(onPressed:busy?null:submitEmail,child:Text(busy?'Bekle...':(register?'Kayıt ol ve devam et':'Giriş yap'))),
    ],
    if(error!=null)...[const SizedBox(height:12),Text(error!,style:const TextStyle(color:Colors.red))],
    const SizedBox(height:14), TextButton(onPressed:()=>setState(()=>phoneMode=!phoneMode),child:Text(phoneMode?'E-posta ile devam et':'Telefon ile devam et (mock)')),
    if(!phoneMode) TextButton(onPressed:()=>setState(()=>register=!register),child:Text(register?'Zaten hesabın var mı? Giriş yap':'Hesabın yok mu? Kayıt ol')),
  ]))));
}

class MockPhoneNoticeScreen extends StatelessWidget {
  const MockPhoneNoticeScreen({super.key});
  @override Widget build(BuildContext context)=>Scaffold(body:SafeArea(child:Padding(padding:const EdgeInsets.all(28),child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[const Icon(Icons.check_circle_rounded,size:80,color:lime),const SizedBox(height:20),const Text('Mock SMS doğrulandı',style:TextStyle(fontSize:28,fontWeight:FontWeight.w900)),const SizedBox(height:12),const Text('SMS şimdilik gerçek Supabase oturumu açmıyor. Gerçek veriyi test etmek için e-posta hesabıyla giriş yap.',textAlign:TextAlign.center),const SizedBox(height:24),FilledButton(onPressed:()=>Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder:(_)=>const AuthScreen()),(_)=>false),child:const Text('E-posta ile girişe dön'))]))));
}

class ProfileSetupScreen extends StatefulWidget { const ProfileSetupScreen({super.key}); @override State<ProfileSetupScreen> createState()=>_ProfileSetupScreenState(); }
class _ProfileSetupScreenState extends State<ProfileSetupScreen>{
 final name=TextEditingController(),city=TextEditingController(); String gender='Kadın'; bool busy=false; String? error;
 Future<void> next()async{if(name.text.trim().isEmpty||city.text.trim().isEmpty)return;setState(()=>busy=true);try{await OpenBackend.instance.saveProfile(name.text,city.text,gender);if(mounted)Navigator.pushReplacement(context,MaterialPageRoute(builder:(_)=>const QuestionSetupScreen()));}catch(e){if(mounted)setState(()=>error=e.toString());}if(mounted)setState(()=>busy=false);}
 @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(),body:SafeArea(child:SingleChildScrollView(padding:const EdgeInsets.all(26),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[const Text('Seni tanıyalım.',style:TextStyle(fontSize:34,fontWeight:FontWeight.w900)),const SizedBox(height:8),const Text('Temel bilgilerin Supabase profilinde saklanacak.'),const SizedBox(height:26),TextField(controller:name,decoration:const InputDecoration(labelText:'Adın')),const SizedBox(height:14),TextField(controller:city,decoration:const InputDecoration(labelText:'Konum')),const SizedBox(height:18),Wrap(spacing:8,children:['Kadın','Erkek','Belirtmek istemiyorum'].map((g)=>ChoiceChip(label:Text(g),selected:gender==g,selectedColor:lime,onSelected:(_)=>setState(()=>gender=g))).toList()),const SizedBox(height:24),FilledButton(onPressed:busy?null:next,child:const Text('Kilit sorularına geç')),if(error!=null)Text(error!,style:const TextStyle(color:Colors.red))]))));
}

class QuestionSetupScreen extends StatefulWidget{const QuestionSetupScreen({super.key});@override State<QuestionSetupScreen> createState()=>_QuestionSetupScreenState();}
class _QuestionSetupScreenState extends State<QuestionSetupScreen>{
 final selected=<int>{}; final qs=const['Bir pazar sabahı seni nerede bulurum?','Seni güldüren küçük şey ne?','Birine hemen güvenmeni sağlayan şey?','Hayalindeki plansız gün nasıl geçer?','Bir şarkı seni hangi ana götürür?','İlk buluşmada en çok neye dikkat edersin?']; bool busy=false;
 Future<void>save()async{setState(()=>busy=true);await OpenBackend.instance.saveLockQuestions(selected.map((i)=>qs[i]).toList());if(mounted)Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder:(_)=>const HomeShell()),(_)=>false);}
 @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(),body:SafeArea(child:Padding(padding:const EdgeInsets.all(26),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[const Text('3 kilit sorunu seç.',style:TextStyle(fontSize:32,fontWeight:FontWeight.w900)),const SizedBox(height:18),Expanded(child:ListView.builder(itemCount:qs.length,itemBuilder:(_,i)=>Card(child:CheckboxListTile(activeColor:lime,value:selected.contains(i),title:Text(qs[i]),onChanged:(_)=>setState((){if(selected.contains(i)){selected.remove(i);}else if(selected.length<3){selected.add(i);}})))),FilledButton(onPressed:selected.length==3&&!busy?save:null,child:Text('${selected.length}/3 · Profili tamamla'))]))));
}

class HomeShell extends StatefulWidget{const HomeShell({super.key});@override State<HomeShell> createState()=>_HomeShellState();}
class _HomeShellState extends State<HomeShell>{int index=0;@override Widget build(BuildContext context){final pages=[const DiscoverLiveScreen(),const KeysLiveScreen(),const MatchesLiveScreen(),const AccountScreen()];return Scaffold(body:pages[index],bottomNavigationBar:NavigationBar(selectedIndex:index,indicatorColor:lime.withValues(alpha:.2),onDestinationSelected:(v)=>setState(()=>index=v),destinations:const[NavigationDestination(icon:Icon(Icons.explore_outlined),label:'Keşfet'),NavigationDestination(icon:Icon(Icons.key_outlined),label:'Anahtarlar'),NavigationDestination(icon:Icon(Icons.chat_bubble_outline),label:'Mesajlar'),NavigationDestination(icon:Icon(Icons.person_outline),label:'Profil')]));}}

class DiscoverLiveScreen extends StatefulWidget{const DiscoverLiveScreen({super.key});@override State<DiscoverLiveScreen> createState()=>_DiscoverLiveScreenState();}
class _DiscoverLiveScreenState extends State<DiscoverLiveScreen>{late Future<List<Map<String,dynamic>>> future;int i=0;@override void initState(){super.initState();future=OpenBackend.instance.discover();}
 @override Widget build(BuildContext context)=>SafeArea(child:FutureBuilder<List<Map<String,dynamic>>>(future:future,builder:(context,s){if(s.connectionState!=ConnectionState.done)return const Center(child:CircularProgressIndicator());if(s.hasError)return Center(child:Text('Keşfet yüklenemedi: ${s.error}'));final rows=s.data??[];if(rows.isEmpty)return const Center(child:Text('Henüz keşfedilecek tamamlanmış profil yok.'));final p=rows[i%rows.length];final q=List<Map<String,dynamic>>.from(p['profile_questions']??const[]);return Padding(padding:const EdgeInsets.all(22),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[const Text('Keşfet ✨',style:TextStyle(fontSize:34,fontWeight:FontWeight.w900)),const SizedBox(height:18),Expanded(child:Container(width:double.infinity,decoration:BoxDecoration(color:ink,borderRadius:BorderRadius.circular(40),image:p['avatar_url']!=null?DecorationImage(image:NetworkImage(p['avatar_url']),fit:BoxFit.cover):null),child:Container(padding:const EdgeInsets.all(24),decoration:BoxDecoration(borderRadius:BorderRadius.circular(40),gradient:LinearGradient(begin:Alignment.topCenter,end:Alignment.bottomCenter,colors:[Colors.transparent,Colors.black.withValues(alpha:.85)])),child:Column(mainAxisAlignment:MainAxisAlignment.end,crossAxisAlignment:CrossAxisAlignment.start,children:[Text(p['display_name']??'Open',style:const TextStyle(color:Colors.white,fontSize:31,fontWeight:FontWeight.w900)),Text(p['city']??'',style:const TextStyle(color:Colors.white70)),const SizedBox(height:14),Wrap(spacing:7,children:List<String>.from(p['interests']??const[]).map((x)=>Chip(label:Text(x))).toList())])))),const SizedBox(height:18),Row(mainAxisAlignment:MainAxisAlignment.center,children:[IconButton.filledTonal(onPressed:()=>setState(()=>i=(i+1)%rows.length),icon:const Icon(Icons.close),iconSize:32),const SizedBox(width:22),IconButton.filled(onPressed:q.isEmpty?null:()=>showModalBottomSheet(context:context,isScrollControlled:true,builder:(_)=>KeyAnswerSheet(profile:p,questions:q)),style:IconButton.styleFrom(backgroundColor:lime,foregroundColor:ink),icon:const Icon(Icons.key_rounded),iconSize:42)] )]));}));}

class KeyAnswerSheet extends StatefulWidget{const KeyAnswerSheet({super.key,required this.profile,required this.questions});final Map<String,dynamic> profile;final List<Map<String,dynamic>> questions;@override State<KeyAnswerSheet> createState()=>_KeyAnswerSheetState();}
class _KeyAnswerSheetState extends State<KeyAnswerSheet>{int selected=0;final answer=TextEditingController();bool busy=false;Future<void>send()async{setState(()=>busy=true);await OpenBackend.instance.sendKey(widget.profile['id'],widget.questions[selected]['id'],answer.text);if(mounted){Navigator.pop(context);ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Anahtar gönderildi 🔑')));}}
 @override Widget build(BuildContext context)=>Padding(padding:EdgeInsets.fromLTRB(24,24,24,MediaQuery.of(context).viewInsets.bottom+24),child:Column(mainAxisSize:MainAxisSize.min,crossAxisAlignment:CrossAxisAlignment.start,children:[const Text('Bir kilit sorusu seç',style:TextStyle(fontSize:24,fontWeight:FontWeight.w900)),const SizedBox(height:12),...List.generate(widget.questions.length,(i)=>RadioListTile<int>(value:i,groupValue:selected,title:Text(widget.questions[i]['question']),onChanged:(v)=>setState(()=>selected=v!))),TextField(controller:answer,maxLines:3,decoration:const InputDecoration(labelText:'Cevabın')),const SizedBox(height:14),FilledButton(onPressed:busy||answer.text.trim().isEmpty?send:send,child:const Text('Anahtarı gönder'))]));}

class KeysLiveScreen extends StatefulWidget{const KeysLiveScreen({super.key});@override State<KeysLiveScreen> createState()=>_KeysLiveScreenState();}
class _KeysLiveScreenState extends State<KeysLiveScreen>{late Future<List<Map<String,dynamic>>> future;void load()=>setState(()=>future=OpenBackend.instance.incomingKeys());@override void initState(){super.initState();future=OpenBackend.instance.incomingKeys();}
 @override Widget build(BuildContext context)=>SafeArea(child:FutureBuilder<List<Map<String,dynamic>>>(future:future,builder:(_,s){final rows=s.data??[];return RefreshIndicator(onRefresh:()async=>load(),child:ListView(padding:const EdgeInsets.all(22),children:[const Text('Anahtarlar',style:TextStyle(fontSize:34,fontWeight:FontWeight.w900)),const SizedBox(height:16),if(s.connectionState!=ConnectionState.done)const Center(child:CircularProgressIndicator()),if(s.hasError)Text('${s.error}'),...rows.map((r){final profile=r['profiles'] as Map<String,dynamic>?;final question=r['profile_questions'] as Map<String,dynamic>?;return Card(child:Padding(padding:const EdgeInsets.all(16),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(profile?['display_name']??'Biri',style:const TextStyle(fontWeight:FontWeight.w900,fontSize:18)),Text(question?['question']??''),const SizedBox(height:8),Text('“${r['answer']}”'),if(r['status']=='pending')Row(children:[TextButton(onPressed:()async{await OpenBackend.instance.rejectKey(r['id']);load();},child:const Text('Reddet')),FilledButton(onPressed:()async{await OpenBackend.instance.acceptKey(r['id']);load();},child:const Text('Kabul et'))])])));})]));}));}

class MatchesLiveScreen extends StatelessWidget{const MatchesLiveScreen({super.key});@override Widget build(BuildContext context)=>SafeArea(child:FutureBuilder<List<Map<String,dynamic>>>(future:OpenBackend.instance.activeMatches(),builder:(_,s){final rows=s.data??[];return ListView(padding:const EdgeInsets.all(22),children:[const Text('Mesajlar',style:TextStyle(fontSize:34,fontWeight:FontWeight.w900)),const SizedBox(height:16),if(s.connectionState!=ConnectionState.done)const Center(child:CircularProgressIndicator()),...rows.map((m)=>ListTile(leading:const CircleAvatar(backgroundColor:lime,child:Icon(Icons.lock_open)),title:const Text('Eşleşme'),subtitle:const Text('Sohbeti aç'),onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>ChatLiveScreen(matchId:m['id'])))))]);})) ;}

class ChatLiveScreen extends StatefulWidget{const ChatLiveScreen({super.key,required this.matchId});final String matchId;@override State<ChatLiveScreen> createState()=>_ChatLiveScreenState();}
class _ChatLiveScreenState extends State<ChatLiveScreen>{final text=TextEditingController();@override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('Sohbet')),body:Column(children:[Expanded(child:StreamBuilder<List<Map<String,dynamic>>>(stream:OpenBackend.instance.messageStream(widget.matchId),builder:(_,s){final rows=s.data??[];return ListView(padding:const EdgeInsets.all(16),children:rows.map((m){final mine=m['sender_id']==OpenBackend.instance.userId;return Align(alignment:mine?Alignment.centerRight:Alignment.centerLeft,child:Container(margin:const EdgeInsets.symmetric(vertical:4),padding:const EdgeInsets.all(12),decoration:BoxDecoration(color:mine?lime:soft,borderRadius:BorderRadius.circular(18)),child:Text(m['body'])));}).toList());})),SafeArea(child:Padding(padding:const EdgeInsets.all(12),child:Row(children:[Expanded(child:TextField(controller:text,decoration:const InputDecoration(hintText:'Mesaj yaz...'))),IconButton.filled(onPressed:()async{await OpenBackend.instance.sendMessage(widget.matchId,text.text);text.clear();},icon:const Icon(Icons.send))])))]));}

class AccountScreen extends StatelessWidget{const AccountScreen({super.key});@override Widget build(BuildContext context)=>SafeArea(child:Padding(padding:const EdgeInsets.all(24),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[const Text('Profil',style:TextStyle(fontSize:34,fontWeight:FontWeight.w900)),const SizedBox(height:18),Text(Supabase.instance.client.auth.currentUser?.email??'Open kullanıcısı'),const Spacer(),OutlinedButton(onPressed:()async{await Supabase.instance.client.auth.signOut();if(context.mounted)Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder:(_)=>const AuthScreen()),(_)=>false);},child:const Text('Çıkış yap'))])));}
