/*
 * $filename
 * com.maddyhome.idea.copyright.pattern.ProjectInfo@2a15d217
 *
 * Developed by $author on 2/11/19 4:36 PM
 * Copyright (c) 2019. Farfetch. All rights reserved.
 */

import 'flutter_panda_platform.dart';

class NativeBundle {
  static Future<String> get bundleID async {
    return await FlutterPandaPlatform.channel.invokeMethod("bundle/id");
  }

  static Future<String> get bundleName async {
    return await FlutterPandaPlatform.channel.invokeMethod("bundle/name");
  }

  static Future<String> get version async {
    return await FlutterPandaPlatform.channel.invokeMethod("bundle/version");
  }

  static Future<String> get build_ver async {
    return await FlutterPandaPlatform.channel.invokeMethod("bundle/build_ver");
  }

  static Future<String> get display_name async {
    return await FlutterPandaPlatform.channel.invokeMethod("bundle/display_name");
  }

  static Future<String> get copyright async {
    return await FlutterPandaPlatform.channel.invokeMethod("bundle/copyright");
  }

  static Future<String> get suite_name async {
    return await FlutterPandaPlatform.channel.invokeMethod("bundle/suite_name");
  }

  static Future<String> get group_name async {
    return await FlutterPandaPlatform.channel.invokeMethod("bundle/group_name");
  }

  static Future<String> get keychain_name async {
    return await FlutterPandaPlatform.channel.invokeMethod("bundle/keychain_name");
  }
}
