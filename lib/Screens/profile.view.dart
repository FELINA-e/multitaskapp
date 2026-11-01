
import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage("images/avatar.png"),
          ),
          const SizedBox(height: 10),
          const Text(
            "Samia-Nady",
            style: TextStyle(
              color: Colors.deepOrange,
              fontSize: 25,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 50),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
                side: const BorderSide(color: Colors.orange),
              ),
              backgroundColor: Colors.white10,
              foregroundColor: Colors.indigo,
              elevation: 25,
            ),
            child: const Text("Edit Profile"),
          ),
        ],
      ),
    );
  }
}
