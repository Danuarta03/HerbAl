import 'dart:io';
import 'dart:typed_data';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final Gemini gemini = Gemini.instance;
  List<ChatMessage> messages = [];
  List<String> chatHistory = [];
  XFile? selectedImage;
  String buffer = "";
  bool isGenerating = false;

  ChatUser currentUser = ChatUser(id: "0", firstName: "User");
  ChatUser geminiUser = ChatUser(
    id: "1",
    firstName: "HerbAl Asisstant",
    profileImage:
        "https://i.pinimg.com/736x/7c/ac/60/7cac607ed0bcbc77f3ddbbae4928118c.jpg",
  );

  Widget _buildCustomMessage(ChatMessage message) {
    return Column(
      crossAxisAlignment: message.user.id == currentUser.id
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: message.user.id == currentUser.id ? 50 : 8,
            right: message.user.id == currentUser.id ? 8 : 50,
          ),
          child: Row(
            mainAxisAlignment: message.user.id == currentUser.id
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              if (message.user.id != currentUser.id) ...[
                CircleAvatar(
                  backgroundImage:
                      NetworkImage(message.user.profileImage ?? ''),
                  radius: 12,
                ),
                const SizedBox(width: 4),
              ],
              Text(
                message.user.firstName ?? '',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: message.user.id == currentUser.id
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            padding: const EdgeInsets.all(8),
            margin: EdgeInsets.only(
              left: message.user.id == currentUser.id ? 50 : 8,
              right: message.user.id == currentUser.id ? 8 : 50,
              top: 4,
              bottom: 4,
            ),
            decoration: BoxDecoration(
              color: message.user.id == currentUser.id
                  ? const Color.fromARGB(255, 212, 231, 197)
                  : const Color.fromARGB(255, 191, 216, 175),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(8),
                topRight: const Radius.circular(8),
                bottomLeft:
                    Radius.circular(message.user.id == currentUser.id ? 8 : 0),
                bottomRight:
                    Radius.circular(message.user.id == currentUser.id ? 0 : 8),
              ),
            ),
            child: message.user.id == geminiUser.id
                ? MarkdownBody(
                    data: message.text,
                    softLineBreak: true,
                    selectable: true,
                    styleSheet: MarkdownStyleSheet(
                      p: const TextStyle(color: Colors.black, fontSize: 14),
                      strong: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                      em: const TextStyle(
                        color: Colors.black,
                        fontStyle: FontStyle.italic,
                      ),
                      h1: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      h2: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      h3: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      blockquote: const TextStyle(
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                      code: const TextStyle(
                        color: Colors.black87,
                        backgroundColor: Color(0xFFf7f7f7),
                      ),
                      listBullet: const TextStyle(color: Colors.black),
                    ),
                  )
                : Text(
                    message.text,
                    style: const TextStyle(color: Colors.black),
                  ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Chat Assistant",
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromRGBO(6, 132, 0, 1),
      ),
      body: Container(
        color: const Color.fromARGB(255, 255, 255, 255),
        child: Column(
          children: [
            if (selectedImage != null)
              Container(
                margin: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Image.file(
                      File(selectedImage!.path),
                      height: 50,
                      width: 50,
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Selected Image',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.black),
                      onPressed: () => setState(() => selectedImage = null),
                    )
                  ],
                ),
              ),
            Expanded(child: _buildChatUI()),
          ],
        ),
      ),
    );
  }

  Widget _buildChatUI() {
    return DashChat(
      inputOptions: InputOptions(
        inputDecoration: InputDecoration(
          hintText: "Chat in here",
          filled: true,
          fillColor: const Color.fromARGB(255, 191, 216, 175),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
        ),
        sendButtonBuilder: (Function() onSend) {
          return IconButton(
            icon: const Icon(Icons.send, color: Colors.black),
            onPressed: onSend,
          );
        },
        trailing: [
          IconButton(
            onPressed: _sendMediaMessage,
            icon: const Icon(Icons.image, color: Colors.black),
          ),
        ],
      ),
      messageOptions: MessageOptions(
        currentUserContainerColor: const Color.fromARGB(255, 212, 231, 197),
        containerColor: const Color.fromARGB(255, 191, 216, 175),
        textColor: Colors.black,
        currentUserTextColor: Colors.black,
        messageRowBuilder:
            (message, previous, next, isAfterDate, isBeforeDate) =>
                _buildCustomMessage(message),
      ),
      currentUser: currentUser,
      onSend: _sendMessage,
      messages: messages,
    );
  }

  void _sendMessage(ChatMessage chatMessage) {
    if (selectedImage != null) {
      chatMessage = ChatMessage(
        user: chatMessage.user,
        createdAt: chatMessage.createdAt,
        text: chatMessage.text,
        medias: [
          ChatMedia(
            url: selectedImage!.path,
            fileName: selectedImage!.name,
            type: MediaType.image,
          )
        ],
      );
      selectedImage = null;
    }

    setState(() {
      messages = [chatMessage, ...messages];
      chatHistory.add("User: ${chatMessage.text}");
    });

    try {
      String conversationContext = chatHistory.join('\n');
      String herbalContext =
          """Jawablah pertanyaan berikut dalam konteks tanaman herbal dengan format:
- Gunakan **teks** untuk poin penting
- Gunakan *teks* untuk nama latin 
- Gunakan # untuk judul utama
- Gunakan ## untuk sub judul
- Gunakan ### untuk sub-sub judul
- Gunakan > untuk quotes/kutipan
- Gunakan - untuk bullet points
- Gunakan `kode` untuk nama ilmiah

Riwayat chat sebelumnya:
$conversationContext

Pertanyaan: ${chatMessage.text}""";

      List<Uint8List>? images;
      if (chatMessage.medias != null && chatMessage.medias!.isNotEmpty) {
        images = [File(chatMessage.medias!.first.url).readAsBytesSync()];
      }

      buffer = "";
      isGenerating = true;

      gemini
          .streamGenerateContent(
        herbalContext,
        images: images,
        generationConfig: GenerationConfig(
          temperature: 0.7,
          maxOutputTokens: 2048,
          topP: 0.8,
          topK: 10,
        ),
      )
          .listen(
        (event) {
          String response = event.content?.parts?.fold(
                "",
                (previous, current) => "$previous ${current.text}",
              ) ??
              "";
          buffer += response;

          if (event.finishReason == "STOP") {
            ChatMessage message = ChatMessage(
              user: geminiUser,
              createdAt: DateTime.now(),
              text: buffer,
            );
            setState(() {
              messages = [message, ...messages];
              chatHistory.add("Assistant: $buffer");
            });
            buffer = "";
            isGenerating = false;
          } else {
            ChatMessage? lastMessage = messages.firstOrNull;
            if (lastMessage != null && lastMessage.user == geminiUser) {
              lastMessage = messages.removeAt(0);
              lastMessage.text = buffer;
              setState(() {
                messages = [lastMessage!, ...messages];
              });
            } else {
              ChatMessage message = ChatMessage(
                user: geminiUser,
                createdAt: DateTime.now(),
                text: buffer,
              );
              setState(() {
                messages = [message, ...messages];
              });
            }
          }
        },
        onError: (error) {
          print("Error: $error");
          isGenerating = false;
          buffer = "";
        },
        onDone: () {
          isGenerating = false;
        },
        cancelOnError: false,
      );
    } catch (e) {
      print(e);
      isGenerating = false;
      buffer = "";
    }
  }

  void _sendMediaMessage() async {
    ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        selectedImage = file;
      });
    }
  }
}
