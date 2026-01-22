import 'package:clwb_crm/screens/client/client_controller.dart';
import 'package:clwb_crm/screens/client/models/client_model.dart';
import 'package:clwb_crm/screens/client/screens/client_list_panel/widgets/client_list_filter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClientListPanel extends GetView<ClientsController> {
  const ClientListPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(color: Color(0xFFE5E7EB)),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(onTap:(){
            controller.seedOnce();
          },child: Text("Clients",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
          const SizedBox(height: 20),
          
          _searchBar(),

          const SizedBox(height: 12),
          const ClientFilters(),
          const SizedBox(height: 12),
      Obx(() => Expanded(child: _clientList()),),
        ],
      ),
    );
  }

  Widget _searchBar() {
    return TextField(
      onChanged: (value) => controller.searchQuery.value = value,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        hintText: 'Search clients...',
        filled: true,
        fillColor: const Color(0xFFF3F4F6),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _clientList() {
    // return Obx(() {
      final clients = controller.searchedClients;

      if (clients.isEmpty) {
        return const Center(
          child: Text(
            'No clients found',
            style: TextStyle(color: Colors.grey),
          ),
        );
      }

      return Obx(() {
        final selectedId = controller.selectedClientId.value;
        return ListView.separated(
        itemCount: clients.length,
        separatorBuilder: (_, __) => const SizedBox(height: 6),
        itemBuilder: (context, index) {
          final client = clients[index];
          // final isSelected = controller.selectedClientId.value == client.id;

          return _ClientTile(
            client: client,
            isSelected: selectedId == client.id,
            onTap: () => controller.selectClient(client.id),

          );
        },
      );}  );
    // });
  }
}



class _ClientTile extends StatelessWidget {
  final ClientModel client;
  final bool isSelected;
  final VoidCallback onTap;

  const _ClientTile({
    required this.client,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return Material (
      color: isSelected ? const Color(0xFFEFF6FF) : Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFFE5E7EB),
                child: Text(
                  client.businessName.isNotEmpty
                      ? client.businessName[0].toUpperCase()
                      : '?',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      client.businessName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      client.businessType,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _statusChip(client.isActive),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusChip(bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
            ? const Color(0xFFD1FAE5)
            : const Color(0xFFFEE2E2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isActive ? 'Active' : 'Inactive',
        style: const TextStyle(fontSize: 12),
      ),
    );
  }
}
