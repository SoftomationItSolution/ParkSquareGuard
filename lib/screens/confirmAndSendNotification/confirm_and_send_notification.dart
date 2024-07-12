import 'dart:convert';

import 'package:fl_sevengen_society_guard_app/localization/localization_const.dart';
import 'package:fl_sevengen_society_guard_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../api.dart';
import '../../api/notification.dart';


IO.Socket socket = IO.io('http://93.127.198.13:5016', <String, dynamic>{
  'transports': ['websocket'],
  'autoConnect': false,
});

class ConfirmAndSendNotificationScreen extends StatefulWidget {
  final Map<String, String> visitorData;

  const ConfirmAndSendNotificationScreen({Key? key, this.visitorData = const {}}) : super(key: key);

  @override
  State<ConfirmAndSendNotificationScreen> createState() => _ConfirmAndSendNotificationScreenState();
}

class _ConfirmAndSendNotificationScreenState extends State<ConfirmAndSendNotificationScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController vehicleTypeController = TextEditingController();
  TextEditingController vehicleNumberController = TextEditingController();
  TextEditingController flatNumberController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController visitorRcController = TextEditingController();


   @override
  void initState() {
    super.initState();
    print("Received visitor data: ${widget.visitorData}");

    nameController.text = widget.visitorData['visitorName'] ?? '';
    contactController.text = widget.visitorData['visitorContact'] ?? '';
    vehicleTypeController.text = widget.visitorData['visitorVehicleType'] ?? '';
    vehicleNumberController.text = widget.visitorData['visitorVehicleNumber'] ?? '';
    flatNumberController.text = widget.visitorData['flatNumber'] ?? '';
    timeController.text = "1 hour";
    // visitorRcController.text = widget.visitorData['visitorRC']??'';
    // Connect to the socket
    socket.connect();
    socket.onConnect((_) {
      print('Connected to socket server');
    });

    socket.onConnectError((data) {
      print('Connection error: $data');
    });

    socket.onError((data) {
      print('Error: $data');
    });

    socket.onDisconnect((_) {
      print('Disconnected from socket server');
    });
  }

  Future<void> fetchDataFromApi() async {
  final url = Uri.parse('${ApiConfig.baseUrl}api/visitor/get-last-permission');
  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = (response.body);
      // print('Received data from API: $data');
      
      // Emit the data to the socket
      if (socket.connected) {
        socket.emit('send_message', data);
        print('Emitted data to socket: $data');
      } else {
        print('Socket not connected');
      }
    } else {
      print('Failed to fetch data. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('An error occurred while fetching data: $e');
  }
}

Future<List<Map<String, dynamic>>> checkUserIds(int flatId) async {
  final url = Uri.parse('${ApiConfig.baseUrl}api/visitor/check-id/$flatId');
  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      print('response checkIds: $data');

      return data.map((item) => {
        'UserId': item['UserId'] as int? ?? 0,
        'Token': item['Token'] as String? ?? '',
      }).toList();
    } else {
      print('Failed to fetch user IDs. Status code: ${response.statusCode}');
      print('Failed to fetch user IDs. Response body: ${response.body}');
      return [];
    }
  } catch (e) {
    print('An error occurred while fetching user IDs: $e');
    return [];
  }
}

Future<void> sendDataToApi() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final int userLoggedinId = prefs.getInt('user_id') ?? 0;
  final int flatId = int.parse(widget.visitorData['flatId'] ?? '0');

  final List<Map<String, dynamic>> userInfo = await checkUserIds(flatId);
  
  final url = Uri.parse('${ApiConfig.baseUrl}log-permission');
  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'visitorVehicle': vehicleTypeController.text,
        'visitorName': nameController.text,
        'visitorContact': contactController.text,
        'flatNumber': flatNumberController.text,
        'flatId': widget.visitorData['flatId'],
        'flatUserId': userLoggedinId,
        'permit': null,
        'visitorRC': vehicleNumberController.text,
        'tagEPC': "0",
        'tagId': "0"
      }),
    );

    if (response.statusCode == 200) {
      print('Socket connected: ${socket.connected}');
      if (socket.connected) {
        // Fetch data from the API and emit it
        await fetchDataFromApi();

        // Send notifications to all users
        for (var user in userInfo) {
          bool notificationSent = await sendNotifications(
            fcmToken: user['Token'],
            title: "New Visitor",
            body: "A new visitor ${nameController.text} has arrived.",
          );
          print("Notification sent to UserId ${user['UserId']}: $notificationSent");
        }

        Navigator.pushNamed(context, '/ringing');
      } else {
        print('Socket not connected');
      }
    } else {
      // Handle API error (existing code)
    }
  } catch (e) {
    // Handle network or other errors (existing code)
  }
}
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
          getTranslate(context, 'confirm_send_notification.guest_entry'),
          style: semibold18Black33,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
            fixPadding * 2.0, fixPadding, fixPadding * 2.0, fixPadding * 2.0),
        physics: const BouncingScrollPhysics(),
        children: [
          Image.asset(
            "assets/home/guests.png",
            height: size.height * 0.13,
          ),
          heightSpace,
          heightSpace,
          heightSpace,
          heightSpace,
          guestNameField(),
          heightSpace,
          heightSpace,
          contactField(),
          heightSpace,
          heightSpace,
          vehicleTypeField(),
          heightSpace,
          heightSpace,
          vehicleNumberField(),
          heightSpace,
          heightSpace,
          flatNumberField(),
          
          // visitorRCField()
        ],
      ),
      bottomNavigationBar: confirmAndSendNotificationButton(),
    );
  }

  Widget confirmAndSendNotificationButton() {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: GestureDetector(
        onTap: sendDataToApi,
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
              )
            ],
          ),
          child: Text(
            getTranslate(context, 'confirm_send_notification.confirm_and_send_notification'),
            style: semibold18White,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  Widget guestNameField() {
    return buildTextField(
      label: getTranslate(context, 'confirm_send_notification.guest_name'),
      controller: nameController,
      keyboardType: TextInputType.name,
    );
  }

  Widget contactField() {
    return buildTextField(
      label: getTranslate(context, 'confirm_send_notification.contact'),
      controller: contactController,
      keyboardType: TextInputType.phone,
    );
  }

  Widget vehicleTypeField() {
    return buildTextField(
      label: getTranslate(context, 'confirm_send_notification.vehicle_type'),
      controller: vehicleTypeController,
    );
  }

  Widget vehicleNumberField() {
    return buildTextField(
      label: getTranslate(context, 'confirm_send_notification.vehicle_number'),
      controller: vehicleNumberController,
    );
  }

  Widget flatNumberField() {
    return buildTextField(
      label: getTranslate(context, 'confirm_send_notification.flat_number'),
      controller: flatNumberController,
    );
  }

  // Widget visitorRCField() {
  //   return buildTextField(
  //     label: getTranslate(context, 'Visitor RC'),
  //     controller: visitorRcController,
  //     // keyboardType: TextInputType.name,
  //   );
  // }

  Widget insideTimeField() {
    return buildTextField(
      label: getTranslate(context, 'confirm_send_notification.inside_time'),
      controller: timeController,
    );
  }

  Widget buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: medium16Grey,
        ),
        heightSpace,
        Container(
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: shadowColor.withOpacity(0.25),
                blurRadius: 6.0,
              )
            ],
          ),
          child: TextField(
            controller: controller,
            style: semibold16Black33,
            cursorColor: primaryColor,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: fixPadding, vertical: fixPadding * 1.4),
              hintStyle: medium16Grey,
            ),
          ),
        )
      ],
    );
  }
}