import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatelessWidget {
  static const routeName = '/profile';
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                width: size.width,
                height: (size.height - 40) * 0.5,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      spreadRadius: 3,
                      offset: Offset(0, 6),
                    ),
                  ],
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(45),
                    bottomLeft: Radius.circular(45),
                  ),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(45),
                        bottomLeft: Radius.circular(45),
                      ),
                      child: Container(
                        decoration: BoxDecoration(),
                        child: Image(
                          fit: BoxFit.fill,
                          image: AssetImage('assets/messi.jpeg'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        'Lionel Messi',
                        style: GoogleFonts.breeSerif(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          'Bracelona',
                          style: GoogleFonts.nanumMyeongjo(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 100,
                    child: GFButton(
                      boxShadow: BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        spreadRadius: 3,
                      ),
                      onPressed: () {},
                      shape: GFButtonShape.pills,
                      text: 'Follow',
                      color: GFColors.DARK,
                      size: GFSize.LARGE,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        '140',
                        style: GoogleFonts.nanumMyeongjo(
                          color: Colors.black,
                          fontSize: 25,
                        ),
                      ),
                      Text(
                        'SHOTS',
                        style: GoogleFonts.nanumMyeongjo(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 10,
                    height: 60,
                    child: VerticalDivider(
                      color: Colors.black,
                      thickness: 1,
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        '727',
                        style: GoogleFonts.nanumMyeongjo(
                          color: Colors.black,
                          fontSize: 25,
                        ),
                      ),
                      Text(
                        'GOALS',
                        style: GoogleFonts.nanumMyeongjo(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 10,
                    height: 60,
                    child: VerticalDivider(
                      color: Colors.black,
                      thickness: 1,
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        '140M',
                        style: GoogleFonts.nanumMyeongjo(
                          color: Colors.black,
                          fontSize: 25,
                        ),
                      ),
                      Text(
                        'FOLLOWERS',
                        style: GoogleFonts.nanumMyeongjo(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec pulvinar sem sit amet sem lobortis, et pretium mauris tincidunt. Vestibulum a justo ut augue vestibulum posuere. Curabitur vel fringilla massa, nec sagittis niamet maximus feugiat. Morbi arcu ante, rhoncus eget ex in, volutpat congue tellus',
                    textAlign: TextAlign.left,
                    style: GoogleFonts.nanumMyeongjo(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Container(
                width: size.width * 0.9,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Stack(
                  overflow: Overflow.clip,
                  children: <Widget>[
                    Align(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 11),
                        child: Container(
                          width: (size.width + 30) * 0.8,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    CircleAvatar(
                                      backgroundImage:
                                          AssetImage('assets/messi.jpeg'),
                                      radius: 25,
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Column(
                                      children: <Widget>[
                                        Text(
                                          'Lionel Messi',
                                          textAlign: TextAlign.left,
                                          style: GoogleFonts.breeSerif(
                                            color: Colors.black,
                                            fontSize: 17,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: Text(
                                            'Bracelona',
                                            textAlign: TextAlign.left,
                                            style: GoogleFonts.nanumMyeongjo(
                                              color: Colors.black,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    Text('Walid Icon'),
                                  ],
                                ),
                                SizedBox(
                                  height: 9,
                                ),
                                Container(
                                  width: (size.width + 10) * 0.8,
                                  height: (size.height) * 0.3,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image(
                                      fit: BoxFit.fill,
                                      image: AssetImage('assets/goal.jpg'),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.favorite_border,
                                      size: 40,
                                    ),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    Text('239'),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Icon(
                                      Icons.comment,
                                      size: 40,
                                    ),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    Text('4234'),
                                    Spacer(),
                                    Text('Walid Icon'),
                                  ],
                                ),
                                SizedBox(
                                  height: 6,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 5),
                                  child: Wrap(
                                    children: <Widget>[
                                      Text(
                                        'Lionel Messi',
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.breeSerif(
                                          color: Colors.black,
                                          fontSize: 19,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Text(
                                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec pulvinar sem sit amet sem lobortis, et pretium mauris tincidunt. Vestibulum a justo ut augue vestibulum posuere. Curabitur vel fringilla massa, nec sagittis niamet maximus feugiat. Morbi arcu ante, rhoncus eget ex in, volutpat congue tellus',
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.nanumMyeongjo(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      alignment: Alignment.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
