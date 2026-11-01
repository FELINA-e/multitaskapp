import 'package:flutter/material.dart';
class LoginView extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
final TextEditingController passwordController = TextEditingController();

LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(),
      body:
      Padding(padding: EdgeInsets.symmetric(horizontal: 24,vertical: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Connexion",
            style: TextStyle(
              fontSize: 20,
              color: Colors.blue,
              fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          TextField(
            controller: usernameController,
            decoration: InputDecoration(
              labelText: "Nom d'ultilisateur",
              labelStyle: TextStyle(color: Colors.indigo,fontSize: 20),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.teal,width: 2),
                borderRadius: BorderRadius.circular(10)),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.pink,width: 3),
                borderRadius: BorderRadius.circular(10)),
            ),
          ),
          SizedBox(height: 15),
          TextField(
            obscureText: true,
            controller: passwordController,
            decoration: InputDecoration(
              labelText: "Mot de passe",
              labelStyle: TextStyle(color: Colors.indigo,fontSize: 20),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal,width: 2),
                  borderRadius: BorderRadius.circular(10)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.pink,width: 3),
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightBlue,
              padding: EdgeInsets.symmetric(horizontal: 40,vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              )),
            onPressed: (){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.teal,
                content: Text(
                  "Connexion de ${usernameController.text} ... (Simulation)")));
            },
            child: Text(
              "Se connecter",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            )),
          SizedBox(height: 20),
          TextButton(
              onPressed: (){
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.teal,
                    content: Text(
                        "Lien de réinitialisation de mot de passe envoyé ! ")));
              },
              child: Text(
                "Mot de passe oublié ?",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20,
                  fontStyle: FontStyle.italic),
          ))
        ],
      ),
      ),
    );
  }
}