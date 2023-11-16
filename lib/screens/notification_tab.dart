import 'package:flutter/material.dart';
class NotificationTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationList(),
    );
  }
}

class NotificationList extends StatelessWidget {
  final List<String> notifications = [
    'Your item biscuit is expired today which was bought on 2023/1/22',
    'Your item colla batch bought on 2023/1/23 is expiring soon on 2023/12/12',
    'Your item biscuit is expired today which was bought on 2023/1/22',
    'Your item colla batch bought on 2023/1/23 is expiring soon on 2023/12/12',
    'Your item biscuit is expired today which was bought on 2023/1/22',
    'Your item colla batch bought on 2023/1/23 is expiring soon on 2023/12/12',
    'Your stoke is getting less please check on it',
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(notifications[index]),
          leading: Icon(Icons.notifications,color: Colors.redAccent,),
        );
      },
    );
  }
}
