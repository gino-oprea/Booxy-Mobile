import 'package:provider/provider.dart';

import '../providers/culture-provider.dart';

import '../providers/login-provider.dart';

import '../providers/label-provider.dart';
import '../models/label.dart';
import 'package:flutter/material.dart';

class BaseStatefulWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return null;
  }
}

class BaseState<T extends BaseStatefulWidget> extends State<T> {
  var _isInitBase = true;

  int idCompany;
  String widgetName;
  List<String> widgetLabels;
  String currentCulture = '';
  List<Label> currentLabels;

  CultureProvider cultureProvider;

  BaseState(List<String> labelsKeys) {
    this.widgetLabels = labelsKeys;
    this._getWidgetLabelsFromServer();
  }

  Future<void> _getWidgetLabelsFromServer() async {
    this.currentLabels =
        await LabelProvider().getLabelsByKeyName(this.widgetLabels);
    setState(() {});
  }

  String getCurrentLabelValue(String keyName) {
    Label currLabel = new Label();
    if (this.currentLabels != null) {
      for (int i = 0; i < this.currentLabels.length; i++) {
        if (this.currentLabels[i].labelName == keyName) {
          currLabel = this.currentLabels[i];
          break;
        }
      }
      if (this.cultureProvider.getCurrentCulture() == 'EN')
        return currLabel.en;
      else
        return currLabel.ro;
    } else
      return '';
  }

  getCurrentCulture() {
    LoginProvider().currentCulture.then((cult) {
      //setState(() {
        this.currentCulture = cult;
        this.cultureProvider.changeCulture(this.currentCulture);
      //});
    });
  }

  Future<bool> setCurrentCulture() async {
    await LoginProvider().setCurrentCulture(this.currentCulture);
    cultureProvider.changeCulture(this.currentCulture);
    //setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }

  @override
  void didChangeDependencies() {
    if (this._isInitBase) {
      this.cultureProvider = Provider.of<CultureProvider>(context);
      this.getCurrentCulture();
    }

    this._isInitBase = false;

    super.didChangeDependencies();
  }
}
