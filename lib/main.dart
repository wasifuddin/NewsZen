import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/discover_screen.dart';
import 'screens/ai_screen.dart';
import 'screens/more_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NewsZen',
      theme: ThemeData(
        primarySwatch: Colors.red,
        fontFamily: 'Poppins',
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  
  final List<Widget> _pages = [
    const HomeScreen(),
    const DiscoverScreen(),
    const SavedScreen(),
    const ProfileScreen(),
  ];

  
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], 
      backgroundColor: Colors.white, 

      
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white, 
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30.0)), 
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1), 
              spreadRadius: 2, 
              blurRadius: 5, 
              offset: const Offset(0, -2), 
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30.0)), 
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.explore),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.auto_awesome_rounded),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart_rounded),
                label: '',
              ),
            ],
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.red, 
            unselectedItemColor: Colors.grey, 
            backgroundColor: Colors.white, 
            showSelectedLabels: false, 
            showUnselectedLabels: false, 
            iconSize: 32.0,
          ),
        ),
      ),
    );
  }
}
