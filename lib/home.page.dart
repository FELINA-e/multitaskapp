import 'package:flutter/material.dart';
import 'Screens/profile.view.dart';
import 'Screens/cards.view.dart';
import 'Screens/home.view.dart';
import 'Screens/login.view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex =1;

  List<Widget>pages=[HomeView(),LoginView(),CardsView(),ProfileView()];

  void changePage(int selectedIndex){
    setState(() {
      currentIndex=selectedIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text(
          "application multitaches",
          style: TextStyle(color:Colors.white,fontSize: 30),
        ),
      ) ,
      body: SafeArea(child: Padding(padding: EdgeInsets.all(16.0),
      child:IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      )),
      bottomNavigationBar: BottomNavigationBar(backgroundColor:Colors.blueGrey,
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: Colors.white,
          selectedItemColor: Colors.orange,
          currentIndex: currentIndex,
          items: [
        BottomNavigationBarItem(icon: Icon(Icons.home),label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.login),label: "Login"),
        BottomNavigationBarItem(icon: Icon(Icons.map),label: "Card"),
        BottomNavigationBarItem(icon: Icon(Icons.person),label: "Profile"),
      ],onTap: changePage),
    );
  }
}
