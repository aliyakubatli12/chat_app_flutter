import 'package:chatappfirebase/components/my_drawer.dart';
import 'package:chatappfirebase/components/user_tile.dart';
import 'package:chatappfirebase/pages/chat_page.dart';
import 'package:chatappfirebase/services/Auth/auth_service.dart';
import 'package:chatappfirebase/services/Auth/chat/chat_services.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ChatServices _chatService = ChatServices();
  final AuthService _authService = AuthService();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "Ana Ekran",
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      drawer: MyDrawer(),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: "Arkadaşını ara...",
              prefixIcon: Icon(
                Icons.search,
                color: Theme.of(context).primaryColor,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 2,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ),
            ),
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ),
        Expanded(
          child: StreamBuilder(
            stream: _chatService.getUsersStream(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Error loading users.",
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                );
              }

              List<Map<String, dynamic>> filteredUsers = snapshot.data!.where((
                userData,
              ) {
                String email = userData["email"] ?? "";
                String searchTerm = _searchController.text.toLowerCase();

                if (searchTerm.isEmpty) {
                  return false;
                }

                return email.toLowerCase().contains(searchTerm);
              }).toList();

              if (filteredUsers.isEmpty) {
                if (_searchController.text.isNotEmpty) {
                  return Center(
                    child: Text(
                      "Aradığınız kullanıcı bulunamadı",
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  );
                } else {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search,
                          size: 80,
                          color: Theme.of(
                            context,
                          ).primaryColor.withOpacity(0.3),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Arkadaşlarını Bul",
                          style: TextStyle(
                            fontSize: 24,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Arama yaparak arkadaşlarını bulabilirsin",
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(
                              context,
                            ).primaryColor.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              }

              return ListView(
                children: filteredUsers
                    .map<Widget>(
                      (userData) => _buildUserListItem(userData, context),
                    )
                    .toList(),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildUserListItem(
    Map<String, dynamic> userData,
    BuildContext context,
  ) {
    if (userData["email"] != _authService.getCurrentUser()!.email) {
      return UserTile(
        text: userData["email"] ?? "E-posta bulunamadı",
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverEmail: userData["email"],
                receiverID: userData["uid"],
              ),
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }
}
