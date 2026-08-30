import 'package:flutter/material.dart';
import 'main.dart' as ui;

class SecurityCenterScreen extends StatefulWidget {
  const SecurityCenterScreen({super.key});
  @override
  State<SecurityCenterScreen> createState() => _SecurityCenterScreenState();
}

class _SecurityCenterScreenState extends State<SecurityCenterScreen> {
  bool showOnline = true;
  bool showDistance = true;
  bool discoverable = true;

  void _soon(String title) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$title yakında aktif olacak.')),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 28),
                decoration: const BoxDecoration(
                  color: ui.OpenApp.lime,
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(36)),
                ),
                child: Column(children: [
                  Row(children: [
                    _circle(Icons.arrow_back_rounded, () => Navigator.pop(context)),
                    const Spacer(),
                    const Text('Güvenlik', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                    const Spacer(),
                    const SizedBox(width: 46),
                  ]),
                  const SizedBox(height: 22),
                  Container(width: 92,height: 92,decoration: const BoxDecoration(color: Colors.white,shape: BoxShape.circle),child: const Icon(Icons.shield_rounded,size: 48)),
                  const SizedBox(height: 15),
                  const Text('Güvenlik Merkezin',style: TextStyle(fontSize: 29,fontWeight: FontWeight.w900,letterSpacing: -.8)),
                  const SizedBox(height: 7),
                  const Text('Profilini ve bağlantılarını kontrol altında tut.',textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w600,color: Color(0xFF465400))),
                  const SizedBox(height: 18),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 11),decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(22)),child: const Row(mainAxisSize: MainAxisSize.min,children: [Icon(Icons.check_circle_rounded,size: 20),SizedBox(width: 7),Text('Hesabın güvende',style: TextStyle(fontWeight: FontWeight.w800))])),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 22, 18, 30),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                  const _SectionTitle('Doğrulama'),
                  _tile(Icons.verified_user_outlined,'Profil doğrulama','Selfie ile gerçek kişi doğrulaması',()=>_soon('Profil doğrulama')),
                  _tile(Icons.phone_iphone_rounded,'Telefon ve e-posta','Hesap doğrulama yöntemlerin',()=>_soon('Telefon ve e-posta')),
                  const _SectionTitle('Koruma'),
                  _tile(Icons.block_rounded,'Engellenen kişiler','Engellediğin hesapları yönet',()=>_soon('Engellenen kişiler')),
                  _tile(Icons.report_gmailerrorred_rounded,'Şikayetler','Güvenlik bildirimlerini yönet',()=>_soon('Şikayetler')),
                  const _SectionTitle('Gizlilik'),
                  _switchTile(Icons.circle_outlined,'Çevrimiçi durum','Aktif olduğunu diğerleri görebilsin',showOnline,(v)=>setState(()=>showOnline=v)),
                  _switchTile(Icons.near_me_outlined,'Mesafemi göster','Yalnızca yaklaşık mesafen gösterilir',showDistance,(v)=>setState(()=>showDistance=v)),
                  _switchTile(Icons.visibility_outlined,'Keşfette görün','Profilin Keşfet ekranında gösterilsin',discoverable,(v)=>setState(()=>discoverable=v)),
                  const _SectionTitle('Bağlantı güvenliği'),
                  _tile(Icons.key_outlined,'Anahtar güvenliği','Kimlerin anahtar gönderebileceğini seç',()=>_soon('Anahtar güvenliği')),
                  _tile(Icons.chat_bubble_outline_rounded,'Mesaj güvenliği','Mesajlaşma ve eşleşme korumaları',()=>_soon('Mesaj güvenliği')),
                  _tile(Icons.location_on_outlined,'Buluşma güvenliği','Güvendiğin biriyle buluşma bilgisi paylaş',()=>_soon('Buluşma güvenliği')),
                  const _SectionTitle('Hesap'),
                  _tile(Icons.devices_rounded,'Aktif oturumlar','Hesabının açık olduğu cihazları gör',()=>_soon('Aktif oturumlar')),
                  _tile(Icons.lock_reset_rounded,'Şifre ve hesap güvenliği','Şifreni ve giriş yöntemlerini yönet',()=>_soon('Hesap güvenliği')),
                  const SizedBox(height: 18),
                  SizedBox(width: double.infinity,child: OutlinedButton.icon(onPressed:()=>_soon('Güvenlik bildirimi'),icon: const Icon(Icons.warning_amber_rounded),label: const Text('Güvenlik veya taciz bildir'),style: OutlinedButton.styleFrom(foregroundColor: Colors.red,side: const BorderSide(color: Color(0xFFFFC7C7)),padding: const EdgeInsets.symmetric(vertical: 17)))),
                ]),
              ),
            ],
          ),
        ),
      );

  Widget _circle(IconData icon,VoidCallback tap)=>Material(color: Colors.white,shape: const CircleBorder(),child: InkWell(onTap: tap,customBorder: const CircleBorder(),child: SizedBox(width:46,height:46,child: Icon(icon))));
  Widget _tile(IconData icon,String title,String sub,VoidCallback tap)=>Container(margin: const EdgeInsets.only(bottom: 10),decoration: BoxDecoration(color: ui.OpenApp.soft,borderRadius: BorderRadius.circular(24)),child: ListTile onTap: tap,contentPadding: const EdgeInsets.symmetric(horizontal: 15,vertical: 7),leading: _icon(icon),title: Text(title,style: const TextStyle(fontWeight: FontWeight.w800)),subtitle: Text(sub),trailing: const Icon(Icons.chevron_right_rounded));
  Widget _switchTile(IconData icon,String title,String sub,bool value,ValueChanged<bool> change)=>Container(margin: const EdgeInsets.only(bottom: 10),decoration: BoxDecoration(color: ui.OpenApp.soft,borderRadius: BorderRadius.circular(24)),child: SwitchListTile value: value,onChanged: change,activeThumbColor: Colors.black,activeTrackColor: ui.OpenApp.lime,secondary: _icon(icon),title: Text(title,style: const TextStyle(fontWeight: FontWeight.w800)),subtitle: Text(sub));
  Widget _icon(IconData icon)=>Container(width:45,height:45,decoration: BoxDecoration(color: ui.OpenApp.lime.withValues(alpha:.24),shape: BoxShape.circle),child: Icon(icon,size:23));
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text); final String text;
  @override Widget build(BuildContext context)=>Padding(padding: const EdgeInsets.fromLTRB(5,18,5,10),child: Text(text,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w900)));
}
