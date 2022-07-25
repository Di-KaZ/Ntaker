import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  SharedPreferences? prefs;
  List<String> parameters = ['autoSave'];

  @override
  void initState() {
    loadSharedPrefs();
    super.initState();
  }

  void togglePref(String key) {
    setState(() {
      prefs!.setBool(
          key, prefs!.getBool(key) != null ? !prefs!.getBool(key)! : true);
    });
  }

  void loadSharedPrefs() async {
    var sprefs = await SharedPreferences.getInstance();
    setState(() {
      prefs = sprefs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView.separated(
          itemBuilder: (context, index) => ListTile(
                title: InkWell(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                      Text(parameters[index]),
                      Text(prefs?.getBool(parameters[index]) != null &&
                              prefs!.getBool(parameters[index]) == true
                          ? 'ON'
                          : 'OFF')
                    ])),
                onTap: () => togglePref(parameters[index]),
              ),
          separatorBuilder: (context, index) => const SizedBox(height: 20),
          itemCount: parameters.length),
    );
  }
}
