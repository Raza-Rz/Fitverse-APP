import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:fitverse/utils/app_colors.dart';

class ChatbotScreen extends StatefulWidget {
  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final List<Map<String, String>> _messages = []; // Stores messages
  final TextEditingController _controller = TextEditingController();
  late final GenerativeModel model; // Declare the model here
  bool _isLoading = false; // To manage loading state
  bool _isBotTyping = false; // To manage typing state
  final ScrollController _scrollController = ScrollController(); // Add a ScrollController

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  // Initialize the chatbot with the API key and model
  Future<void> _initializeChat() async {
    final apiKey = 'AIzaSyClfL314p0FtrUjBlh8zIJfNbYJt-c52fA'; // Replace with your actual API key
    if (apiKey.isEmpty) {
      print('Error: API key is missing!');
      return; // Early exit to prevent further crashes
    }
    print('API Key: $apiKey'); // Verify API Key
    
    try {
      model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: apiKey,
        generationConfig: GenerationConfig(
          temperature: 1,
          topK: 40,
          topP: 0.95,
          maxOutputTokens: 8192,
          responseMimeType: 'text/plain',
        ),
        systemInstruction: Content.system('You are a fitness assistant chatbot...'),
      );
      _sendMessage('Hello!');await Future.delayed(const Duration(seconds: 1));  // Adds a 1-second delay

    } catch (e) {
      print('Error initializing chatbot: $e');
    }
  }

  // Send the message to the model and get the response
  Future<void> _sendMessage(String message) async {
    // Avoid sending duplicate messages
    if (_messages.isNotEmpty && _messages.first['user'] == message) {
      print('Duplicate message, skipping send.');
      return;
    }

    setState(() {
      _messages.insert(0, {'user': message});
      _isLoading = true;
      _isBotTyping = true;
    });

    final content = Content.text(message);
    final chat = model.startChat(history: [
      Content.model([TextPart(message)]),
    ]);

    try {
      // Adding a small delay to avoid rapid API calls
      await Future.delayed(const Duration(seconds: 1)); // Add delay here if needed

      final response = await chat.sendMessage(content);

      if (response.text != null) {
        setState(() {
          _messages.insert(0, {'bot': response.text!});
          _isBotTyping = false; // Hide 'Bot is typing'
        });
      } else {
        setState(() {
          _messages.insert(0, {'bot': 'Sorry, I didn\'t get a response.'});
          _isBotTyping = false;
        });
      }
    } catch (e) {
      // Handle errors, retry logic can be added here
      print('Error sending message: $e');
      setState(() {
        _messages.insert(0, {'bot': 'Error occurred, please try again.'});
        _isBotTyping = false;
      });
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }

    // Clear the input field after sending
    _controller.clear();

    // Scroll to the top of the new message after it is added
    _scrollToTop();
  }

  // Smoothly scroll to the top of the list (new message)
  void _scrollToTop() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0.0, // Scroll to the top (0.0 means top of the list)
          duration: const Duration(milliseconds: 300), // Smooth scroll duration
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Chatbot'),
        backgroundColor: AppColors.lightGrayColor,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Chat messages
          Expanded(
            child: ListView.builder(
              reverse: true, // This will show new messages at the bottom
              padding: EdgeInsets.symmetric(vertical: 15),
              itemCount: _messages.length + (_isBotTyping ? 1 : 0), // Add 1 for typing indicator
              itemBuilder: (context, index) {
                if (_isBotTyping && index == 0) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Bot is typing...',
                        style: TextStyle(color: Colors.grey.shade600, fontStyle: FontStyle.italic),
                      ),
                    ),
                  );
                }
                final message = _messages[index - (_isBotTyping ? 1 : 0)]; // Adjust index for typing indicator
                final isUser = message.containsKey('user'); // Check if it's the user message
                
                // Apply smooth fade-in animation for each message bubble
                return AnimatedOpacity(
                  opacity: 1.0,
                  duration: const Duration(milliseconds: 300), // Smooth fade-in
                  child: Align(
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 16), // Add horizontal margin for breathing space
                      padding: const EdgeInsets.all(14),
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                      decoration: BoxDecoration(
                        color: isUser ? AppColors.primaryColor1 : Colors.grey.shade300,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(12),
                          topRight: const Radius.circular(12),
                          bottomLeft: isUser ? const Radius.circular(12) : const Radius.circular(0),
                          bottomRight: isUser ? const Radius.circular(0) : const Radius.circular(12),
                        ),
                      ),
                      child: Text(
                        isUser ? message['user']! : message['bot']!,
                        style: TextStyle(
                          color: isUser ? Colors.white : Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                );
              },
              controller: _scrollController, // Attach the controller to the ListView
            ),
          ),
          
          // Input field
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                        hintText: 'Type your message...',
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.send, color: AppColors.primaryColor1),
                          onPressed: () {
                            if (_controller.text.isNotEmpty) {
                              _sendMessage(_controller.text);
                              _controller.clear(); // Clear text after sending
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
