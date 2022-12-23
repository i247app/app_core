import 'dart:async';

import 'package:app_core/header/khoc_header.dart';
import 'package:app_core/helper/kserver_handler.dart';
import 'package:app_core/model/klead.dart';
import 'package:app_core/ui/widget/kradio.dart';
import 'package:app_core/app_core.dart';
import 'package:app_core/ui/widget/keyboard_killer.dart';
import 'package:flutter/material.dart';

class _KLocationInfo {
  final KLatLng latLng;
  final String formattedAddress;

  _KLocationInfo({required this.latLng, required this.formattedAddress});
}

class KPGLeadForm extends StatefulWidget {
  final KLead? lead;

  KPGLeadForm({required this.lead});

  @override
  State<StatefulWidget> createState() => _KPGLeadFormState();
}

class _KPGLeadFormState extends State<KPGLeadForm> {
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

  List<String> leadInterests = [];

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
              KStringHelper.isExist(appbarTitle) ? appbarTitle! : 'Sales Lead'),
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
