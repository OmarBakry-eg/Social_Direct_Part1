import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileInformation extends StatelessWidget {
  final String number, description;
  ProfileInformation({@required this.description, @required this.number});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          number,
          style: GoogleFonts.nanumMyeongjo(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        SizedBox(
          height: 6,
        ),
        Text(
          description,
          style: GoogleFonts.nanumMyeongjo(
            color: Colors.black,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
