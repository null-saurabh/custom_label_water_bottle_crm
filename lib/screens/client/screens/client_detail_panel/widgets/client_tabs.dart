import 'package:flutter/material.dart';

class ClientTabs extends StatelessWidget {
  const ClientTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: TabBar(
        labelColor: Colors.blue,
        unselectedLabelColor: Colors.grey,
        indicatorColor: Colors.blue,
        tabs: const [
          Tab(text: 'Overview'),
          Tab(text: 'Pricing & Packs'),
          Tab(text: 'Orders'),
          Tab(text: 'Payments'),
          Tab(text: 'Notes & Communication'),
        ],
      ),
    );
  }
}
