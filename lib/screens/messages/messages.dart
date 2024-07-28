import 'package:Park360/localization/localization_const.dart';
import 'package:Park360/theme/theme.dart';
import 'package:flutter/material.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final messagesList = [
    {
      "image": "assets/messages/image1.png",
      "name": "Cody Fisher (A-202)",
      "lastMessage": "Keep street dog away from..",
      "time": "2.00am"
    },
    {
      "image": "assets/messages/image2.png",
      "name": "Albert Flores (B-101)",
      "lastMessage": "Keep street dog away from..",
      "time": "2.00am"
    },
    {
      "image": "assets/messages/image3.png",
      "name": "Devon Lane (A-402)",
      "lastMessage": "Keep street dog away from..",
      "time": "2.00am"
    },
    {
      "image": "assets/messages/image4.png",
      "name": "Albert Flores (C-302)",
      "lastMessage": "Keep street dog away from..",
      "time": "2.00am"
    },
    {
      "image": "assets/messages/image5.png",
      "name": "Marvin McKinney (A-105)",
      "lastMessage": "Keep street dog away from..",
      "time": "2.00am"
    },
    {
      "image": "assets/messages/image6.png",
      "name": "Jerome Bell (B-202)",
      "lastMessage": "Keep street dog away from..",
      "time": "2.00am"
    },
    {
      "image": "assets/messages/image7.png",
      "name": "Robert Fox (A-601)",
      "lastMessage": "Keep street dog away from..",
      "time": "2.00am"
    },
    {
      "image": "assets/messages/image8.png",
      "name": "Annette Black(A-105)",
      "lastMessage": "Keep street dog away from..",
      "time": "2.00am"
    },
    {
      "image": "assets/messages/image9.png",
      "name": "Jerome Bell (B-505)",
      "lastMessage": "Keep street dog away from..",
      "time": "2.00am"
    },
    {
      "image": "assets/messages/image10.png",
      "name": "Guy Hawkins (A-602)",
      "lastMessage": "Keep street dog away from..",
      "time": "2.00am"
    },
    {
      "image": "assets/messages/image11.png",
      "name": "Annette Black (B-104)",
      "lastMessage": "Keep street dog away from..",
      "time": "2.00am"
    },
    {
      "image": "assets/messages/image12.png",
      "name": "Darrell Steward (A-506)",
      "lastMessage": "Keep street dog away from..",
      "time": "2.00am"
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
          getTranslate(context, 'message.message'),
          style: semibold18Black33,
        ),
      ),
      body: messageListContent(),
    );
  }

  messageListContent() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: fixPadding),
      itemCount: messagesList.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(
              vertical: fixPadding, horizontal: fixPadding * 2.0),
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/chat');
            },
            child: Row(
              children: [
                Container(
                  height: 50.0,
                  width: 50.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(
                        messagesList[index]['image'].toString(),
                      ),
                    ),
                  ),
                ),
                width5Space,
                widthSpace,
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              messagesList[index]['name'].toString(),
                              style: medium16Primary,
                              overflow: TextOverflow.ellipsis,
                            ),
                            height5Space,
                            Text(
                              messagesList[index]['lastMessage'].toString(),
                              style: medium14Grey,
                              overflow: TextOverflow.ellipsis,
                            )
                          ],
                        ),
                      ),
                      Text(
                        messagesList[index]['time'].toString(),
                        style: medium14Grey,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
