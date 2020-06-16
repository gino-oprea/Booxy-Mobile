import '../base-widgets/base-stateful-widget.dart';
import '../providers/login-provider.dart';
import 'package:flutter/material.dart';

class LoginScreen extends BaseStatefulWidget {
  static const routeName = '/login';

  @override
  _LoginScreenState createState() => _LoginScreenState([
    'lblInvalidLogin',
    'lblMandatoryField',
    'lblPassword'
  ]);
}

class _LoginScreenState extends BaseState<LoginScreen> {
  final _form = GlobalKey<FormState>();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  _LoginScreenState(List<String> labelsKeys) : super(labelsKeys);

  Future<void> saveForm(BuildContext context) async {
    final isValid = _form.currentState.validate();
    if (!isValid) return null;

    _form.currentState.save(); //triggers onSaved on every form field

    //submit
    bool isLoggedIn =
        await LoginProvider().login(_authData['email'], _authData['password']);

    if (!isLoggedIn)
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(getCurrentLabelValue('lblInvalidLogin')),
          duration: Duration(seconds: 2),
        ),
      );
    else {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    final appBar = AppBar(
      title: Text('Login'),
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
                                Icons.email,
                              ),
                              onPressed: () {},
                            ),
                            Expanded(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Email',
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
                                      .requestFocus(_passwordFocusNode);
                                },
                                onSaved: (value) {
                                  _authData['email'] = value;
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
                              icon: Icon(Icons.lock_open),
                              onPressed: () {},
                            ),
                            Expanded(
                              child: TextFormField(
                                focusNode: _passwordFocusNode,
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: getCurrentLabelValue('lblPassword'),
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
                                  saveForm(context);
                                },
                                onSaved: (value) {
                                  _authData['password'] = value;
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
                                label: Text('Login'),
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
