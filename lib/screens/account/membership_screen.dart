import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class MembershipScreen extends StatelessWidget {
  const MembershipScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBg,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark, foregroundColor: Colors.white, elevation: 0,
        title: const Text('Membership & Package', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          // Current package card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: AppColors.primaryDark, borderRadius: BorderRadius.circular(16)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Row(children: [
                Icon(Icons.card_membership, color: Colors.white70, size: 20),
                SizedBox(width: 8),
                Text('Current Package', style: TextStyle(color: Colors.white70, fontSize: 12)),
              ]),
              const SizedBox(height: 8),
              const Text('Basic Member', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Row(children: [
                _statChip('10', 'Points'),
                const SizedBox(width: 12),
                _statChip('RM 100', 'Credit'),
                const SizedBox(width: 12),
                _statChip('1', 'Package'),
              ]),
            ]),
          ),
          const SizedBox(height: 24),
          const Align(alignment: Alignment.centerLeft,
            child: Text('Upgrade Your Plan', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textDark))),
          const SizedBox(height: 12),
          ...[
            {'name':'Silver Member','price':'RM 29/month','perks':['50 points/month','RM 200 credit','Priority booking','5% discount on all'],'color':AppColors.primaryMed},
            {'name':'Gold Member','price':'RM 59/month','perks':['120 points/month','RM 500 credit','Free delivery','10% discount on all','Expert consultation'],'color':AppColors.primaryDark},
          ].map((pkg) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white, borderRadius: BorderRadius.circular(12),
              border: Border.all(color: (pkg['color'] as Color).withOpacity(0.3))),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(pkg['name'] as String, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: pkg['color'] as Color)),
                Text(pkg['price'] as String, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: pkg['color'] as Color)),
              ]),
              const SizedBox(height: 10),
              ...(pkg['perks'] as List<String>).map((perk) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(children: [
                  Icon(Icons.check_circle_outline, size: 14, color: pkg['color'] as Color),
                  const SizedBox(width: 8),
                  Text(perk, style: const TextStyle(fontSize: 12, color: AppColors.textMed)),
                ]),
              )),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Upgrade to ${pkg['name']} coming soon!'),
                    backgroundColor: AppColors.primaryDark)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: pkg['color'] as Color, foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 12)),
                  child: Text('Upgrade to ${pkg['name']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                ),
              ),
            ]),
          )),
        ]),
      ),
    );
  }

  static Widget _statChip(String val, String label) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
    child: Column(children: [
      Text(val, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
      Text(label, style: const TextStyle(color: Colors.white60, fontSize: 10)),
    ]),
  );
}
