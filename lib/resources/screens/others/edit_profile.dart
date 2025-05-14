import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mkrempire/app/controllers/profile_controller.dart';
import 'package:mkrempire/app/helpers/hive_helper.dart';
import 'package:mkrempire/app/helpers/keys.dart';
import 'package:mkrempire/resources/widgets/custom_app_bar.dart';
import 'package:mkrempire/resources/widgets/custom_app_button.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../config/app_colors.dart';
import '../../../config/app_themes.dart';
import '../../widgets/custom_textfield.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final ProfileController profileController = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();

    // Initialize controllers with HiveHelper values
    profileController.firstNameEditingController.text =
        HiveHelper.read(Keys.firstName) ?? '';
    profileController.lastNameEditingController.text =
        HiveHelper.read(Keys.lastName) ?? '';
    profileController.usernameController.text =
        HiveHelper.read(Keys.username) ?? '';
    profileController.phoneNumberEditingController.text =
        HiveHelper.read(Keys.userPhone) ?? '';
    profileController.addressController.text =
        HiveHelper.read(Keys.address) ?? '';

    // Also set the initial values in the controller
    profileController.firstName.value =
        profileController.firstNameEditingController.text;
    profileController.lastName.value =
        profileController.lastNameEditingController.text;
    profileController.userName.value =
        profileController.usernameController.text;
    profileController.phone.value =
        profileController.phoneNumberEditingController.text;
    profileController.address.value = profileController.addressController.text;
  }

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Edit Profile',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.0.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(30),
              Text("First Name", style: t.displayMedium),
              Gap(10),
              CustomTextField(
                readOnly: true,
                hintText: "Enter First Name",
                controller: profileController.firstNameEditingController,
                onChanged: (V) {
                  profileController.firstName.value =
                      V.isEmpty ? HiveHelper.read(Keys.firstName) : V;
                },
              ),
              Gap(24),
              Text("Last Name", style: t.displayMedium),
              Gap(10),
              CustomTextField(
                hintText: "Enter LastName",
                controller: profileController.lastNameEditingController,
                onChanged: (v) {
                  profileController.lastName.value =
                      v.isEmpty ? HiveHelper.read(Keys.lastName) : v;
                },
                readOnly: true,
              ),
              Gap(24),
              // Text("Username", style: t.displayMedium),
              // Gap(10),
              // CustomTextField(
              //   hintText: "Enter Username",
              //   controller: profileController.usernameController,
              //   onChanged: (v) {
              //     profileController.userName.value =
              //         v.isEmpty ? HiveHelper.read(Keys.username) : v;
              //   },
              // ),
              Gap(24),
              Text("Phone Number", style: t.displayMedium),
              Gap(10),
              Row(children: [
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8.r)),
                    border: Border.all(
                        color: AppThemes.getSliderInactiveColor(), width: 1),
                  ),
                  child: CountryCodePicker(
                    padding: EdgeInsets.zero,
                    dialogBackgroundColor: AppThemes.getDarkCardColor(),
                    dialogTextStyle: t.bodyMedium?.copyWith(fontSize: 16.sp),
                    flagWidth: 29.w,
                    textStyle: t.displayMedium,
                    onChanged: (CountryCode countryCode) {
                      profileController.countryCode = countryCode.code!;
                      profileController.phoneCode = countryCode.dialCode!;
                      profileController.countryName = countryCode.name!;
                    },
                    initialSelection: '${profileController.countryCode}',
                    showCountryOnly: false,
                    showOnlyCountryWhenClosed: false,
                    alignLeft: false,
                  ),
                ),
                16.horizontalSpace,
                Expanded(
                    child: CustomTextField(
                      readOnly: true,
                      hintText: "Enter Phone",
                  controller: profileController.phoneNumberEditingController,
                  keyboardType: TextInputType.phone,
                  onChanged: (v) {
                    profileController.phone.value =
                        v.isEmpty ? HiveHelper.read(Keys.userPhone) : v;
                  },
                ))
              ]),
              Gap(24),
              Text("Address", style: t.displayMedium),
              Gap(10.h),
              CustomTextField(
                hintText: "Enter Address",
                controller: profileController.addressController,
                onChanged: (v) {
                  profileController.address.value =
                      v.isEmpty ? HiveHelper.read(Keys.address) : v;
                },
              ),
              Gap(70),
          // CustomAppButton(
          //   // text: '',
          //   onTap: ()async{
          //     final response = profileController.getUserProfile(context);
          //     print('response $response');
          //   },
          // ),

              Obx(() => CustomAppButton(
                isLoading: profileController.isLoading.value == true,
                  bgColor: profileController.address.value.isEmpty ||
                          profileController.phone.value.isEmpty ||
                          profileController.firstName.value.isEmpty ||
                          profileController.lastName.value.isEmpty
                      ? Get.isDarkMode
                          ? AppColors.secondaryColor.withOpacity(0.3)
                          : AppColors.mainColor.withOpacity(0.3)
                      : Get.isDarkMode
                          ? AppColors.secondaryColor
                          : AppColors.mainColor,
                  onTap: profileController.address.value.isEmpty ||
                          profileController.phone.value.isEmpty ||
                          profileController.firstName.value.isEmpty ||
                          profileController.lastName.value.isEmpty
                      ? null
                      : () {
                          profileController.updateProfile(
                              fname: profileController.firstName.value,
                              lname: profileController.lastName.value,
                              // userName: profileController.userName.value,
                              languageId: 1,
                              address: profileController.address.value,
                              phoneCode: profileController.phoneCode,
                              phone: profileController.phone.value,
                              country: profileController.countryName,
                              countryCode: profileController.countryCode);
                          print('Updating profile with:');
                          print(
                              'First Name: ${profileController.firstName.value}');
                          print(
                              'Last Name: ${profileController.lastName.value}');
                          // print(
                          //     'Username: ${profileController.userName.value}');
                          print('Address: ${profileController.address.value}');
                          print('Phone Code: ${profileController.phoneCode}');
                          print('Phone: ${profileController.phone.value}');
                          print('Country: ${profileController.countryName}');
                          print(
                              'Country Code: ${profileController.countryCode}');
                        }))
            ],
          ),
        ),
      ),
    );
  }
}
