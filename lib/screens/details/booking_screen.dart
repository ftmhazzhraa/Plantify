import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../models/models.dart';

class BookingScreen extends StatefulWidget {
  final PlantService service;
  const BookingScreen({super.key, required this.service});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _nameCtrl    = TextEditingController();
  final _phoneCtrl   = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _notesCtrl   = TextEditingController();
  String _date = '';
  String _time = '';

  static const _timeSlots = ['9:00 AM','10:00 AM','11:00 AM','1:00 PM','2:00 PM','3:00 PM','4:00 PM'];

  @override
  void dispose() {
    _nameCtrl.dispose(); _phoneCtrl.dispose();
    _addressCtrl.dispose(); _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(colorScheme: const ColorScheme.light(primary: AppColors.primaryDark)),
        child: child!,
      ),
    );
    if (d != null) setState(() => _date = '${d.day}/${d.month}/${d.year}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBg,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark, foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Book Service', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primaryDark.withOpacity(0.2))),
            child: Row(children: [
              ClipRRect(borderRadius: BorderRadius.circular(8),
                child: Image.asset(widget.service.image, width: 64, height: 64, fit: BoxFit.cover)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(widget.service.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
                const SizedBox(height: 2),
                Text('RM ${widget.service.price.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 13, color: AppColors.primaryMed, fontWeight: FontWeight.w600)),
              ])),
            ]),
          ),
          const SizedBox(height: 20),

          _section('Your Details'),
          _field(_nameCtrl, 'Full name', Icons.person_outline),
          const SizedBox(height: 12),
          _field(_phoneCtrl, 'Phone number', Icons.phone_outlined, type: TextInputType.phone),
          const SizedBox(height: 12),
          _field(_addressCtrl, 'Service address', Icons.location_on_outlined, maxLines: 2),
          const SizedBox(height: 20),

          _section('Select Date'),
          GestureDetector(
            onTap: _pickDate,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.divider)),
              child: Row(children: [
                const Icon(Icons.calendar_today_outlined, size: 20, color: AppColors.textGrey),
                const SizedBox(width: 12),
                Text(_date.isEmpty ? 'Choose a date' : _date,
                  style: TextStyle(fontSize: 13, color: _date.isEmpty ? AppColors.textGrey : AppColors.textDark)),
              ]),
            ),
          ),
          const SizedBox(height: 20),

          _section('Select Time'),
          Wrap(spacing: 8, runSpacing: 8,
            children: _timeSlots.map((t) => GestureDetector(
              onTap: () => setState(() => _time = t),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: _time == t ? AppColors.primaryDark : AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _time == t ? AppColors.primaryDark : AppColors.divider),
                ),
                child: Text(t, style: TextStyle(fontSize: 12,
                  color: _time == t ? Colors.white : AppColors.textDark,
                  fontWeight: _time == t ? FontWeight.bold : FontWeight.normal)),
              ),
            )).toList(),
          ),
          const SizedBox(height: 20),

          _section('Additional Notes'),
          _field(_notesCtrl, 'Any special requests?', Icons.note_outlined, maxLines: 3),
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
                    Text('Booking Confirmed!', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ]),
                  content: Text('Your booking for ${widget.service.name} has been confirmed. We will contact you shortly.'),
                  actions: [
                    ElevatedButton(
                      onPressed: () { Navigator.pop(context); Navigator.pop(context); },
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
              child: Text('Confirm Booking — RM ${widget.service.price.toStringAsFixed(2)}',
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
