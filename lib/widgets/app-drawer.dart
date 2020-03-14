import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Login'),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Contul meu'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.access_time),
            title: Text('Programari'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.business),
            title: Text('Companiile mele'),
          ),
          Divider(
            thickness: 1.0,
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
          ),
        ],
      ),
    );
  }
}
