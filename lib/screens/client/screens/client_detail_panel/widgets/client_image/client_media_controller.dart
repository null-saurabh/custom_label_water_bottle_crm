import 'dart:typed_data';
import 'package:clwb_crm/screens/client/firebase_repo/client_repo.dart';
import 'package:clwb_crm/screens/client/models/client_media.dart';
import 'package:clwb_crm/screens/client/models/client_model.dart';
import 'package:clwb_crm/screens/client/screens/client_detail_panel/widgets/client_image/client_media_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

enum ClientMediaTab { labels, business }

class ClientMediaController extends GetxController {
  final ClientModel client;
  ClientMediaController({required this.client});

  final repo = ClientRepository();
  final storage = ClientMediaStorage();
  final picker = ImagePicker();

  final activeTab = ClientMediaTab.labels.obs;
  final isUploading = false.obs;

  // Helpers to read current media from client snapshot
  // (If your ClientModel already parses these, use that instead)
  List<ClientMediaImage> get labelImages {
    final raw = client.media.draftLabelImages; // adapt to your model
    return raw;
  }

  List<ClientMediaImage> get businessImages {
    final raw = client.media.businessPhotos;
    return raw;
  }

  ClientMediaImage? get finalized => client.media.finalizedLabelImage;

  void switchTab(ClientMediaTab t) => activeTab.value = t;

  Future<void> openImage(ClientMediaImage img) async {
    final uri = Uri.tryParse(img.url);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.platformDefault);
  }

  Future<void> addImages() async {
    final field = activeTab.value == ClientMediaTab.labels
        ? 'draftLabelImages'
        : 'businessPhotos';

    final picked = await picker.pickMultiImage(imageQuality: 85);
    if (picked.isEmpty) return;

    try {
      isUploading.value = true;

      final out = <ClientMediaImage>[];

      for (final x in picked) {
        final bytes = await x.readAsBytes();
        final ext = (x.name.split('.').last).toLowerCase();
        final contentType = ext == 'png' ? 'image/png' : 'image/jpeg';

        final folder = activeTab.value == ClientMediaTab.labels ? 'labels' : 'business';
        final fileName = '${DateTime.now().millisecondsSinceEpoch}_${x.name}';

        final path = 'clients/${client.id}/$folder/$fileName';

        final url = await storage.uploadBytes(
          path: path,
          bytes: bytes,
          contentType: contentType,
        );

        out.add(ClientMediaImage(url: url, path: path, name: x.name));
      }

      await repo.addClientMediaImages(
        clientId: client.id,
        field: field,
        images: out,
      );

      Get.snackbar('Success', 'Images uploaded');
    } catch (e) {
      Get.snackbar('Error', 'Upload failed');
    } finally {
      isUploading.value = false;
    }
  }

  Future<void> deleteImage(ClientMediaImage img) async {
    final field = activeTab.value == ClientMediaTab.labels
        ? 'draftLabelImages'
        : 'businessPhotos';

    try {
      // 1) remove from firestore
      await repo.removeClientMediaImage(
        clientId: client.id,
        field: field,
        image: img,
      );

      // 2) delete from storage
      await storage.deletePath(img.path);

      // 3) if it was finalized, clear it
      final f = finalized;
      if (f != null && f.path == img.path) {
        await repo.setFinalizedLabelImage(clientId: client.id, image: null);
      }

      Get.snackbar('Deleted', 'Image removed');
    } catch (e) {
      Get.snackbar('Error', 'Delete failed');
    }
  }

  Future<void> setAsFinalized(ClientMediaImage img) async {
    try {
      await repo.setFinalizedLabelImage(clientId: client.id, image: img);
      Get.snackbar('Updated', 'Selected as final label image');
    } catch (e) {
      Get.snackbar('Error', 'Failed to set final image');
    }
  }
}
