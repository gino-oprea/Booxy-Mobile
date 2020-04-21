import '../models/generic-response-object.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = GlobalKey<FormState>();

  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  Future<GenericResponseObject> saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) return null;

    _form.currentState.save(); //triggers onSaved on every form field

    //submit
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
                                      ? 'camp obligatoriu'
                                      : null;
                                },
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context)
                                      .requestFocus(_passwordFocusNode);
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
                              icon: Icon(Icons.lock_open),
                              onPressed: () {},
                            ),
                            Expanded(
                              child: TextFormField(
                                focusNode: _passwordFocusNode,
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  contentPadding: EdgeInsets.all(0),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).accentColor),
                                  ),
                                ),
                                textInputAction: TextInputAction.done,
                                validator: (value) {
                                  return value.isEmpty
                                      ? 'camp obligatoriu'
                                      : null;
                                },
                                onFieldSubmitted: (_) {},
                                onSaved: (value) {
                                  saveForm();
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
                                  saveForm();
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