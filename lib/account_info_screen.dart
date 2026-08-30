import 'package:flutter/material.dart';
import 'data/open_backend.dart';
import 'location_picker.dart';
import 'main.dart' as ui;

class AccountInfoScreen extends StatefulWidget {
  const AccountInfoScreen({super.key, required this.profile});
  final Map<String, dynamic> profile;
  @override State<AccountInfoScreen> createState()=>_AccountInfoScreenState();
}

class _AccountInfoScreenState extends State<AccountInfoScreen>{
  late final TextEditingController name;
  DateTime? birthDate;
  String country='',city='',district='';
  bool saving=false;

  @override void initState(){
    super.initState();
    name=TextEditingController(text:(widget.profile['display_name']??'').toString());
    birthDate=DateTime.tryParse((widget.profile['birth_date']??'').toString());
    country=(widget.profile['country']??'').toString();
    city=(widget.profile['city']??'').toString();
    district=(widget.profile['district']??'').toString();
  }
  @override void dispose(){name.dispose();super.dispose();}
  int? get age {if(birthDate==null)return null;final n=DateTime.now();var a=n.year-birthDate!.year;if(n.month<birthDate!.month||(n.month==birthDate!.month&&n.day<birthDate!.day))a--;return a;}
  String get location=>[country,city,district].where((e)=>e.isNotEmpty).join(' · ');

  Future<void> pickBirth()async{
    final now=DateTime.now();
    final d=await showDatePicker(context:context,initialDate:birthDate??DateTime(now.year-25,now.month,now.day),firstDate:DateTime(1940),lastDate:DateTime(now.year-18,now.month,now.day),helpText:'Doğum tarihini seç');
    if(d!=null&&mounted)setState(()=>birthDate=d);
  }
  Future<void> pickLocation()async{
    final v=await LocationPicker.show(context,country:country,state:city,district:district);
    if(v==null||!mounted)return;
    setState((){country=v.country;city=v.state;district=v.district;});
  }
  Future<void> save()async{
    if(name.text.trim().length<2){ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Ad soyadını gir.')));return;}
    if(birthDate==null){ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Doğum tarihini seç.')));return;}
    if(country.isEmpty||city.isEmpty||district.isEmpty){ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Ülke, il ve ilçeyi seç.')));return;}
    final id=OpenBackend.instance.userId;if(id==null)return;
    setState(()=>saving=true);
    try{
      final data={'display_name':name.text.trim(),'birth_date':'${birthDate!.year.toString().padLeft(4,'0')}-${birthDate!.month.toString().padLeft(2,'0')}-${birthDate!.day.toString().padLeft(2,'0')}','country':country,'city':city,'district':district};
      await OpenBackend.instance.client.from('profiles').update(data).eq('id',id);
      if(!mounted)return;
      Navigator.pop(context,data);
    }catch(e){if(mounted)ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('Kaydedilemedi: $e')));}finally{if(mounted)setState(()=>saving=false);}
  }

  @override Widget build(BuildContext context)=>Scaffold(
    backgroundColor:const Color(0xfff7f7f4),
    appBar:AppBar(backgroundColor:Colors.transparent,title:const Text('Hesap bilgileri',style:TextStyle(fontWeight:FontWeight.w900))),
    body:SafeArea(child:ListView(padding:const EdgeInsets.fromLTRB(20,12,20,28),children:[
      const Text('Profil bilgilerin',style:TextStyle(fontSize:28,fontWeight:FontWeight.w900,letterSpacing:-.7)),
      const SizedBox(height:6),const Text('Keşfet kartında görünen temel bilgilerini buradan düzenleyebilirsin.',style:TextStyle(color:ui.OpenApp.muted,height:1.4)),
      const SizedBox(height:24),
      _Box(child:TextField(controller:name,textCapitalization:TextCapitalization.words,decoration:const InputDecoration(labelText:'Ad soyad',prefixIcon:Icon(Icons.person_outline_rounded)))),
      const SizedBox(height:12),
      _Box(child:ListTile(contentPadding:const EdgeInsets.symmetric(horizontal:16,vertical:5),leading:const Icon(Icons.cake_outlined),title:const Text('Yaş',style:TextStyle(fontWeight:FontWeight.w800)),subtitle:Text(birthDate==null?'Doğum tarihini seç':'${age??'-'} yaş · ${birthDate!.day.toString().padLeft(2,'0')}.${birthDate!.month.toString().padLeft(2,'0')}.${birthDate!.year}'),trailing:const Icon(Icons.chevron_right_rounded),onTap:pickBirth)),
      const SizedBox(height:12),
      _Box(child:ListTile(contentPadding:const EdgeInsets.symmetric(horizontal:16,vertical:5),leading:const Icon(Icons.location_on_outlined),title:const Text('Ülke · İl · İlçe',style:TextStyle(fontWeight:FontWeight.w800)),subtitle:Text(location.isEmpty?'Konum seç':location),trailing:const Icon(Icons.chevron_right_rounded),onTap:pickLocation)),
      const SizedBox(height:28),
      SizedBox(height:58,child:FilledButton(onPressed:saving?null:save,style:FilledButton.styleFrom(backgroundColor:ui.OpenApp.lime,foregroundColor:Colors.black),child:Text(saving?'Kaydediliyor...':'Değişiklikleri kaydet',style:const TextStyle(fontWeight:FontWeight.w900)))),
    ])),
  );
}
class _Box extends StatelessWidget{const _Box({required this.child});final Widget child;@override Widget build(BuildContext context)=>Container(decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(22)),child:child);}
