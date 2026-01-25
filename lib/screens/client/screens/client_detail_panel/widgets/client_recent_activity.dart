import 'package:clwb_crm/screens/client/client_controller.dart';
import 'package:clwb_crm/screens/client/models/client_model.dart';
import 'package:clwb_crm/screens/client/screens/client_detail_panel/client_activity_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RecentActivityList extends GetView<ClientsController> {
  const RecentActivityList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {



      final clientId = controller.selectedClientId.value;

      if (clientId == null) {
        return const Center(
          child: Text('Select a client to view activity'),
        );
      }

      if (!Get.isRegistered<ClientActivityController>(tag: clientId)) {
        return const Center(
          child: Text('Select a client to view activity'),
        );
      }

      final activityController =
      Get.find<ClientActivityController>(tag: clientId);

      final activities = activityController.activities;

      if (activities.isEmpty) {
        return const Center(
          child: Text(
            'No recent activity',
            style: TextStyle(color: Colors.grey),
          ),
        );
      }

      final grouped = _groupByDate(activities);

      return Container(
        key: ValueKey(clientId), // 🔥 FORCE REBUILD ON CLIENT CHANGE
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            ...grouped.entries.map(
                  (entry) => _dateSection(entry.key, entry.value),
            ),
          ],
        ),
      );
    });
  }

  // ----------------------------
  // UI HELPERS (UNCHANGED LOOK)
  // ----------------------------

  Widget _dateSection(String date, List<ClientActivity> activities) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 24),
        Text(
          date,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 12),
        ...activities.map(_activityTile),
      ],
    );
  }

  Widget _activityTile(ClientActivity activity) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _activityIcon(activity.type),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      DateFormat('h:mm a').format(activity.at),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      activity.userName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      activity.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                if (activity.note.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    activity.note,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('View'),
          ),
        ],
      ),
    );
  }

  Widget _activityIcon(ClientActivityType type) {
    IconData icon;
    Color color;

    switch (type) {
      case ClientActivityType.order:
        icon = Icons.check_circle;
        color = const Color(0xFF4ADE80);
        break;
      case ClientActivityType.note:
        icon = Icons.note;
        color = const Color(0xFF94A3B8);
        break;
      case ClientActivityType.call:
        icon = Icons.call;
        color = const Color(0xFF22C55E);
        break;
      case ClientActivityType.email:
        icon = Icons.email;
        color = const Color(0xFF3B82F6);
        break;
      default:
        icon = Icons.circle;
        color = Colors.grey;
    }

    return CircleAvatar(
      radius: 14,
      backgroundColor: color.withOpacity(0.15),
      child: Icon(icon, size: 16, color: color),
    );
  }

  Map<String, List<ClientActivity>> _groupByDate(
      List<ClientActivity> activities,
      ) {
    final map = <String, List<ClientActivity>>{};

    for (final a in activities) {
      final date =
      DateFormat('EEEE, MMM d, yyyy').format(a.at);
      map.putIfAbsent(date, () => []).add(a);
    }

    return map;
  }
}
