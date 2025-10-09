import 'package:chatappfirebase/services/Auth/auth_service.dart';
import 'package:chatappfirebase/components/my_button.dart';
import 'package:chatappfirebase/components/my_textfield.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _pwcontroller = TextEditingController();

  void Function()? onTap;

  LoginPage({super.key, required this.onTap});

  void login(BuildContext context) async {
    final authService = AuthService();

    try {
      await authService.signInWithEmailPassword(
        _emailcontroller.text,
        _pwcontroller.text,
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(title: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              "lib/assets/images/iOS-5-dark-mod-iphone-wallpaper-ar72014.png",
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 80.0),
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 3,
                  ),
                ),
                child: ClipOval(
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      Colors.white,
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

            const SizedBox(height: 80),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Colors.white,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    color: Colors.white,
                    size: 24,
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      "Gerçek zamanlı mesajlaşma",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Colors.white,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.photo_camera_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      "Fotoğraf paylaşımı",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            Text(
              "Hoş Geldiniz",
              style: TextStyle(
                color: Colors.white, 
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 25),

            MyTextField(
              hintText: 'E-posta',
              obsecureText: false,
              controller: _emailcontroller,
              icon: Icons.email,
            ),

            const SizedBox(height: 10),
            MyTextField(
              hintText: 'Şifre',
              obsecureText: true,
              controller: _pwcontroller,
              icon: Icons.lock,
            ),

            const SizedBox(height: 25),

            MyButton(text: 'Giriş Yapınız', onTap: () => login(context)),

            const SizedBox(height: 25),

            const SizedBox(height: 25),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Üye değil misiniz? ",
                  style: TextStyle(color: Colors.white),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    "Kayıt olun",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
