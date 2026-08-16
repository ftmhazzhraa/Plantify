import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class BuyScreen extends StatefulWidget {
  final String productName;
  final double price;
  const BuyScreen({super.key, required this.productName, required this.price});

  @override
  State<BuyScreen> createState() => _BuyScreenState();
}

class _BuyScreenState extends State<BuyScreen> {
  final _nameCtrl    = TextEditingController();
  final _phoneCtrl   = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _notesCtrl   = TextEditingController();
  String _selectedPayment = 'Online Banking';

  static const _paymentMethods = ['Online Banking', 'Credit / Debit Card', 'E-Wallet', 'Cash on Delivery'];

  @override
  void dispose() {
    _nameCtrl.dispose(); _phoneCtrl.dispose();
    _addressCtrl.dispose(); _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBg,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Checkout', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _section('Order Summary'),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.divider)),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Expanded(child: Text(widget.productName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textDark))),
              Text('RM ${widget.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryMed)),
            ]),
          ),
          const SizedBox(height: 20),

          _section('Delivery Details'),
          _field(_nameCtrl, 'Full name', Icons.person_outline),
          const SizedBox(height: 12),
          _field(_phoneCtrl, 'Phone number', Icons.phone_outlined, type: TextInputType.phone),
          const SizedBox(height: 12),
          _field(_addressCtrl, 'Delivery address', Icons.location_on_outlined, maxLines: 2),
          const SizedBox(height: 12),
          _field(_notesCtrl, 'Notes (optional)', Icons.note_outlined, maxLines: 2),
          const SizedBox(height: 20),

          _section('Payment Method'),
          ...List.generate(_paymentMethods.length, (i) {
            final m = _paymentMethods[i];
            return GestureDetector(
              onTap: () => setState(() => _selectedPayment = m),
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: _selectedPayment == m ? AppColors.primaryLight : AppColors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: _selectedPayment == m ? AppColors.primaryDark : AppColors.divider),
                ),
                child: Row(children: [
                  Container(
                    width: 18, height: 18,
                    decoration: BoxDecoration(shape: BoxShape.circle,
                      border: Border.all(color: _selectedPayment == m ? AppColors.primaryDark : AppColors.navInactive, width: 2)),
                    child: _selectedPayment == m
                      ? Center(child: Container(width: 8, height: 8,
                          decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primaryDark)))
                      : null,
                  ),
                  const SizedBox(width: 12),
                  Text(m, style: TextStyle(fontSize: 13, color: _selectedPayment == m ? AppColors.primaryDark : AppColors.textDark,
                    fontWeight: _selectedPayment == m ? FontWeight.bold : FontWeight.normal)),
                ]),
              ),
            );
          }),
          const SizedBox(height: 28),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                showDialog(context: context, builder: (_) => AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  title: const Row(children: [
                    Icon(Icons.check_circle, color: AppColors.primaryDark, size: 28),
                    SizedBox(width: 10),
                    Text('Order Placed!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ]),
                  content: const Text('Your order has been placed successfully. We will notify you once it is confirmed.'),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryDark, foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                      child: const Text('Done'),
                    ),
                  ],
                ));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryDark, foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text('Place Order — RM ${widget.price.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 20),
        ]),
      ),
    );
  }

  Widget _section(String t) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Text(t, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark)),
  );

  Widget _field(TextEditingController ctrl, String hint, IconData icon, {TextInputType? type, int maxLines = 1}) {
    return Container(
      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.divider)),
      child: TextField(
        controller: ctrl, keyboardType: type, maxLines: maxLines,
        style: const TextStyle(fontSize: 13, color: AppColors.textDark),
        decoration: InputDecoration(
          hintText: hint, hintStyle: const TextStyle(color: AppColors.textGrey, fontSize: 13),
          prefixIcon: Icon(icon, size: 20, color: AppColors.textGrey),
          border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        ),
      ),
    );
  }
}
