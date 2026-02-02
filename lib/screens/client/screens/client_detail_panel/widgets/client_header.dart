import 'package:clwb_crm/screens/client/client_controller.dart';
import 'package:clwb_crm/screens/client/models/client_model.dart';
import 'package:clwb_crm/screens/client/screens/add_client/add_client_dialog.dart';
import 'package:clwb_crm/screens/client/screens/edit_client/edit_client_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClientHeader extends StatelessWidget {
  final ClientModel client;

  const ClientHeader({super.key, required this.client});

  @override
  Widget build(BuildContext context) {

    final cc = Get.find<ClientsController>();


    return Row(
      children: [
        CircleAvatar(
          radius: 26,
          child: Text(
            client.businessName.isNotEmpty
                ? client.businessName[0].toUpperCase()
                : '?',
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  client.businessName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Get.dialog(
                      EditClientDialog(
                        client: client, // 👈 pass client
                      ),
                      barrierDismissible: true,
                    );
                  },
                  icon: Icon(Icons.edit, color: Colors.grey, size: 20),
                ),
              ],
            ),
            Text(
              '${client.contactName} · ${client.contactRole}',
              style: const TextStyle(color: Colors.grey),
            ),
            Text(
              '+91 ${client.phone}',
              style: const TextStyle(color: Colors.grey),
            ),


                Row (
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Location: ${client.locations.first.area}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(width: 6),

                    IconButton(
                      padding: EdgeInsets.all(1),
                      tooltip: 'Open Google Maps',
                      onPressed: () => cc.openGoogleMaps(client.id),
                      icon: const Icon(
                        Icons.pin_drop_outlined,
                        color: Colors.grey,
                        size: 16,
                      ),
                    ),

                    IconButton(
                      tooltip: 'Edit Google Maps link',
                      onPressed: () => cc.openEditGoogleMapsDialog(client.id),
                      icon: const Icon(
                        Icons.link,
                        color: Colors.grey,
                        size: 20,
                      ),
                    ),
                    IconButton(
                      tooltip: 'Client media',
                      onPressed: () => cc.openClientMediaDialog(client.id),
                      icon: const Icon(Icons.photo_library_outlined, color: Colors.grey, size: 18),
                    ),
                  ],
                ),

          ],
        ),
      ],
    );
  }
}
