import 'package:app_core/helper/kserver_handler.dart';
import 'package:app_core/model/kgig_address.dart';
import 'package:app_core/model/klead.dart';
import 'package:app_core/model/klink_helper.dart';
import 'package:app_core/app_core.dart';
import 'package:app_core/ui/leads/kpg_lead_form.dart';
import 'package:app_core/ui/widget/kdivider.dart';
import 'package:app_core/ui/widget/kicon_label.dart';
import 'package:app_core/ui/widget/kperspective_toggle.dart';
import 'package:flutter/material.dart';

class KSalesListing extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _KSalesListingState();
}

class _KSalesListingState extends State<KSalesListing> {
  List<KLead>? leads;

  bool isLoading = false;
  bool isCheckinProcessing = false;
  bool isShowAllLead = false;
  bool isCheckedIn = false;
  KLatLng? currentLatLng;

  int currentAddressIndex = 0;
  KGigAddress? currentAddress;

  @override
  void initState() {
    super.initState();

    loadLeads();
  }

  Future getCurrentLatLng() async {
    try {
      final latLng = await KLocationHelper.getKLatLng();
      if (latLng == null) return;

      setState(() {
        currentLatLng = latLng;
      });
    } catch (e) {}
  }

  Future loadLeads() async {
    this.setState(() {
      isLoading = true;
    });
    try {
      String? attribute = isShowAllLead ? "all" : null;
      final response = await KServerHandler.getSalesLeads(
          lead: KLead()
            ..action = KLead.ACTION_LIST
            ..kattribute = attribute);

      setState(() {
        this.leads = response.leads ?? [];
        this.isLoading = false;
      });
    } catch (ex) {
      setState(() {
        this.leads = [];
        this.isLoading = false;
      });
    }
  }

  void toCheckInCreate() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => KPGLeadForm(lead: null),
      ),
    );
    loadLeads();
  }

  void toCheckInEdit([KLead? lead]) async {
    if (lead != null)
      await Navigator.of(context)
          .push(MaterialPageRoute(builder: (ctx) => KPGLeadForm(lead: lead)));
    loadLeads();
  }

  void toggleMyLead() async {
    if (isShowAllLead && !isLoading) {
      this.setState(() {
        leads = null;
        isShowAllLead = false;
      });
      await loadLeads();
    }
  }

  void toggleAllLead() async {
    if (!isShowAllLead && !isLoading) {
      this.setState(() {
        leads = null;
        isShowAllLead = true;
      });
      await loadLeads();
    }
  }

  @override
  Widget build(BuildContext context) {
    final body = this.leads == null
        ? Center(child: CircularProgressIndicator())
        : this.leads!.length == 0
            ? Center(child: Text("No leads found"))
            : ListView.separated(
                itemCount: leads!.length,
                itemBuilder: (_, i) =>
                    _CheckInItem(leads![i], onClick: toCheckInEdit),
                separatorBuilder: (_, __) =>
                    KDivider(margin: EdgeInsets.zero),
              );

    final fab = FloatingActionButton(
      onPressed: toCheckInCreate,
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: Icon(Icons.create),
    );

    final perspectiveToggle = Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Expanded(
            child: KPerspectiveToggle(
              child: Text("My"),
              onClick: () => toggleMyLead(),
              isSelected: !this.isShowAllLead,
            ),
          ),
          SizedBox(width: 6),
          Expanded(
            child: KPerspectiveToggle(
              child: Text("All"),
              onClick: () => toggleAllLead(),
              isSelected: this.isShowAllLead,
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Sales Leads'),
        actions: [
          // if (!isCheckinProcessing)
          // IconButton(
          //   onPressed: handleGoToCheckin,
          //   icon: Icon(Icons.fact_check_outlined),
          //   color: Styles.colorPrimary,
          // ),
          // else
          //   Padding(
          //     padding: EdgeInsets.only(right: 10),
          //     child: SizedBox(
          //       width: 20,
          //       height: 20,
          //       child: Center(
          //         child: FittedBox(
          //           child: CircularProgressIndicator(),
          //         ),
          //       ),
          //     ),
          //   ),
          if (!isLoading)
            IconButton(
              onPressed: KThrottleHelper.throttle(
                toCheckInCreate,
                throttleID: 'create_check_in_btn',
              ),
              icon: Icon(Icons.add),
              color: Theme.of(context).colorScheme.primary,
            )
          else
            Padding(
              padding: EdgeInsets.only(right: 10, left: 15),
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
      // floatingActionButton: fab,
      body: SafeArea(
        child: Column(
          children: [
            perspectiveToggle,
            Expanded(child: body),
          ],
        ),
      ),
    );
  }
}

class _CheckInItem extends StatelessWidget {
  final KLead lead;
  final Function(KLead) onClick;

  _CheckInItem(this.lead, {required this.onClick});

  @override
  Widget build(BuildContext context) {
    final info = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          "Lead Status: ${lead.leadStatus ?? ""}",
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.headline6,
        ),
        Text(
          KUtil.prettyDate(lead.leadDate, showTime: true),
          style: Theme.of(context).textTheme.bodyText1,
        ),
        if (lead.businessName != null) ...[
          SizedBox(height: 4),
          Text(
            lead.businessName ?? "",
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.headline6,
          ),
        ],
        if (lead.contactName != null) ...[
          SizedBox(height: 4),
          KIconLabel(
            icon: Icons.person_outline,
            text: lead.contactName ?? "",
            textStyle: Theme.of(context).textTheme.bodyText1!,
            isFlexible: true,
          ),
        ],
        if (lead.phoneNumber != null) ...[
          SizedBox(height: 4),
          KIconLabel(
            icon: Icons.phone_in_talk_outlined,
            text: lead.phoneNumber ?? "",
            textStyle: Theme.of(context).textTheme.bodyText1!,
            isFlexible: true,
          ),
        ],
        if (lead.address != null) ...[
          SizedBox(height: 4),
          KIconLabel(
            icon: Icons.location_on_rounded,
            textOverflow: TextOverflow.ellipsis,
            text: lead.address ?? "",
            textStyle: Theme.of(context).textTheme.bodyText1!,
            isFlexible: true,
          ),
        ],
      ],
    );

    final callButton = IconButton(
      onPressed: () => KLinkHelper.openPhone(lead.phoneNumber ?? ""),
      icon: Icon(Icons.call, color: Theme.of(context).colorScheme.primary),
    );

    final body = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[Expanded(child: info), callButton],
    );

    return InkWell(
      onTap: () => this.onClick.call(lead),
      child: Container(padding: EdgeInsets.all(10), child: body),
    );
  }
}
