import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_assets.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({super.key, required this.currentIndex, required this.onTap});

  static const _items = [
    _NavDef('HOME',     A.navHomeGreen, A.navHome),
    _NavDef('MALL',     A.navMallGreen, A.navMall),
    _NavDef('DISCOVER', A.navDiscover,  A.navDiscover),
    _NavDef('INBOX',    A.navInbox,     A.navInbox),
    _NavDef('ACCOUNT',  A.navAccount,   A.navAccount),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.divider))),
      child: SafeArea(top: false,
        child: SizedBox(height: 62,
          child: Row(children: List.generate(_items.length, (i) {
            final item = _items[i];
            final active = currentIndex == i;
            return Expanded(
              child: InkWell(
                onTap: () => onTap(i),
                splashColor: AppColors.primaryDark.withOpacity(0.10),
                highlightColor: AppColors.primaryDark.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 2.5, width: active ? 32 : 0,
                    decoration: BoxDecoration(color: AppColors.primaryDark, borderRadius: BorderRadius.circular(2))),
                  const SizedBox(height: 5),
                  AnimatedScale(duration: const Duration(milliseconds: 200), scale: active ? 1.12 : 1.0,
                    child: Image.asset(active ? item.iconActive : item.iconInactive, height: 22,
                      color: active ? AppColors.primaryDark : AppColors.navInactive)),
                  const SizedBox(height: 3),
                  Text(item.label, style: TextStyle(fontSize: 9,
                    fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                    color: active ? AppColors.primaryDark : AppColors.navInactive,
                    letterSpacing: 0.3)),
                ]),
              ),
            );
          }))),
      ),
    );
  }
}

class _NavDef {
  final String label;
  final String iconActive;
  final String iconInactive;
  const _NavDef(this.label, this.iconActive, this.iconInactive);
}
