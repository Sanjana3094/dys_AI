import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // for env vars

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Empathetic Chat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: Colors.green.shade600,
          onPrimary: Colors.white,
          secondary: Colors.green.shade300,
          surface: Colors.white,
          surfaceContainerHighest: Colors.grey.shade50, // fixed deprecated `background`
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.green.shade600,
          elevation: 0,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.green.shade600,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.shade600,
            foregroundColor: Colors.white,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.green.shade600,
            side: BorderSide(color: Colors.green.shade600),
          ),
        ),
        fontFamily: 'Roboto',
      ),
      home: const ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  ChatScreenState createState() => ChatScreenState(); // renamed from _ChatScreenState
}

class ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  final List<String> _suggestedReplies = [
    "I'm doing well",
    "I'm feeling stressed",
    "I'm not sure",
    "I'd rather not say"
  ];
  bool _isTyping = false;
  final Set<String> _topicsDiscussed = {};

  final String _apiUrl = "https://api.openai.com/v1/chat/completions";
  final String _systemPrompt = """
You are an empathetic, emotionally intelligent AI chatbot designed to build strong connections with users. Your goal is to actively listen, validate emotions, and respond in a warm, engaging, and human-like manner.

Be proactive in the conversation—ask thoughtful follow-up questions, gently guide the user through complex feelings, and use affirmations like "That makes sense," or "I hear you."

Keep your tone friendly, non-judgmental, and supportive. Use emojis sparingly to add warmth when appropriate 😊.

Use interactive techniques such as:
* Offering choices: "Would you like to talk more about it, or would you prefer a distraction right now?"
* Reflection: "It sounds like you're feeling ___ because of ___. Is that right?"
* Encouragement: "You've been through a lot—how are you taking care of yourself today?"
* Memory-based support: If the user shared something earlier, reference it to show care and continuity.

Above all, make the user feel safe, heard, and valued. Always end messages with an open door: "I'm here if you want to talk more."
""";

  @override
  void initState() {
    super.initState();
    _addBotMessage("Hi there! 👋 I'm here to chat and support you. How are you feeling today?");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Empathetic Support Chat', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8.0),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isTyping) {
                  return _buildTypingIndicator();
                }
                return _messages[index];
              },
            ),
          ),
          _buildQuickReplies(),
          _buildMessageComposer(),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: Row(
        children: List.generate(3, (i) => _buildDot(i)).expand((w) => [w, const SizedBox(width: 4)]).toList(),
      ),
    );
  }

  Widget _buildDot(int i) => AnimatedContainer(
    duration: const Duration(milliseconds: 300),
    height: 8.0,
    width: 8.0,
    decoration: BoxDecoration(color: Colors.grey.shade500, shape: BoxShape.circle),
  );

  Widget _buildQuickReplies() {
    if (_suggestedReplies.isEmpty) return const SizedBox.shrink();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Row(
        children: _suggestedReplies.map((reply) => Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: OutlinedButton(
            onPressed: () => _handleSubmitted(reply),
            child: Text(reply),
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildMessageComposer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: const InputDecoration(hintText: 'Type your message...', border: InputBorder.none),
              onSubmitted: _handleSubmitted,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () => _handleSubmitted(_textController.text),
            color: Theme.of(context).colorScheme.primary,
          )
        ],
      ),
    );
  }

  void _addUserMessage(String text) {
    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
    });
    _scrollToBottom();
    _extractUserInfo(text);
  }

  void _addBotMessage(String text) {
    setState(() {
      _messages.add(ChatMessage(text: text, isUser: false));
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
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

  void _handleSubmitted(String text) {
    if (text.trim().isEmpty) return;
    _textController.clear();
    _addUserMessage(text);
    setState(() {
      _suggestedReplies.clear();
      _isTyping = true;
    });
    _getResponseFromOpenAI(text);
  }

  void _extractUserInfo(String message) {
    message = message.toLowerCase();
    List<String> topics = ['anxiety', 'stress', 'depression', 'work', 'school', 'family', 'relationship', 'health', 'sleep', 'exercise', 'food', 'mood'];
    for (var topic in topics) {
      if (message.contains(topic)) _topicsDiscussed.add(topic);
    }
  }

  Future<void> _getResponseFromOpenAI(String userMessage) async {
    final String apiKey = dotenv.env['OPENAI_API_KEY'] ?? '';
    if (apiKey.isEmpty) {
      _addBotMessage("API Key not found. Please set it in your .env file.");
      return;
    }

    List<Map<String, String>> messages = [
      {"role": "system", "content": _systemPrompt},
      ..._messages.map((msg) => {
        "role": msg.isUser ? "user" : "assistant",
        "content": msg.text,
      })
    ];

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': messages,
          'temperature': 0.85,
          'max_tokens': 600,
        }),
      );

      setState(() => _isTyping = false);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _addBotMessage(data['choices'][0]['message']['content']);
      } else {
        _addBotMessage("Sorry, an error occurred. Please try again later.");
      }
    } catch (e) {
      setState(() => _isTyping = false);
      _addBotMessage("Error: $e");
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;
  const ChatMessage({super.key, required this.text, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) _buildAvatar(context),
          Flexible(
            child: Container(
              margin: EdgeInsets.only(left: isUser ? 64.0 : 8.0, right: isUser ? 8.0 : 64.0),
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              decoration: BoxDecoration(
                color: isUser ? Theme.of(context).colorScheme.primary : Colors.grey.shade200,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(isUser ? 20.0 : 4.0),
                  topRight: Radius.circular(isUser ? 4.0 : 20.0),
                  bottomLeft: const Radius.circular(20.0),
                  bottomRight: const Radius.circular(20.0),
                ),
              ),
              child: Text(
                text,
                style: TextStyle(color: isUser ? Colors.white : Colors.black87, fontSize: 16.0),
              ),
            ),
          ),
          if (isUser) _buildAvatar(context),
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) => CircleAvatar(
    backgroundColor: isUser ? Colors.green.shade200 : Colors.green.shade700,
    child: Icon(isUser ? Icons.person : Icons.smart_toy, color: isUser ? Colors.green.shade700 : Colors.white),
  );
}
