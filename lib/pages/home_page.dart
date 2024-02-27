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
  ValueNotifier<bool> isOnSearch = ValueNotifier(false);
  ValueNotifier<List<ChannelModel>?> channelMatch = ValueNotifier([]);
  ScrollController mainListScrollController = ScrollController();

  @override
  void initState() {
    adManager = AdManager(context);
    super.initState();
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
                return const Text("Titgram");
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
          channelMatch.value = snapshot.data;
          return ValueListenableBuilder(
            valueListenable: channelMatch,
            builder: (context, value, child) {
              // add ads to the list
              // then render
              List smartList = [];
              smartList.addAll(value as Iterable);
              int numberOfChats = value!.length;
              for (var i = 0; i < numberOfChats; i += 5) {
                smartList.insert(i, adManager.insertBanner());
              }

              return ListView.builder(
                controller: mainListScrollController,
                padding: const EdgeInsets.all(8.0),
                itemBuilder: (context, index) {
                  var channel = smartList![index];
                  if (channel is Widget) {
                    return channel;
                  }
                  return ListTile(
                    leading: SizedBox(
                      height: 50,
                      width: 50,
                      child: ClipRect(
                        child: FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: "https://roy4d.com/graddle/icons/ios/64.png",
                          imageErrorBuilder: (context, error, stackTrace) {
                            return Container();
                          },
                        ),
                      ),
                    ),
                    title: Text(),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
