import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/providers/settings_provider.dart';

import 'config/api_config.dart';
import 'services/weather_service.dart';
import 'services/location_service.dart';
import 'services/storage_service.dart';
import 'providers/weather_provider.dart';
import 'providers/location_provider.dart';
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';
import 'utils/constants.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final weatherService = WeatherService(apiKey: ApiConfig.apiKey);
    final locationService = LocationService();
    final storageService = StorageService();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(
          create: (_) =>
              WeatherProvider(weatherService, locationService, storageService),
        ),
        ChangeNotifierProvider(
          create: (_) => LocationProvider(locationService),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppConstants.appName,
        theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: const Color(0xFF1A202C),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1A202C),
            elevation: 0,
          ),
        ),
        home: HomeScreen(),
        routes: {SettingsScreen.routeName: (_) => const SettingsScreen()},
      ),
    );
  }
}
