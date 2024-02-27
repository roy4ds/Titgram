import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:titgram/ads/admob/admanager.dart';
import 'package:titgram/incs/api/roy4d_api.dart';
import 'package:titgram/models/channel_model.dart';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late AdManager adManager;
  late Roy4dApi roy4dApi;
  ValueNotifier<bool> isOnSearch = ValueNotifier(false);
  ValueNotifier<List<ChannelModel>?> channelMatch = ValueNotifier([]);
  ScrollController mainListScrollController = ScrollController();

  @override
  void initState() {
    adManager = AdManager(context);
    super.initState();
    roy4dApi = Roy4dApi(context);
    roy4dApi.getChannels();

    mainListScrollController.addListener(() {
      double maxScroll = mainListScrollController.position.maxScrollExtent;
      double currentScroll = mainListScrollController.position.pixels;
      double delta = 200.0; // or something else..
      if (maxScroll - currentScroll <= delta) {
        roy4dApi.getChannels();
      }
    });
  }

  List<Widget> drawables() {
    List x = [];
    List<Widget> y = [];
    for (var d in x) {
      y.add(
        ListTile(
          onTap: () {
            Navigator.of(context).pushNamed(d);
          },
          title: Text(d.capitalize()),
        ),
      );
    }
    return y;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ValueListenableBuilder(
            valueListenable: isOnSearch,
            builder: (context, value, child) {
              if (value) {
                return Container(
                  padding: const EdgeInsets.fromLTRB(12, 20, 8, 2),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
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
            }),
        actions: [
          IconButton(
            onPressed: () {
              isOnSearch.value = !isOnSearch.value;
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [...drawables()],
        ),
      ),
      body: StreamBuilder<List<ChannelModel>>(
        stream: Roy4dApi.channelStreamCtrl,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          channelMatch.value = snapshot.data;
          return ValueListenableBuilder(
            valueListenable: channelMatch,
            builder: (context, value, child) {
              if (value == null || value.isEmpty) {
                return const Center(
                  child: Text('No chats found'),
                );
              }
              List smartList = [];
              smartList.addAll(value as Iterable);
              int numberOfChats = value.length;
              if (numberOfChats > 5) {
                for (var i = 0; i < numberOfChats; i += 5) {
                  smartList.insert(i, adManager.insertBanner());
                }
              }
              return ListView.builder(
                controller: mainListScrollController,
                padding: const EdgeInsets.all(8.0),
                itemCount: smartList.length,
                itemBuilder: (context, index) {
                  var channel = smartList[index];
                  if (channel is Widget) {
                    return channel;
                  }
                  channel = channel as ChannelModel;
                  String photo = channel.photo!.smallFileId;
                  return ListTile(
                    leading: SizedBox(
                      height: 50,
                      width: 50,
                      child: ClipRect(
                        child: FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image:
                              "https://roy4d.com/graddle/.bin/ffx/101/$photo.jpg",
                          imageErrorBuilder: (context, error, stackTrace) {
                            return Container();
                          },
                        ),
                      ),
                    ),
                    title: Text(jsonEncode(channel.title)),
                    subtitle: Text("${channel.subscribers}subscribers"),
                  );
                },
              );
            },
          );
        },
      ),
      // bottomNavigationBar: BottomNavigationBar(items: items),
    );
  }
}
