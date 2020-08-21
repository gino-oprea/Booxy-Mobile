import 'package:booxy/enums/actions-enum.dart';

import '../base-widgets/base-stateful-widget.dart';
import 'package:flutter/material.dart';

class LangPickerDialog extends BaseStatefulWidget {
  @override
  _LangPickerDialogState createState() => _LangPickerDialogState([]);
}

class _LangPickerDialogState extends BaseState<LangPickerDialog> {
  _LangPickerDialogState(List<String> labelsKeys) : super(labelsKeys) {
    this.widgetName = 'Language picker dialog';
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
              groupValue: loginProvider.currentCulture,
              onChanged: (value) async {
                //this.currentCulture = value;
                await this.setCurrentCulture(value);
                logAction(this.idCompany, false, ActionsEnum.Edit, '',
                    'Change culture to RO');
                Navigator.of(context).pop(value);
              },
            ),
            RadioListTile<String>(
              title: Text('EN'),
              value: 'EN',
              groupValue: loginProvider.currentCulture,
              onChanged: (value) async {
                // this.currentCulture = value;
                await this.setCurrentCulture(value);
                logAction(this.idCompany, false, ActionsEnum.Edit, '',
                    'Change culture to EN');
                Navigator.of(context).pop(value);
              },
            )
          ],
        ),
      ),
    );
  }
}
