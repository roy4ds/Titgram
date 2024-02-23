import 'package:flutter/material.dart';
import 'package:titgram/ads/admob/admanager.dart';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late AdManager adManager;
  ValueNotifier<bool> isOnSearch = ValueNotifier(false);
  ValueNotifier<List> channelMatch = ValueNotifier([]);
  ScrollController mainListScrollController = ScrollController();

  @override
  void initState() {
    adManager = AdManager(context);
    super.initState();
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
          ]),
      body: StreamBuilder(
        stream: null,
        builder: (context, snapshot) {
          // channelMatch.value = snapshot.data;
          return ValueListenableBuilder(
            valueListenable: channelMatch,
            builder: (context, value, child) {
              return ListView.builder(
                controller: mainListScrollController,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: ClipRect(
                      child: FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: "https://roy4d.com/graddle/icons/ios/64.png",
                        imageErrorBuilder: (context, error, stackTrace) {
                          return Container();
                        },
                      ),
                    ),
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
