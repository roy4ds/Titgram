import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:titgram/models/channel_model.dart';
import 'package:titgram/models/country_model.dart';
import 'package:titgram/models/user_model.dart';

class Roy4dApi {
  final BuildContext context;
  Roy4dApi(this.context);

  Map<String, String> headers() {
    return {
      "Authorization":
          "Bearer GThFfKRsxEVcopWYVRxplWEX6B2M0Bf5bZmwq2RuD7hLS/nYPkLJSoShglKJQ1PbYkd5SmF2S2pwc2ptcURKM0Rlbk9Cc2xkdFBBVWUxL0RqU3V3VFo4OUhua0Zjd1l2c2VESkxiLzhUelNoS1U2U3c2cVN5Q0EzeG1CeVZlVXo4Vkc3ZWxOK2RzUDQ5ZUczZklncVJFa21yeWxnZS9jYWxsSHdhSmR2UURZREZBV3VzbnVtejljYzUyeFVFc3VxSjhobVlSL2d1NjhnNVpkUk9BM3dLRnhNRUZreXdBOUZCQWJ4dEJFcCtUUG9acm5idjZwRzh4SnZOeE9HMmlMT2R4d1VGUHVxT1pjbGJERFFNL0hGM0tZdXRRN3l6TWhyUlRvVWU1UkIvSWdNLzJCekNNcEgxNlhTaEFtMitGTHNobXJUYnpmRXlFVmNJUU02cjI2aVNDSE9IdldSWlhQR1NRMEVVdVVTTTM0UlVreEg2dGpERUlDM00wRm9mMEJQT3h2enhiNzNEeGJJT2EwRnovdk9xejV6aWMvWEVtSEpwUjhUT1R6YVFaNWJqRDNQY21TRWN4MFJGNHNzY0R4TVp5R3FFdENlM2tHSWRLL1ZFVjExeTQyKyt5Y3BSanovS2YvSUpWOGxPaEphOWoyTXZvbmpxNVpjMzZFbFZUeEF0SVJEZ1oxVjEwazByMHNKM2RBbWp5Mjd5ZnBWSDBBSmR2NzIzRHBGcXBsSkRMUkhGMUVKZEdCTWs5c3pOK245Q2tlQmVnTld1UzZwNmxCNHlpaUdsbHNUTzhtZ2NWMjJtV2JUOGR1QzR2anhDdWVOK0RyYkpPeFhVbUp0NkQ4RkZiUzVjUGFMREtyaUdCRUtUWG41bnVnZTlEWT0="
    };
  }

  void showSnack(String response) {
    final SnackBar snackBar = SnackBar(content: Text(response));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<User?> auth(Map<String, dynamic> user) async {
    String action = user['action'] ?? "";
    if (action.isEmpty) {
      return null;
    }
    var url = Uri.https('roy4d.com', "/user/$action", {'q': '{http}'});
    var response = await http.post(url);
    if (response.statusCode != 200) {
      showSnack('Request failed with status: ${response.statusCode}.');
    } else {
      return userFromJson(response.body);
    }
    return null;
  }

  Map<String, CountryModel> countries = {};
  Future<Map<String, CountryModel>?> getCountries() async {
    if (countries.isEmpty) {
      var url = Uri.https('roy4d.com', '/surface/.map/.incs/api/getCountries');
      var response = await http.post(url, headers: headers());
      if (response.statusCode != 200) {
        showSnack('Request failed with status: ${response.statusCode}.');
      } else {
        countries = countryModelFromJson(response.body);
      }
    }
    return countries;
  }

  List channels = [];
  Future getChannels() async {
    int offset = channels.length;
    int limit = 15;
    var url = Uri.https('roy4d.com', '/allgram/.bin/getChannels',
        {'path': 0, 'range': "$offset,$limit"});
    var response = await http.post(url, headers: headers());
    if (response.statusCode != 200) {
      return showSnack('Request failed with status: ${response.statusCode}.');
    } else {
      channels.addAll(channelModelFromJson(response.body));
    }
  }

  List groups = [];
  Future getGroups() async {
    int offset = channels.length;
    int limit = 15;
    var url = Uri.https('roy4d.com', '/allgram/.bin/getGroups',
        {'path': 1, 'range': "$offset,$limit"});
    var response = await http.post(url, headers: headers());
    if (response.statusCode != 200) {
      showSnack('Request failed with status: ${response.statusCode}.');
    } else {
      groups.addAll(channelModelFromJson(response.body));
    }
  }

  Future getBots() async {
    var url = Uri.https('roy4d.com', '/allgram/.bin/getBots', {'q': '{http}'});
    var response = await http.post(url, headers: headers());
    if (response.statusCode != 200) {
      showSnack('Request failed with status: ${response.statusCode}.');
    } else {
      var res = jsonDecode(response.body) as Map<String, dynamic>;
    }
  }

  searchCountryFromMaplist(Map, String) {}

  showCountryBottomSheetSelector() {
    return showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      enableDrag: true,
      showDragHandle: true,
      builder: (context) {
        return FutureBuilder(
          future: getCountries(),
          builder: (context, snapshot) {
            ValueListenable<Map> cc = ValueNotifier({});
            return Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: TextFormField(
                    onChanged: (value) {
                      searchCountryFromMaplist(cc, value);
                    },
                    onFieldSubmitted: (value) {
                      searchCountryFromMaplist(cc, value);
                    },
                    textInputAction: TextInputAction.search,
                    decoration: const InputDecoration(
                      hintText: "Search",
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                ValueListenableBuilder(
                  valueListenable: cc,
                  builder: (context, value, child) {
                    int iCount = 10;
                    return ListView.builder(
                      itemCount: iCount,
                      itemBuilder: (context, index) {},
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
