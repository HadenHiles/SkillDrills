import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skill_drills/pages/Profile.dart';

import 'NavPage.dart';

// This is the stateful widget that the main application instantiates.
class Nav extends StatefulWidget {
  Nav({Key key}) : super(key: key);

  @override
  _NavState createState() => _NavState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _NavState extends State<Nav> {
  final lightLogo = Container(
    height: 60,
    child: SvgPicture.asset(
      'assets/images/logo/SkillDrills.svg',
      semanticsLabel: 'Skill Drills',
    ),
  );

  // State variables
  Widget _title;
  int _selectedIndex = 2;
  bool _showLogoToolbar = true;
  static List<NavPage> _pages = [
    NavPage(
      title: Text(
        "Profile",
        style: TextStyle(
          fontSize: 26,
          color: Colors.black87,
        ),
        textAlign: TextAlign.center,
      ),
      body: Profile(),
    ),
    NavPage(
      title: Text(
        "History",
        style: TextStyle(
          fontSize: 26,
          color: Colors.black87,
        ),
        textAlign: TextAlign.center,
      ),
    ),
    NavPage(
      title: Text(
        "Start",
        style: TextStyle(
          fontSize: 26,
          color: Colors.black87,
        ),
        textAlign: TextAlign.center,
      ),
    ),
    NavPage(
      title: Text(
        "Drills",
        style: TextStyle(
          fontSize: 26,
          color: Colors.black87,
        ),
        textAlign: TextAlign.center,
      ),
    ),
    NavPage(
      title: Text(
        "Routines",
        style: TextStyle(
          fontSize: 26,
          color: Colors.black87,
        ),
        textAlign: TextAlign.center,
      ),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _title = index == 2 ? lightLogo : _pages[index].title;
      _showLogoToolbar = (_pages[index].title is Container) || index == 2;
    });
  }

  @override
  void initState() {
    setState(() {
      _title = lightLogo;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              collapsedHeight: _showLogoToolbar ? 100 : 65,
              expandedHeight: _showLogoToolbar ? 200.0 : 140,
              backgroundColor: Colors.white24,
              floating: false,
              pinned: true,
              flexibleSpace: DecoratedBox(
                decoration: BoxDecoration(
                  color: _showLogoToolbar ? Theme.of(context).primaryColor : Color(0xFFF7F7F7),
                ),
                child: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  titlePadding: _showLogoToolbar ? EdgeInsets.only(left: 10, right: 10, bottom: 20, top: 20) : null,
                  centerTitle: _showLogoToolbar ? true : false,
                  title: _title,
                  background: Container(
                    color: _showLogoToolbar ? Theme.of(context).primaryColor : Colors.white24,
                  ),
                ),
              ),
            ),
          ];
        },
        body: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Start',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: 'Drills',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Routines',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.black54,
        onTap: _onItemTapped,
      ),
    );
  }
}
