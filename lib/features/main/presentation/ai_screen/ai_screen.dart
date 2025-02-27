import 'package:flutter/material.dart';
import 'package:news_zen/core/theme/colors.dart';
import 'package:news_zen/core/utils/app_assets.dart';
import 'package:news_zen/features/main/presentation/notifications_screen/notifications_screen.dart';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];

  // Simulate sending a message
  void _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.insert(0, ChatMessage(isUserMessage: true, message: text));
    });

    _messageController.clear();

    final response = await _getChatbotResponse(text);
    setState(() {
      _messages.insert(0, ChatMessage(isUserMessage: false, message: response));
    });
  }

  // Simulate receiving a response from the chatbot
  Future<String> _getChatbotResponse(String message) async {
    await Future.delayed(const Duration(seconds: 1));

    // Simple chatbot logic
    if (message.toLowerCase().contains('hello')) {
      return 'Hi there! How can I assist you today?';
    } else if (message.toLowerCase().contains('news')) {
      return 'Here are the latest news updates...';
    } else {
      return 'I\'m sorry, I didn\'t understand that. Can you please rephrase?';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: main_background_colour,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: main_background_colour,
          title: Column(
            children: [
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Image.asset(
                      AppAssets.image.img_med_logo,
                      width: 140,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showNotificationScreen(context);
                    },
                    icon: Icon(Icons.notifications, color: primary_red),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom * 0.0), // Reduces push-up effect
        child: Column(
          children: [
            // Message List
            Expanded(
              child: ListView.builder(
                reverse: true, // Messages appear from bottom
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return ChatBubble(
                    isUserMessage: message.isUserMessage,
                    message: message.message,
                  );
                },
              ),
            ),
            // Message Input Field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F1F1), // Light grey background for input field
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          hintText: 'Type your message...',
                          hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                          border: InputBorder.none,
                        ),
                        onSubmitted: (text) => _sendMessage(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send, color: primary_red),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10), // Added space beneath the input field
          ],
        ),
      ),
    );
  }
}

class ChatMessage {
  final bool isUserMessage;
  final String message;

  ChatMessage({required this.isUserMessage, required this.message});
}

class ChatBubble extends StatelessWidget {
  final bool isUserMessage;
  final String message;

  const ChatBubble({super.key, required this.isUserMessage, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: isUserMessage ? primary_red : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          message,
          style: TextStyle(
            color: isUserMessage ? Colors.white : Colors.black,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}