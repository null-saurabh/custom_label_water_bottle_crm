import 'package:clwb_crm/screens/leads/add_lead_model.dart';
import 'package:clwb_crm/screens/leads/widgets/lead_activity/lead_activity_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

class LeadActivityTimeline extends StatelessWidget {
  final String leadId;
  const LeadActivityTimeline({super.key, required this.leadId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LeadActivityController>(
      init: LeadActivityController(leadId),
      builder: (controller) {
        return SingleChildScrollView(
          child: Obx(() {
            if (controller.activities.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'No activity yet',
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }
          
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.activities.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (_, i) {
                final a = controller.activities[i];
                return _ActivityItem(activity: a);
              },
            );
          }),
        );
      },
    );
  }
}





class _ActivityItem extends StatelessWidget {
  final LeadActivity activity;
  const _ActivityItem({required this.activity});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ActivityIcon(type: activity.type),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                activity.title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (activity.note.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    activity.note,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                  ),
                ),
              const SizedBox(height: 4),
              Text(
                _timeAgo(activity.at),
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}



class _ActivityIcon extends StatelessWidget {
  final LeadActivityType type;
  const _ActivityIcon({required this.type});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;

    switch (type) {
      case LeadActivityType.call:
        icon = Icons.call;
        color = Colors.green;
        break;
      case LeadActivityType.whatsapp:
        icon = Icons.chat;
        color = Colors.teal;
        break;
      case LeadActivityType.visit:
        icon = Icons.location_on;
        color = Colors.orange;
        break;
      case LeadActivityType.statusChanged:
        icon = Icons.sync_alt;
        color = Colors.blue;
        break;
      case LeadActivityType.followUp:
        icon = Icons.schedule;
        color = Colors.purple;
        break;
      case LeadActivityType.created:
        icon = Icons.flag;
        color = Colors.indigo;
        break;
      default:
        icon = Icons.notes;
        color = Colors.grey;
    }

    return CircleAvatar(
      radius: 16,
      backgroundColor: color.withOpacity(0.12),
      child: Icon(icon, size: 16, color: color),
    );
  }
}


String _timeAgo(DateTime dt) {
  final diff = DateTime.now().difference(dt);
  if (diff.inDays > 0) return '${diff.inDays}d ago';
  if (diff.inHours > 0) return '${diff.inHours}h ago';
  if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
  return 'Just now';
}

