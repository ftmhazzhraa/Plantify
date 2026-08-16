import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import 'home/home_screen.dart';
import 'mall/mall_screen.dart';
import 'discover/discover_screen.dart';
import 'inbox/inbox_screen.dart';
import 'account/account_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;
  int _mallTab = 0;

  void _go(int i) => setState(() => _index = i);

  void _goMallTab(int tab) => setState(() {
    _index = 1;
    _mallTab = tab;
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          HomeScreen(onNavTap: _go, onMallTabTap: _goMallTab),
          MallScreen(key: ValueKey(_mallTab), initialTab: _mallTab),
          const DiscoverScreen(),
          const InboxScreen(),
          const AccountScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: _index, onTap: _go),
    );
  }
}
