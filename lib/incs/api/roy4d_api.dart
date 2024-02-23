import 'dart:convert' as convert;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Roy4dApi {
  final BuildContext context;
  Roy4dApi(this.context);

  Map<String, String> headers() {
    return {"Authorization": "Bearer "};
  }

  Future auth(Map<String, dynamic> user) async {
    String action = user['action'] ?? "";
    if (action.isEmpty) {
      return;
    }
    var url = Uri.https('roy4d.com', "/user/$action", {'q': '{http}'});
    var response = await http.post(url);
    if (response.statusCode != 200) {
      print('Request failed with status: ${response.statusCode}.');
    } else {
      var res = convert.jsonDecode(response.body) as Map<String, dynamic>;
    }
  }

  Future getCountries() async {
    var url = Uri.https(
        'roy4d.com', '/surface/.map/.incs/api/getCountries', {'q': '{http}'});
    var response = await http.post(url, headers: headers());
    if (response.statusCode != 200) {
      print('Request failed with status: ${response.statusCode}.');
    } else {
      var res = convert.jsonDecode(response.body) as Map<String, dynamic>;
    }
  }

  Future getChannels() async {
    var url =
        Uri.https('roy4d.com', '/allgram/.bin/getChannels', {'q': '{http}'});
    var response = await http.post(url, headers: headers());
    if (response.statusCode != 200) {
      print('Request failed with status: ${response.statusCode}.');
    } else {
      var res = convert.jsonDecode(response.body) as Map<String, dynamic>;
    }
  }

  Future getGroups() async {
    var url =
        Uri.https('roy4d.com', '/allgram/.bin/getGroups', {'q': '{http}'});
    var response = await http.post(url, headers: headers());
    if (response.statusCode != 200) {
      print('Request failed with status: ${response.statusCode}.');
    } else {
      var res = convert.jsonDecode(response.body) as Map<String, dynamic>;
    }
  }

  Future getBots() async {
    var url = Uri.https('roy4d.com', '/allgram/.bin/getBots', {'q': '{http}'});
    var response = await http.post(url, headers: headers());
    if (response.statusCode != 200) {
      print('Request failed with status: ${response.statusCode}.');
    } else {
      var res = convert.jsonDecode(response.body) as Map<String, dynamic>;
    }
  }

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
