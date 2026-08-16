import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameCtrl    = TextEditingController();
  final _emailCtrl   = TextEditingController();
  final _passCtrl    = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscure1 = true, _obscure2 = true;

  @override
  void dispose() {
    _nameCtrl.dispose(); _emailCtrl.dispose();
    _passCtrl.dispose(); _confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBg,
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(24, MediaQuery.of(context).padding.top + 32, 24, 32),
            decoration: const BoxDecoration(
              color: AppColors.primaryDark,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
            ),
            child: Column(children: [
              Image.network(
                'https://res.cloudinary.com/dbp2s9lc0/image/upload/v1786664816/Plantify_kgpn7b.png',
                width: 110,
                errorBuilder: (_,__,___) => const Text('Plantify',
                  style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 6),
              const Text('Create your account', style: TextStyle(color: Colors.white70, fontSize: 13)),
            ]),
          ),

          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Register', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textDark)),
              const SizedBox(height: 4),
              const Text('Fill in the details below', style: TextStyle(fontSize: 13, color: AppColors.textGrey)),
              const SizedBox(height: 24),

              _label('Full Name'),
              _field(_nameCtrl, 'Enter your full name', Icons.person_outline),
              const SizedBox(height: 14),

              _label('Email'),
              _field(_emailCtrl, 'Enter your email', Icons.email_outlined),
              const SizedBox(height: 14),

              _label('Password'),
              _field(_passCtrl, 'Create a password', Icons.lock_outline, obscure: _obscure1,
                suffix: IconButton(
                  icon: Icon(_obscure1 ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 20, color: AppColors.textGrey),
                  onPressed: () => setState(() => _obscure1 = !_obscure1),
                )),
              const SizedBox(height: 14),

              _label('Confirm Password'),
              _field(_confirmCtrl, 'Confirm your password', Icons.lock_outline, obscure: _obscure2,
                suffix: IconButton(
                  icon: Icon(_obscure2 ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 20, color: AppColors.textGrey),
                  onPressed: () => setState(() => _obscure2 = !_obscure2),
                )),
              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDark, foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Create Account', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 18),

              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text('Already have an account? ', style: TextStyle(color: AppColors.textGrey, fontSize: 13)),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text('Login', style: TextStyle(color: AppColors.primaryMed, fontSize: 13, fontWeight: FontWeight.bold)),
                ),
              ]),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _label(String t) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(t, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark)),
  );

  Widget _field(TextEditingController ctrl, String hint, IconData icon, {bool obscure = false, Widget? suffix}) {
    return Container(
      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider)),
      child: TextField(
        controller: ctrl, obscureText: obscure,
        style: const TextStyle(fontSize: 13, color: AppColors.textDark),
        decoration: InputDecoration(
          hintText: hint, hintStyle: const TextStyle(color: AppColors.textGrey, fontSize: 13),
          prefixIcon: Icon(icon, size: 20, color: AppColors.textGrey),
          suffixIcon: suffix, border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}
