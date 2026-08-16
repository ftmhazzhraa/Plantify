import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class AppointmentScreen extends StatelessWidget {
  const AppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBg,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Appointment Details',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          // ── Status badge ─────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(20)),
            child: const Text('Upcoming',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,
                    color: AppColors.primaryDark)),
          ),
          const SizedBox(height: 20),

          // ── Main detail card ──────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.divider),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              // Service name
              const Text('Garden Maintenance',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,
                      color: AppColors.textDark)),
              const SizedBox(height: 4),
              const Text('Plantify Professional Service',
                  style: TextStyle(fontSize: 13, color: AppColors.textGrey)),
              const Divider(height: 28),

              // Date row
              _detailRow(
                Icons.calendar_today_outlined,
                'Date',
                '26 September 2026',
              ),
              const SizedBox(height: 16),

              // Time row
              _detailRow(
                Icons.access_time_outlined,
                'Time',
                '12:30 PM – 2:30 PM',
              ),
              const SizedBox(height: 16),

              // Location row
              _detailRow(
                Icons.location_on_outlined,
                'Address',
                '123 Plant Street, 1/1, Taman Damai, 68000 Ampang, Selangor',
              ),
              const SizedBox(height: 16),

              // Duration row
              _detailRow(
                Icons.timer_outlined,
                'Duration',
                '2 hours',
              ),
            ]),
          ),
          const SizedBox(height: 20),

          // ── Notes card ────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.divider),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Notes',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,
                      color: AppColors.textDark)),
              const SizedBox(height: 8),
              const Text(
                'Please ensure outdoor plants are accessible. '
                'Our specialist will bring all necessary equipment.',
                style: TextStyle(fontSize: 13, color: AppColors.textMed,
                    height: 1.5),
              ),
            ]),
          ),
          const SizedBox(height: 20),

          // ── Actions ───────────────────────────────────────────
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Appointment reschedule requested.'),
                  backgroundColor: AppColors.primaryDark,
                  behavior: SnackBarBehavior.floating,
                ));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryDark,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Reschedule',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Appointment cancellation requested.'),
                  backgroundColor: AppColors.primaryDark,
                  behavior: SnackBarBehavior.floating,
                ));
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: BorderSide(color: Colors.red.shade300),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Cancel Appointment',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ),
          ),
          const SizedBox(height: 24),
        ]),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(icon, size: 20, color: AppColors.primaryDark),
      const SizedBox(width: 12),
      Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label,
              style: const TextStyle(fontSize: 11, color: AppColors.textGrey,
                  letterSpacing: 0.3)),
          const SizedBox(height: 2),
          Text(value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                  color: AppColors.textDark, height: 1.4)),
        ]),
      ),
    ]);
  }
}
