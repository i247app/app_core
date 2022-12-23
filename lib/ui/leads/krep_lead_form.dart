import 'dart:async';

import 'package:app_core/header/khoc_header.dart';
import 'package:app_core/helper/kserver_handler.dart';
import 'package:app_core/model/klead.dart';
import 'package:app_core/ui/widget/kradio.dart';
import 'package:app_core/value/kphrases.dart';
import 'package:app_core/app_core.dart';
import 'package:app_core/ui/widget/keyboard_killer.dart';
import 'package:flutter/material.dart';
import 'package:wheel_chooser/wheel_chooser.dart';

class _KLocationInfo {
  final KLatLng latLng;
  final String formattedAddress;

  _KLocationInfo({required this.latLng, required this.formattedAddress});
}

class KREPLeadForm extends StatefulWidget {
  final KLead? lead;

  KREPLeadForm({required this.lead});

  @override
  State<StatefulWidget> createState() => _KREPLeadFormState();
}

class _KREPLeadFormState extends State<KREPLeadForm> {
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController storeNameController = TextEditingController();
  final TextEditingController contactNameController = TextEditingController();
  final TextEditingController contactPhoneController = TextEditingController();
  final TextEditingController contactEmailController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final KRadioController statusController = KRadioController();

  final Map<String, String> leadStatuses = {
    KLead.STATUS_YES: "Yes",
    KLead.STATUS_NO: "No",
    KLead.STATUS_FOLLOW_UP: "Maybe",
    KLead.STATUS_NONE: "None",
  };

  // ignore: cancel_subscriptions
  // StreamSubscription? posStreamSub;
  //
  // _LocationInfo? bgLoc;
  //
  // _LocationInfo? syncLoc;

  bool get isCreate => widget.lead == null;
  bool isLoading = false;

  String? appbarTitle;

  final Map<String, String> tags = {
    KHocHeader.MAM_NON: "Mầm Non",
    KHocHeader.MAU_GIAO: "Mẫu Giáo",
  };

  final Map<String, String> tagsCap = {
    KHocHeader.CAP_1: "Cấp 1",
    KHocHeader.CAP_2: "Cấp 2",
    KHocHeader.CAP_3: "Cấp 3",
  };

  final Map<String, String> tagsDayKem = {
    KHocHeader.DAY_KEM: "Dạy Kèm",
    KHocHeader.LOP: "Lớp",
    KHocHeader.VO_LONG: "Vỡ Lòng",
  };

  final Map<String, String> tagsLuyenthi = {
    KHocHeader.LT_HK: "LT HK",
    KHocHeader.LT_LEN_6: "LT Lên 6",
    KHocHeader.LT_LEN_10: "LT Lên 10",
    KHocHeader.LT_THPT: "LT THPT",
    KHocHeader.LT_DH: "LT ĐH",
  };

  final List<String> tagsUserType = ["Student", "Tutor", "GV", "User", "Guest"];

  final List<String> tagsGigMedium = [
    KHocHeader.MEDIUM_ONLINE,
    KHocHeader.MEDIUM_IN_PERSON,
  ];

  List<String> leadInterests = [];
  String? userType;
  String? gigMedium;
  int grade = 1;

  List<int> gradeList = [-1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];

  // late Picker gradePicker;

  @override
  void initState() {
    super.initState();

    print("isCreate $isCreate");

    statusController.id = KLead.STATUS_NONE;

    // if (isCreate)
    //   setupLocationListener();
    // else
    if (widget.lead != null) fillFormData(widget.lead!);
  }

  @override
  void dispose() {
    // this.posStreamSub!.cancel();
    super.dispose();
  }

  // void initPicker() {
  //   this.setState(() {
  //     gradePicker = Picker(
  //       selecteds: [grade],
  //       height: 100,
  //       looping: true,
  //       itemExtent: 60,
  //       onSelect: (Picker picker, int index, List<int> selected) {
  //         this.grade = selected[0];
  //       },
  //       adapter: NumberPickerAdapter(data: [
  //         NumberPickerColumn(
  //           begin: -1,
  //           end: 12,
  //           onFormatValue: (value) {
  //             if (value == -1) {
  //               return Phrases.shortPreSchool;
  //             } else if (value == 0) {
  //               return Phrases.shortKindergarten;
  //             }
  //             return "$value";
  //           },
  //         ),
  //         // NumberPickerColumn(begin: 0, end: 25),
  //       ]),
  //       hideHeader: true,
  //       backgroundColor: Colors.transparent,
  //     );
  //   });
  // }

  void fillFormData(KLead lead) {
    print(lead.toJson());
    setState(() {
      this.storeNameController.text = lead.businessName ?? "";
      this.contactNameController.text = lead.contactName ?? "";
      this.contactPhoneController.text = lead.phoneNumber ?? "";
      this.contactEmailController.text = lead.email ?? "";
      this.noteController.text = lead.leadNote ?? "";
      this.statusController.id = lead.leadStatus ?? "";
      this.leadInterests = lead.interests ?? [];
    });
  }

  void resetFormData() {
    setState(() {
      this.storeNameController.text = "";
      this.contactNameController.text = "";
      this.contactPhoneController.text = "";
      this.contactEmailController.text = "";
      this.noteController.text = "";
      this.statusController.id = "";
      this.leadInterests = [];
      this.userType = null;
      this.gigMedium = null;
    });
  }

  // Future<_LocationInfo> buildLocationInfo(KLatLng latLng) async {
  //   String formattedAddress = await GeoHelper.lookupLatLng(latLng)
  //       .then((v) => v?.formattedAddress.toString() ?? "");
  //
  //   return _LocationInfo(
  //     latLng: latLng,
  //     formattedAddress: formattedAddress,
  //   );
  // }

  void onSubmit() async {
    this.setState(() {
      this.isLoading = true;
    });
    try {
      if (formKey.currentState != null && formKey.currentState!.validate()) {
        // _LocationInfo? overrideLocInfo = locationInfo;

        KLead lead = widget.lead ?? KLead()
          ..businessName = storeNameController.text
          ..contactName = contactNameController.text
          ..phoneNumber = contactPhoneController.text
          ..email = contactEmailController.text
          ..leadNote = noteController.text
          ..leadStatus = statusController.id
          ..userType = userType?.toUpperCase()
          ..gigMedium = gigMedium
          ..grade = grade.toString()
          ..interests = leadInterests
          // ..latLng = overrideLocInfo?.latLng
          // ..address = overrideLocInfo?.formattedAddress ?? ""
          ..kuid = KSessionData.me != null && KSessionData.me!.puid != null
              ? KSessionData.me!.puid!
              : "";

        final response = isCreate
            ? await KServerHandler.createSalesLead(lead: lead)
            : await KServerHandler.modifySalesLead(lead: lead);

        KToastHelper.show(response.kstatus == 100 ? "Success" : "Error");
        if (response.kstatus == 100) {
          if (isCreate) {
            this.setState(() {
              this.appbarTitle = "${lead.phoneNumber} OK";
            });
            this.resetFormData();
          } else {
            Navigator.of(context).pop();
          }
        }
        ;
      }
    } catch (ex) {
      print(ex);
    }
    if (mounted) {
      this.setState(() {
        this.isLoading = false;
      });
    }
  }

  Widget buildSelection(Map<String, String> map) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 4.0, // gap between adjacent chips
      runSpacing: 4.0, // gap between lines
      children: <Widget>[
        ...map.keys.map(
          (key) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: InkWell(
                onTap: () {
                  var text = noteController.text;
                  String keyValue = map[key]!;

                  if (leadInterests.contains(key)) {
                    leadInterests.remove(key);
                  } else {
                    leadInterests.add(key);
                  }

                  if (text.contains(keyValue)) {
                    text = text.replaceAll(", ${keyValue}", "");
                    text = text.replaceAll("${keyValue}", "");
                    if (text.startsWith(", ")) text = text.substring(2);
                    noteController.text = text;
                    noteController.selection = TextSelection.fromPosition(
                      TextPosition(offset: noteController.text.length),
                    );
                    setState(() {});
                    return;
                  }

                  if (text.isEmpty) {
                    text = keyValue;
                  } else {
                    text += ", $keyValue";
                  }
                  noteController.text = text;
                  noteController.selection = TextSelection.fromPosition(
                    TextPosition(offset: noteController.text.length),
                  );
                  setState(() {});
                },
                child: Chip(
                  elevation: 3,
                  backgroundColor: leadInterests.contains(key)
                      ? Theme.of(context).colorScheme.primary
                      : Colors.white,
                  label: Text(
                    map[key]!,
                    style: Theme.of(context).textTheme.subtitle1?.copyWith(
                        color: leadInterests.contains(key)
                            ? KStyles.colorButtonText
                            : KStyles.extraDarkGrey),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final userTypeWidget = Wrap(
      alignment: WrapAlignment.center,
      spacing: 4.0, // gap between adjacent chips
      runSpacing: 4.0, // gap between lines
      children: <Widget>[
        ...tagsUserType.map(
          (key) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.0),
              child: InkWell(
                onTap: () {
                  if (userType == key) {
                    setState(() {
                      userType = null;
                    });
                  } else {
                    setState(() {
                      userType = key;
                    });
                  }
                },
                child: Chip(
                  elevation: 3,
                  backgroundColor:
                      userType == key ? Theme.of(context).colorScheme.primary : Colors.white,
                  label: Text(
                    key,
                    style: Theme.of(context).textTheme.subtitle1?.copyWith(
                        color: userType == key
                            ? KStyles.colorButtonText
                            : KStyles.extraDarkGrey),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );

    final gigMediumWidget = Wrap(
      alignment: WrapAlignment.center,
      spacing: 4.0, // gap between adjacent chips
      runSpacing: 4.0, // gap between lines
      children: <Widget>[
        ...tagsGigMedium.map(
          (key) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: InkWell(
                onTap: () {
                  if (gigMedium == key) {
                    setState(() {
                      gigMedium = null;
                    });
                  } else {
                    setState(() {
                      gigMedium = key;
                    });
                  }
                },
                child: Chip(
                  elevation: 3,
                  backgroundColor:
                      gigMedium == key ? Theme.of(context).colorScheme.primary : Colors.white,
                  label: Text(
                    key,
                    style: Theme.of(context).textTheme.subtitle1?.copyWith(
                        color: gigMedium == key
                            ? KStyles.colorButtonText
                            : KStyles.extraDarkGrey),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );

    final gradePicker = WheelChooser.custom(
      horizontal: true,
      onValueChanged: (a) {
        this.grade = gradeList[a];
      },
      itemSize: 80,
      children: gradeList.map((grade) {
        if (grade == -1) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                KPhrases.preSchool,
                textAlign: TextAlign.center,
              ),
            ),
          );
        } else if (grade == 0) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                KPhrases.kindergarten,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        return Text(
          "$grade",
          textAlign: TextAlign.center,
        );
      }).toList(),
    );

    final form = Form(
      key: formKey,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              style: Theme.of(context).textTheme.subtitle1,
              controller: contactPhoneController,
//          validator: (z) => z.isEmpty ? "Field required" : null,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                icon: Icon(Icons.phone),
                hintText: 'Fone',
                hintStyle: Theme.of(context).textTheme.subtitle1,
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 4),
            TextFormField(
              style: Theme.of(context).textTheme.subtitle1,
              controller: contactNameController,
//          validator: (z) => z.isEmpty ? "Field required" : null,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                icon: Icon(Icons.person),
                hintText: 'Name',
                hintStyle: Theme.of(context).textTheme.subtitle1,
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 4),
            TextFormField(
              style: Theme.of(context).textTheme.subtitle1,
              controller: noteController,
              keyboardType: TextInputType.text,
              minLines: 2,
              maxLines: 4,
              decoration: InputDecoration(
                icon: Icon(Icons.note),
                hintText: 'Note',
                hintStyle: Theme.of(context).textTheme.subtitle1,
                border: OutlineInputBorder(),
              ),
            ),
            if (widget.lead != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(height: 20),
                  Text(
                    "Lead status?",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(height: 10),
                  KRadio.fromMap(
                    controller: statusController,
                    map: this.leadStatuses,
                  ),
                ],
              )
            else
              Column(
                children: [
                  SizedBox(height: 24),
                  Text(
                    "User",
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 6),
                  userTypeWidget,
                  SizedBox(height: 12),
                  SizedBox(height: 6),
                  Text(
                    "Cách Học",
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                  gigMediumWidget,
                  SizedBox(height: 24),
                  Text(
                    KPhrases.grade,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  SizedBox(
                    height: 50,
                    child: gradePicker,
                  ),
                  SizedBox(height: 24),
                  Text(
                    "Tags",
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 6),
                  buildSelection(tags),
                  buildSelection(tagsCap),
                  SizedBox(height: 24),
                  buildSelection(tagsDayKem),
                  SizedBox(height: 24),
                  buildSelection(tagsLuyenthi),
                ],
              ),
          ]),
    );

    final body = SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: form,
          ),
          // Container(
          //   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          //   child: map,
          // ),
          // checkInButton
        ],
      ),
    );

    return KeyboardKiller(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            KStringHelper.isExist(appbarTitle) ? appbarTitle! : 'REM Lead',
          ),
          actions: [
            if (!isLoading)
              IconButton(
                onPressed: KThrottleHelper.throttle(
                  onSubmit,
                  throttleID: 'check_in_btn',
                ),
                icon: Icon(Icons.check),
                color: Theme.of(context).colorScheme.primary,
              )
            else
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: Center(
                    child: FittedBox(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
              ),
          ],
        ),
        body: SafeArea(child: body),
      ),
    );
  }
}
