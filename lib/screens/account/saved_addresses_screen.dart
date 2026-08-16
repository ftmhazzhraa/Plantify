import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class SavedAddressesScreen extends StatefulWidget {
  const SavedAddressesScreen({super.key});
  @override
  State<SavedAddressesScreen> createState() => _SavedAddressesScreenState();
}

class _SavedAddressesScreenState extends State<SavedAddressesScreen> {
  final _addresses = [
    {'label':'Home','address':'No. 12, Jalan Damai 3, Taman Damai Perdana, 68000 Ampang, Selangor','isDefault':true},
  ];

  void _addAddress() {
    final ctrl = TextEditingController();
    showDialog(context: context, builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Add New Address', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      content: TextField(controller: ctrl, maxLines: 3,
        decoration: InputDecoration(hintText: 'Enter full address',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)))),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            if (ctrl.text.isNotEmpty) {
              setState(() => _addresses.add({'label':'New Address','address':ctrl.text,'isDefault':false}));
            }
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryDark, foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          child: const Text('Add')),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBg,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark, foregroundColor: Colors.white, elevation: 0,
        title: const Text('Saved Addresses', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        actions: [IconButton(icon: const Icon(Icons.add), onPressed: _addAddress)],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _addresses.length,
        itemBuilder: (_, i) {
          final a = _addresses[i];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(12),
              border: Border.all(color: a['isDefault'] == true ? AppColors.primaryDark : AppColors.divider)),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.location_on_outlined, color: AppColors.primaryDark, size: 22)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Text(a['label'] as String, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                  if (a['isDefault'] == true) ...[
                    const SizedBox(width: 6),
                    Container(padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(8)),
                      child: const Text('Default', style: TextStyle(fontSize: 9, color: AppColors.primaryDark, fontWeight: FontWeight.bold))),
                  ],
                ]),
                const SizedBox(height: 4),
                Text(a['address'] as String, style: const TextStyle(fontSize: 12, color: AppColors.textGrey, height: 1.4)),
              ])),
              IconButton(icon: const Icon(Icons.delete_outline, size: 20, color: AppColors.textGrey),
                onPressed: () => setState(() => _addresses.removeAt(i))),
            ]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addAddress,
        backgroundColor: AppColors.primaryDark, foregroundColor: Colors.white,
        icon: const Icon(Icons.add), label: const Text('Add Address'),
      ),
    );
  }
}
