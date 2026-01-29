import 'package:flutter/material.dart';

class ClientTabs extends StatelessWidget {
  const ClientTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return const TabBar(
      labelColor: Colors.blue,
      unselectedLabelColor: Colors.grey,
      indicatorColor: Colors.blue,
      tabs: [
        Tab(text: 'Overview'),
        Tab(text: 'Activity'),
        Tab(text: 'Orders'),
        Tab(text: 'Payments'),
      ],
    );
  }
}

