import 'package:booxy/providers/login-provider.dart';
import 'package:booxy/screens/company-search-screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InitializeScreen extends StatefulWidget {
  static const routeName = '/initialize';

  @override
  _InitializeScreenState createState() => _InitializeScreenState();
}

class _InitializeScreenState extends State<InitializeScreen> {
  var _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<LoginProvider>(context).currentUserProp.then((result) {        
        Provider.of<LoginProvider>(context).getCurrentCulture().then((_) {            
          Navigator.of(context).pushReplacementNamed(CompanySearchScreen.routeName);
        });
      });
    }

    _isInit = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(        
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }
}
