import 'package:Park360/localization/localization_const.dart';
import 'package:Park360/main.dart';
import 'package:Park360/theme/theme.dart';
import 'package:flutter/material.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  late int selectedIndex;

  void _changeLanguges(String languageCode) async {
    Locale temp = await setLocale(languageCode);

    // ignore: use_build_context_synchronously
    MyApp.setLocale(context, temp);
  }

  @override
  void initState() {
    setState(() {
      selectedIndex = languageValue!;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          getTranslate(context, 'language.language'),
          style: semibold18Black33,
        ),
      ),
      body: languageListContent(),
      bottomNavigationBar: updateButton(context),
    );
  }

  updateButton(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: GestureDetector(
        onTap: () {
          setState(() {
            languageValue = selectedIndex;
            for (int i = 0; i < Languages.languageList.length; i++) {
              if (languageValue == i) {
                _changeLanguges(
                    Languages.languageList[i].languageCode.toString());
              }
            }
          });

          setIntLanguageValue(languageValue!);
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
            getTranslate(context, 'language.update'),
            style: semibold18White,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  languageListContent() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: fixPadding),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedIndex = index;
            });
          },
          child: Container(
            width: double.maxFinite,
            margin: const EdgeInsets.symmetric(
                vertical: fixPadding, horizontal: fixPadding * 2.0),
            padding: const EdgeInsets.symmetric(
                horizontal: fixPadding * 1.5, vertical: fixPadding * 1.3),
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
                Expanded(
                  child: Text(
                    Languages.languageList[index].name.toString(),
                    style: semibold16Black33,
                  ),
                ),
                Container(
                  height: 24,
                  width: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: whiteColor,
                    border: selectedIndex == index
                        ? Border.all(
                            color: primaryColor,
                            width: 8,
                          )
                        : null,
                    boxShadow: [
                      selectedIndex == index
                          ? BoxShadow(
                              color: primaryColor.withOpacity(0.1),
                              blurRadius: 12.0,
                              offset: const Offset(0, 6),
                            )
                          : BoxShadow(
                              color: shadowColor.withOpacity(0.2),
                              blurRadius: 5,
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      itemCount: Languages.languageList.length,
    );
  }
}

class Languages {
  String? name;
  String? languageCode;
  int? id;

  Languages({this.id, this.languageCode, this.name});

  static final languageList = [
    Languages(id: 0, name: "English", languageCode: 'en'),
    Languages(id: 1, name: "हिंदी", languageCode: 'hi'),
    Languages(id: 2, name: "Indonesian", languageCode: 'id'),
    Languages(id: 3, name: "中国人", languageCode: 'zh'),
    Languages(id: 4, name: "عربي", languageCode: 'ar'),
  ];
}
