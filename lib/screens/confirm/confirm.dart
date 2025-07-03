import 'dart:async';
import 'dart:convert';

import 'package:Park360/localization/localization_const.dart';
import 'package:Park360/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../api.dart';

class ConfirmScreen extends StatefulWidget {
  final Map<String, dynamic> entryData;

  const ConfirmScreen({Key? key, required this.entryData}) : super(key: key);

  @override
  State<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  bool isIn = true;
  String? visitorId;
  Duration duration = Duration.zero;
  Timer? timer;

  @override
  void initState() {
    super.initState();
  }

// @override
// void dispose() {
//   stopTimer();
//   super.dispose();
// }

// void startTimer() {
//   timer = Timer.periodic(Duration(seconds: 1), (timer) {
//     setState(() {
//       duration += Duration(seconds: 1);
//     });
//   });
// }

// void stopTimer() {
//   timer?.cancel();
//   timer = null;
// }

Future<void> addVisitorIn() async {
  final url = Uri.parse('${ApiConfig.baseUrl}api/visitor/addVisitorIn');
  final data = widget.entryData['data'] ?? {};

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'entryType': 'IN',
        'inTime': DateTime.now().toIso8601String(),
        'outTime': null,
        'duration': null,
        'gatePass': data['gatePass'],
        'visitorVehicle': null,
        'permit': 1,
        'tagId': '0',
        'tagEPC': '0',
        'visitorRC': '0',
        'visitorType': 'Frequent Entries',
        'company': null
      }),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      setState(() {
        visitorId = responseData['id'].toString();
        isIn = false;
        duration = Duration.zero;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Visitor checked in successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to check in visitor')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Network error: $e')),
    );
  }
}
  Future<void> updateVisitorOut() async {
    if (visitorId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No visitor ID available for check-out')),
      );
      return;
    }

    final url =
        Uri.parse('${ApiConfig.baseUrl}api/visitor/visitorOut/$visitorId');

    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'outTime': DateTime.now().toIso8601String(),
          'entryType': 'OUT',
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          isIn = true;
          visitorId = null;
        });
        // stopTimer();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Visitor checked out successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to check out visitor')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Network error: $e')),
      );
    }
  }
Future<void> addGuestIn() async {
  final url = Uri.parse('${ApiConfig.baseUrl}api/visitor/addGuestIn');
  final data = widget.entryData['data'] ?? {};

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'entryCode': data['entryCode'],
        'inTime': DateTime.now().toIso8601String(),
        'outTime': null,
        'duration': null,
        'flatId': data['flatId'],
        'userId': data['userId'],
        'visitorVehicle': null,
        'permit': 1,
        'tagId': '0',
        'tagEPC': '0',
        'visitorRC': '0',
        'visitorType': 'Guest',
        'company': null
      }),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Guest checked in successfully')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to check in guest')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Network error: $e')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isFrequent = widget.entryData['type'] == 'frequent';
    final data = widget.entryData['data'] ?? {};

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: whiteColor,
        elevation: 0.0,
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
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
            fixPadding * 2.0, fixPadding, fixPadding * 2.0, fixPadding * 2.0),
        physics: const BouncingScrollPhysics(),
        children: [
          heightSpace,
          heightSpace,
          heightSpace,
          heightSpace,
          Row(
            children: [
              detailBox(
                  getTranslate(context, 'confirm.guest'),
                  isFrequent
                      ? data['name']?.toString() ?? 'N/A'
                      : data['guestName']?.toString() ?? 'N/A'),
              widthSpace,
              widthSpace,
              detailBox(
                  getTranslate(context, 'confirm.visiting'),
                  isFrequent
                      ? "Flat ${data['flatId']?.toString() ?? 'N/A'}"
                      : "A-102"),
              widthSpace,
              widthSpace,
              detailBox(
                  getTranslate(context, 'confirm.gatepass'),
                  isFrequent
                      ? data['gatePass']?.toString() ?? 'N/A'
                      : data['entryCode']?.toString() ?? 'N/A'),
            ],
          ),
          heightSpace,
          heightSpace,
          detailBox(
              "Phone",
              isFrequent
                  ? data['contact']?.toString() ?? 'N/A'
                  : data['guestPhone']?.toString() ?? 'N/A'),
          if (isFrequent) ...[
            heightSpace,
            heightSpace,
            detailBox("Gender", data['gender']?.toString() ?? 'N/A'),
            heightSpace,
            heightSpace,
            detailBox("Age", data['age']?.toString() ?? 'N/A'),
          ] else ...[
            heightSpace,
            heightSpace,
            detailBox("Enter Date", formatDate(data['enterDate']?.toString())),
            heightSpace,
            heightSpace,
            detailBox("Enter Time", formatTime(data['enterTime']?.toString())),
          ],
          heightSpace,
          heightSpace,
          if (isFrequent) ...[
            heightSpace,
            heightSpace,
            // Text(
            //   "Duration: ${formatDuration(duration)}",
            //   style: semibold18Black33,
            //   textAlign: TextAlign.center,
            // ),
            heightSpace,
            heightSpace,
            Row(
              children: [
                Expanded(child: inOutButton(context)),
              ],
            )
          ] else
            confirmAndSendinButton(context)
        ],
      ),
    );
  }

  // Widget inOutButton(BuildContext context) {
  //   return GestureDetector(
  //     onTap: () {
  //       if (isIn) {
  //         addVisitorIn();
  //       } else {
  //         updateVisitorOut();
  //       }
  //     },
  //     child: Container(
  //       padding: const EdgeInsets.all(fixPadding * 1.4),
  //       decoration: BoxDecoration(
  //         color: isIn ? Colors.green : Colors.red,
  //         borderRadius: BorderRadius.circular(10.0),
  //         boxShadow: [
  //           BoxShadow(
  //             color: (isIn ? Colors.green : Colors.red).withOpacity(0.1),
  //             blurRadius: 12.0,
  //             offset: const Offset(0, 6),
  //           )
  //         ],
  //       ),
  //       alignment: Alignment.center,
  //       child: Text(
  //         isIn ? "In" : "Out",
  //         style: semibold18White,
  //         textAlign: TextAlign.center,
  //       ),
  //     ),
  //   );
  // }

Widget inOutButton(BuildContext context) {
  return GestureDetector(
    onTap: () {
      addVisitorIn();
    },
    child: Container(
      padding: const EdgeInsets.all(fixPadding * 1.4),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.1),
            blurRadius: 12.0,
            offset: const Offset(0, 6),
          )
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        "In",
        style: semibold18White,
        textAlign: TextAlign.center,
      ),
    ),
  );
}

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  String formatDate(String? dateStr) {
    if (dateStr == null) return 'N/A';
    try {
      DateTime date = DateTime.parse(dateStr);
      return DateFormat('dd-MM-yyyy').format(date);
    } catch (e) {
      return 'Invalid Date';
    }
  }

  String formatTime(String? timeStr) {
    if (timeStr == null) return 'N/A';
    try {
      DateTime time = DateTime.parse(timeStr);
      return DateFormat('HH:mm').format(time);
    } catch (e) {
      return 'Invalid Time';
    }
  }

  confirmAndSendinButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
         addGuestIn();
      },
      child: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.all(fixPadding * 1.4),
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.1),
              blurRadius: 12.0,
              offset: const Offset(0, 6),
            )
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          getTranslate(context, 'confirm.confirm_send_in'),
          style: semibold18White,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }



  detailBox(String title, String detail) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: fixPadding * 2.0, horizontal: fixPadding),
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
        child: Column(
          children: [
            Text(
              title,
              style: medium16Grey,
              overflow: TextOverflow.ellipsis,
            ),
            heightSpace,
            Text(
              detail,
              style: semibold16Black33,
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
      ),
    );
  }
}
