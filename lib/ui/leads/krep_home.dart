import 'package:app_core/helper/kgeo_helper.dart';
import 'package:app_core/helper/kserver_handler.dart';
import 'package:app_core/helper/service/adress_cache_service.dart';
import 'package:app_core/model/kcheck_in.dart';
import 'package:app_core/model/kgig_address.dart';
import 'package:app_core/app_core.dart';
import 'package:app_core/ui/leads/krep_listing.dart';
import 'package:app_core/ui/leads/ksales_listing.dart';
import 'package:flutter/material.dart';

class KREPHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _KREPHomeState();
}

class _KREPHomeState extends State<KREPHome> {
  bool isLoading = false;
  bool isCheckedIn = false;
  KLatLng? currentLatLng;

  int currentAddressIndex = 0;
  KGigAddress? currentAddress;

  @override
  void initState() {
    super.initState();

    loadCheckinStatus();
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

  Future<String?> getCurrentAddress() async {
    try {
      final latLng = await KLocationHelper.getKLatLng();
      if (latLng == null) return null;

      final currentAddresses =
          await KGeoHelper.getGigAddressesFromLatLng(latLng);
      if (currentAddresses == null) return null;

      // Cache the addresses
      currentAddresses.forEach((e) {
        print("caching an address...");
        KAddressCacheService.addToCache(e);
      });

      setState(() {
        currentAddressIndex = 0;
        currentAddress = currentAddresses.first;
        currentLatLng = latLng;
      });
      if (currentAddresses.length > 0)
        return currentAddresses.first.prettyAddress;
    } catch (e) {}

    return null;
  }

  void loadCheckinStatus() async {
    if (isLoading) return;

    this.setState(() {
      isLoading = true;
    });

    try {
      await getCurrentAddress();
      final response = await KServerHandler.salesLeadsCheckinStatus(
        KCheckIn()
          ..addressLine = currentAddress?.prettyAddress
          ..placeID = currentAddress?.placeID
          ..latLng = currentLatLng,
      );

      if (response.isNoData) {
        this.setState(() {
          isCheckedIn = false;
        });
      } else {
        this.setState(() {
          isCheckedIn = true;
        });
      }
    } catch (ex) {
      this.setState(() {
        isCheckedIn = false;
      });
    }

    this.setState(() {
      isLoading = false;
    });
  }

  void handleGoToREPLeadListing() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => KREPListing()));
  }

  void handleGoToLeadListing() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => KSalesListing()));
  }

  void handleCheckin() async {
    if (isLoading) return;

    this.setState(() {
      isLoading = true;
    });

    try {
      final response = await KServerHandler.salesLeadsCheckin(
        KCheckIn()
          ..addressLine = currentAddress?.prettyAddress
          ..placeID = currentAddress?.placeID
          ..latLng = currentLatLng,
      );

      if (response.isSuccess) {
        // KSnackBarHelper.show(
        //   text: "Checkin success!",
        //   isSuccess: true,
        // );
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text("Check-In OK"),
            content: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("${currentAddress?.prettyAddress}"),
                  Text("lat: ${currentLatLng?.lat}"),
                  Text("lng: ${currentLatLng?.lng}"),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Ok'),
              ),
            ],
          ),
        );
        this.setState(() {
          isCheckedIn = true;
        });
      } else {
        KSnackBarHelper.show(
          text: "Checkin failed!",
          isSuccess: false,
        );
        this.setState(() {
          isCheckedIn = false;
        });
      }
    } catch (ex) {
      KSnackBarHelper.show(
        text: "Checkin failed!",
        isSuccess: false,
      );
      this.setState(() {
        isCheckedIn = false;
      });
    }

    this.setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final checkInButton = Opacity(
      opacity: isCheckedIn ? 0.6 : 1,
      child: InkWell(
        onTap: isCheckedIn ? null : handleCheckin,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 50,
              color: isCheckedIn ? KStyles.lightGrey : Theme.of(context).colorScheme.primary,
            ),
            SizedBox(height: 8),
            Text(
              "Check In",
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ],
        ),
      ),
    );

    final leadListButton = InkWell(
      onTap: handleGoToLeadListing,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.cruelty_free_outlined,
            size: 50,
            color: Theme.of(context).colorScheme.primary,
          ),
          SizedBox(height: 8),
          Text(
            "PG",
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ],
      ),
    );

    final repButton = InkWell(
      onTap: handleGoToREPLeadListing,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.child_care_outlined,
            size: 50,
            color: Theme.of(context).colorScheme.primary,
          ),
          SizedBox(height: 8),
          Text(
            "REP",
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ],
      ),
    );

    final body = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (isLoading)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Center(child: CircularProgressIndicator()),
            )
          else ...[
            checkInButton,
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text("${currentAddress?.prettyAddress ?? ""}"),
            ),
            SizedBox(
              height: 60,
            ),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              leadListButton,
              repButton,
            ],
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('REP Home'),
      ),
      // floatingActionButton: fab,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: body,
        ),
      ),
    );
  }
}
