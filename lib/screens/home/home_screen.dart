import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_assets.dart';
import '../../data/mock_data.dart';
import '../details/appointment_screen.dart';
import '../details/discover_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  final ValueChanged<int> onNavTap;
  final ValueChanged<int> onMallTabTap;
  const HomeScreen({super.key, required this.onNavTap, required this.onMallTabTap});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _catIndex = 0;

  void _snack(String msg) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: AppColors.primaryDark,
      duration: const Duration(milliseconds: 1000),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: AppColors.screenBg,
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          // ── GREEN HEADER ──────────────────────────────────────
          Container(
            width: double.infinity,
            color: AppColors.primaryDark,
            padding: EdgeInsets.fromLTRB(16, top + 14, 16, 0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              // Logo
              Image.network(
                'https://res.cloudinary.com/dbp2s9lc0/image/upload/v1786664816/Plantify_kgpn7b.png',
                height: 44,
                errorBuilder: (_, __, ___) => const Text('Plantify',
                    style: TextStyle(color: Colors.white, fontSize: 26,
                        fontWeight: FontWeight.bold, letterSpacing: 3)),
              ),
              const SizedBox(height: 4),
              Container(height: 0.5, width: 120, color: Colors.white30),
              const SizedBox(height: 5),
              const Text('NEXT APPOINTMENT',
                  style: TextStyle(color: Colors.white70, fontSize: 9,
                      letterSpacing: 2.5)),
              const SizedBox(height: 10),

              // ── Appointment row — centred, assets icons, arrow right ──
              // IntrinsicWidth + Center ensures the whole row is centred
              // crossAxisAlignment.center ensures icons + text align vertically
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Calendar icon (asset)
                    Image.asset(A.iconCalendar,
                        width: 13, height: 13, color: Colors.white),
                    const SizedBox(width: 4),
                    const Text('14 Oct 2025',
                        style: TextStyle(color: Colors.white, fontSize: 11)),
                    const SizedBox(width: 10),

                    // Clock icon (asset)
                    Image.asset(A.iconClock,
                        width: 13, height: 13, color: Colors.white),
                    const SizedBox(width: 4),
                    const Text('12:30 PM',
                        style: TextStyle(color: Colors.white, fontSize: 11)),
                    const SizedBox(width: 10),

                    // Location icon (asset)
                    Image.asset(A.iconLocation,
                        width: 10, height: 13, color: Colors.white),
                    const SizedBox(width: 4),
                    const Text('123 Plant Street...',
                        style: TextStyle(color: Colors.white, fontSize: 11)),
                    const SizedBox(width: 10),

                    // Arrow button — right-facing, centred with text
                    Material(
                      color: AppColors.primaryMed,
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        splashColor: Colors.white24,
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(
                                builder: (_) => const AppointmentScreen())),
                        child: const Padding(
                          padding: EdgeInsets.all(7),
                          child: Icon(Icons.arrow_forward_ios,
                              size: 12, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Stats pill
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(14),
                      topRight: Radius.circular(14)),
                ),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                  _stat('CREDIT', 'RM100.00'),
                  Container(width: 1, height: 28, color: AppColors.divider),
                  _stat('POINTS', '10'),
                  Container(width: 1, height: 28, color: AppColors.divider),
                  _stat('PACKAGE', '1'),
                ]),
              ),
            ]),
          ),

          // ── BANNER ────────────────────────────────────────────
          ClipRect(
            child: SizedBox(
              height: 200, width: double.infinity,
              child: Image.asset(A.homeBanner, fit: BoxFit.cover),
            ),
          ),

          // ── SECTION BUTTONS: SHOP / SERVICES / POSTS ─────────
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(children: [
              Expanded(child: _sectionBtn(A.btnShop, () {
                widget.onNavTap(1); widget.onMallTabTap(0);
              })),
              const SizedBox(width: 8),
              Expanded(child: _sectionBtn(A.btnServices, () {
                widget.onNavTap(1); widget.onMallTabTap(1);
              })),
              const SizedBox(width: 8),
              Expanded(child: _sectionBtn(A.btnPosts, () {
                widget.onNavTap(1); widget.onMallTabTap(2);
              })),
            ]),
          ),

          // ── CATEGORIES SECTION LABEL ──────────────────────────
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('CATEGORIES',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                    letterSpacing: 0.3)),
          ),
          const SizedBox(height: 4),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('Browse plants by type',
                style: TextStyle(fontSize: 11, color: AppColors.textGrey)),
          ),
          const SizedBox(height: 12),

          // ── CATEGORY ICONS ────────────────────────────────────
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: MockData.categoryLabels.length,
              itemBuilder: (_, i) {
                final sel = _catIndex == i;
                return GestureDetector(
                  onTap: () {
                    setState(() => _catIndex = i);
                    _snack('${MockData.categoryLabels[i]} selected');
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    child: Column(children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        width: 66, height: 66,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: sel
                              ? AppColors.primaryDark.withOpacity(0.12)
                              : AppColors.white,
                          border: sel
                              ? Border.all(color: AppColors.primaryDark, width: 1.8)
                              : Border.all(color: AppColors.divider),
                          boxShadow: [BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 4, offset: const Offset(0, 2))],
                        ),
                        child: ClipOval(
                          child: Image.asset(MockData.categoryIcons[i],
                              fit: BoxFit.contain),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(MockData.categoryLabels[i],
                          style: TextStyle(
                              fontSize: 10,
                              color: sel ? AppColors.primaryDark : AppColors.textGrey,
                              fontWeight: sel ? FontWeight.bold : FontWeight.normal)),
                    ]),
                  ),
                );
              },
            ),
          ),

          // ── NEW SERVICES ───────────────────────────────────────
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('NEW SERVICES',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,
                        color: AppColors.textDark)),
                Text('Recommended based on your preference',
                    style: TextStyle(fontSize: 10, color: AppColors.textGrey)),
              ]),
              GestureDetector(
                onTap: () { widget.onNavTap(1); widget.onMallTabTap(1); },
                child: const Text('View All',
                    style: TextStyle(fontSize: 12, color: AppColors.primaryMed,
                        fontWeight: FontWeight.w600)),
              ),
            ]),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 145,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: MockData.services.length,
              itemBuilder: (_, i) {
                final s = MockData.services[i];
                return Material(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    splashColor: AppColors.primaryDark.withOpacity(0.08),
                    onTap: () { widget.onNavTap(1); widget.onMallTabTap(1); },
                    child: Container(
                      width: 165, margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                          border: Border.all(color: AppColors.divider, width: 0.5),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(10)),
                          child: Image.asset(s.image,
                              width: double.infinity, height: 80, fit: BoxFit.cover),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(s.name,
                                style: const TextStyle(fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textDark),
                                maxLines: 1, overflow: TextOverflow.ellipsis),
                            Text('RM ${s.price.toStringAsFixed(2)}',
                                style: const TextStyle(fontSize: 11,
                                    color: AppColors.primaryMed,
                                    fontWeight: FontWeight.w600)),
                          ]),
                        ),
                      ]),
                    ),
                  ),
                );
              },
            ),
          ),

          // ── TRENDING DISCOVERIES ───────────────────────────────
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('TRENDING DISCOVERIES',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,
                      color: AppColors.textDark)),
              GestureDetector(
                onTap: () => widget.onNavTap(2),
                child: const Text('View All',
                    style: TextStyle(fontSize: 12, color: AppColors.primaryMed,
                        fontWeight: FontWeight.w600))),
            ]),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(A.trending,
                    width: double.infinity, height: 155, fit: BoxFit.cover),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => widget.onNavTap(2),
                  icon: const Icon(Icons.explore_outlined, size: 18),
                  label: const Text('Explore',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDark,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ]),
          ),

          // ── LOCATION SECTION ───────────────────────────────────
          const SizedBox(height: 28),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('LOCATION',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,
                    color: AppColors.textDark, letterSpacing: 0.3)),
          ),
          const SizedBox(height: 10),

          // Map image from assets — actual Petaling Jaya / Selangor map
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/images/map_location.png',
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Location cards
          ..._locationCards(),
          const SizedBox(height: 28),
        ]),
      ),
    );
  }

  List<Widget> _locationCards() {
    const locations = [
      _LocationData(
        name: 'Sunway Pyramid',
        address: 'No. 3, Jalan PJS 11/15, Bandar Sunway, 47500 Petaling Jaya, Selangor',
        hours: '10am – 10pm',
      ),
      _LocationData(
        name: 'The Gardens Mall',
        address: 'Mid Valley City, Lingkaran Syed Putra, 59200 Kuala Lumpur',
        hours: '10am – 10pm',
      ),
    ];
    return locations.map((loc) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(loc.name,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold,
                  color: AppColors.textDark)),
          const SizedBox(height: 6),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Icon(Icons.location_on_outlined,
                size: 16, color: AppColors.primaryDark),
            const SizedBox(width: 6),
            Expanded(
              child: Text(loc.address,
                  style: const TextStyle(fontSize: 12,
                      color: AppColors.primaryMed,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.primaryMed,
                      height: 1.4)),
            ),
          ]),
          const SizedBox(height: 4),
          Row(children: [
            const Icon(Icons.access_time_outlined,
                size: 16, color: AppColors.textGrey),
            const SizedBox(width: 6),
            Text(loc.hours,
                style: const TextStyle(fontSize: 12, color: AppColors.textMed)),
          ]),
        ]),
      );
    }).toList();
  }

  Widget _stat(String label, String value) => Column(children: [
    Text(label,
        style: const TextStyle(fontSize: 9, color: AppColors.textGrey,
            letterSpacing: 0.5)),
    const SizedBox(height: 2),
    Text(value,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold,
            color: AppColors.textDark)),
  ]);

  Widget _sectionBtn(String asset, VoidCallback onTap) {
    return Material(
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        splashColor: Colors.white38, onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(asset, fit: BoxFit.cover, height: 48),
        ),
      ),
    );
  }
}

class _LocationData {
  final String name;
  final String address;
  final String hours;
  const _LocationData({required this.name, required this.address, required this.hours});
}

class _MapPin extends StatelessWidget {
  final String label;
  const _MapPin({required this.label});
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2),
                blurRadius: 4)]),
        child: Text(label,
            style: const TextStyle(fontSize: 7, fontWeight: FontWeight.bold,
                color: Colors.black87)),
      ),
      const Icon(Icons.location_on, size: 22, color: Colors.red),
    ]);
  }
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()..color = const Color(0xFFE8E0D0));
    final block = Paint()..color = const Color(0xFFD4C8B0);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width * 0.28, size.height * 0.4), block);
    canvas.drawRect(Rect.fromLTWH(size.width*0.32, size.height*0.45, size.width*0.36, size.height*0.5), block);
    final road = Paint()..color = Colors.white..strokeWidth = 10..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(0, size.height*0.35), Offset(size.width, size.height*0.35), road);
    canvas.drawLine(Offset(0, size.height*0.68), Offset(size.width, size.height*0.68), road);
    canvas.drawLine(Offset(size.width*0.30, 0), Offset(size.width*0.30, size.height), road);
    canvas.drawLine(Offset(size.width*0.70, 0), Offset(size.width*0.70, size.height), road);
  }
  @override bool shouldRepaint(_) => false;
}
