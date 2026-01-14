import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rentease/app/app.dart';
import 'package:rentease/core/services/hive/hive_service.dart';
import 'package:rentease/core/services/storage/user_session_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Set system UI overlay Style
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  await HiveService().init();

  //shared preference ko object eta banauni kinani
  //shared preference chai async ho tara provider chai sync

  // shared pref
  final sharedPrefs = await SharedPreferences.getInstance();

  runApp( ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(sharedPrefs)
    ],
    child: App()));
}
