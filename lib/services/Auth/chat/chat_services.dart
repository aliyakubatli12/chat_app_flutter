import 'package:chatappfirebase/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ChatServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();
        return user;
      }).toList();
    });
  }

  Future<void> SendMessage(String receiverID, String message) async {
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
      senderID: currentUserID,
      senderEmail: currentUserEmail,
      receiverID: receiverID,
      message: message,
      timestamp: timestamp,
    );

    List<String> ids=[currentUserID,receiverID];
    ids.sort();
    String chatroomID = ids.join("_");

     await FirebaseFirestore.instance.collection("ChatRooms").doc(chatroomID).collection("Messages").add(newMessage.toMap());
   }

  Future<void> SendImageMessage(String receiverID, String imageUrl) async {
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
      senderID: currentUserID,
      senderEmail: currentUserEmail,
      receiverID: receiverID,
      message: "Resim gönderildi", // Varsayılan mesaj
      timestamp: timestamp,
      type: 'image',
      content: imageUrl,
    );

    List<String> ids=[currentUserID,receiverID];
    ids.sort();
    String chatroomID = ids.join("_");

     await FirebaseFirestore.instance.collection("ChatRooms").doc(chatroomID).collection("Messages").add(newMessage.toMap());
   }

  Future<String?> pickAndUploadImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      
      if (image == null) return null;

      final String currentUserID = _auth.currentUser!.uid;
      final String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final String filePath = 'chat_images/$currentUserID/$fileName.jpg';

      final Reference ref = FirebaseStorage.instance.ref().child(filePath);
      final UploadTask uploadTask = ref.putFile(File(image.path));
      
      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      
      return downloadUrl;
    } catch (e) {
      print('Resim yükleme hatası: $e');
      return null;
    }
  }

   Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
     List<String> ids = [userID, otherUserID];
     ids.sort();
     String chatRoomID = ids.join('_');

     return _firestore
         .collection("ChatRooms")
         .doc(chatRoomID)
         .collection("Messages")
         .orderBy("timestamp", descending: false)
         .snapshots();
   }
 }
