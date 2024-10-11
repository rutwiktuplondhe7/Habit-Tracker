import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../themes/theme_provider.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Center(
        child: CupertinoSwitch(
          value: Provider.of<ThemePovider>(context).isDarkMode,
          onChanged: (value) =>
              Provider.of<ThemePovider>(context, listen: false).toggleTheme(),
        ),
      ),
    );
  }
}
