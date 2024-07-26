import 'dart:convert';
import 'dart:io';

import 'package:ParkSquare/localization/localization_const.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api.dart';
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
  String userName = '';
  String blockName = '';
  String towerName = '';
  String? _imageUrl;
  File? _image;

  @override
  void initState() {
    super.initState();
    loadUserData();
    print("Initial _image: $_image");
    print("Initial _imageUrl: $_imageUrl");
  }

  // void loadUserData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   int? userId = prefs.getInt('user_id');
  //   blockName = prefs.getString('block_name') ?? '';
  //   towerName = prefs.getString('tower_name') ?? '';

  //   final response =
  //       await http.get(Uri.parse('${ApiConfig.baseUrl}$userId'));
  //   if (response.statusCode == 200) {
  //     final userData = json.decode(response.body);
  //     print("userData>>>>>>>, $userData");
  //     setState(() {
  //       nameController.text = userData['userName'] ?? '';
  //       emailController.text = userData['userEmail'] ?? '';
  //       phoneController.text = userData['userContact'] ?? '';
  //       // _imageUrl = userData['image'] != null ? '${ApiConfig.baseUrl}${userData['image']}' : null;
  //       _imageUrl = userData['image'] != null
  //           ? '${ApiConfig.baseUrl}${userData['image']}'
  //           : null;
  //       print("Updated _imageUrl: $_imageUrl");
  //     });
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Failed to load user data')),
  //     );
  //   }
  // }

void loadUserData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int? userId = prefs.getInt('user_id');
  blockName = prefs.getString('block_name') ?? '';
  towerName = prefs.getString('tower_name') ?? '';

  final response = await http.get(Uri.parse('${ApiConfig.baseUrl}$userId'));
  if (response.statusCode == 200) {
    final userData = json.decode(response.body);
    print("userData>>>>>>>, $userData");
    setState(() {
      nameController.text = userData['userName'] ?? '';
      emailController.text = userData['userEmail'] ?? '';
      phoneController.text = userData['userContact'] ?? '';
      _imageUrl = userData['image'] != null
          ? '${ApiConfig.baseUrl}${userData['image'].replaceFirst('/opt/soft/parking/parkingApi/uploads/', 'uploads/')}'
          : null;
      print("Updated _imageUrl: $_imageUrl");
    });
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to load user data')),
    );
  }
}

  
  Future<void> updateUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? userId = prefs.getInt('user_id');

    final url = Uri.parse('${ApiConfig.baseUrl}updateUsers/$userId');

    try {
      var request = http.MultipartRequest('PUT', url);
      request.fields['userName'] = nameController.text;
      request.fields['userEmail'] = emailController.text;
      request.fields['userContact'] = phoneController.text;

      if (_image != null) {
        var file = await http.MultipartFile.fromPath('image', _image!.path);
        request.files.add(file);
      }

      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );

        // Update SharedPreferences
        await prefs.setString('userName', nameController.text);
        await prefs.setString('userEmail', emailController.text);
        await prefs.setString('userContact', phoneController.text);

        // Update _imageUrl if a new image was uploaded
        if (_image != null) {
          var jsonResponse = json.decode(responseString);
          String imageUrl = '${ApiConfig.baseUrl}${jsonResponse['image']}';
          print("Full image URL: $imageUrl");
          Future.delayed(Duration(seconds: 2), () {
            setState(() {
              _imageUrl = imageUrl;
              _image = null;
            });
          });
        }
        imageCache.clear();
        imageCache.clearLiveImages();
        // // Clear image cache
        // await imageCache.clear();
        // await imageCache.clearLiveImages();

        setState(() {
          // Force a rebuild of the widget tree
        });

        print("Image URL after update: $_imageUrl");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
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
          Text(
            nameController.text,
            // "Albert flores",
            textAlign: TextAlign.center,
            style: semibold18Primary,
          ),
          height5Space,
          Text(
            (blockName.isNotEmpty && towerName.isNotEmpty)
                ? "$blockName | $towerName"
                : "No Data Available",
            style: medium14Grey,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
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
          // Navigator.pop(context);
          updateUserData();
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
            ),
            child: _image != null
                ? ClipOval(
                    child: Image.file(
                      _image!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        print('Error loading local image: $error');
                        return Icon(Icons.error);
                      },
                    ),
                  )
                : _imageUrl != null
                    ? ClipOval(
                        child: Image.network(
                          _imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            print('Error loading network image: $error');
                            return Icon(Icons.error);
                          },
                        ),
                      )
                    : Image.asset(
                        "assets/settings/profileImage.png",
                        fit: BoxFit.cover,
                      ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: cameraButton(size),
          ),
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
            optionWidget(
                context,
                Icons.camera_alt,
                const Color(0xFF1E4799),
                getTranslate(context, 'edit_profile.camera'),
                ImageSource.camera),
            heightSpace,
            heightSpace,
            optionWidget(
                context,
                Icons.photo,
                const Color(0xFF1E996D),
                getTranslate(context, 'edit_profile.gallery'),
                ImageSource.gallery),
            heightSpace,
            heightSpace,
            optionWidget(context, Icons.delete, const Color(0xFFEF1717),
                getTranslate(context, 'edit_profile.remove'), null),
          ],
        );
      },
    );
  }

  optionWidget(BuildContext context, IconData icon, Color color, String title,
      ImageSource? source) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        if (source != null) {
          _getImage(source);
        } else {
          _removeImage();
        }
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

  Future _getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _imageUrl =
            null;
      });
    }
  }

  void _removeImage() {
    setState(() {
      _image = null;
      _imageUrl = null;
    });
  }
}
