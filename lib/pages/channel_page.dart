import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:titgram/ads/admob/admanager.dart';
import 'package:titgram/models/channel_model.dart';

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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(jsonDecode(channel.title)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: SizedBox(
                  width: double.infinity,
                  height: 300,
                  child: Card(
                    elevation: 8,
                    margin: const EdgeInsets.all(8),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(channel.subscribers.toString()),
                    ),
                  ),
                ),
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
                    padding: MaterialStatePropertyAll(EdgeInsets.all(8.0)),
                    backgroundColor: MaterialStatePropertyAll(Colors.blue),
                    foregroundColor: MaterialStatePropertyAll(Colors.white),
                    textStyle:
                        MaterialStatePropertyAll(TextStyle(fontSize: 16))),
                child: const Text("Join"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
