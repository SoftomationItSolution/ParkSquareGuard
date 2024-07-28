import 'dart:convert';

import 'package:Park360/localization/localization_const.dart';
import 'package:Park360/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../api.dart';

class SelectEntryAddressScreen extends StatefulWidget {
  final Map<String, String> visitorData;

  const SelectEntryAddressScreen({Key? key, this.visitorData = const {}}) : super(key: key);

  @override
  State<SelectEntryAddressScreen> createState() => _SelectEntryAddressScreenState();
}

class _SelectEntryAddressScreenState extends State<SelectEntryAddressScreen> with TickerProviderStateMixin {
  TabController? tabController;
  List<dynamic> parkingData = [];
  List<String> towerNames = [];
  String? selectedFlatNumber;
  int? selectedFlatId;

  @override
  void initState() {
    super.initState();
    print("Received in SelectEntryAddressScreen: ${widget.visitorData}");
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('${ApiConfig.baseUrl}flatNumber'));
    if (response.statusCode == 200) {
      setState(() {
        parkingData = json.decode(response.body);
        towerNames = parkingData.map<String>((data) => data['tower_name'] as String).toSet().toList();
        tabController = TabController(length: towerNames.length, vsync: this);
      });
    } else {
      throw Exception('Failed to load parking data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: whiteColor,
        elevation: 0.0,
        titleSpacing: 0.0,
        centerTitle: false,
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
          getTranslate(context, 'select_entry_address.guest_entry'),
          style: semibold18Black33,
        ),
      ),
      body: parkingData.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                tabBar(),
                Expanded(
                  child: TabBarView(
                    controller: tabController,
                    physics: const BouncingScrollPhysics(),
                    children: towerNames.map((towerName) {
                      return towerListContent(towerName);
                    }).toList(),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: continueButton(),
    );
  }

  Widget continueButton() {
    return GestureDetector(
      onTap: () {
        if (selectedFlatNumber != null && selectedFlatId != null) {
          Navigator.pushNamed(
            context,
            '/confirmAndSendNotification',
            arguments: {
              ...widget.visitorData,
              'flatNumber': selectedFlatNumber,
              'flatId': selectedFlatId.toString(),
            },
          );
        } else {
        }
      },
      child: Container(
        margin: const EdgeInsets.all(fixPadding * 2.0),
        padding: const EdgeInsets.symmetric(horizontal: fixPadding * 2.0, vertical: fixPadding * 1.4),
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.2),
              blurRadius: 6.0,
            )
          ],
        ),
        child: Text(
          getTranslate(context, 'select_entry_address.continue'),
          style: semibold18White,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget towerListContent(String towerName) {
    final flats = parkingData.where((data) => data['tower_name'] == towerName).toList();
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(fixPadding * 2.0, fixPadding * 2.0, fixPadding * 2.0, fixPadding),
      itemCount: flats.length,
      itemBuilder: (context, index) {
        final flat = flats[index];
        final flatNumber = flat['flat_number'];
        final flatId = flat['id'];
        return listContent(flatNumber, flatId, isSelected: flatNumber == selectedFlatNumber);
      },
    );
  }

  Widget listContent(String flatNumber, int flatId, {bool isSelected = false}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFlatNumber = flatNumber;
          selectedFlatId = flatId;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: fixPadding),
        padding: const EdgeInsets.all(fixPadding * 1.3),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor.withOpacity(0.1) : whiteColor,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: isSelected ? primaryColor : Colors.transparent),
          boxShadow: [
            BoxShadow(
              color: shadowColor.withOpacity(0.2),
              blurRadius: 6.0,
            )
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          flatNumber,
          style: isSelected ? TextStyle(fontWeight: FontWeight.bold, color: primaryColor) : TextStyle(fontWeight: FontWeight.bold, color: blackColor),
        ),
      ),
    );
  }

  Widget tabBar() {
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
            isScrollable: true,
            controller: tabController,
            labelStyle: semibold16Black33.copyWith(fontFamily: "Inter"),
            labelColor: primaryColor,
            unselectedLabelColor: greyD9Color,
            unselectedLabelStyle: semibold16Grey.copyWith(fontFamily: "Inter"),
            tabs: towerNames.map((towerName) {
              return Tab(text: towerName);
            }).toList(),
          ),
        ),
      ],
    );
  }
}
