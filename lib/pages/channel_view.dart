import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:titgram/ads/admob/admanager.dart';
import 'package:titgram/models/channel_model.dart';

late ChannelModel channel;

class ChannelView extends StatefulWidget {
  ChannelView({super.key, required String selectedChannel}) {
    channel = ChannelModel.fromJson(jsonDecode(selectedChannel));
  }

  @override
  State<ChannelView> createState() => _ChannelViewState();
}

class _ChannelViewState extends State<ChannelView> {
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
        title: Text(channel.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Text(channel.subscribers.toString()),
            )
          ],
        ),
      ),
      bottomNavigationBar: adManager.insertBanner(),
    );
  }
}
