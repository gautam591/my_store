import 'dart:convert';

import 'package:flutter/material.dart';

import '../request.dart';
class NotificationTab extends StatefulWidget {
  final Map<String, dynamic> user;

  const NotificationTab({
    super.key,
    required this.user,
  });

  @override
  State<NotificationTab> createState() => _NotificationTabState();
}

class _NotificationTabState extends State<NotificationTab>{
  Map<String, dynamic> dataNotifications = {};
  List<String> notifications = [];

  Future<void> getNotifications({bool refresh = true}) async {
    String itemsExpiryRaw = json.encode(await Requests.getNotifications(widget.user['uid'], refresh: refresh));
    dataNotifications = json.decode(itemsExpiryRaw)['data'];
    setState(() {
      notifications = [];
      dataNotifications.forEach((key, value) {
        notifications.add('$value');
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getNotifications(refresh: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: getNotifications,
        child: ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(notifications[index]),
              leading: Icon(Icons.notifications,color: Colors.redAccent,),
            );
          },
        ),
      ),
    );
  }
}
