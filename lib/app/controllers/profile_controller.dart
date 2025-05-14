import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mkrempire/app/helpers/hive_helper.dart';
import 'package:mkrempire/app/helpers/keys.dart';
import 'package:mkrempire/app/repository/profile_repo.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mkrempire/resources/screens/others/bottom_nav_bar.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../resources/widgets/custom_dialog.dart';
import '../../resources/widgets/custom_loading.dart';

class ProfileController extends GetxController {
  late ProfileRepo profileRepo;
  var isLoading = false.obs;
  var isUploadingPhoto = false.obs;
  var profileImage = ''.obs;
  var uploadImage = ''.obs;
  @override
  void onInit() {
    profileRepo = ProfileRepo();
    this.getUserProfile();
    super.onInit();
  }

  TextEditingController currentPassEditingController = TextEditingController();
  TextEditingController newPassEditingController = TextEditingController();
  TextEditingController confirmEditingController = TextEditingController();

  RxString currentPassVal = "".obs;
  RxString newPassVal = "".obs;
  RxString confirmPassVal = "".obs;

  bool currentPassShow = true;
  bool isNewPassShow = true;
  bool isConfirmPassShow = true;

  currentPassObscure() {
    currentPassShow = !currentPassShow;
    update();
  }

  newPassObscure() {
    isNewPassShow = !isNewPassShow;
    update();
  }

  confirmPassObscure() {
    isConfirmPassShow = !isConfirmPassShow;
    update();
  }

  void validateUpdatePass({required String newPass}) async {
    if (newPassVal.value != confirmPassVal.value) {
      CustomDialog.showWarning(
          context: Get.context!,
          message: "New Password and Confirm Password didn't match!",
          buttonText: "Close");
    } else {
      await updatePassword(newPass: newPass);
    }
  }

  Future<void> updatePassword({required String newPass}) async {
    try {
      var response = await profileRepo.updatePassword(
          email: HiveHelper.read(Keys.userEmail), newPass: newPass);
      if (response['status'] == 'success') {
        CustomDialog.showSuccess(
            buttonText: 'Close',
            message: 'Password Updated Successfully',
            context: Get.context!);
        clearChangePasswordVal();
        Get.back();

        update();
      } else {
        CustomDialog.showError(
            message: '${response['message']}',
            context: Get.context!,
            buttonText: "close");
      }
    } catch (e) {
      print('Error:$e');
    }
  }

  TextEditingController firstNameEditingController = TextEditingController();
  TextEditingController lastNameEditingController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneNumberEditingController = TextEditingController();
  String countryCode = 'NG';
  String phoneCode = '+234';
  String countryName = 'Nigeria';
  var firstName = ''.obs;
  var lastName = ''.obs;
  var userName = ''.obs;
  var address = ''.obs;
  var phone = ''.obs;
  Future<void> updateProfile(
      {required String fname,
      required String lname,
      // required String userName,
      required int languageId,
      required String address,
      required String phoneCode,
      required String phone,
      required String country,
      required String countryCode}) async {
    try {
      isLoading.value = true;
      final response = await profileRepo.updateProfile(
          fname: fname,
          lname: lname,
          // userName: userName,
          languageId: languageId,
          address: address,
          phoneCode: phoneCode,
          phone: phone,
          country: country,
          countryCode: countryCode);
      if (response['status'] == "success") {
        HiveHelper.write(Keys.country, country);
        // HiveHelper.write(Keys.username, userName);
        HiveHelper.write(Keys.firstName, fname);
        HiveHelper.write(Keys.lastName, lname);
        HiveHelper.write(Keys.languageData, languageId);
        HiveHelper.write(Keys.countryCode, countryCode);
        HiveHelper.write(Keys.userPhone, phone);
        HiveHelper.write(Keys.userPhoneCode, phoneCode);
        HiveHelper.write(Keys.address, address);
        CustomDialog.showSuccess(
            buttonAction: ()=>Get.to(()=>BottomNavBar()),
            context: Get.context!,
            message: response['message'],
            buttonText: "close");
      } else {
        CustomDialog.showError(
            context: Get.context!,
            message: response['message'],
            buttonText: "close");
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  XFile? pickedImage;
  Future<void> pickImage(ImageSource source) async {
    final checkPermission = await Permission.camera.request();
    if (checkPermission.isGranted) {
      final picker = ImagePicker();
      final pickedImageFile = await picker.pickImage(source: source);
      final File imageFile = File(pickedImageFile!.path);
      final int fileSizeInBytes = await imageFile.length();
      final double fileSizeInMB = fileSizeInBytes / (1024 * 1024);

      pickedImage = pickedImageFile;
      if (pickedImage != null) {
        if (fileSizeInMB >= 4) {
          CustomDialog.showError(
              message:
                  "Image size exceeds 4 MB. Please choose a smaller image.",
              context: Get.context!,
              buttonText: "close");
        } else {
          await updateProfilePhoto(filePath: pickedImage!.path);
        }
      }
      update();
    } else {
      CustomDialog.showError(
          message:
              "Please grant camera permission in app settings to use this feature.",
          context: Get.context!,
          buttonText: "close");
    }
  }

  Future updateProfilePhoto({required String filePath}) async {
    try {
      isUploadingPhoto.value = true;

      // Create a File object from the file path
      File imageFile = File(filePath);

      var response = await profileRepo.uploadProfileImage(imageFile: imageFile);
      print(response);
      if (response['status'] == 'success') {
        uploadImage.value = filePath;
        HiveHelper.write(Keys.profilePic, filePath);
        print('Profile image updated at path: $filePath');

        CustomDialog.showSuccess(
            context: Get.context!,
            message: response['message'],
            buttonText: "close");
      } else {
        CustomDialog.showError(
            message: '${response['message']}',
            context: Get.context!,
            buttonText: "close");
        print("issue:${response['message']}");
      }
    } catch (e) {
      print('Error:$e');
    } finally {
      isUploadingPhoto.value = false;
    }
  }


  ///
  Future<void> getUserProfile() async {
    isLoading.value = true;
    try {
      // print('{email: $singInPin}');
      final response =
      await profileRepo.getUserProfile();

      if (response['status'] == 'success') {
        final profile = response['message']['profile'];
        HiveHelper.write(Keys.firstName, profile['firstname']);
        HiveHelper.write(Keys.userEmail, profile['email']);
        HiveHelper.write(Keys.profilePic, profile['image']);
        HiveHelper.write(Keys.lastName, profile['lastname'] ?? '');
        HiveHelper.write(Keys.userPhone, profile['phone'] ?? '');
        HiveHelper.write(Keys.kyc, profile['kyc'] ?? '');
        HiveHelper.write(Keys.userPin, profile['user_pin']);
        HiveHelper.write(Keys.tier, profile['tier']);

        print(response);
      } else {
        print(response['status']);
      }
    } catch (e) {
      // print(response['status']);
      print('Error ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }



  clearChangePasswordVal() {
    currentPassEditingController.clear();
    newPassEditingController.clear();
    confirmEditingController.clear();
    currentPassVal.value = '';
    newPassVal.value = '';
    confirmPassVal.value = '';
  }

}
