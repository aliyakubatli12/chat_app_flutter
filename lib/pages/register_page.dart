import 'package:chatappfirebase/services/Auth/auth_service.dart';
import 'package:chatappfirebase/components/my_button.dart';
import 'package:chatappfirebase/components/my_textfield.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _confirmPwController = TextEditingController();

  final void Function()? onTap;

  RegisterPage({super.key, required this.onTap});

  void register(BuildContext context) {
    final _auth = AuthService();

    if (_pwController.text == _confirmPwController.text) {
      try {
        _auth.signUpWithEmailPassword(
          _emailController.text,
          _pwController.text,
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(title: Text(e.toString())),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) =>
            const AlertDialog(title: Text("Şifreler uyuşmuyor!")),
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
                  border: Border.all(color: Colors.white, width: 3),
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

            Text(
              "Aramıza hoş geldiniz",
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
              controller: _emailController,
              icon: Icons.email,
            ),

            const SizedBox(height: 10),
            MyTextField(
              hintText: 'Şifre',
              obsecureText: true,
              icon: Icons.lock,
              controller: _pwController,
            ),

            const SizedBox(height: 10),
            MyTextField(
              hintText: 'Şifreyi onaylayın ',
              obsecureText: true,
              controller: _confirmPwController,
              icon: Icons.shield,
            ),

            const SizedBox(height: 25),

            MyButton(text: 'Kayıt olun', onTap: () => register(context)),

            const SizedBox(height: 25),

            const SizedBox(height: 25),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Hesabınız var mı? ",
                  style: TextStyle(color: Colors.white),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    "Giriş  yapınız",
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
