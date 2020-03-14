import 'package:booxy/widgets/app-drawer.dart';
import 'package:flutter/material.dart';

class CompanySearchScreen extends StatefulWidget {
  @override
  _CompanySearchScreenState createState() => _CompanySearchScreenState();
}

class _CompanySearchScreenState extends State<CompanySearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 40,          
          margin: EdgeInsets.symmetric(vertical: 5),
          child: TextField(  
            maxLines: 1,                            
            decoration: InputDecoration(
                hintText: 'Cauta companie',
                border: InputBorder.none,                
                fillColor: Colors.white,
                filled: true,),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.filter_list,
              color: Colors.white,
            ),
            onPressed: null,
          )
        ],
      ),
      drawer: AppDrawer(),
      body: Container(
        child: Text('test'),
      ),
    );
  }
}
