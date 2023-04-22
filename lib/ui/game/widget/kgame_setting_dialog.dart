import 'package:app_core/app_core.dart';
import 'package:app_core/lingo/kphrases.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/Picker.dart';

class KGameSettingDialog extends StatefulWidget {
  final Function onClose;

  const KGameSettingDialog({
    required this.onClose,
  });

  @override
  _KGameSettingDialogState createState() => _KGameSettingDialogState();
}

class _KGameSettingDialogState extends State<KGameSettingDialog> {
  late Picker gradePicker;

  static List<String> CALC_LIST = ["+", "-", "x", ":"];
  List<String> calcSelected = [CALC_LIST.first];
  int grade = 1;

  bool isLoaded = false;

  @override
  void initState() {
    super.initState();

    initPicker();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void initPicker() {
    this.setState(() {
      gradePicker = Picker(
        selecteds: [grade],
        height: 130,
        looping: true,
        itemExtent: 60,
        onSelect: (Picker picker, int index, List<int> selected) {
          this.grade = selected[0];
        },
        adapter: NumberPickerAdapter(data: [
          NumberPickerColumn(
            begin: 0,
            end: 13,
            onFormatValue: (value) {
              if (value == -1) {
                return KPhrases.preSchool;
              } else if (value == 0) {
                return KPhrases.kindergarten;
              }
              return "$value";
            },
          ),
          // NumberPickerColumn(begin: 0, end: 25),
        ]),
        hideHeader: true,
        backgroundColor: Colors.transparent,
        containerColor: Colors.transparent,
        textStyle: TextStyle(
          color: Colors.white,
        ),
        selectedTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      );
    });
  }

  void onSelectCalc(calc) {
    this.setState(() {
      if (calcSelected.contains(calc)) {
        calcSelected.remove(calc);
      } else {
        calcSelected.add(calc);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final body = Container(
      width: MediaQuery.of(context).size.width * 0.85,
      height: MediaQuery.of(context).size.height * 0.50,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            KAssets.IMG_RANKING_BLUE,
            package: 'app_core',
          ),
          fit: BoxFit.fill,
        ),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Transform.translate(
              offset: Offset(15, -5),
              child: InkWell(
                onTap: () => widget.onClose(),
                child: Container(
                  width: 50,
                  height: 50,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Transform.translate(
                  offset: Offset(5, -5),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: FittedBox(
                      child: Text(
                        "SETTING",
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Text(
                  "Select Grade",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 100,
                  child: gradePicker.makePicker(),
                ),
                SizedBox(
                  height: 25,
                ),
                Text(
                  "Select Calculation",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: GridView.count(
                    shrinkWrap: true,
                    childAspectRatio: 1,
                    crossAxisCount: 4,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(10),
                    children: CALC_LIST
                        .map(
                          (calc) => Container(
                            key: Key(calc),
                            padding: EdgeInsets.symmetric(
                              vertical: 3,
                              horizontal: 3,
                            ),
                            child: InkWell(
                              onTap: () {
                                onSelectCalc(calc);
                              },
                              child: Container(
                                decoration: calcSelected.contains(calc)
                                    ? BoxDecoration(
                                        color: Color(0xff2c1c44),
                                        borderRadius: BorderRadius.circular(5),
                                      )
                                    : BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border(
                                          right: BorderSide(
                                            width: 5,
                                            color: Color(0xff2c1c44),
                                          ),
                                          left: BorderSide(
                                            width: 5,
                                            color: Color(0xff2c1c44),
                                          ),
                                          top: BorderSide(
                                            width: 5,
                                            color: Color(0xff2c1c44),
                                          ),
                                          bottom: BorderSide(
                                            width: 5,
                                            color: Color(0xff2c1c44),
                                          ),
                                        ),
                                      ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${calc}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 40,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return body;
  }
}
