import 'package:chatappfirebase/components/chat_bubble.dart';
import 'package:chatappfirebase/services/Auth/auth_service.dart';
import 'package:chatappfirebase/services/Auth/chat/chat_services.dart';
import 'package:chatappfirebase/components/my_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;

  ChatPage({super.key, required this.receiverEmail, required this.receiverID});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();

  final ChatServices _chatServices = ChatServices();
  final AuthService _authService = AuthService();

  FocusNode myFocusNode = FocusNode();

  List<QueryDocumentSnapshot> _messages = [];
  bool _isLoading = false;
  bool _hasMore = true;
  DocumentSnapshot? _lastDocument;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        Future.delayed(const Duration(milliseconds: 300), () => scrollDown());
      }
    });

    _loadInitialMessages();

    _listenForNewMessages();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels <= 100 && _hasMore && !_isLoading) {
        _loadMoreMessages();
      }
    });

    Future.delayed(const Duration(milliseconds: 100), () => scrollDown());
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void scrollDown() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0.0);
    }
  }

  Future<void> _loadInitialMessages() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      String senderID = _authService.getCurrentUser()!.uid;
      List<String> ids = [widget.receiverID, senderID];
      ids.sort();
      String chatRoomID = ids.join('_');

      Query query = FirebaseFirestore.instance
          .collection("ChatRooms")
          .doc(chatRoomID)
          .collection("Messages")
          .orderBy("timestamp", descending: true)
          .limit(20);

      QuerySnapshot snapshot = await query.get();

      setState(() {
        _messages = snapshot.docs;
        _lastDocument = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;
        _hasMore = snapshot.docs.length == 20;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error loading initial messages: $e');
    }
  }

  Future<void> _loadMoreMessages() async {
    if (_isLoading || !_hasMore || _lastDocument == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      String senderID = _authService.getCurrentUser()!.uid;
      List<String> ids = [widget.receiverID, senderID];
      ids.sort();
      String chatRoomID = ids.join('_');

      Query query = FirebaseFirestore.instance
          .collection("ChatRooms")
          .doc(chatRoomID)
          .collection("Messages")
          .orderBy("timestamp", descending: true)
          .startAfterDocument(_lastDocument!)
          .limit(20);

      QuerySnapshot snapshot = await query.get();

      if (snapshot.docs.isNotEmpty) {
        setState(() {
          _messages.addAll(snapshot.docs);
          _lastDocument = snapshot.docs.last;
          _hasMore = snapshot.docs.length == 20;
          _isLoading = false;
        });
      } else {
        setState(() {
          _hasMore = false;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error loading more messages: $e');
    }
  }

  void _listenForNewMessages() {
    String senderID = _authService.getCurrentUser()!.uid;
    List<String> ids = [widget.receiverID, senderID];
    ids.sort();
    String chatRoomID = ids.join('_');

    FirebaseFirestore.instance
        .collection("ChatRooms")
        .doc(chatRoomID)
        .collection("Messages")
        .orderBy("timestamp", descending: true)
        .limit(1)
        .snapshots()
        .listen((snapshot) {
          if (snapshot.docs.isNotEmpty && _messages.isNotEmpty) {
            QueryDocumentSnapshot latestMessage = snapshot.docs.first;
            QueryDocumentSnapshot currentLatest = _messages.first;

            if (latestMessage.id != currentLatest.id) {
              setState(() {
                _messages.insert(0, latestMessage);

                if (_messages.length > 100) {
                  _messages = _messages.take(100).toList();
                }
              });

              Future.delayed(
                const Duration(milliseconds: 100),
                () => scrollDown(),
              );
            }
          }
        });
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatServices.SendMessage(
        widget.receiverID,
        _messageController.text,
      );

      _messageController.clear();

      Future.delayed(const Duration(milliseconds: 100), () => scrollDown());
    }
  }

  void sendImage() async {
    final String? imageUrl = await _chatServices.pickAndUploadImage();
    if (imageUrl != null) {
      await _chatServices.SendImageMessage(widget.receiverID, imageUrl);
    }
    scrollDown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          widget.receiverEmail.split("@")[0],
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          _buildUserInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    if (_isLoading && _messages.isEmpty) {
      return Center(
        child: CircularProgressIndicator(color: Theme.of(context).primaryColor),
      );
    }

    if (_messages.isEmpty) {
      return Center(
        child: Text(
          "Henüz mesaj yok",
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
      );
    }

    return Scrollbar(
      thumbVisibility: true,
      thickness: 4.0,
      radius: Radius.circular(6.0),
      controller: _scrollController,
      child: ListView.builder(
        controller: _scrollController,
        reverse: true,
        itemCount: _messages.length + (_hasMore ? 1 : 0),
        // The syntax error was here. The logic must be inside the itemBuilder's function body.
        itemBuilder: (context, index) {
          if (index == _messages.length) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            );
          }
          return _buildMessageItem(_messages[index]);
        },
      ),
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    bool isCurrentUser = data['senderID'] == _authService.getCurrentUser()!.uid;
    String messageType = data['type'] ?? 'text';

    var aligment = isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: aligment,
      child: Column(
        crossAxisAlignment: isCurrentUser
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          if (messageType == 'image')
            Container(
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.6,
                maxHeight: 300,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: isCurrentUser ? Colors.blue : Colors.grey[300],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  data['content'] ?? '',
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 200,
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      child: Center(
                        child: Icon(Icons.error, color: Colors.red, size: 50),
                      ),
                    );
                  },
                ),
              ),
            )
          else
            ChatBubble(message: data["message"], isCurrentUser: isCurrentUser),
        ],
      ),
    );
  }

  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40.0),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor == Colors.white
                  ? Colors.black
                  : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).primaryColor,
                width: 2,
              ),
            ),
            margin: EdgeInsets.only(left: 25, right: 8),
            child: IconButton(
              onPressed: sendImage,
              icon: Icon(Icons.image, color: Theme.of(context).primaryColor),
            ),
          ),
          Expanded(
            child: MyTextField(
              controller: _messageController,
              hintText: "Mesajınız ....",
              obsecureText: false,
              focusNode: myFocusNode,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor == Colors.white
                  ? Colors.black
                  : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).primaryColor,
                width: 2,
              ),
            ),
            margin: EdgeInsets.only(right: 25),
            child: IconButton(
              onPressed: sendMessage,
              icon: Icon(
                Icons.arrow_upward,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
