import 'package:fl_sevengen_society_guard_app/localization/localization_const.dart';
import 'package:fl_sevengen_society_guard_app/theme/theme.dart';
import 'package:flutter/material.dart';

class InOutScreen extends StatefulWidget {
  const InOutScreen({super.key});

  @override
  State<InOutScreen> createState() => _InOutScreenState();
}

class _InOutScreenState extends State<InOutScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  final insideList = [
    {
      "image": "assets/home/guests.png",
      "name": "Cameron Williamson",
      "number": "Block A-420",
      "type": "Guest",
      "time": "1hr",
      "Phonenumber": "+91 1234567890"
    },
    {
      "image": "assets/home/food-delivery.png",
      "name": "Leslie Alexander",
      "number": "Block B-105",
      "type": "Delivery ",
      "time": "5min",
      "Phonenumber": "+91 1234567890"
    },
    {
      "image": "assets/home/cab.png",
      "name": "Savannah Nguyen",
      "number": "Block A-120",
      "type": "Cab",
      "time": "Pickup",
      "Phonenumber": "+91 1234567890"
    },
    {
      "image": "assets/home/maid.png",
      "name": "Ralph Edwards",
      "number": "Block B-220",
      "type": "Service",
      "time": "2hr",
      "Phonenumber": "+91 1234567890"
    },
    {
      "image": "assets/home/guests.png",
      "name": "Darlene Robertson",
      "number": "Block B-105",
      "type": "Guest",
      "time": "3hr",
      "Phonenumber": "+91 1234567890"
    },
    {
      "image": "assets/home/food-delivery.png",
      "name": "Devon Lane",
      "number": "Block A-202",
      "type": "Delivery",
      "time": "10min",
      "Phonenumber": "+91 1234567890"
    },
    {
      "image": "assets/home/cab.png",
      "name": "Courtney Henry",
      "number": "Block A-204",
      "type": "Cab",
      "time": "Dropup",
      "Phonenumber": "+91 1234567890"
    },
    {
      "image": "assets/home/guests.png",
      "name": "Kathryn Murphy",
      "number": "Block A-420",
      "type": "Guest",
      "time": "1hr",
      "Phonenumber": "+91 1234567890"
    },
  ];

  final waitingList = [
    {
      "image": "assets/home/guests.png",
      "name": "Cameron Williamson",
      "number": "Block A-420",
      "type": "Guest",
      "Phonenumber": "+91 1234567890"
    },
    {
      "image": "assets/home/food-delivery.png",
      "name": "Leslie Alexander",
      "number": "Block B-105",
      "type": "Delivery ",
      "Phonenumber": "+91 1234567890"
    },
    {
      "image": "assets/home/cab.png",
      "name": "Savannah Nguyen",
      "number": "Block A-120",
      "type": "Cab",
      "Phonenumber": "+91 1234567890"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: whiteColor,
        elevation: 0.0,
        titleSpacing: 20.0,
        automaticallyImplyLeading: false,
        title: Text(
          getTranslate(context, 'in_out.In_Out'),
          style: semibold18Black33,
        ),
      ),
      body: Column(
        children: [
          tabBar(),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                insideListContent(),
                waitingListContent(),
              ],
            ),
          )
        ],
      ),
    );
  }

  waitingListContent() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(
          horizontal: fixPadding * 2.0, vertical: fixPadding),
      itemCount: waitingList.length,
      itemBuilder: (context, index) {
        return listContent(
            index,
            waitingList[index]['image'].toString(),
            "${waitingList[index]['number']} | ${waitingList[index]['type']}",
            insideList[index]['name'].toString(),
            getTranslate(context, 'in_out.in'),
            greenColor);
      },
    );
  }

  insideListContent() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(
          horizontal: fixPadding * 2.0, vertical: fixPadding),
      itemCount: insideList.length,
      itemBuilder: (context, index) {
        return listContent(
            index,
            insideList[index]['image'].toString(),
            "${insideList[index]['number']} | ${insideList[index]['type']} | ${insideList[index]['time']}",
            insideList[index]['name'].toString(),
            getTranslate(context, 'in_out.out'),
            redColor);
      },
    );
  }

  listContent(int index, image, text, name, boxText, boxColor) {
    return Container(
      padding: const EdgeInsets.all(fixPadding * 0.8),
      margin: const EdgeInsets.symmetric(vertical: fixPadding),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: shadowColor.withOpacity(0.2),
            blurRadius: 6.0,
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 58,
            width: 58,
            padding: const EdgeInsets.all(fixPadding * 0.7),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: [
                BoxShadow(
                  color: shadowColor.withOpacity(0.2),
                  blurRadius: 6.0,
                )
              ],
            ),
            alignment: Alignment.center,
            child: Image.asset(
              image,
              fit: BoxFit.cover,
            ),
          ),
          widthSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: semibold15Black33,
                  overflow: TextOverflow.ellipsis,
                ),
                heightBox(3.0),
                Text(
                  text,
                  style: medium14Grey,
                  overflow: TextOverflow.ellipsis,
                ),
                heightBox(3.0),
                Row(
                  children: [
                    const Icon(
                      Icons.call,
                      color: blueColor,
                      size: 15,
                    ),
                    Expanded(
                      child: Text(
                        insideList[index]['Phonenumber'].toString(),
                        style: medium14Black33,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: 60,
            padding: const EdgeInsets.all(fixPadding * 0.7),
            decoration: BoxDecoration(
              color: boxColor,
              borderRadius: BorderRadius.circular(5.0),
            ),
            alignment: Alignment.center,
            child: Text(
              boxText,
              style: medium14White,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  tabBar() {
    return Stack(
      children: [
        Container(
          height: 45,
          width: double.maxFinite,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: greyD9Color, width: 2.0),
            ),
          ),
        ),
        SizedBox(
          height: 45.0,
          width: double.maxFinite,
          child: TabBar(
            controller: tabController,
            labelStyle: semibold16Black33.copyWith(fontFamily: "Inter"),
            labelColor: primaryColor,
            unselectedLabelColor: greyColor,
            unselectedLabelStyle: semibold16Grey.copyWith(fontFamily: "Inter"),
            tabs: [
              Tab(
                  text:
                      "${getTranslate(context, 'in_out.inside')}(${insideList.length})"),
              Tab(
                  text:
                      "${getTranslate(context, 'in_out.waiting')}(${waitingList.length})"),
            ],
          ),
        ),
      ],
    );
  }
}
