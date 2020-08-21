import 'dart:convert';
import '../base-widgets/base-stateful-widget.dart';
import '../screens/company-bookings-admin-screen.dart';
import '../models/company.dart';
import 'package:flutter/material.dart';

class MyCompanyListItem extends BaseStatefulWidget {
  final Company company;
  dynamic memoryImage;

  MyCompanyListItem(this.company, this.memoryImage);

  @override
  _MyCompanyListItemState createState() => _MyCompanyListItemState([]);
}

class _MyCompanyListItemState extends BaseState<MyCompanyListItem> {
  _MyCompanyListItemState(List<String> labelsKeys) : super(labelsKeys);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () {
          Navigator.of(context).pushNamed(CompanyBookingsAdminScreen.routeName, arguments: widget.company);
        },
        leading: CircleAvatar(
          radius: 30.0,
          backgroundImage: widget.memoryImage,
          // widget.company.image.length > 0
          //     ? MemoryImage(base64Decode(widget.company.image[0].img))
          //     : NetworkImage(
          //         'https://i.ya-webdesign.com/images/vector-buildings-logo-1.png'),
          backgroundColor: Colors.transparent,
        ),
        title: Text(widget.company.name),
        subtitle: Text(widget.company.address),
        trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[Icon(Icons.arrow_right)]),
        isThreeLine: true,
      ),
    );
  }
}
