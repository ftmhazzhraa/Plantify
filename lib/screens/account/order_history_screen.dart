import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_assets.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  static const _orders = [
    {'id':'#PLT-2025-001','name':'Monstera Deliciosa','price':'RM 100.00','date':'12 Aug 2025','status':'Delivered','img':A.shop1},
    {'id':'#PLT-2025-002','name':'Peace Lily + Repotting Service','price':'RM 135.00','date':'5 Aug 2025','status':'Delivered','img':A.shop2},
    {'id':'#PLT-2025-003','name':'Golden Barrel Cactus','price':'RM 50.00','date':'28 Jul 2025','status':'Delivered','img':A.shop3},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBg,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark, foregroundColor: Colors.white, elevation: 0,
        title: const Text('Order History', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _orders.length,
        itemBuilder: (_, i) {
          final o = _orders[i];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.divider)),
            child: Row(children: [
              ClipRRect(borderRadius: BorderRadius.circular(8),
                child: Image.asset(o['img']!, width: 60, height: 60, fit: BoxFit.contain)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(o['id']!, style: const TextStyle(fontSize: 10, color: AppColors.textGrey)),
                const SizedBox(height: 2),
                Text(o['name']!, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textDark),
                  maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text(o['date']!, style: const TextStyle(fontSize: 11, color: AppColors.textGrey)),
              ])),
              const SizedBox(width: 8),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text(o['price']!, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primaryMed)),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(10)),
                  child: Text(o['status']!, style: const TextStyle(fontSize: 10, color: AppColors.primaryDark, fontWeight: FontWeight.w600))),
              ]),
            ]),
          );
        },
      ),
    );
  }
}
