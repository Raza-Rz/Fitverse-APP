import 'dart:async';
import 'dart:convert'; // For JSON encoding/decoding
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitverse/utils/app_colors.dart';

class ChatbotScreen extends StatefulWidget {
  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final List<Map<String, dynamic>> _messages = [];
  final TextEditingController _controller = TextEditingController();
  late final GenerativeModel model;
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  bool _showGoToBottom = false;
  bool _isManualScroll = false;

  @override
  void initState() {
    super.initState();
    _initializeChat();
    _scrollController.addListener(_handleScroll);
    _loadMessages();
    _deleteOldMessages();
  }

  Future<void> _initializeChat() async {
    final apiKey = 'AIzaSyClfL314p0FtrUjBlh8zIJfNbYJt-c52fA';
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
  }

  void _handleScroll() {
    if (_scrollController.offset < _scrollController.position.maxScrollExtent - 50) {
      setState(() {
        _showGoToBottom = true;
      });
    } else {
      setState(() {
        _showGoToBottom = false;
      });
    }

    if (_scrollController.offset == _scrollController.position.maxScrollExtent) {
      _isManualScroll = false;
    } else {
      _isManualScroll = true;
    }
  }

  Future<void> _sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    final messageData = {'user': message, 'timestamp': DateTime.now().toIso8601String()};
    setState(() {
      _messages.add(messageData);
    });

    await _saveMessages();
    _scrollToBottom();

    try {
      final content = Content.text(message);
      final chat = model.startChat(history: [Content.model([TextPart(message)])]);
      final response = await chat.sendMessage(content);

      if (response.text != null) {
        _animateBotTyping(response.text!);
      } else {
        _addBotMessage('Sorry, I could not understand that.');
      }
    } catch (e) {
      _addBotMessage('Error occurred, please try again.');
    }
  }

  void _addBotMessage(String message) {
    final messageData = {'bot': message, 'timestamp': DateTime.now().toIso8601String()};
    setState(() {
      _messages.add(messageData);
    });
    _saveMessages();
  }

  void _animateBotTyping(String fullResponse) {
    final messageData = {'bot': '', 'timestamp': DateTime.now().toIso8601String()};
    setState(() {
      _messages.add(messageData); // Placeholder for typing effect
    });

    int index = 0;
    Timer.periodic(const Duration(milliseconds: 30), (timer) {
      if (index < fullResponse.length) {
        setState(() {
          _messages[_messages.length - 1]['bot'] =
              _messages[_messages.length - 1]['bot']! + fullResponse[index];
        });
        index++;
        _scrollToBottom();
      } else {
        timer.cancel();
        _saveMessages();
      }
    });
  }

  void _scrollToBottom() {
  // Ensure this runs after the build cycle for accurate position data
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  });
}


  // Save messages to local storage
  Future<void> _saveMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _messages.map((message) {
      return {
        ...message,
        'timestamp': message['timestamp'] ?? DateTime.now().toIso8601String()
      };
    }).toList();
    prefs.setString('chat_messages', jsonEncode(data));
  }

  // Load messages from local storage
  Future<void> _loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('chat_messages');
    if (data != null) {
      final savedMessages = List<Map<String, dynamic>>.from(jsonDecode(data));
      setState(() {
        _messages.addAll(savedMessages);
      });
    }
  }

  // Delete messages older than 3 days
  Future<void> _deleteOldMessages() async {
    final now = DateTime.now();
    _messages.removeWhere((message) {
      final timestamp = DateTime.parse(message['timestamp']);
      return now.difference(timestamp).inDays > 3;
    });
    await _saveMessages();
  }

  Widget _buildMessage(Map<String, dynamic> message) {
    final isUser = message.containsKey('user');
    final text = isUser ? message['user']! : message['bot']!;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isUser ? AppColors.primaryColor1 : Colors.grey.shade200,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: isUser ? const Radius.circular(12) : Radius.zero,
            bottomRight: isUser ? Radius.zero : const Radius.circular(12),
          ),
        ),
        child: isUser
            ? Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              )
            : MarkdownBody(
                data: text,
                styleSheet: MarkdownStyleSheet(
                  p: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Chatbot'),
        backgroundColor: AppColors.lightGrayColor,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(bottom: 60),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    return _buildMessage(_messages[index]);
                  },
                ),
              ),
              _buildInputField(),
            ],
          ),
          if (_showGoToBottom)
            Positioned(
              bottom: 70,
              right: 20,
              child: FloatingActionButton(
                  mini: true,
                  onPressed: _scrollToBottom,
                  child: const Icon(Icons.arrow_downward),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField() {
    return Container(
      color: Colors.grey.shade100,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Type your message...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send, color: AppColors.primaryColor1),
            onPressed: () {
              final text = _controller.text;
              _controller.clear();
              _sendMessage(text);
            },
          ),
        ],
      ),
    );
  }
}
