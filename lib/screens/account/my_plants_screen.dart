import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_assets.dart';

class MyPlantsScreen extends StatelessWidget {
  const MyPlantsScreen({super.key});

  static const _plants = [
    {'name':'Monstera','icon':A.shop1,'status':'Healthy','water':'Every 7 days','light':'Indirect light'},
    {'name':'Peace Lily','icon':A.shop2,'status':'Needs water','water':'Every 5 days','light':'Low light'},
    {'name':'Cactus','icon':A.shop3,'status':'Healthy','water':'Every 14 days','light':'Full sun'},
    {'name':'Fiddle Leaf Fig','icon':A.shop4,'status':'Healthy','water':'Every 7 days','light':'Bright indirect'},
    {'name':'Snake Plant','icon':A.shop5,'status':'Healthy','water':'Every 10 days','light':'Any light'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBg,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark, foregroundColor: Colors.white, elevation: 0,
        title: const Text('My Plants', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.82),
        itemCount: _plants.length,
        itemBuilder: (_, i) {
          final p = _plants[i];
          final healthy = p['status'] == 'Healthy';
          return Container(
            decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.divider)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.asset(p['icon']!, width: double.infinity, height: 110, fit: BoxFit.contain),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(p['name']!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: healthy ? AppColors.primaryLight : Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(10)),
                    child: Text(p['status']!, style: TextStyle(fontSize: 10,
                      color: healthy ? AppColors.primaryDark : Colors.orange.shade700,
                      fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(height: 5),
                  Row(children: [
                    const Icon(Icons.water_drop_outlined, size: 11, color: AppColors.textGrey),
                    const SizedBox(width: 3),
                    Text(p['water']!, style: const TextStyle(fontSize: 10, color: AppColors.textGrey)),
                  ]),
                ]),
              ),
            ]),
          );
        },
      ),
    );
  }
}
