import 'package:flutter/material.dart';

class Header extends StatefulWidget {
  const Header({super.key});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
  //  String selectedCountry = 'Egypt - Cairo';
    return  Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset('assets/images/splash/listys_logo.png', width: 120, height: 60),
          
        ],
      );
  }
}