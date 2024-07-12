import 'package:fl_sevengen_society_guard_app/localization/localization_const.dart';
import 'package:flutter/material.dart';

import '../../theme/theme.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    nameController.text = "Albert Flores";
    emailController.text = "Albert@mail.com";
    phoneController.text = "+91 1234567890";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0.0,
        titleSpacing: 0.0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: black33Color,
          ),
        ),
        title: Text(
          getTranslate(context, 'edit_profile.edit_profile'),
          style: semibold18Black33,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(fixPadding * 2.0),
        physics: const BouncingScrollPhysics(),
        children: [
          userImage(size),
          heightSpace,
          const Text(
            "Albert flores",
            textAlign: TextAlign.center,
            style: semibold18Primary,
          ),
          height5Space,
          const Text(
            "Gate A | SevenGen society",
            style: medium14Grey,
            textAlign: TextAlign.center,
          ),
          heightSpace,
          heightSpace,
          heightSpace,
          nameField(),
          heightSpace,
          heightSpace,
          emailAddressField(),
          heightSpace,
          heightSpace,
          phoneField(),
        ],
      ),
      bottomNavigationBar: updateButton(context),
    );
  }

  updateButton(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          margin: const EdgeInsets.all(fixPadding * 2.0),
          padding: const EdgeInsets.symmetric(
              horizontal: fixPadding * 2.0, vertical: fixPadding * 1.4),
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(0.1),
                blurRadius: 12.0,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Text(
            getTranslate(context, 'edit_profile.update'),
            style: semibold18White,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  phoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          getTranslate(context, 'edit_profile.phone_number'),
          style: medium16Grey,
        ),
        heightSpace,
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: whiteColor,
            boxShadow: [
              BoxShadow(
                color: blackColor.withOpacity(0.2),
                blurRadius: 6.0,
              )
            ],
          ),
          child: TextField(
            controller: phoneController,
            cursorColor: primaryColor,
            style: medium16Black33,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: fixPadding * 1.5),
              hintText:
                  getTranslate(context, 'edit_profile.enter_phone_number'),
              hintStyle: medium16Grey,
            ),
          ),
        )
      ],
    );
  }

  emailAddressField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          getTranslate(context, 'edit_profile.email_address'),
          style: medium16Grey,
        ),
        heightSpace,
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: whiteColor,
            boxShadow: [
              BoxShadow(
                color: blackColor.withOpacity(0.2),
                blurRadius: 6.0,
              )
            ],
          ),
          child: TextField(
            controller: emailController,
            cursorColor: primaryColor,
            style: medium16Black33,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: fixPadding * 1.5),
              hintText:
                  getTranslate(context, 'edit_profile.enter_email_address'),
              hintStyle: medium16Grey,
            ),
          ),
        )
      ],
    );
  }

  nameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          getTranslate(context, 'edit_profile.name'),
          style: medium16Grey,
        ),
        heightSpace,
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: whiteColor,
            boxShadow: [
              BoxShadow(
                color: blackColor.withOpacity(0.2),
                blurRadius: 6.0,
              )
            ],
          ),
          child: TextField(
            controller: nameController,
            cursorColor: primaryColor,
            style: medium16Black33,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: fixPadding * 1.5),
              hintText: getTranslate(context, 'edit_profile.enter_name'),
              hintStyle: medium16Grey,
            ),
          ),
        )
      ],
    );
  }

  userImage(Size size) {
    return Center(
      child: Stack(
        children: [
          Container(
            height: size.height * 0.14,
            width: size.height * 0.14,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: whiteColor,
              border: Border.all(color: whiteColor, width: 2),
              boxShadow: [
                BoxShadow(color: shadowColor.withOpacity(0.23), blurRadius: 6.0)
              ],
              image: const DecorationImage(
                image: AssetImage("assets/settings/profileImage.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          languageValue == 4
              ? Positioned(
                  left: 0,
                  bottom: 0,
                  child: cameraButton(size),
                )
              : Positioned(
                  right: 0,
                  bottom: 0,
                  child: cameraButton(size),
                )
        ],
      ),
    );
  }

  cameraButton(Size size) {
    return GestureDetector(
      onTap: () {
        addImageDialog();
      },
      child: Container(
        height: size.height * 0.047,
        width: size.height * 0.047,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: whiteColor,
        ),
        alignment: Alignment.center,
        child: const Icon(
          Icons.camera_alt_outlined,
          color: black33Color,
          size: 21,
        ),
      ),
    );
  }

  addImageDialog() {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: whiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10.0),
        ),
      ),
      builder: (context) {
        return ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(fixPadding * 2.0),
          children: [
            Text(
              getTranslate(context, 'edit_profile.add_image'),
              style: semibold18Black33,
            ),
            heightSpace,
            heightSpace,
            optionWidget(context, Icons.camera_alt, const Color(0xFF1E4799),
                getTranslate(context, 'edit_profile.camera')),
            heightSpace,
            heightSpace,
            optionWidget(context, Icons.photo, const Color(0xFF1E996D),
                getTranslate(context, 'edit_profile.gallery')),
            heightSpace,
            heightSpace,
            optionWidget(context, Icons.delete, const Color(0xFFEF1717),
                getTranslate(context, 'edit_profile.remove')),
          ],
        );
      },
    );
  }

  optionWidget(BuildContext context, IconData icon, Color color, String title) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Row(
        children: [
          Container(
            height: 40.0,
            width: 40.0,
            decoration: BoxDecoration(
              color: whiteColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: blackColor.withOpacity(0.2),
                  blurRadius: 5.0,
                )
              ],
            ),
            alignment: Alignment.center,
            child: Icon(
              icon,
              color: color,
            ),
          ),
          widthSpace,
          width5Space,
          Expanded(
            child: Text(
              title,
              style: medium16Black33,
            ),
          )
        ],
      ),
    );
  }
}
