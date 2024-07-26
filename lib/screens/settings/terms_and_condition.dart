import 'package:ParkSquare/localization/localization_const.dart';
import 'package:flutter/material.dart';

import '../../theme/theme.dart';

class TermsAndConditionScreen extends StatefulWidget {
  const TermsAndConditionScreen({super.key});

  @override
  State<TermsAndConditionScreen> createState() =>
      _TermsAndConditionScreenState();
}

class _TermsAndConditionScreenState extends State<TermsAndConditionScreen> {
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
          getTranslate(context, 'terms_and_condition.terms_condition'),
          style: semibold18Black33,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
            fixPadding * 2.0, fixPadding, fixPadding * 2.0, fixPadding * 2.0),
        physics: const BouncingScrollPhysics(),
        children: const [
          // Text(
          //   "Lorem ipsum dolor sit amet, consectetur adipiscindf elitj. Eu scelerisque neque neque vestibulumaugued enullalkll quis mauris. Ac solliciegestapellentesqueg adipiscing. Leo aliquam, aliquam non sit valaoreethg Morbi felis volutpat eu vestibulum, ornare purus ath the puruse. Pretium maecenas in eget sapien odioh. ",
          //   style: medium15Grey,
          // ),
          // heightSpace,
          // Text(
          //   "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Imperdiet accumsan nec, enim viverra.Interdum massa diam. Pellentesque ornare ornare lobortis sit. Utpulvinar tincidunt amet mi elit rutrum. Liberolorem acommodof. Egestas vel duis ut a ivenenatisLectussLorem ipsum dolor sit amet, consectetur adipiscing elit. Imperdiet accumsan nec, enim viverra.Interdum massa diam. Pellentesque ornare ornare lobortis sit. Utpulvinar tincidunt amet mi elit rutrum. Liberolorem acommodof. Egestas vel duis ut a ivenenatisLectuss  ",
          //   style: medium15Grey,
          // ),
          // heightSpace,
          // Text(
          //   "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Imperdiet accumsan nec, enim viverra.Interdum massa diam. Pellentesque ornare ornare lobortis sit. Utpulvinar tincidunt amet mi elit rutrum. Liberolorem acommodof. Egestas vel duis ut a ivenenatisLectussLorem ipsum dolor sit amet, consectetur adipiscing elit. Imperdiet accumsan nec, enim viverra.Interdum massa diam. Pellentesque ornare ornare lobortis sit. Utpulvinar tincidunt amet mi elit rutrum. Liberolorem acommodof. Egestas vel duis ut a ivenenatisLectuss  ",
          //   style: medium15Grey,
          // ),
          // heightSpace,
          // Text(
          //   "Lorem ipsum dolor sit amet, consectetur adipiscindf elitj. Eu scelerisque neque neque vestibulumaugued enullalkll quis mauris. Ac solliciegestapellentesqueg adipiscing. Leo aliquam, aliquam non sit valaoreethg Morbi felis volutpat eu vestibulum, ornare purus ath the puruse. Pretium maecenas in eget sapien odioh. ",
          //   style: medium15Grey,
          // ),
          // heightSpace,
          // Text(
          //   "Lorem ipsum dolor sit amet, consectetur adipiscindf elitj. Eu scelerisque neque neque vestibulumaugued enullalkll quis mauris. Ac solliciegestapellentesqueg adipiscing. Leo aliquam, aliquam non sit valaoreethg Morbi felis volutpat eu vestibulum, ornare purus ath the puruse. Pretium maecenas in eget sapien odioh. ",
          //   style: medium15Grey,
          // ),
        ],
      ),
    );
  }
}
