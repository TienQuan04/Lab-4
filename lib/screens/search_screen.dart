import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/providers/weather_provider.dart';
import 'package:weather_app/services/storage_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => SearchScreenState();
}
class SearchScreenState extends State<SearchScreen> {
  final TextEditingController controller = TextEditingController();
  final StorageService storageService = StorageService();
  bool isLoading = false;
  List<String> recentCities = [];
  @override
  void initState() {
    super.initState();
    loadRecent();
  }
  Future<void> loadRecent() async {
    final cities = await storageService.getRecentCities();
    setState(() {
      recentCities = cities;
    });
  }
  Future<void> search(String city) async {
    final trimmed = city.trim();
    if (trimmed.isEmpty) return;
    setState(() => isLoading = true);
    try {
      await context.read<WeatherProvider>().fetchWeatherByCity(trimmed);
      await addToRecent(trimmed);

      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }
  Future<void> addToRecent(String city) async {
    city = city.trim();
    if (city.isEmpty) return;

    recentCities.remove(city);
    recentCities.insert(0, city);
    if (recentCities.length > 5) {
      recentCities = recentCities.take(5).toList();
    }

    await storageService.saveRecentCities(recentCities);
    if (mounted) setState(() {});
  }
  Future<void> removeCity(String city) async {
    recentCities.remove(city);
    await storageService.saveRecentCities(recentCities);
    if (mounted) setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search city')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controller,
              textInputAction: TextInputAction.search,
              onSubmitted: search,
              decoration: InputDecoration(
                hintText: 'Nhập tên thành phố (ví dụ: London)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => search(controller.text),
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (isLoading)
              const CircularProgressIndicator()
            else
              const SizedBox.shrink(),
            const SizedBox(height: 16),
            if (recentCities.isNotEmpty) ...[
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Recent searches',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: recentCities
                      .map(
                        (city) => InputChip(
                          label: Text(city),
                          onPressed: () => search(city),
                          onDeleted: () => removeCity(city),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
