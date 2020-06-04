import 'package:booxy/providers/label-provider.dart';

import '../models/label.dart';

mixin BaseWidget {
  int idCompany;
  String widgetName;
  List<String> widgetLabels;
  String currentCulture = 'RO';
  List<Label> currentLabels;

  Future<void> getWidgetLabelsFromServer() async {
    this.currentLabels =
        await LabelProvider().getLabelsByKeyName(this.widgetLabels);
  }

  String getCurrentLabelValue(String keyName) {
    Label currLabel = new Label();
    for (int i = 0; i < this.currentLabels.length; i++) {
      if (this.currentLabels[i].labelName == keyName) {
        currLabel = this.currentLabels[i];
        break;
      }
    }
    if (this.currentCulture == 'EN')
      return currLabel.en;
    else
      return currLabel.ro;
  }
}
