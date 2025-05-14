import 'dart:io';

import 'package:mkrempire/app/repository/supportrepo.dart';
import 'package:mkrempire/resources/widgets/custom_dialog.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class Supportcontroller extends GetxController {
  late SupportRepo supportRepo;
  var isLoading = false.obs;
  var selectedImages = <File>[].obs;
  var tickets = [].obs;

  @override
  void onInit() {
    supportRepo = SupportRepo();
    viewTickets();
    super.onInit();
  }

  Future<void> pickImages() async {
    final ImagePicker _picker = ImagePicker();

    try {
      final List<XFile>? images = await _picker.pickMultiImage();
      if (images != null) {
        // Check if adding these would exceed the 5 image limit
        if (selectedImages.length + images.length > 5) {
          Get.snackbar('Too many images', 'You can only select up to 5 images',
              snackPosition: SnackPosition.BOTTOM);
          return;
        }

        // Add selected images to the list
        selectedImages.addAll(images.map((image) => File(image.path)).toList());
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick images: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Clear selected images
  void clearImages() {
    selectedImages.clear();
  }

  // Remove a specific image
  void removeImage(int index) {
    if (index >= 0 && index < selectedImages.length) {
      selectedImages.removeAt(index);
    }
  }

  Future<void> createTicket({
    required Map<String, dynamic> data,
  }) async {
    try {
      isLoading.value = true;

      // Add images if there are any
      // if (selectedImages.isNotEmpty) {
      //   for (int i = 0; i < selectedImages.length; i++) {
      //     formData['images[$i]'] = selectedImages[i];
      //   }
      // }
      var response = await supportRepo.createTicket(json: data);
      if (response['status'] == 'success') {
        viewTickets();
        CustomDialog.showSuccess(
            context: Get.context!,
            message: response['message'],
            buttonText: "Close");
      } else {
        CustomDialog.showError(
            context: Get.context!,
            message: response['message'],
            buttonText: "Close");
      }
      clearImages();
    } catch (e) {
      print('Error:$e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> viewTickets() async {
    try {
      isLoading.value = true;
      var response = await supportRepo.ticketList();
      if (response['status'] == 'success') {
        tickets.value = response['message']['tickets'];
        print(tickets);
      } else {
        CustomDialog.showError(
            context: Get.context!,
            message: response['message'],
            buttonText: "Close");
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> replyTickets({
    required String ticketId,
    required String message,
  }) async {
    try {
      isLoading.value = true;
      var response = await supportRepo.replyTicket(
        ticketId: ticketId,
        json: {"message": message},
      );
      if (response['status'] == 'success') {
        CustomDialog.showSuccess(
            context: Get.context!,
            message: response['message'],
            buttonText: "Close");
      } else {
        CustomDialog.showError(
            context: Get.context!,
            message: response['message'],
            buttonText: "Close");
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> closeTickets(String ticketId) async {
    try {
      isLoading.value = true;
      var response = await supportRepo.closeTicket(ticketId: ticketId);
      print(response);
      if (response['status'] == 'success') {
        viewTickets();
        CustomDialog.showSuccess(
            context: Get.context!,
            message: response['message'],
            buttonText: "Close");
      } else {
        CustomDialog.showError(
            context: Get.context!,
            message: response['message'],
            buttonText: "Close");
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteTickets(String ticketId) async {
    try {
      isLoading.value = true;
      var response = await supportRepo.deleteTicket(ticketId: ticketId);
      if (response['status'] == 'success') {
        viewTickets();
      } else {
        CustomDialog.showError(
            context: Get.context!,
            message: response['message'],
            buttonText: "Close");
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
