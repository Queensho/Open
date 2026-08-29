import 'package:flutter/material.dart';

void main() => runApp(const OpenApp());

class OpenApp extends StatelessWidget {
  const OpenApp({super.key});
  static const lime = Color(0xFFBFFF00);
  static const ink = Color(0xFF111111);
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Open',
    theme: ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.white,
      colorScheme: ColorScheme.fromSeed(seedColor: lime),
      filledButtonTheme: FilledButtonThemeData(style: FilledButton.styleFrom(backgroundColor: lime, foregroundColor: ink, minimumSize: const Size.fromHeight(58), shape: const StadiumBorder(), textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800))),
    ),
    home: const SplashScreen(),
  );
}

class AssetPng extends StatelessWidget {
  const AssetPng(this.path, {super.key, this.size = 126, this.scale = 1.85});
  final String path; final double size; final double scale;
  @override
  Widget build(BuildContext context) => Container(
    width: size, height: size,
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(size * .28), boxShadow: [BoxShadow(color: OpenApp.lime.withValues(alpha: .22), blurRadius: 34, spreadRadius: 5, offset: const Offset(0,8)), BoxShadow(color: Colors.black.withValues(alpha: .05), blurRadius: 12, offset: const Offset(0,6))]),
    child: ClipRRect(borderRadius: BorderRadius.circular(size*.28), child: Center(child: Transform.scale(scale: scale, child: SizedBox(width:size,height:size,child:Image.asset(path,fit:BoxFit.contain,filterQuality:FilterQuality.high,isAntiAlias:true))))),
  );
}

class SplashScreen extends StatefulWidget { const SplashScreen({super.key}); @override State<SplashScreen> createState()=>_SplashScreenState(); }
class _SplashScreenState extends State<SplashScreen>{
  @override void initState(){super.initState();Future.delayed(const Duration(milliseconds:1400),(){if(mounted)Navigator.pushReplacement(context,MaterialPageRoute(builder:(_)=>const WelcomeScreen()));});}
  @override Widget build(BuildContext context)=>Scaffold(body:Center(child:Column(mainAxisSize:MainAxisSize.min,children:[const AssetPng('assets/icons/splash_logo.png',size:118,scale:1.65),const SizedBox(height:28),const Text('Open',style:TextStyle(fontSize:44,fontWeight:FontWeight.w900,letterSpacing:-1.8)),const SizedBox(height:9),Container(width:34,height:5,decoration:BoxDecoration(color:OpenApp.lime,borderRadius:BorderRadius.circular(9)))])));
}

class WelcomeScreen extends StatelessWidget{const WelcomeScreen({super.key});@override Widget build(BuildContext context)=>Scaffold(body:SafeArea(child:Padding(padding:const EdgeInsets.fromLTRB(28,28,28,24),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[const Spacer(flex:2),const AssetPng('assets/icons/splash_logo.png',size:90,scale:1.65),const SizedBox(height:30),const Text('Open',style:TextStyle(fontSize:52,height:1,fontWeight:FontWeight.w900,letterSpacing:-2)),const SizedBox(height:22),const Text('Kaydırma.\nÖnce kilidimi aç.',style:TextStyle(fontSize:31,height:1.08,fontWeight:FontWeight.w800,letterSpacing:-.7)),const SizedBox(height:18),Container(width:44,height:4,decoration:BoxDecoration(color:OpenApp.lime,borderRadius:BorderRadius.circular(8))),const SizedBox(height:16),const Text('Bir fotoğraftan fazlasını keşfet.\nSoruyu cevapla, profili aç ve gerçek bir bağ kur.',style:TextStyle(fontSize:16,height:1.5,color:Color(0xFF6B6B6B))),const Spacer(flex:3),FilledButton(onPressed:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const OnboardingScreen())),child:const Text('Başlayalım'))]))));}

class OnboardingScreen extends StatefulWidget{const OnboardingScreen({super.key});@override State<OnboardingScreen> createState()=>_OnboardingScreenState();}
class _OnboardingScreenState extends State<OnboardingScreen>{
 final controller=PageController(); int page=0;
 final pages=const [('Profil değil,\ninsanı keşfet.','Önce soruları cevapla, sonra karar ver.','assets/icons/onboarding_lock_user.png'),('3 kilit soru,\nyüzlerce olasılık.','Merak uyandıran sorularla daha anlamlı sohbetler.','assets/icons/icon_question.png'),('Doğru kişiyle\nanahtarın uyusun.','Anahtarını gönder. Kabul edilirse profil açılır ve sohbet başlar.','assets/icons/icon_key.png'),('Gerçek bağlantılar\nburada başlar.','Daha az yüzeysel, daha çok sen.','assets/icons/icon_unlock.png')];
 void next(){if(page<pages.length-1){controller.nextPage(duration:const Duration(milliseconds:330),curve:Curves.easeOutCubic);}else{Navigator.pushReplacement(context,MaterialPageRoute(builder:(_)=>const LoginScreen()));}}
 @override Widget build(BuildContext context)=>Scaffold(body:SafeArea(child:Column(children:[Align(alignment:Alignment.centerRight,child:Padding(padding:const EdgeInsets.only(right:20,top:6),child:TextButton(onPressed:()=>Navigator.pushReplacement(context,MaterialPageRoute(builder:(_)=>const LoginScreen())),child:const Text('Atla',style:TextStyle(color:OpenApp.ink,fontWeight:FontWeight.w800))))),Expanded(child:PageView.builder(controller:controller,itemCount:pages.length,onPageChanged:(v)=>setState(()=>page=v),itemBuilder:(_,i){final p=pages[i];return Padding(padding:const EdgeInsets.fromLTRB(28,8,28,18),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Expanded(child:Center(child:Container(width:230,height:230,decoration:BoxDecoration(shape:BoxShape.circle,gradient:RadialGradient(colors:[OpenApp.lime.withValues(alpha:.17),OpenApp.lime.withValues(alpha:.025),Colors.transparent])),child:Center(child:AssetPng(p.$3,size:146,scale:i==0?1.0:1.95))))),Container(padding:const EdgeInsets.symmetric(horizontal:12,vertical:6),decoration:BoxDecoration(color:OpenApp.lime,borderRadius:BorderRadius.circular(18)),child:Text('0${i+1}',style:const TextStyle(fontWeight:FontWeight.w900,fontSize:16))),const SizedBox(height:18),Text(p.$1,style:const TextStyle(fontSize:34,height:1.06,fontWeight:FontWeight.w900,letterSpacing:-1)),const SizedBox(height:15),Text(p.$2,style:const TextStyle(fontSize:16,height:1.45,color:Color(0xFF6B6B6B))),const SizedBox(height:26),Row(children:List.generate(pages.length,(d)=>AnimatedContainer(duration:const Duration(milliseconds:220),margin:const EdgeInsets.only(right:8),width:d==page?28:9,height:9,decoration:BoxDecoration(color:d==page?OpenApp.lime:const Color(0xFFE0E0E0),borderRadius:BorderRadius.circular(10))))),const SizedBox(height:25),FilledButton(onPressed:next,child:Text(i==pages.length-1?'Open’a gir':'Devam et'))]));}))])));
}

class LoginScreen extends StatelessWidget{const LoginScreen({super.key});@override Widget build(BuildContext context)=>Scaffold(body:SafeArea(child:Padding(padding:const EdgeInsets.all(28),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[const Spacer(),const AssetPng('assets/icons/splash_logo.png',size:82,scale:1.65),const SizedBox(height:26),const Text('Open',style:TextStyle(fontSize:48,fontWeight:FontWeight.w900,letterSpacing:-2)),const SizedBox(height:12),const Text('Gerçek bağlantılar burada başlar.',style:TextStyle(fontSize:18,color:Color(0xFF666666))),const Spacer(),FilledButton.icon(onPressed:(){},icon:const Icon(Icons.phone_rounded),label:const Text('Telefon ile devam et')),const SizedBox(height:12),OutlinedButton.icon(style:OutlinedButton.styleFrom(minimumSize:const Size.fromHeight(58),shape:const StadiumBorder(),foregroundColor:OpenApp.ink),onPressed:(){},icon:const Icon(Icons.mail_outline_rounded),label:const Text('E-posta ile devam et')),const SizedBox(height:24)])))));}
