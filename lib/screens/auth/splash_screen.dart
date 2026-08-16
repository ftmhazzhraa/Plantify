import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1400));
    _fade  = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _scale = Tween<double>(begin: 0.7, end: 1.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut));
    _ctrl.forward();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: Center(
        child: FadeTransition(
          opacity: _fade,
          child: ScaleTransition(
            scale: _scale,
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Image.network(
                'https://res.cloudinary.com/dbp2s9lc0/image/upload/v1786664816/Plantify_kgpn7b.png',
                width: 200,
                errorBuilder: (_, __, ___) => const Text('Plantify',
                    style: TextStyle(color: Colors.white, fontSize: 40,
                        fontWeight: FontWeight.bold, letterSpacing: 4)),
              ),
              const SizedBox(height: 18),
              // Updated: exclamation mark added
              const Text('Your Green World!',
                  style: TextStyle(color: Colors.white60, fontSize: 15,
                      letterSpacing: 2)),
            ]),
          ),
        ),
      ),
    );
  }
}
