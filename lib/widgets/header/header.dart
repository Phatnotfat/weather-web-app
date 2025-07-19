import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff4c72e1),
      padding: const EdgeInsets.symmetric(vertical: 20),
      width: double.infinity,
      child: const Center(
        child: Text(
          'Weather Dashboard',
          style: TextStyle(
            fontSize: 22,
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
