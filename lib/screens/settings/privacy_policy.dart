import 'package:fl_sevengen_society_guard_app/localization/localization_const.dart';
import 'package:fl_sevengen_society_guard_app/theme/theme.dart';
import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
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
          getTranslate(context, 'privacy_policy.privacy_policy'),
          style: semibold18Black33,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
            fixPadding * 2.0, fixPadding, fixPadding * 2.0, fixPadding * 2.0),
        physics: const BouncingScrollPhysics(),
        children: [
          logo(),
          heightSpace,
          heightSpace,
          const Text(
            "Lorem ipsum dolor sit amet, consectetur adipiscindf elitj. Eu scelerisque neque neque vestibulumaugued enullalkll quis mauris. Ac solliciegestapellentesqueg adipiscing. Leo aliquam, aliquam non sit valaoreethg Morbi felis volutpat eu vestibulum, ornare purus ath the puruse. Pretium maecenas in eget sapien odioh. ",
            style: medium15Grey,
          ),
          heightSpace,
          const Text(
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Imperdiet accumsan nec, enim viverra.Interdum massa diam. Pellentesque ornare ornare lobortis sit. Utpulvinar tincidunt amet mi elit rutrum. Liberolorem acommodof. Egestas vel duis ut a ivenenatisLectussLorem ipsum dolor sit amet, consectetur adipiscing elit. Imperdiet accumsan nec, enim viverra.Interdum massa diam. Pellentesque ornare ornare lobortis sit. Utpulvinar tincidunt amet mi elit rutrum. Liberolorem acommodof. Egestas vel duis ut a ivenenatisLectuss  ",
            style: medium15Grey,
          ),
          heightSpace,
          const Text(
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Imperdiet accumsan nec, enim viverra.Interdum massa diam. Pellentesque ornare ornare lobortis sit. Utpulvinar tincidunt amet mi elit rutrum. Liberolorem acommodof. Egestas vel duis ut a ivenenatisLectussLorem ipsum dolor sit amet, consectetur adipiscing elit. Imperdiet accumsan nec, enim viverra.Interdum massa diam. Pellentesque ornare ornare lobortis sit. Utpulvinar tincidunt amet mi elit rutrum. Liberolorem acommodof. Egestas vel duis ut a ivenenatisLectuss  ",
            style: medium15Grey,
          ),
          heightSpace,
          const Text(
            "Lorem ipsum dolor sit amet, consectetur adipiscindf elitj. Eu scelerisque neque neque vestibulumaugued enullalkll quis mauris. Ac solliciegestapellentesqueg adipiscing. Leo aliquam, aliquam non sit valaoreethg Morbi felis volutpat eu vestibulum, ornare purus ath the puruse. Pretium maecenas in eget sapien odioh. ",
            style: medium15Grey,
          ),
          heightSpace,
          const Text(
            "Lorem ipsum dolor sit amet, consectetur adipiscindf elitj. Eu scelerisque neque neque vestibulumaugued enullalkll quis mauris. Ac solliciegestapellentesqueg adipiscing. Leo aliquam, aliquam non sit valaoreethg Morbi felis volutpat eu vestibulum, ornare purus ath the puruse. Pretium maecenas in eget sapien odioh. ",
            style: medium15Grey,
          ),
        ],
      ),
    );
  }

  logo() {
    return Column(
      children: [
        const Icon(
          Icons.home_work_outlined,
          color: primaryColor,
          size: 45.0,
        ),
        heightSpace,
        const Text(
          "SEVENGEN",
          style: semibold28Primary,
          textAlign: TextAlign.center,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 30.0,
              height: 2,
              color: primaryColor,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: fixPadding / 2),
              child: Text(
                "Society",
                style: medium18Primary,
              ),
            ),
            Container(
              width: 30.0,
              height: 2,
              color: primaryColor,
            ),
          ],
        )
      ],
    );
  }
}
