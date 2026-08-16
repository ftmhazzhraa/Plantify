import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = TextEditingController();
    return Scaffold(
      backgroundColor: AppColors.screenBg,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Forgot Password', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(12)),
            child: Row(children: [
              const Icon(Icons.lock_reset, color: AppColors.primaryDark, size: 32),
              const SizedBox(width: 14),
              const Expanded(child: Text(
                'Enter your email and we will send you a link to reset your password.',
                style: TextStyle(color: AppColors.primaryDark, fontSize: 13, height: 1.5),
              )),
            ]),
          ),
          const SizedBox(height: 28),
          const Text('Email Address', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark)),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.divider)),
            child: TextField(
              controller: ctrl,
              style: const TextStyle(fontSize: 13, color: AppColors.textDark),
              decoration: const InputDecoration(
                hintText: 'Enter your email',
                hintStyle: TextStyle(color: AppColors.textGrey, fontSize: 13),
                prefixIcon: Icon(Icons.email_outlined, size: 20, color: AppColors.textGrey),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Password reset link sent!'),
                  backgroundColor: AppColors.primaryDark,
                ));
                Future.delayed(const Duration(seconds: 2), () {
                  if (context.mounted) Navigator.pop(context);
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryDark, foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Send Reset Link', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            ),
          ),
        ]),
      ),
    );
  }
}
