import 'package:booxy/providers/login-provider.dart';

import '../base-widgets/base-stateful-widget.dart';
import '../enums/actions-enum.dart';
import '../models/user.dart';
import '../providers/user-provider.dart';
import 'package:flutter/material.dart';

class ChangePasswordScreen extends BaseStatefulWidget {
  static const routeName = '/change-password';

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState([
        'lblChangePassword',
        'lblCurrentPassword',
        'lblNewPassword',
        'lblConfirmNewPassword',
        'lblYourPasswordChanged',
        'lblSave',
        'lblMandatoryField',
        'lblPasswordComplexity',
        'lblPasswordsDontMatch',
        'lblCurrentPasswordNotCorrect'
      ]);
}

class _ChangePasswordScreenState extends BaseState<ChangePasswordScreen> {
  final _form = GlobalKey<FormState>();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  final _currentPasswordFocusNode = FocusNode();
  final _newPasswordFocusNode = FocusNode();
  final _confirmNewPasswordFocusNode = FocusNode();

  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();

  _ChangePasswordScreenState(List<String> labelsKeys) : super(labelsKeys) {
    this.widgetName = 'Change Password';
  }

  @override
  void dispose() {
    _currentPasswordFocusNode.dispose();
    _newPasswordFocusNode.dispose();
    _confirmNewPasswordFocusNode.dispose();

    super.dispose();
  }

  Future<void> saveForm(BuildContext context) async {
    final isValid = _form.currentState.validate();
    if (!isValid) return null;

    bool isCurrentPassValid = await UserProvider().currentPasswordIsValid(
        loginProvider.currentUser.id, _currentPasswordController.text);

    if (!isCurrentPassValid) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(getCurrentLabelValue('lblCurrentPasswordNotCorrect')),
          duration: Duration(seconds: 2),
        ),
      );
      return null;
    }

    _form.currentState.save();

    loginProvider.currentUser.password = _newPasswordController.text;
    //submit
    final gro = await UserProvider().editUser(loginProvider.currentUser);

    loginProvider.currentUser.password = null; //resetare in aplicatie

    if (gro.error != '') {
      await logAction(
          this.idCompany, true, ActionsEnum.Edit, gro.error, gro.errorDetailed);

      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('An error occurred'),
          duration: Duration(seconds: 1),
        ),
      );
    } else {
      logAction(
          this.idCompany, false, ActionsEnum.Edit, '', 'Password changed');
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(getCurrentLabelValue('lblYourPasswordChanged')),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    final appBar = AppBar(
      title: Text(getCurrentLabelValue('lblChangePassword')),
    );

    return Scaffold(
      key: _scaffoldKey,
      appBar: appBar,
      body: Form(
        key: _form,
        child: SingleChildScrollView(
          child: Container(
            height: deviceHeight -
                appBar.preferredSize.height -
                MediaQuery.of(context).padding.top,
            width: deviceWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Card(
                  margin: EdgeInsets.all(25),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5, 10, 10, 20),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.lock_open,
                              ),
                              onPressed: () {},
                            ),
                            Expanded(
                              child: TextFormField(
                                focusNode: _currentPasswordFocusNode,
                                controller: _currentPasswordController,
                                decoration: InputDecoration(
                                  labelText: getCurrentLabelValue(
                                      'lblCurrentPassword'),
                                  contentPadding: EdgeInsets.all(0),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).accentColor),
                                  ),
                                ),
                                keyboardType: TextInputType.text,
                                obscureText: true,
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value.isEmpty)
                                    return getCurrentLabelValue(
                                        'lblMandatoryField');
                                  return null;
                                },
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context)
                                      .requestFocus(_newPasswordFocusNode);
                                },
                                onSaved: (value) {},
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.lock,
                              ),
                              onPressed: () {},
                            ),
                            Expanded(
                              child: TextFormField(
                                focusNode: _newPasswordFocusNode,
                                controller: _newPasswordController,
                                decoration: InputDecoration(
                                  labelText:
                                      getCurrentLabelValue('lblNewPassword'),
                                  contentPadding: EdgeInsets.all(0),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).accentColor),
                                  ),
                                ),
                                keyboardType: TextInputType.text,
                                obscureText: true,
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value.isEmpty)
                                    return getCurrentLabelValue(
                                        'lblMandatoryField');
                                  else {
                                    Pattern pattern =
                                        '((?=.*\\d)(?=.*[a-z])(?=.*[A-Z]).{8,})';
                                    RegExp regex = new RegExp(pattern);
                                    if (!regex.hasMatch(value))
                                      return getCurrentLabelValue(
                                          'lblPasswordComplexity');
                                  }
                                  return null;
                                },
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context).requestFocus(
                                      _confirmNewPasswordFocusNode);
                                },
                                onSaved: (value) {},
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.lock,
                              ),
                              onPressed: () {},
                            ),
                            Expanded(
                              child: TextFormField(
                                focusNode: _confirmNewPasswordFocusNode,
                                decoration: InputDecoration(
                                  labelText: getCurrentLabelValue(
                                      'lblConfirmNewPassword'),
                                  contentPadding: EdgeInsets.all(0),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).accentColor),
                                  ),
                                ),
                                keyboardType: TextInputType.text,
                                obscureText: true,
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value.isEmpty)
                                    return getCurrentLabelValue(
                                        'lblMandatoryField');
                                  else {
                                    if (value != _newPasswordController.text)
                                      return getCurrentLabelValue(
                                          'lblPasswordsDontMatch');
                                  }
                                  return null;
                                },
                                onFieldSubmitted: (_) {
                                  saveForm(context);
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              RaisedButton.icon(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(18.0)),
                                icon: Icon(Icons.done),
                                label: Text(getCurrentLabelValue('lblSave')),
                                onPressed: () {
                                  saveForm(context);
                                },
                                elevation: 1,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                color: Theme.of(context).accentColor,
                                textColor: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
