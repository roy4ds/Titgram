import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:titgram/models/channel_model.dart';
import 'package:titgram/models/country_model.dart';
import 'package:titgram/models/user_model.dart';

class Roy4dApi {
  late BuildContext context;
  ValueNotifier<List<ChannelModel>?> groupMatch = ValueNotifier([]);
  ValueNotifier<List<ChannelModel>?> channelMatch = ValueNotifier([]);

  dynamic dataBox;
  Roy4dApi({BuildContext? ctxt}) {
    if (ctxt != null) {
      context = ctxt;
    }
    init();
  }

  void updateContext(BuildContext ctxt) {
    context = ctxt;
  }

  void init() async {
    await Hive.openBox('adbx');
    dataBox = Hive.box('adbx');
  }

  Map<String, String> headers() {
    return {
      "Authorization":
          "Bearer GThFfKRsxEVcopWYVRxplWEX6B2M0Bf5bZmwq2RuD7hLS/nYPkLJSoShglKJQ1PbYkd5SmF2S2pwc2ptcURKM0Rlbk9Cc2xkdFBBVWUxL0RqU3V3VFo4OUhua0Zjd1l2c2VESkxiLzhUelNoS1U2U3c2cVN5Q0EzeG1CeVZlVXo4Vkc3ZWxOK2RzUDQ5ZUczZklncVJFa21yeWxnZS9jYWxsSHdhSmR2UURZREZBV3VzbnVtejljYzUyeFVFc3VxSjhobVlSL2d1NjhnNVpkUk9BM3dLRnhNRUZreXdBOUZCQWJ4dEJFcCtUUG9acm5idjZwRzh4SnZOeE9HMmlMT2R4d1VGUHVxT1pjbGJERFFNL0hGM0tZdXRRN3l6TWhyUlRvVWU1UkIvSWdNLzJCekNNcEgxNlhTaEFtMitGTHNobXJUYnpmRXlFVmNJUU02cjI2aVNDSE9IdldSWlhQR1NRMEVVdVVTTTM0UlVreEg2dGpERUlDM00wRm9mMEJQT3h2enhiNzNEeGJJT2EwRnovdk9xejV6aWMvWEVtSEpwUjhUT1R6YVFaNWJqRDNQY21TRWN4MFJGNHNzY0R4TVp5R3FFdENlM2tHSWRLL1ZFVjExeTQyKyt5Y3BSanovS2YvSUpWOGxPaEphOWoyTXZvbmpxNVpjMzZFbFZUeEF0SVJEZ1oxVjEwazByMHNKM2RBbWp5Mjd5ZnBWSDBBSmR2NzIzRHBGcXBsSkRMUkhGMUVKZEdCTWs5c3pOK245Q2tlQmVnTld1UzZwNmxCNHlpaUdsbHNUTzhtZ2NWMjJtV2JUOGR1QzR2anhDdWVOK0RyYkpPeFhVbUp0NkQ4RkZiUzVjUGFMREtyaUdCRUtUWG41bnVnZTlEWT0="
    };
  }

  dynamic showSnack(String response) {
    try {
      final SnackBar snackBar = SnackBar(content: Text(response));
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(snackBar);
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<User?> auth(Map<String, dynamic> user) async {
    String action = user['action'] ?? "";
    if (action.isEmpty) {
      return null;
    }
    var url = Uri.https('roy4d.com', "/user/$action");
    dynamic response;
    try {
      response = await http.post(url, body: {"user": jsonEncode(user['user'])});
    } on http.ClientException catch (e) {
      return showSnack(e.message);
    }
    if (response.statusCode != 200) {
      showSnack('Request failed with status: ${response.statusCode}.');
    } else {
      var r = response.body;
      var res = jsonDecode(r);
      if (res['error'] != null) {
        showSnack(res['description']);
        return null;
      } else {
        return userFromJson(r);
      }
    }
    return null;
  }

  Map<String, CountryModel> countries = {};
  Future<Map<String, CountryModel>?> getCountries() async {
    if (countries.isEmpty) {
      var url = Uri.https('roy4d.com', '/surface/.map/.incs/api/getCountries');
      dynamic response;
      try {
        response = await http.post(url, headers: headers());
      } on http.ClientException catch (e) {
        return showSnack(e.message);
      }
      if (response.statusCode != 200) {
        return showSnack('Request failed with status: ${response.statusCode}.');
      } else {
        countries.addAll(countryModelFromJson(response.body));
      }
    }
    return countries;
  }

  List<ChannelModel> channels = [];
  Future<List<ChannelModel>?> getChannels({bool resume = false}) async {
    if (resume == true && channels.isNotEmpty) {
      return channels;
    }
    int limit = 15;
    int offset = channels.length;
    if (offset % 15 > 0) return null;
    var url = Uri.https('roy4d.com', '/allgram/.bin/getChannels',
        {"path": "0", "range": "$offset,$limit"});
    dynamic response;
    try {
      response = await http.post(url, headers: headers());
    } on http.ClientException catch (e) {
      return showSnack(e.message);
    }
    if (response.statusCode != 200) {
      return showSnack('Request failed with status: ${response.statusCode}.');
    } else {
      try {
        var res = channelModelFromJson(response.body);
        channels.insertAll(0, res);
        return res;
      } on FormatException catch (e) {
        showSnack(e.message);
      }
    }
    return null;
  }

  List<ChannelModel> groups = [];
  Future<List<ChannelModel>?> getGroups({bool resume = false}) async {
    if (resume == true && groups.isNotEmpty) {
      return groups;
    }
    int limit = 15;
    int offset = groups.length;
    if (offset % 15 > 0) return null;
    var url = Uri.https('roy4d.com', '/allgram/.bin/getChannels',
        {"path": "1", "range": "$offset,$limit"});
    dynamic response;
    try {
      response = await http.post(url, headers: headers());
    } on http.ClientException catch (e) {
      return showSnack(e.message);
    }
    if (response.statusCode != 200) {
      showSnack('Request failed with status: ${response.statusCode}.');
    } else {
      try {
        var res = channelModelFromJson(response.body);
        groups.insertAll(0, res);
        return res;
      } on FormatException catch (e) {
        return showSnack(e.message);
      } on TypeError catch (e) {
        return showSnack(e.toString());
      }
    }
    return null;
  }

  Future getBots() async {
    var url = Uri.https('roy4d.com', '/allgram/.bin/getBots');
    var response = await http.post(url, headers: headers());
    if (response.statusCode != 200) {
      showSnack('Request failed with status: ${response.statusCode}.');
    } else {
      jsonDecode(response.body);
    }
  }

  showCountryBottomSheetSelector(
      TextEditingController dc, TextEditingController cc) {
    Map<String, CountryModel> countries = {};
    ValueNotifier<Map<String, CountryModel>> myCountries = ValueNotifier({});
    Map<String, Map<String, CountryModel>> filtrate = {};

    void searchCountryFromMaplist(String s) {
      String ss = s.toUpperCase();
      if (ss.length == 2 && countries.containsKey(ss)) {
        Map<String, CountryModel> x = {};
        x[ss] = countries[ss]!;
        myCountries.value = x;
      } else {
        String sss = s.toLowerCase();
        countries.forEach((key, ctr) {
          String cname = ctr.name.toLowerCase();
          String pcode = ctr.phonecode.toString();
          Map<String, CountryModel> x = {};
          if (cname.contains(sss) || pcode.contains(sss)) {
            x[key] = ctr;
            if (!filtrate.containsKey(sss)) {
              filtrate[sss] = x;
            } else {
              filtrate[sss]!.addAll(x);
            }
          }
        });
        if (!filtrate.containsKey(sss) || filtrate[sss]!.isEmpty) {
          myCountries.value = {};
        } else {
          myCountries.value = filtrate[sss]!;
        }
      }
    }

    return showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      enableDrag: true,
      showDragHandle: true,
      builder: (context) {
        return FutureBuilder<Map<String, CountryModel>?>(
          future: getCountries(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (!snapshot.hasData) {
              return const Center(
                child: Text("No data found"),
              );
            }
            countries = snapshot.data!;
            myCountries.value = countries;
            return Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: TextFormField(
                    onChanged: (value) {
                      searchCountryFromMaplist(value.trim());
                    },
                    textInputAction: TextInputAction.search,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      hintText: "Search",
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                Expanded(
                  child: ValueListenableBuilder(
                    valueListenable: myCountries,
                    builder: (context, countries, child) {
                      if (countries.isEmpty) {
                        return const Center(
                          child: Text("No match found"),
                        );
                      }
                      Iterable cKeys = countries.keys;
                      int iCount = cKeys.length;
                      return ListView.builder(
                        itemCount: iCount,
                        itemBuilder: (context, index) {
                          CountryModel? country =
                              countries[cKeys.elementAt(index)];
                          if (country == null) return Container();
                          return ListTile(
                            onTap: () {
                              cc.text = country.shortcode;
                              dc.text = "+${country.phonecode.toString()}";
                              Navigator.pop(context);
                            },
                            title: Text(country.name),
                            trailing: Text(country.phonecode.toString()),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
