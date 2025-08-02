import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

var myDeafultBackgroundColor = Colors.grey.shade200;

var myAppbar = AppBar(
  backgroundColor: Colors.grey.shade300,
);
var myDrawer = Drawer(
  backgroundColor: Colors.grey.shade200,
  child: Column(
    children: [
      DrawerHeader(child: Image.asset('asset/images/karwaan.png', fit: BoxFit.cover,)),
      ListTile(
        leading: Icon(Icons.home),
        title: Text('H O M E '),
      ),
      ListTile(
        leading: Icon(Icons.info),
        title: Text('I N F O'),
      ),
      ListTile(
        leading: Icon(Icons.settings),
        title: Text('s E T T I N G S '),
      ),
      ListTile(
        leading: Icon(Icons.person),
        title: Text('P R O F I L E '),
      ),
      ListTile(
        leading: Icon(Icons.logout),
        title: Text('L O G O U T'),
      ),
    ],
  ),
);

var title = GoogleFonts.poppins(
  fontWeight: FontWeight.bold,
  fontSize: 25,
  color: Colors.grey.shade900
);

var lowSizedBox = const SizedBox(height: 13);
var middleSizedBox = const SizedBox(height: 20);
var heighSizedBox = const SizedBox(height: 30);
var supperHeighSizedbox = const SizedBox(height: 40);

 var accentBlue = Color(0xFF2196F3);
 var primaryBlue = Color(0xFF1976D2);

 var mainPaddingall =  const Padding(padding: EdgeInsets.all(20));
 var mainPaddingSy = const Padding(padding: EdgeInsets.symmetric(horizontal: 20));

 var lowPaddingall = const Padding(padding: EdgeInsets.all(10));
 var lowPaddingSy = const Padding(padding: EdgeInsets.symmetric(horizontal: 10));

 var heighPaddingall = const Padding(padding: EdgeInsets.all(30));
 var heighPaddingSy = const Padding(padding: EdgeInsets.symmetric(horizontal: 30));