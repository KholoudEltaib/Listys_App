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
          // Row(
          //   children: [
          //     Icon(Icons.location_on_outlined, color: Colors.grey[400], size: 20),
          //     const SizedBox(width: 4),
          //     DropdownButton<String>(
          //       value: selectedCountry,
          //       dropdownColor: const Color(0xFF2E2E2E),
          //       underline: const SizedBox(),
          //       style: TextStyle(color: Colors.grey[400], fontSize: 14),
          //       iconEnabledColor: Colors.grey[400],
          //       items: <String>[
          //         'Egypt - Cairo',
          //         'London - UK',
          //         'New York - USA',
          //       ].map<DropdownMenuItem<String>>((String value) {
          //         return DropdownMenuItem(
          //           value: value,
          //           child: Text(value),
          //         );
          //       }).toList(),
          //       onChanged: (value) {
          //         if (value != null) {
          //           setState(() {
          //             selectedCountry = value;
          //           });
          //         }
          //       },
          //     ),
          //   ],
          // ),
        ],
      );
  }
}