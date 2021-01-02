import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skill_drills/main.dart';
import 'package:skill_drills/tabs/Profile.dart';
import 'package:skill_drills/services/factory.dart';
import 'package:skill_drills/tabs/profile/settings/Settings.dart';
import 'package:skill_drills/widgets/BasicTitle.dart';
import 'NavTab.dart';

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
  List<Widget> _actions;
  int _selectedIndex = 2;
  bool _showLogoToolbar = true;
  static List<NavTab> _tabs = [
    NavTab(
      title: BasicTitle(title: "Profile"),
      actions: [
        Container(
          margin: EdgeInsets.only(top: 10),
          child: IconButton(
            icon: Icon(
              Icons.settings,
              size: 28,
            ),
            onPressed: () {
              navigatorKey.currentState.push(MaterialPageRoute(builder: (BuildContext context) {
                return ProfileSettings();
              }));
            },
          ),
        ),
      ],
      body: Profile(),
    ),
    NavTab(
      title: BasicTitle(title: "History"),
    ),
    NavTab(
      title: BasicTitle(title: "Start"),
    ),
    NavTab(
      title: BasicTitle(title: "Drills"),
    ),
    NavTab(
      title: BasicTitle(title: "Routines"),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _title = index == 2 ? lightLogo : _tabs[index].title;
      _actions = _tabs[index].actions;
      _showLogoToolbar = (_tabs[index].title is Container) || index == 2;
    });
  }

  @override
  void initState() {
    setState(() {
      _title = lightLogo;
      _actions = [];
    });

    initFactoryDefaults();

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
              backgroundColor: Theme.of(context).colorScheme.primary,
              iconTheme: Theme.of(context).iconTheme,
              actionsIconTheme: Theme.of(context).iconTheme,
              floating: false,
              pinned: true,
              flexibleSpace: DecoratedBox(
                decoration: BoxDecoration(
                  color: _showLogoToolbar ? Theme.of(context).primaryColor : Theme.of(context).appBarTheme.backgroundColor,
                ),
                child: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  titlePadding: _showLogoToolbar ? EdgeInsets.only(left: 10, right: 10, bottom: 20, top: 20) : null,
                  centerTitle: _showLogoToolbar ? true : false,
                  title: _title,
                  background: Container(
                    color: _showLogoToolbar ? Theme.of(context).primaryColor : Theme.of(context).appBarTheme.backgroundColor,
                  ),
                ),
              ),
              actions: _actions,
            ),
          ];
        },
        body: _tabs.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
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
        backgroundColor: Theme.of(context).backgroundColor,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Theme.of(context).colorScheme.onPrimary,
        onTap: _onItemTapped,
      ),
    );
  }
}
