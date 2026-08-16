import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../data/app_state.dart';

// ── Cart Checkout Screen ───────────────────────────────────────
// Reached by tapping "Checkout" in the Cart tab of Saved/Favourites.
// Shows order summary, delivery form, payment method selector,
// and a Place Order button that clears the cart on success.

class CartCheckoutScreen extends StatefulWidget {
  const CartCheckoutScreen({super.key});

  @override
  State<CartCheckoutScreen> createState() => _CartCheckoutScreenState();
}

class _CartCheckoutScreenState extends State<CartCheckoutScreen> {
  final _nameCtrl    = TextEditingController();
  final _phoneCtrl   = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _notesCtrl   = TextEditingController();
  String _payment    = 'Online Banking';

  static const _paymentMethods = [
    'Online Banking',
    'Credit / Debit Card',
    'E-Wallet',
    'Cash on Delivery',
  ];

  @override
  void dispose() {
    _nameCtrl.dispose(); _phoneCtrl.dispose();
    _addressCtrl.dispose(); _notesCtrl.dispose();
    super.dispose();
  }

  void _placeOrder() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(children: [
          Icon(Icons.check_circle, color: AppColors.primaryDark, size: 28),
          SizedBox(width: 10),
          Text('Order Placed!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ]),
        content: const Text(
            'Your order has been placed successfully. '
            'We will notify you once it is confirmed and dispatched.'),
        actions: [
          ElevatedButton(
            onPressed: () {
              // Clear the cart in AppState
              AppState.instance.clearCart();
              // Pop dialog + this screen + go back to Saved/Favourites
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryDark,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Done',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart  = AppState.instance.cartItems;
    final total = AppState.instance.cartTotal;

    return Scaffold(
      backgroundColor: AppColors.screenBg,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Checkout',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          // ── Order Summary ──────────────────────────────────
          _sectionTitle('Order Summary'),
          Container(
            decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.divider)),
            child: Column(children: [
              ...cart.asMap().entries.map((e) {
                final i    = e.key;
                final item = e.value;
                return Column(children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    child: Row(children: [
                      Container(
                        width: 36, height: 36,
                        decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(6)),
                        child: const Icon(Icons.local_florist_outlined,
                            color: AppColors.primaryDark, size: 20),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(item.name,
                            style: const TextStyle(fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark)),
                      ),
                      Text('× ${item.qty}',
                          style: const TextStyle(fontSize: 12,
                              color: AppColors.textGrey)),
                      const SizedBox(width: 10),
                      Text(
                        'RM ${(item.price * item.qty).toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryMed),
                      ),
                    ]),
                  ),
                  if (i < cart.length - 1)
                    const Divider(height: 1, indent: 14, endIndent: 14),
                ]);
              }),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                  const Text('Total',
                      style: TextStyle(fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark)),
                  Text(
                    'RM ${total.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryDark),
                  ),
                ]),
              ),
            ]),
          ),
          const SizedBox(height: 20),

          // ── Delivery Details ───────────────────────────────
          _sectionTitle('Delivery Details'),
          _field(_nameCtrl,    'Full name',         Icons.person_outline),
          const SizedBox(height: 12),
          _field(_phoneCtrl,   'Phone number',      Icons.phone_outlined,
              type: TextInputType.phone),
          const SizedBox(height: 12),
          _field(_addressCtrl, 'Delivery address',  Icons.location_on_outlined,
              maxLines: 2),
          const SizedBox(height: 12),
          _field(_notesCtrl,   'Notes (optional)',  Icons.note_outlined,
              maxLines: 2),
          const SizedBox(height: 20),

          // ── Payment Method ─────────────────────────────────
          _sectionTitle('Payment Method'),
          ..._paymentMethods.map((pm) {
            final sel = _payment == pm;
            return GestureDetector(
              onTap: () => setState(() => _payment = pm),
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: sel ? AppColors.primaryLight : AppColors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: sel ? AppColors.primaryDark : AppColors.divider),
                ),
                child: Row(children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 18, height: 18,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: sel
                                ? AppColors.primaryDark
                                : AppColors.navInactive,
                            width: 2)),
                    child: sel
                        ? Center(
                            child: Container(
                              width: 8, height: 8,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.primaryDark),
                            ))
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Text(pm,
                      style: TextStyle(
                          fontSize: 13,
                          color: sel
                              ? AppColors.primaryDark
                              : AppColors.textDark,
                          fontWeight: sel
                              ? FontWeight.bold
                              : FontWeight.normal)),
                ]),
              ),
            );
          }),
          const SizedBox(height: 28),

          // ── Place Order button ─────────────────────────────
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _placeOrder,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryDark,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                'Place Order — RM ${total.toStringAsFixed(2)}',
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ]),
      ),
    );
  }

  Widget _sectionTitle(String t) => Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(t,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold,
              color: AppColors.textDark)));

  Widget _field(TextEditingController ctrl, String hint, IconData icon,
      {TextInputType? type, int maxLines = 1}) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider)),
      child: TextField(
        controller: ctrl,
        keyboardType: type,
        maxLines: maxLines,
        style: const TextStyle(fontSize: 13, color: AppColors.textDark),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: AppColors.textGrey, fontSize: 13),
          prefixIcon: Icon(icon, size: 20, color: AppColors.textGrey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
              vertical: 14, horizontal: 12),
        ),
      ),
    );
  }
}
