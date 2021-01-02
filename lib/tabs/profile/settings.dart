import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skill_drills/theme/StateNotifier.dart';
import 'package:skill_drills/widgets/BasicTitle.dart';

class ProfileSettings extends StatefulWidget {
  ProfileSettings({Key key}) : super(key: key);

  @override
  _ProfileSettingsState createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  // State settings values
  bool _restTimer = true;
  bool _darkMode = false;

  @override
  void initState() {
    super.initState();

    _loadSettings();
  }

  //Loading counter value on start
  _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _darkMode = (prefs.getBool('dark_mode') ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              collapsedHeight: 65,
              expandedHeight: 65,
              backgroundColor: Theme.of(context).backgroundColor,
              floating: false,
              pinned: true,
              leading: Container(
                margin: EdgeInsets.only(top: 10),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: 28,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              flexibleSpace: DecoratedBox(
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                ),
                child: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  titlePadding: null,
                  centerTitle: false,
                  title: BasicTitle(title: "Settings"),
                  background: Container(
                    color: Theme.of(context).backgroundColor,
                  ),
                ),
              ),
              actions: [],
            ),
          ];
        },
        body: SettingsList(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          sections: [
            SettingsSection(
              title: 'General',
              tiles: [
                SettingsTile(
                  titleTextStyle: Theme.of(context).textTheme.bodyText1,
                  title: 'Activities',
                  subtitle: '',
                  leading: Icon(
                    Icons.directions_walk,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  onPressed: (BuildContext context) {},
                ),
                SettingsTile.switchTile(
                  titleTextStyle: Theme.of(context).textTheme.bodyText1,
                  title: 'Rest Timer',
                  leading: Icon(
                    Icons.timer,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  switchValue: _restTimer,
                  onToggle: (bool value) {
                    setState(() {
                      _restTimer = value;
                    });
                  },
                ),
                SettingsTile.switchTile(
                  titleTextStyle: Theme.of(context).textTheme.bodyText1,
                  title: 'Dark Mode',
                  leading: Icon(
                    Icons.brightness_2,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  switchValue: _darkMode,
                  onToggle: (bool value) async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    setState(() {
                      _darkMode = !_darkMode;
                      prefs.setBool('dark_mode', _darkMode);
                    });

                    Provider.of<ThemeStateNotifier>(context, listen: false).updateTheme(value);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
