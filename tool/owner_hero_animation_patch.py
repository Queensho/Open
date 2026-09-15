from pathlib import Path
import re

p = Path('lib/owner_dashboard_live.dart')
text = p.read_text(encoding='utf-8')

new_sky = r'''  Widget skyBody(bool light) {
    // The celestial body sits BELOW Aracsahibi3d.png in the hero Stack.
    // Moving it vertically makes it rise from / sink behind the character.
    return IgnorePointer(
      child: AnimatedPositioned(
        duration: const Duration(milliseconds: 1050),
        curve: Curves.easeInOutCubicEmphasized,
        right: light ? 48 : 62,
        top: light ? 132 : 142,
        width: light ? 128 : 108,
        height: light ? 128 : 108,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 650),
          switchInCurve: Curves.easeOutBack,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) {
            final slide = Tween<Offset>(
              begin: const Offset(0, 1.15),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
            final scale = Tween<double>(begin: .55, end: 1).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
            );
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: slide,
                child: ScaleTransition(scale: scale, child: child),
              ),
            );
          },
          child: light ? _sun() : _moon(),
        ),
      ),
    );
  }

  Widget _sun() => Container(
        key: const ValueKey('hero-sun'),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const RadialGradient(
            colors: [Color(0xFFFFFDE7), Color(0xFFFFE66D), Color(0xFFFFB300)],
            stops: [0, .55, 1],
          ),
          boxShadow: [
            BoxShadow(color: const Color(0xFFFFC107).withValues(alpha: .55), blurRadius: 38, spreadRadius: 13),
            BoxShadow(color: const Color(0xFFFFE082).withValues(alpha: .30), blurRadius: 65, spreadRadius: 22),
          ],
        ),
      );

  Widget _moon() => Container(
        key: const ValueKey('hero-moon'),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFFE8EEFF),
          boxShadow: [
            BoxShadow(color: const Color(0xFF9FB4FF).withValues(alpha: .42), blurRadius: 34, spreadRadius: 10),
          ],
        ),
        child: Align(
          alignment: const Alignment(.42, -.22),
          child: Container(
            width: 82,
            height: 82,
            decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF152443)),
          ),
        ),
      );
'''

pattern = r"  Widget skyBody\(bool light\) \{.*?\n  \}\n\n  @override\n  Widget build"
text, n = re.subn(pattern, new_sky + "\n  @override\n  Widget build", text, count=1, flags=re.S)
if n != 1:
    raise SystemExit('owner hero skyBody patch target not found')

# Background is deliberately independent from the transparent foreground character.
# This prevents a second baked-in character and keeps the sun/moon visibly behind him.
old = "child: Image.asset(light ? 'assets/Aracsahibig.png' : 'assets/Aracsahibi.png', key: ValueKey(light), fit: BoxFit.cover, alignment: Alignment.topCenter),"
new = "child: AnimatedContainer(key: ValueKey(light), duration: const Duration(milliseconds: 850), decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: light ? const [Color(0xFFF5F2FF), Color(0xFFE9E4F7)] : const [Color(0xFF071426), Color(0xFF101C38)]))),"
if old not in text:
    raise SystemExit('owner hero background patch target not found')
text = text.replace(old, new, 1)

p.write_text(text, encoding='utf-8')
print('Owner hero sun/moon rise animation applied.')
