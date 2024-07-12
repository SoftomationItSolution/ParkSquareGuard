import 'package:fl_sevengen_society_guard_app/localization/localization_const.dart';
import 'package:fl_sevengen_society_guard_app/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bx.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: whiteColor,
        elevation: 0.0,
        titleSpacing: 20.0,
        automaticallyImplyLeading: false,
        title: Text(
          getTranslate(context, 'settings.settings'),
          style: semibold18Black33,
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: fixPadding),
        children: [
          guardDetail(),
          quickContactTitle(),
          quickContactOption(size),
          heightSpace,
          listTileWidget(
              CupertinoIcons.globe, getTranslate(context, 'settings.language'),
              () {
            Navigator.pushNamed(context, '/language');
          }),
          listTileWidget(Icons.help_outline_outlined,
              getTranslate(context, 'settings.get_support'), () {
            Navigator.pushNamed(context, '/getSupport');
          }),
          listTileWidget(Icons.list_alt,
              getTranslate(context, 'settings.terms_and_condition'), () {
            Navigator.pushNamed(context, '/termsAndConditions');
          }),
          listTileWidget(Icons.person_outline,
              getTranslate(context, 'settings.privacy_policy'), () {
            Navigator.pushNamed(context, '/privacyPolicy');
          }),
          listTileWidget(Icons.logout, getTranslate(context, 'settings.logout'),
              () {
            logoutDialog(context);
          }, iconColor: redColor, textColor: redColor),
        ],
      ),
    );
  }

  logoutDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          clipBehavior: Clip.hardEdge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          insetPadding: const EdgeInsets.symmetric(
              horizontal: fixPadding * 4.5, vertical: fixPadding * 2.0),
          backgroundColor: whiteColor,
          child: ListView(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            children: [
              Padding(
                padding: const EdgeInsets.all(fixPadding * 2.0),
                child: Column(
                  children: [
                    const Icon(
                      Icons.logout,
                      color: primaryColor,
                      size: 35,
                    ),
                    heightSpace,
                    Text(
                      getTranslate(context, 'settings.logout'),
                      style: semibold18Primary,
                    ),
                    heightSpace,
                    Text(
                      getTranslate(context, 'settings.sure_text'),
                      style: semibold16Black33,
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: fixPadding * 1.2),
                        decoration: BoxDecoration(
                          color: whiteColor,
                          boxShadow: [
                            BoxShadow(
                              color: blackColor.withOpacity(0.2),
                              blurRadius: 6.0,
                            )
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          getTranslate(context, 'settings.no'),
                          style: semibold18Black33,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: fixPadding * 1.2),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          boxShadow: [
                            BoxShadow(
                              color: blackColor.withOpacity(0.2),
                              blurRadius: 6.0,
                            )
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          getTranslate(context, 'settings.yes'),
                          style: semibold18White,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  listTileWidget(IconData icon, String title, Function() onTap,
      {Color textColor = black33Color, Color iconColor = primaryColor}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(
            horizontal: fixPadding * 2.0, vertical: fixPadding),
        padding: const EdgeInsets.symmetric(
            horizontal: fixPadding, vertical: fixPadding * 0.75),
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: shadowColor.withOpacity(0.2),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: greyF6F3Color,
              ),
              child: Icon(
                icon,
                color: iconColor,
              ),
            ),
            widthSpace,
            Expanded(
              child: Text(
                title,
                style: semibold15Black33.copyWith(color: textColor),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 18.0,
              color: black33Color,
            )
          ],
        ),
      ),
    );
  }

  quickContactOption(Size size) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: fixPadding * 2.0, vertical: fixPadding * 1.7),
      color: greyF6F3Color,
      child: Row(
        children: [
          contactWidget(size, getTranslate(context, 'settings.call_admin'), () {
            Navigator.pushNamed(context, '/call');
          }),
          widthSpace,
          widthSpace,
          contactWidget(size, getTranslate(context, 'settings.call_secretory'),
              () {
            Navigator.pushNamed(context, '/call');
          }),
        ],
      ),
    );
  }

  contactWidget(Size size, String title, Function() onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
              vertical: fixPadding * 1.2, horizontal: fixPadding),
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(5.0),
            boxShadow: [
              BoxShadow(
                color: shadowColor.withOpacity(0.2),
                blurRadius: 6.0,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.call_outlined,
                color: blueColor,
                size: 23,
              ),
              widthSpace,
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: size.width * 0.27),
                child: Text(
                  title,
                  style: semibold15Blue,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  quickContactTitle() {
    return Padding(
      padding: const EdgeInsets.only(
          left: fixPadding * 2.0, right: fixPadding * 2.0, bottom: fixPadding),
      child: Text(
        getTranslate(context, 'settings.quick_contact'),
        style: semibold16Black33,
      ),
    );
  }

  guardDetail() {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: fixPadding, vertical: fixPadding * 1.5),
      margin: const EdgeInsets.fromLTRB(
          fixPadding * 2.0, fixPadding, fixPadding * 2.0, fixPadding * 2.0),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: shadowColor.withOpacity(0.2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 68.0,
            width: 68.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: whiteColor,
              border: Border.all(color: whiteColor, width: 2.0),
              boxShadow: [
                BoxShadow(
                  color: shadowColor.withOpacity(0.2),
                  blurRadius: 6.0,
                )
              ],
              image: const DecorationImage(
                image: AssetImage("assets/settings/profileImage.png"),
              ),
            ),
          ),
          widthSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Albert Flores",
                  style: semibold16Black33,
                ),
                heightBox(3.0),
                const Text(
                  "Gate A | SevenGen society",
                  style: medium14Grey,
                ),
                heightBox(3.0),
                Text(
                  getTranslate(context, 'settings.on_duty'),
                  style: semibold16Green,
                )
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/editProfile');
            },
            child: const Iconify(
              Bx.edit,
              color: primaryColor,
              size: 22,
            ),
          )
        ],
      ),
    );
  }
}
