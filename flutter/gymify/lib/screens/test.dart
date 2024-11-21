import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:gymify/utils/custom_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 190, 184, 250),
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      bottomNavigationBar: CurvedNavigationBar(
          animationCurve: Curves.fastEaseInToSlowEaseOut,
          backgroundColor: const Color.fromARGB(255, 190, 184, 250),
          items: const [
            Icon(Icons.home),
            Icon(Icons.search),
            Icon(Icons.add),
            Icon(Icons.notifications),
            Icon(Icons.account_circle),
          ]),
      body: Center(
        child: Column(
          children: <Widget>[
            const Text('Welcome to Gymify'),
            const Text('Your Personal Fitness Trainer'),
            const Text('Get Started'),
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  margin: const EdgeInsets.all(10),
                  child: const Text(
                    'Get Started',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
            CustomButton(
              text: "Login",
              textStyle: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
              color: Colors.yellow,
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
    );
  }
}
