import '../base-widgets/base-stateful-widget.dart';
import '../enums/actions-enum.dart';
import '../models/user.dart';
import '../providers/user-provider.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends BaseStatefulWidget {
  static const routeName = '/register';

  @override
  _RegisterScreenState createState() => _RegisterScreenState([
        'lblMandatoryField',
        'lblRegister',
        'lblRegisterNow',
        'lblFirstName',
        'lblLastName',
        'lblPhone',
        'lblPassword',
        'lblConfirmPassword',
        'lblInvalidEmail',
        'lblPasswordComplexity',
        'lblPasswordsDontMatch',
        'lblActivationLinkSent'
      ]);
}

class _RegisterScreenState extends BaseState<RegisterScreen> {
  final _form = GlobalKey<FormState>();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  final _firstNameFocusNode = FocusNode();
  final _lastNameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  final _passwordController = TextEditingController();

  User _user = User();

  _RegisterScreenState(List<String> labelsKeys) : super(labelsKeys) {
    this.widgetName = 'Register';
  }

  @override
  void dispose() {
    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    _emailFocusNode.dispose();
    _phoneFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();

    super.dispose();
  }

  Future<void> saveForm(BuildContext context) async {
    final isValid = _form.currentState.validate();
    if (!isValid) return null;

    _form.currentState.save();

    //submit
    final gro = await UserProvider().registerUser(_user);

    if (gro.error != '') {
      await logAction(
          this.idCompany, true, ActionsEnum.Add, gro.error, gro.errorDetailed);

      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('An error occurred'),
          duration: Duration(seconds: 1),
        ),
      );
    } else {
      logAction(this.idCompany, false, ActionsEnum.Add, '', 'Registered user');
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(getCurrentLabelValue('lblActivationLinkSent')),
          duration: Duration(seconds: 2),
        ),
      );

      Future.delayed(Duration(seconds: 2), () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    final appBar = AppBar(
      title: Text(getCurrentLabelValue('lblRegister')),
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
                                Icons.person,
                              ),
                              onPressed: () {},
                            ),
                            Expanded(
                              child: TextFormField(
                                focusNode: _firstNameFocusNode,
                                decoration: InputDecoration(
                                  labelText:
                                      getCurrentLabelValue('lblFirstName'),
                                  contentPadding: EdgeInsets.all(0),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).accentColor),
                                  ),
                                ),
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  return value.isEmpty
                                      ? getCurrentLabelValue(
                                          'lblMandatoryField')
                                      : null;
                                },
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context)
                                      .requestFocus(_lastNameFocusNode);
                                },
                                onSaved: (value) {
                                  _user.firstName = value;
                                },
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
                                Icons.person,
                              ),
                              onPressed: () {},
                            ),
                            Expanded(
                              child: TextFormField(
                                focusNode: _lastNameFocusNode,
                                decoration: InputDecoration(
                                  labelText:
                                      getCurrentLabelValue('lblLastName'),
                                  contentPadding: EdgeInsets.all(0),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).accentColor),
                                  ),
                                ),
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  return value.isEmpty
                                      ? getCurrentLabelValue(
                                          'lblMandatoryField')
                                      : null;
                                },
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context)
                                      .requestFocus(_emailFocusNode);
                                },
                                onSaved: (value) {
                                  _user.lastName = value;
                                },
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
                                Icons.email,
                              ),
                              onPressed: () {},
                            ),
                            Expanded(
                              child: TextFormField(
                                focusNode: _emailFocusNode,
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  contentPadding: EdgeInsets.all(0),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).accentColor),
                                  ),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value.isEmpty)
                                    return getCurrentLabelValue(
                                        'lblMandatoryField');
                                  else {
                                    Pattern pattern =
                                        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                    RegExp regex = new RegExp(pattern);
                                    if (!regex.hasMatch(value))
                                      return getCurrentLabelValue(
                                          'lblInvalidEmail');
                                  }
                                  return null;
                                },
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context)
                                      .requestFocus(_phoneFocusNode);
                                },
                                onSaved: (value) {
                                  _user.email = value;
                                },
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
                                Icons.phone,
                              ),
                              onPressed: () {},
                            ),
                            Expanded(
                              child: TextFormField(
                                focusNode: _phoneFocusNode,
                                decoration: InputDecoration(
                                  labelText: getCurrentLabelValue('lblPhone'),
                                  contentPadding: EdgeInsets.all(0),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).accentColor),
                                  ),
                                ),
                                keyboardType: TextInputType.phone,
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  return value.isEmpty
                                      ? getCurrentLabelValue(
                                          'lblMandatoryField')
                                      : null;
                                },
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context)
                                      .requestFocus(_passwordFocusNode);
                                },
                                onSaved: (value) {
                                  _user.phone = value;
                                },
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
                                focusNode: _passwordFocusNode,
                                controller: _passwordController,
                                decoration: InputDecoration(
                                  labelText:
                                      getCurrentLabelValue('lblPassword'),
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
                                  FocusScope.of(context)
                                      .requestFocus(_confirmPasswordFocusNode);
                                },
                                onSaved: (value) {
                                  _user.password = value;
                                },
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
                                focusNode: _confirmPasswordFocusNode,
                                decoration: InputDecoration(
                                  labelText: getCurrentLabelValue(
                                      'lblConfirmPassword'),
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
                                    if (value != _passwordController.text)
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
                                label: Text(
                                    getCurrentLabelValue('lblRegisterNow')),
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
