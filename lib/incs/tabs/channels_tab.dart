import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:titgram/ads/admob/admanager.dart';
import 'package:titgram/incs/api/roy4d_api.dart';
import 'package:titgram/models/channel_model.dart';
import 'package:transparent_image/transparent_image.dart';

late Roy4dApi roy4dApi;

class ChannelsTab extends StatefulWidget {
  ChannelsTab({super.key, required Roy4dApi roy4dApiInstance}) {
    roy4dApi = roy4dApiInstance;
  }

  @override
  State<ChannelsTab> createState() => _ChannelsTabState();
}

class _ChannelsTabState extends State<ChannelsTab> {
  late AdManager adManager;
  ValueNotifier<List<ChannelModel>?> channelMatch = ValueNotifier([]);
  ScrollController mainListScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    adManager = AdManager(context);
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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ChannelModel>>(
      stream: Roy4dApi.channelStreamCtrl,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (channelMatch.value == null) {
          return const Center(
            child: Text("No chats found"),
          );
        }
        List<ChannelModel> superList = [
          ...channelMatch.value!,
          ...snapshot.data!
        ];
        channelMatch.value = superList;
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
            if (numberOfChats > 6) {
              for (var i = 0; i < numberOfChats; i += 6) {
                smartList.insert(i, adManager.insertBanner());
              }
            }
            return ListView.builder(
              controller: mainListScrollController,
              itemCount: smartList.length,
              itemBuilder: (context, index) {
                var channel = smartList[index];
                if (channel is Widget) {
                  return channel;
                }
                channel = channel as ChannelModel;
                String? photo = channel.photo?.smallFileId;
                return ListTile(
                  onTap: () {
                    context.pushNamed('channel', extra: {"channel": channel});
                  },
                  leading: SizedBox(
                    height: 50,
                    width: 50,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
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
                  title: Text(
                    json.decode(channel.title),
                    style: const TextStyle(fontSize: 16),
                  ),
                  subtitle: Text(
                    "${channel.subscribers}subscribers",
                    style: const TextStyle(fontSize: 12),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
