import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color.fromRGBO(73, 122, 125, 1),
                  Color.fromRGBO(17, 28, 76, 1),
                ],
              ),
            ),
          ),
          const Scaffold(
            backgroundColor: Colors.transparent,
          ),
        ],
      ),
    );
  }
}
