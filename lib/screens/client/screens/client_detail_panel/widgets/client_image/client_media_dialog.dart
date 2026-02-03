import 'package:clwb_crm/core/widgets/premium_button.dart';
import 'package:clwb_crm/screens/client/models/client_media.dart';
import 'package:clwb_crm/screens/client/screens/client_detail_panel/widgets/client_image/client_media_controller.dart';
import 'package:clwb_crm/screens/inventory/dialogs/base_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClientMediaDialog extends StatelessWidget {
  final ClientMediaController c;
  const ClientMediaDialog({super.key, required this.c});

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      title: 'Client Media',
      footer: Obx(
            () => PremiumButton(
          text: c.isUploading.value ? 'Uploading...' : 'Add Images',
          onTap: c.isUploading.value ? () {} : c.addImages,
        ),
      ),
      child: Column(
        children: [
          Obx(() {
            return Row(
              children: [
                _TabButton(
                  label: 'Label',
                  active: c.activeTab.value == ClientMediaTab.labels,
                  onTap: () => c.switchTab(ClientMediaTab.labels),
                ),
                const SizedBox(width: 8),
                _TabButton(
                  label: 'Business',
                  active: c.activeTab.value == ClientMediaTab.business,
                  onTap: () => c.switchTab(ClientMediaTab.business),
                ),
              ],
            );
          }),
          const SizedBox(height: 16),

          Obx(() {
            final isLabels = c.activeTab.value == ClientMediaTab.labels;
            final list = isLabels ? c.labelImages : c.businessImages;

            if (list.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(12),
                child: Text('No images yet. Tap “Add Images”.'),
              );
            }

            return



              GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: list.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (_, i) {
                final img = list[i];
                final isFinal = isLabels &&
                    c.finalized != null &&
                    c.finalized!.path == img.path;

                return MediaThumb(
                  img: img,
                  // isFinal: isFinal,
                  onOpen: () => c.openImage(img),
                  onDelete: () => c.deleteImage(img),
                  onMakePrimary: isLabels ? () => c.setAsFinalized(img) : null,
                );


                // Expanded(
                //   child: GridView.builder(
                //     padding: const EdgeInsets.all(16),
                //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                //       crossAxisCount: 4, // adjust
                //       crossAxisSpacing: 12,
                //       mainAxisSpacing: 12,
                //       childAspectRatio: 1,
                //     ),
                //     itemCount: images.length,
                //     itemBuilder: (_, i) {
                //       final img = images[i];
                //       return MediaThumb(
                //         img: img,
                //         onOpen: () => c.openInNewTab(img.url),
                //         onDelete: () => c.deleteImage(img),
                //         onMakePrimary: () => c.setFinalized(img.url),
                //       );
                //     },
                //   ),
                // )


              },
            );
          }),
        ],
      ),
    );
  }
}




class MediaThumb extends StatelessWidget {
  final ClientMediaImage img;
  final VoidCallback onOpen;
  final VoidCallback? onDelete;
  final VoidCallback? onMakePrimary;

  const MediaThumb({
    super.key,
    required this.img,
    required this.onOpen,
    this.onDelete,
    this.onMakePrimary,
  });

  @override
  Widget build(BuildContext context) {
    // Debug: confirm URL is fine
    // ignore: avoid_print
    print('thumb url: ${img.url}');

    return AspectRatio(
      aspectRatio: 1, // ✅ forces a square tile size
      child: Stack(
        children: [
          Positioned.fill(
            child: InkWell(
              onTap: onOpen,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  img.url,
                  fit: BoxFit.cover,
                  // ✅ helps on web: shows while loading
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (_, e, __) {
                    // ignore: avoid_print
                    print('Image error: $e');
                    return const Center(child: Icon(Icons.broken_image));
                  },
                ),
              ),
            ),
          ),

          // top-right actions
          Positioned(
            right: 6,
            top: 6,
            child: Row(
              children: [
                IconButton(
                  tooltip: 'Make primary',
                  onPressed: onMakePrimary,
                  icon: const Icon(Icons.star_border),
                ),
                IconButton(
                  tooltip: 'Delete',
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



class _TabButton extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _TabButton({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: active ? Colors.black : Colors.white,
          foregroundColor: active ? Colors.white : Colors.black,
        ),
        child: Text(label),
      ),
    );
  }
}

// class _Thumb extends StatelessWidget {
//   final ClientMediaImage img;
//   final bool isFinal;
//   final VoidCallback onOpen;
//   final VoidCallback onDelete;
//   final VoidCallback? onSetFinal;
//
//   const _Thumb({
//     required this.img,
//     required this.isFinal,
//     required this.onOpen,
//     required this.onDelete,
//     this.onSetFinal,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         InkWell(
//           onTap: onOpen,
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(12),
//             child: Image.network(
//               img.url,
//               fit: BoxFit.cover,
//               width: double.infinity,
//               height: double.infinity,
//               errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.broken_image)),
//             ),
//           ),
//         ),
//
//         Positioned(
//           right: 4,
//           top: 4,
//           child: Row(
//             children: [
//               if (onSetFinal != null)
//                 IconButton(
//                   tooltip: 'Set as final',
//                   onPressed: onSetFinal,
//                   icon: Icon(isFinal ? Icons.star : Icons.star_border, size: 18),
//                 ),
//               IconButton(
//                 tooltip: 'Delete',
//                 onPressed: onDelete,
//                 icon: const Icon(Icons.delete_outline, size: 18),
//               ),
//             ],
//           ),
//         ),
//
//         if (isFinal)
//           Positioned(
//             left: 8,
//             bottom: 8,
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//               decoration: BoxDecoration(
//                 color: Colors.black.withValues(alpha: 0.7),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: const Text(
//                 'FINAL',
//                 style: TextStyle(color: Colors.white, fontSize: 11),
//               ),
//             ),
//           ),
//       ],
//     );
//   }
// }
