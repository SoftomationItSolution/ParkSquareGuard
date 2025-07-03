import 'dart:convert';

import 'package:Park360/localization/localization_const.dart';
import 'package:Park360/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../api.dart';

class InOutScreen extends StatefulWidget {
  const InOutScreen({super.key});

  @override
  State<InOutScreen> createState() => _InOutScreenState();
}

class _InOutScreenState extends State<InOutScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  List<Map<String, dynamic>> insideList = [];
  List<Map<String, dynamic>> waitingList = [];
  bool isLoading = true;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
    fetchData();
  }

  String extractFilename(String path) {
    return path.split('/').last;
  }

  // Future<void> fetchData() async {
  //   final response = await http.get(Uri.parse('${ApiConfig.baseUrl}api/visitor/get-all-permission'));

  //   if (response.statusCode == 200) {
  //     List<dynamic> data = json.decode(response.body);
  //     List<Map<String, dynamic>> inside = [];
  //     List<Map<String, dynamic>> waiting = [];

  //     for (var item in data) {
  //       if (item['permit'] == 1) {
  //         inside.add({
  //           "id": item['id'],
  //           "image": "assets/home/guests.png",
  //           "name": item['visitorName'],
  //           "number": item['flatNumber'],
  //           "type": item['visitorType'] ?? "Unknown",
  //           "Phonenumber": item['visitorContact']
  //         });
  //       } else if (item['permit'] == null) {
  //         waiting.add({
  //           "image": "assets/home/guests.png",
  //           "name": item['visitorName'],
  //           "number": item['flatNumber'],
  //           "type": item['visitorType'] ?? "Unknown",
  //           "Phonenumber": item['visitorContact']
  //         });
  //       }
  //     }

  //     setState(() {
  //       insideList = inside;
  //       waitingList = waiting;
  //       isLoading = false;
  //     });
  //   } else {
  //     // Handle error
  //     setState(() {
  //       isLoading = false;
  //     });
  //     throw Exception('Failed to load data');
  //   }
  // }

Future<void> fetchData() async {
  final response = await http.get(Uri.parse('${ApiConfig.baseUrl}api/visitor/get-all-permission'));

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    List<Map<String, dynamic>> inside = [];
    List<Map<String, dynamic>> waiting = [];

    for (var item in data) {
      String imageUrl = item['visitorImage'] != null 
          ? 'http://93.127.198.13:2005/uploads/${extractFilename(item['visitorImage'])}'
          : "assets/home/guests.png";
          
      if (item['permit'] == 1 && item['outTime'] == null) {
        inside.add({
          "id": item['id'],
          "image": imageUrl,
          "name": item['visitorName'],
          "number": item['flatNumber'],
          "type": item['visitorType'] ?? "Unknown",
          "Phonenumber": item['visitorContact']
        });
      } else if (item['permit'] == null) {
        waiting.add({
          "image": imageUrl,
          "name": item['visitorName'],
          "number": item['flatNumber'],
          "type": item['visitorType'] ?? "Unknown",
          "Phonenumber": item['visitorContact']
        });
      }
    }

    setState(() {
      insideList = inside;
      waitingList = waiting;
      isLoading = false;
    });
  } else {
    // Handle error
    setState(() {
      isLoading = false;
    });
    throw Exception('Failed to load data');
  }
}

Future<void> updateOutTime(String id) async {
  final url = Uri.parse('http://93.127.198.13:2005/update-outTime/$id');
  final outTime = DateTime.now().toIso8601String();

  try {
    final response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'outTime': outTime,
      }),
    );

    if (response.statusCode == 200) {
      print('OutTime updated successfully.');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Out time updated successfully!')),
      );
      // Refresh the data after updating
      fetchData();
    } else {
      print('Failed to update outTime.');
    }
  } catch (e) {
    print('Error: $e');
  }
}


  @override
  Widget build(BuildContext context) {
    print("Inside list length: ${insideList.length}");
  print("Waiting list length: ${waitingList.length}");
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
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
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
            waitingList[index]['name'].toString(),
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
            "${insideList[index]['number']} | ${insideList[index]['type']}",
            insideList[index]['name'].toString(),
            getTranslate(context, 'in_out.out'),
            redColor);
      },
    );
  }

 listContent(int index, image, text, name, boxText, boxColor) {
   if (index >= insideList.length) {
    print('Index $index is out of bounds for insideList');
    return Container();
   }
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
          child: image.startsWith('http')
              ? Image.network(
                  image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      "assets/home/guests.png",
                      fit: BoxFit.cover,
                    );
                  },
                )
              : Image.asset(
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
        GestureDetector(
          onTap: () async {
            await updateOutTime(insideList[index]['id'].toString());
          },
          child: Container(
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
