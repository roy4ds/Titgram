import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:titgram/ads/admob/admanager.dart';
import 'package:titgram/incs/api/roy4d_api.dart';
import 'package:titgram/incs/tabs/bots_tab.dart';
import 'package:titgram/incs/tabs/channels_tab.dart';
import 'package:titgram/incs/utils/extensions.dart';
import 'package:titgram/incs/tabs/groups_tab.dart';
import 'package:titgram/models/channel_model.dart';
import 'package:titgram/pages/login_manager.dart';

Roy4dApi roy4dApi = Roy4dApi();

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late AdManager adManager;
  final box = Hive.box('app');
  ValueNotifier<bool> isOnSearch = ValueNotifier(false);

  @override
  void initState() {
    adManager = AdManager(context);
    roy4dApi.updateContext(context);
    super.initState();
  }

  List<Widget> drawables(BuildContext context) {
    List<String> x = [
      'shops',
      'markets',
      'business',
      'ads',
      'stories',
      'affiliates',
      'travel'
    ];
    List<Widget> y = [];
    for (var d in x) {
      y.add(
        ListTile(
          onTap: () {
            Navigator.pop(context);
            if (d == 'travel') d = 'surface';
            context.pushNamed('web', pathParameters: {"res": d});
          },
          title: Text(d.capitalize()),
        ),
      );
    }
    return y;
  }

  Map<String, List<ChannelModel>> filtants = {};
  void searchChat(String text, int type) async {
    List<ChannelModel>? src = [];
    List<ChannelModel>? matches = [];
    if (type == 0) {
      src = await roy4dApi.getChannels(resume: true);
    } else if (type == 1) {
      src = await roy4dApi.getGroups(resume: true);
    } else {
      src = null;
    }
    if (src == null || src.isEmpty) {
      return;
    } else {
      for (ChannelModel channel in src) {
        if (channel.title.toLowerCase().contains(text.toLowerCase())) {
          matches.add(channel);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isdark = box.get('isdark', defaultValue: false);
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        if (Navigator.of(context).canPop()) {
          Navigator.pop(context);
        }
      },
      child: DefaultTabController(
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
                        onChanged: (value) {
                          searchChat(
                              value, DefaultTabController.of(context).index);
                        },
                      ),
                    );
                  } else {
                    return const Text(
                      "Titgram",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
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
                    padding: const EdgeInsets.all(8),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Center(
                          child: Container(
                            height: 84,
                            width: 84,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.fromBorderSide(
                                BorderSide(color: Colors.orangeAccent),
                              ),
                            ),
                            child: const Icon(Icons.headphones),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
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
            body: TabBarView(
              children: [
                ChannelsTab(
                  roy4dApiInstance: roy4dApi,
                ),
                GroupsTab(
                  roy4dApiInstance: roy4dApi,
                ),
                const BotsTab(),
              ],
            )
            // bottomNavigationBar: BottomNavigationBar(items: items),
            ),
      ),
    );
  }
}
