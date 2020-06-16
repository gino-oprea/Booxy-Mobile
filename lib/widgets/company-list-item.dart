import 'dart:convert';
import '../base-widgets/base-stateful-widget.dart';
import '../models/company.dart';
import '../screens/company-details-screen.dart';
import 'package:flutter/material.dart';

class CompanyListItem extends BaseStatefulWidget {
  final Company company;

  CompanyListItem(this.company);

  @override
  _CompanyListItemState createState() => _CompanyListItemState([]);
}

class _CompanyListItemState extends BaseState<CompanyListItem> {
  _CompanyListItemState(List<String> labelsKeys) : super(labelsKeys);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () {
          Navigator.of(context).pushNamed(CompanyDetailsScreen.routeName,
              arguments: this.widget.company);
        },
        leading: CircleAvatar(
          radius: 30.0,
          backgroundImage: widget.company.image.length > 0
              ? MemoryImage(base64Decode(widget.company.image[0].img))
              : NetworkImage(
                  'https://i.ya-webdesign.com/images/vector-buildings-logo-1.png'),
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
