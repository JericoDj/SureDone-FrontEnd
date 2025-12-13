import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppShell extends StatelessWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: _BottomNavBar(),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).uri.toString();

    int currentIndex = 0;

    if (currentLocation.startsWith("/activity")) currentIndex = 1;
    else if (currentLocation.startsWith("/messages")) currentIndex = 2;
    else if (currentLocation.startsWith("/wallet")) currentIndex = 3;
    else if (currentLocation.startsWith("/profile")) currentIndex = 4;

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        switch (index) {
          case 0:
            context.go("/home");
            break;
          case 1:
            context.go("/activity");
            break;
          case 2:
            context.go("/messages");
            break;
          case 3:
            context.go("/wallet");
            break;
          case 4:
            context.go("/profile");
            break;
        }
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.blueAccent,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.event_note), label: "Activity"),
        BottomNavigationBarItem(icon: Icon(Icons.chat_bubble), label: "Messages"),
        BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: "Wallet"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }
}
