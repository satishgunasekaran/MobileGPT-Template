import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gpt_mobile/chat_message.dart';
import 'package:gpt_mobile/tokens.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_chatgpt_api/flutter_chatgpt_api.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  final List<ChatMessageCard> _messages = [];

  var _api;

  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _api =
        ChatGPTApi(sessionToken: session_token, clearanceToken: clearane_token);
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Function to send a message
  void _sendMessage() async {
    ChatMessageCard _message =
        ChatMessageCard(text: _textEditingController.text, sender: "user");

    setState(() {
      _messages.insert(0, _message);
      _isTyping = true;
    });

    _textEditingController.clear();

    // var newMessage = await _api.sendMessage(_message.text);
    // print(newMessage);

    var response = "Iam bot";

    ChatMessageCard botMessage = ChatMessageCard(text: response, sender: "bot");

    print(botMessage.text);

    setState(() {
      _messages.insert(0, botMessage);
      _isTyping = false;
    });
  }

  // Function to create a new SendMessage widget
  Widget _buildTextComposer() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            onSubmitted: (value) => _sendMessage(),
            controller: _textEditingController,
            decoration: InputDecoration.collapsed(hintText: "Send a message"),
          ),
        ),
        IconButton(onPressed: () => _sendMessage(), icon: Icon(Icons.send))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Mobile GPT"),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Flexible(
                  child: ListView.builder(
                      itemCount: _messages.length,
                      reverse: true,
                      padding: Vx.m8,
                      itemBuilder: ((context, index) {
                        return _messages[index];
                      }))),
              if (_isTyping)
                const LinearProgressIndicator(
                  color: Colors.green,
                  backgroundColor: Colors.transparent,
                ).pOnly(bottom: 8.0),
              Divider(height: 1.0),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                decoration: BoxDecoration(color: context.cardColor),
                child: _buildTextComposer(),
              )
            ],
          ),
        ));
  }
}
