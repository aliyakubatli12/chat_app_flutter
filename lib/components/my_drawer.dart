import 'package:chatappfirebase/services/Auth/auth_service.dart';
import 'package:chatappfirebase/pages/setting_page.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  void logout() {
    final _auth = AuthService();
    _auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              DrawerHeader(
                child: Center(
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor == Colors.white ? Colors.black : Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                        width: 2,
                      ),
                    ),
                    child: ClipOval(
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          Theme.of(context).primaryColor,
                          BlendMode.srcIn,
                        ),
                        child: Image.asset(
                          "lib/assets/images/20-Creative-Chat-Logo-Designs-19 (1).png",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: Text('A N A  M E N Ü', style: TextStyle(color: Theme.of(context).primaryColor)),
                  leading: Icon(Icons.home, color: Theme.of(context).primaryColor),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: Text('A Y A R L A R ', style: TextStyle(color: Theme.of(context).primaryColor)),
                  leading: Icon(Icons.settings, color: Theme.of(context).primaryColor),
                  onTap: () {
                    Navigator.pop(context);

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingsPage()),
                    );
                  },
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.only(left: 25.0, bottom: 25.0),
            child: ListTile(
              title: Text('Ç I K I Ş ', style: TextStyle(color: Theme.of(context).primaryColor)),
              leading: Icon(Icons.logout, color: Theme.of(context).primaryColor),
              onTap: logout,
            ),
          ),
        ],
      ),
    );
  }
}
