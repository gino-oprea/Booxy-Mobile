import '../providers/login-provider.dart';
import 'package:flutter/material.dart';

class LangPickerDialog extends StatefulWidget {
  @override
  _LangPickerDialogState createState() => _LangPickerDialogState();
}

class _LangPickerDialogState extends State<LangPickerDialog> {
  var _isInit = true;

  String currentCulture = 'RO';

  getCurrentCulture() {
    LoginProvider().currentCulture.then((cult) {
      setState(() {
        this.currentCulture = cult;
      });
    });
  }

  setCurrentCulture() {
    LoginProvider()
        .setCurrentCulture(this.currentCulture)
        .then((value) => this.getCurrentCulture());
  }

  @override
  void didChangeDependencies() {
    if (this._isInit) {
      this.getCurrentCulture();
    }

    this._isInit = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: 0.0,
      child: Container(
        height: 200,
        child: Column(
          children: <Widget>[
            RadioListTile<String>(
              title: Text('RO'),
              value: 'RO',
              groupValue: this.currentCulture,
              onChanged: (value) {
                this.currentCulture = value;
                this.setCurrentCulture();
                Navigator.of(context).pop(this.currentCulture);
              },
            ),
            RadioListTile<String>(
              title: Text('EN'),
              value: 'EN',
              groupValue: this.currentCulture,
              onChanged: (value) {
                this.currentCulture = value;
                this.setCurrentCulture();
                Navigator.of(context).pop(this.currentCulture);
              },
            )
          ],
        ),
      ),
    );
  }
}
