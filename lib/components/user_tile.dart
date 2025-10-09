import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final String text;
  final void Function()? onTap;

  const UserTile({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor == Colors.white ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).primaryColor,
            width: 1,
          ),
        ),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
        padding: const EdgeInsets.all(20),
        child: Row(children: [
          Icon(Icons.person, color: Theme.of(context).primaryColor == Colors.white ? Colors.white : Colors.black),
          const SizedBox(width: 10),
          Text(text, style: TextStyle(color: Theme.of(context).primaryColor == Colors.white ? Colors.white : Colors.black))
        ]),
      ),
    );
  }
}
