import 'package:flutter/material.dart';

import '../../../../core/extensions/localization_extension.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.homeTitle)),
      body: Center(child: Text(context.l10n.homeWelcome)),
    );
  }
}
