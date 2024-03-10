import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:titgram/ads/admob/admanager.dart';
import 'package:titgram/models/channel_model.dart';
import 'package:transparent_image/transparent_image.dart';

late ChannelModel channel;

class ChannelPage extends StatefulWidget {
  ChannelPage({super.key, required ChannelModel selectedChannel}) {
    channel = selectedChannel;
  }

  @override
  State<ChannelPage> createState() => _ChannelPageState();
}

class _ChannelPageState extends State<ChannelPage> {
  late AdManager adManager;
  @override
  void initState() {
    adManager = AdManager(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String? photo = channel.photo?.smallFileId;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(jsonDecode(channel.title)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: SizedBox(
            width: double.infinity,
            height: 300,
            child: Card(
              elevation: 4,
              margin: const EdgeInsets.all(8),
              child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(children: [
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            height: 96,
                            width: 96,
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white12),
                            ),
                            child: FadeInImage.memoryNetwork(
                                placeholder: kTransparentImage,
                                image:
                                    "https://roy4d.com/graddle/.bin/ffx/101/$photo.jpg"),
                          ),
                          Text("${channel.subscribers}subscribers"),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: TextButton(
                        onPressed: () {
                          context.pushNamed('cview',
                              pathParameters: {"clink": channel.link});
                        },
                        style: const ButtonStyle(
                            elevation: MaterialStatePropertyAll(8),
                            padding:
                                MaterialStatePropertyAll(EdgeInsets.all(8.0)),
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.teal),
                            foregroundColor:
                                MaterialStatePropertyAll(Colors.white),
                            textStyle: MaterialStatePropertyAll(
                                TextStyle(fontSize: 16))),
                        child: const Text("Join Chat"),
                      ),
                    ),
                  ])),
            ),
          ),
        ),
      ),
      bottomNavigationBar: adManager.insertBanner(),
    );
  }
}
