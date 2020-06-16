import '../base-widgets/base-stateful-widget.dart';
import '../providers/user-provider.dart';
import '../models/generic-response-object.dart';
import '../providers/login-provider.dart';
import '../models/user.dart';
import 'package:flutter/material.dart';

class MyAccountScreen extends BaseStatefulWidget {
  static const routeName = '/my-account';

  @override
  _MyAccountScreenState createState() => _MyAccountScreenState([
    'lblSaved',
    'lblMyAccount',
    'lblFirstName',
    'lblLastName',
    'lblPhone',
    'lblMandatoryField',
    'lblSave'
    ]);
}

class _MyAccountScreenState extends BaseState<MyAccountScreen> {
  bool _isInit = true;

  final _form = GlobalKey<FormState>();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  final _firstNameFocusNode = FocusNode();
  final _lastNameFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  var _editedUser = new User();

  _MyAccountScreenState(List<String> labelsKeys) : super(labelsKeys);

  @override
  void didChangeDependencies() {
    if (_isInit) {
      LoginProvider().currentUser.then((usr) {
        setState(() {
          this._editedUser = usr;
          this._firstNameController.text = usr.firstName;
          this._lastNameController.text = usr.lastName;
          this._emailController.text = usr.email;
          this._phoneController.text = usr.phone;
        });
      });
    }

    _isInit = false;

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    _phoneFocusNode.dispose();
    _emailFocusNode.dispose();

    super.dispose();
  }

  Future<GenericResponseObject> saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) return null;

    _form.currentState.save(); //triggers onSaved on every form field
    //submit

    var gro = await UserProvider().editUser(_editedUser);
    if (gro.info.indexOf('success') > -1)
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(getCurrentLabelValue('lblSaved')),
          duration: Duration(seconds: 2),
        ),
      );
    else {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(gro.error),
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
      title: Text(getCurrentLabelValue('lblMyAccount')),
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
                                controller: _firstNameController,
                                decoration: InputDecoration(
                                  labelText: getCurrentLabelValue('lblFirstName'),
                                  contentPadding: EdgeInsets.all(0),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).accentColor),
                                  ),
                                ),
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  return value.isEmpty
                                      ? getCurrentLabelValue('lblMandatoryField')
                                      : null;
                                },
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context)
                                      .requestFocus(_lastNameFocusNode);
                                },
                                onSaved: (value) {
                                  this._editedUser.firstName = value;
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
                              icon: Icon(Icons.person),
                              onPressed: () {},
                            ),
                            Expanded(
                              child: TextFormField(
                                focusNode: _lastNameFocusNode,
                                controller: _lastNameController,
                                decoration: InputDecoration(
                                  labelText: getCurrentLabelValue('lblLastName'),
                                  contentPadding: EdgeInsets.all(0),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).accentColor),
                                  ),
                                ),
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  return value.isEmpty
                                      ? getCurrentLabelValue('lblMandatoryField')
                                      : null;
                                },
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context)
                                      .requestFocus(_phoneFocusNode);
                                },
                                onSaved: (value) {
                                  this._editedUser.lastName = value;
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
                              onPressed: () {},
                              icon: Icon(Icons.phone),
                            ),
                            Expanded(
                              child: TextFormField(
                                focusNode: _phoneFocusNode,
                                controller: _phoneController,
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
                                      ? getCurrentLabelValue('lblMandatoryField')
                                      : null;
                                },
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context)
                                      .requestFocus(_emailFocusNode);
                                },
                                onSaved: (value) {
                                  this._editedUser.phone = value;
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
                              icon: Icon(Icons.email),
                              onPressed: () {},
                            ),
                            Expanded(
                              child: TextFormField(
                                focusNode: _emailFocusNode,
                                controller: _emailController,
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  contentPadding: EdgeInsets.all(0),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).accentColor),
                                  ),
                                ),
                                textInputAction: TextInputAction.done,
                                validator: (value) {
                                  return value.isEmpty
                                      ? getCurrentLabelValue('lblMandatoryField')
                                      : null;
                                },
                                onFieldSubmitted: (_) {
                                  this.saveForm();
                                },
                                onSaved: (value) {
                                  this._editedUser.email = value;
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 40,
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
                                  this.saveForm();
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
