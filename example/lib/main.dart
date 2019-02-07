import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_panda_platform/flutter_panda_platform.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _bundleId;
  String _bundleName;
  String _bundleVersion;
  String _buildVersion;
  String _displayName;
  String _copyright;
  String _suite_name;
  String _group_name;
  String _keychain_name;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String bundleId = await NativeBundle.bundleID;
    String bundleName = await NativeBundle.bundleName;
    String bundleVersion = await NativeBundle.version;
    String buildVersion = await NativeBundle.build_ver;
    String displayName = await NativeBundle.display_name;
    String copyright = await NativeBundle.copyright;
    String suite_name = await NativeBundle.suite_name;
    String group_name = await NativeBundle.group_name;
    String keychain_name = await NativeBundle.keychain_name;

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _bundleId = bundleId;
      _bundleName = bundleName;
      _bundleVersion = bundleVersion;
      _buildVersion = buildVersion;
      _displayName = displayName;
      _copyright = copyright;
      _suite_name = suite_name;
      _group_name = group_name;
      _keychain_name = keychain_name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('ID: ${_bundleId}'),
              Text('Name: ${_bundleName}'),
              Text('Version: ${_bundleVersion}.${_buildVersion}'),
              Text("DisplayName: ${_displayName}"),
              Text("Copyrigh: ${_copyright}"),
              Text("Suite Name: ${_suite_name}"),
              Text("Group Name: ${_group_name}"),
              Text("KeyChain Name: ${_keychain_name}"),
            ],
          ),
        ),
      ),
    );
  }
}
