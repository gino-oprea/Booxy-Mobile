import 'dart:convert';
import 'package:booxy/enums/actions-enum.dart';
import 'package:booxy/providers/companies-provider.dart';
import 'package:provider/provider.dart';
import '../base-widgets/base-stateful-widget.dart';
import '../models/company.dart';
import '../screens/company-details-screen.dart';
import 'package:flutter/material.dart';

class CompanyListItem extends BaseStatefulWidget {
  final Company company;
  final bool showFavouritesButton;
  bool isFavourite;
  dynamic memoryImage;

  void Function(String) showPageMessage;

  CompanyListItem(this.company, this.showFavouritesButton, this.isFavourite, this.memoryImage,
      this.showPageMessage);

  @override
  _CompanyListItemState createState() => _CompanyListItemState([]);
}

class _CompanyListItemState extends BaseState<CompanyListItem> {
  _CompanyListItemState(List<String> labelsKeys) : super(labelsKeys) {
    this.widgetName = 'Company list item';
    this.logViewAction = false;
  }

  @override
  void didChangeDependencies() {
    this.idCompany = widget.company.id;

    super.didChangeDependencies();
  }

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
          children: <Widget>[
            if (widget.showFavouritesButton)
              IconButton(
                icon: Icon(
                  widget.isFavourite ? Icons.favorite : Icons.favorite_border,
                ),
                color: Theme.of(context).accentColor,
                onPressed: () async {
                  if (widget.isFavourite) {
                    var gro = await Provider.of<CompaniesProvider>(context)
                        .deleteFavouriteCompany(widget.company.id);
                    if (gro.error != '') {
                      widget.showPageMessage(gro.error);
                      this.logAction(widget.company.id, true,
                          ActionsEnum.Delete, gro.error, gro.errorDetailed);
                    } else {
                      setState(() {
                        widget.isFavourite = false;
                      });
                    }
                  } else {
                    var gro = await Provider.of<CompaniesProvider>(context)
                        .setFavouriteCompany(widget.company.id);
                    if (gro.error != '') {
                      widget.showPageMessage(gro.error);
                      this.logAction(widget.company.id, true, ActionsEnum.Add,
                          gro.error, gro.errorDetailed);
                    } else {
                      setState(() {
                        widget.isFavourite = true;
                      });
                    }
                  }
                },
              ),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }
}
