import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:titgram/ads/admob/admanager.dart';
import 'package:titgram/incs/api/roy4d_api.dart';
import 'package:titgram/incs/tabs/bots_tab.dart';
import 'package:titgram/incs/tabs/channels_tab.dart';
import 'package:titgram/incs/utils/extensions.dart';
import 'package:titgram/models/channel_model.dart';
import 'package:titgram/incs/tabs/groups_tab.dart';
import 'package:titgram/pages/login_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late AdManager adManager;
  late Roy4dApi roy4dApi;
  final box = Hive.box('app');
  ValueNotifier<bool> isOnSearch = ValueNotifier(false);
  ValueNotifier<List<ChannelModel>?> channelMatch = ValueNotifier([]);

  @override
  void initState() {
    adManager = AdManager(context);
    super.initState();
    roy4dApi = Roy4dApi(context);
  }

  List<Widget> drawables(BuildContext context) {
    List<String> x = [
      'shops',
      'maps',
      'business',
      'stories',
      'markets',
      'affiliates'
    ];
    List<Widget> y = [];
    for (var d in x) {
      y.add(
        ListTile(
          onTap: () {
            Navigator.pop(context);
            context.pushNamed('web', pathParameters: {"res": d});
          },
          title: Text(d.capitalize()),
        ),
      );
    }
    return y;
  }

  @override
  Widget build(BuildContext context) {
    bool isdark = box.get('isdark', defaultValue: false);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: ValueListenableBuilder(
              valueListenable: isOnSearch,
              builder: (context, value, child) {
                if (value) {
                  return Container(
                    padding: const EdgeInsets.fromLTRB(12, 8, 8, 2),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: "Search...",
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  );
                } else {
                  return const Text(
                    "Titgram",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                  );
                }
              },
            ),
            actions: [
              IconButton(
                onPressed: () {
                  isOnSearch.value = !isOnSearch.value;
                },
                icon: const Icon(Icons.search),
              ),
            ],
            bottom: const TabBar(tabs: [
              Tab(
                text: "Channels",
              ),
              Tab(
                text: "Groups",
              ),
              Tab(
                text: "Bots",
              ),
            ]),
          ),
          drawer: Drawer(
            child: Column(
              children: [
                DrawerHeader(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    alignment: Alignment.center,
                    child: Stack(
                      children: [
                        const Icon(Icons.headphones),
                        Positioned(
                          bottom: 20,
                          right: 20,
                          child: IconButton(
                            onPressed: () {
                              box.put('isdark', !isdark);
                            },
                            icon: Icon(isdark != true
                                ? Icons.light_mode
                                : Icons.dark_mode_rounded),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      ...drawables(context),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Row(
                    children: [
                      const Text(
                        "Log Out",
                        style: TextStyle(fontSize: 18),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          LoginManager().logout(context);
                        },
                        icon: const Icon(Icons.logout),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              ChannelsTab(),
              GroupsTab(),
              BotsTab(),
            ],
          )
          // bottomNavigationBar: BottomNavigationBar(items: items),
          ),
    );
  }
}
