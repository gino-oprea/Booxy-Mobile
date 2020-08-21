import '../providers/log-provider.dart';

import '../enums/actions-enum.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../models/log-item.dart';
import '../models/user.dart';
import '../providers/culture-provider.dart';
import '../providers/login-provider.dart';
import '../providers/label-provider.dart';
import '../models/label.dart';

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
  String widgetName = '';
  List<String> widgetLabels;
  // String currentCulture = '';
  List<Label> currentLabels;
  //User currentUser;
  bool logViewAction = true;

  // CultureProvider cultureProvider;
  LoginProvider loginProvider;

  BaseState(List<String> labelsKeys) {
    this.widgetLabels = labelsKeys;
    this._getWidgetLabelsFromServer();

    // LoginProvider().currentUserProp.then((result) {
    //   this.currentUser = result;
    //   setState(() {});
    // });
  }

  Future<void> _getWidgetLabelsFromServer() async {
    this.currentLabels =
        await LabelProvider().getLabelsByKeyName(this.widgetLabels);
    setState(() {});
  }

  Future<void> logAction(int idCompany, bool isError, int idAction,
      String errMsg, String infoMsg) async {
    if (!this.logViewAction && idAction == ActionsEnum.View) return;

    if (this.widgetName.trim() != '') {
      User usr = await LoginProvider().currentUserProp;

      var log = new LogItem();

      if (usr != null) {
        log.idUser = usr.id;
        log.email = usr.email;
        log.userFirstName = usr.firstName;
        log.userLastName = usr.lastName;
        log.phone = usr.phone;
      }
      log.idCompany = this.idCompany;
      log.isError = isError;
      log.pageName = this.widgetName;
      log.idAction = idAction;
      log.actionName = ActionsEnum.getActionName(idAction);
      log.logErrorMessage = errMsg;
      log.logInfoMessage = infoMsg;

      LogProvider().setLog(log);
    }
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
      if (this.loginProvider.currentCulture == 'EN')
        return currLabel.en;
      else
        return currLabel.ro;
    } else
      return '';
  }

  // getCurrentCulture() {
  //   loginProvider.getCurrentCulture().then((cult) {
  //     //setState(() {
  //     this.currentCulture = cult;
  //     this.cultureProvider.changeCulture(this.currentCulture);
  //     //});
  //   });
  // }

  Future<void> setCurrentCulture(String culture) async {
    await loginProvider.setCurrentCulture(culture);
    // cultureProvider.changeCulture(this.currentCulture);
    //setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }

  @override
  void didChangeDependencies() {
    this.loginProvider = Provider.of<LoginProvider>(context);
    // this.cultureProvider = Provider.of<CultureProvider>(context);

    if (this._isInitBase) {
      loginProvider.currentUserProp.then((result) {
        // this.currentUser = result;
        // setState(() {});
        loginProvider.getCurrentCulture().then((_) {
          loginProvider.loginChange();
        });
      });

      // this.getCurrentCulture();
      this.logAction(this.idCompany, false, ActionsEnum.View, '', '');
    }

    this._isInitBase = false;
    super.didChangeDependencies();
  }
}
