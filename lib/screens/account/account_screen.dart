import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_assets.dart';
import 'edit_profile_screen.dart';
import 'order_history_screen.dart';
import 'saved_favourites_screen.dart';
import 'saved_addresses_screen.dart';
import 'membership_screen.dart';
import 'my_plants_screen.dart';
import '../../data/app_state.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});
  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool _notificationsOn = true;
  bool _locationOn = true;

  void _snack(String msg) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg),
      backgroundColor: AppColors.primaryDark, behavior: SnackBarBehavior.floating,
      duration: const Duration(milliseconds: 1000), margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))));
  }

  void _showSupport(String title, String body) {
    showModalBottomSheet(
      context: context,
      // isScrollControlled lets the sheet grow taller than 50% of screen
      // so long content like Help & FAQ never overflows
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
      builder: (ctx) {
        // Clamp height to 80% of screen so it never goes full-screen
        final maxH = MediaQuery.of(ctx).size.height * 0.80;
        return ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxH),
          child: Padding(
            // Add keyboard inset so content stays above keyboard if needed
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Drag handle
                const SizedBox(height: 12),
                Center(
                  child: Container(
                    width: 40, height: 4,
                    decoration: BoxDecoration(
                        color: AppColors.divider,
                        borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                const SizedBox(height: 14),
                // Title (not scrollable — stays pinned at top)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(title,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark)),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Divider(height: 20),
                ),
                // Body — scrollable so long content never overflows
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(body,
                        style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textMed,
                            height: 1.7)),
                  ),
                ),
                const SizedBox(height: 20),
                // Close button always visible at the bottom
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryDark,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Close',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _push(Widget w) => Navigator.push(context, MaterialPageRoute(builder: (_) => w));

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: AppColors.screenBg,
      body: SingleChildScrollView(
        child: Column(children: [
          // Header
          Container(
            color: AppColors.primaryDark,
            padding: EdgeInsets.fromLTRB(16, top + 16, 16, 28),
            child: Column(children: [
              Stack(alignment: Alignment.bottomRight, children: [
                CircleAvatar(radius: 44, backgroundColor: AppColors.primaryMed,
                  child: const Text('E', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold))),
                Material(color: AppColors.white, shape: const CircleBorder(),
                  child: InkWell(customBorder: const CircleBorder(),
                    onTap: () => _push(const EditProfileScreen()),
                    child: const Padding(padding: EdgeInsets.all(5),
                      child: Icon(Icons.camera_alt_outlined, size: 16, color: AppColors.primaryDark)))),
              ]),
              const SizedBox(height: 12),
              Text(AppState.instance.profileName, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text(AppState.instance.profileEmail, style: const TextStyle(color: Colors.white60, fontSize: 12)),
              const SizedBox(height: 16),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                _badge('10','Points'), Container(width:1,height:36,color:Colors.white24),
                _badge('RM100','Credit'), Container(width:1,height:36,color:Colors.white24),
                _badge('1','Package'),
              ]),
            ]),
          ),

          // My Plants
          Padding(padding: const EdgeInsets.fromLTRB(16,16,16,0),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('My Plants', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textDark)),
              GestureDetector(onTap: () => _push(const MyPlantsScreen()),
                child: const Text('View All', style: TextStyle(fontSize: 12, color: AppColors.primaryMed, fontWeight: FontWeight.w600))),
            ])),
          const SizedBox(height: 10),
          SizedBox(
            height: 90,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 5,
              itemBuilder: (_, i) {
                const names = ['Monstera','Lily','Cactus','Fig','Snake'];
                const icons = [A.shop1, A.shop2, A.shop3, A.shop4, A.shop5];
                return GestureDetector(
                  onTap: () => _push(const MyPlantsScreen()),
                  child: Container(
                    width: 72, margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.divider)),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Image.asset(icons[i], width: 40, height: 40, fit: BoxFit.contain),
                      const SizedBox(height: 4),
                      Text(names[i], style: const TextStyle(fontSize: 9, color: AppColors.textGrey), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
                    ]),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          // Account section
          _sLabel('Account'),
          _menuItem(Icons.person_outline, 'Edit Profile', () => _push(const EditProfileScreen())),
          _menuItem(Icons.history, 'Order History', () => _push(const OrderHistoryScreen())),
          _menuItem(Icons.favorite_border, 'Saved / Favourites', () => _push(const SavedFavouritesScreen())),
          _menuItem(Icons.location_on_outlined, 'Saved Addresses', () => _push(const SavedAddressesScreen())),
          _menuItem(Icons.card_membership_outlined, 'Membership & Package', () => _push(const MembershipScreen())),

          const SizedBox(height: 8),
          _sLabel('Preferences'),
          _toggleItem(Icons.notifications_outlined, 'Push Notifications', _notificationsOn,
            (v) { setState(() => _notificationsOn = v); _snack(v ? 'Notifications on' : 'Notifications off'); }),
          _toggleItem(Icons.location_on_outlined, 'Location Access', _locationOn,
            (v) { setState(() => _locationOn = v); _snack(v ? 'Location on' : 'Location off'); }),

          const SizedBox(height: 8),
          _sLabel('Support'),
          _menuItem(Icons.help_outline, 'Help & FAQ', () => _showSupport('Help & FAQ',
            'Q: How do I track my order?\nA: Go to Order History to see your order status.\n\nQ: Can I cancel an order?\nA: Orders can be cancelled within 1 hour of placing them.\n\nQ: How do I book a service?\nA: Go to Mall > Services and tap Book Now on your preferred service.\n\nQ: How do I contact support?\nA: Use the Contact Us option below.')),
          _menuItem(Icons.chat_bubble_outline, 'Contact Us', () => _showSupport('Contact Us',
            'Email: support@plantify.com\nPhone: +60 3-1234 5678\nHours: Mon–Fri, 9 AM–6 PM\n\nFor urgent matters, please call us directly. For general enquiries, email is the fastest way to reach our team.')),
          _menuItem(Icons.privacy_tip_outlined, 'Privacy Policy', () => _showSupport('Privacy Policy',
            'Plantify respects your privacy. We collect only the information needed to provide our services, including name, email, and order details.\n\nWe do not share your personal data with third parties without your consent. All data is encrypted and stored securely.\n\nYou may request deletion of your data at any time by contacting our support team.')),

          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: Material(color: Colors.transparent, borderRadius: BorderRadius.circular(12),
              child: InkWell(borderRadius: BorderRadius.circular(12), splashColor: Colors.red.withOpacity(0.1),
                onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false),
                child: Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(border: Border.all(color: Colors.red.shade300), borderRadius: BorderRadius.circular(12)),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(Icons.logout, color: Colors.red.shade400, size: 18),
                    const SizedBox(width: 8),
                    Text('Log Out', style: TextStyle(color: Colors.red.shade400, fontSize: 14, fontWeight: FontWeight.bold)),
                  ])))),
          ),
        ]),
      ),
    );
  }

  Widget _badge(String val, String label) => Column(children: [
    Text(val, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
    Text(label, style: const TextStyle(color: Colors.white60, fontSize: 10)),
  ]);

  Widget _sLabel(String t) => Padding(padding: const EdgeInsets.fromLTRB(16,0,16,4),
    child: Text(t.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textGrey, letterSpacing: 1.2)));

  Widget _menuItem(IconData icon, String label, VoidCallback onTap) {
    return Material(color: AppColors.white,
      child: InkWell(splashColor: AppColors.primaryDark.withOpacity(0.07), onTap: onTap,
        child: Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.divider))),
          child: Row(children: [
            Icon(icon, size: 20, color: AppColors.primaryDark),
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textDark))),
            const Icon(Icons.chevron_right, size: 18, color: AppColors.navInactive),
          ]))));
  }

  Widget _toggleItem(IconData icon, String label, bool val, ValueChanged<bool> onChange) {
    return Material(color: AppColors.white,
      child: Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.divider))),
        child: Row(children: [
          Icon(icon, size: 20, color: AppColors.primaryDark),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textDark))),
          Switch(value: val, onChanged: onChange, activeColor: AppColors.primaryDark),
        ])));
  }
}
