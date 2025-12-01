import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hemo/_shared/services/csc/csc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CitiesModal extends WatchingStatefulWidget {
  const CitiesModal._(this.params);

  static Future<City?> show(BuildContext context, (int, int) params) {
    return showModalBottomSheet<City?>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      builder: (_) => CitiesModal._(params),
    );
  }

  final (int, int) params;

  @override
  State<CitiesModal> createState() => _CitiesModalState();
}

class _CitiesModalState extends State<CitiesModal> {
  final CscService _cscService = di<CscService>();

  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cscService.getCities.run(widget.params);
    _searchController.addListener(() {
      _cscService.searchCities.run(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cities = watchValue((CscService c) => c.filteredCitiesInState);
    final isRunning = watchValue((CscService c) => c.getCities.isRunning);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16).r,
          child: SearchBar(
            enabled: !isRunning,
            controller: _searchController,
            hintText: 'Search for a city',
          ),
        ),
        8.verticalSpace,
        Expanded(
          child: Skeletonizer(
            enabled: isRunning,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: isRunning ? 3 : cities.length,
              itemBuilder: (context, index) {
                if (isRunning) return ListTile(title: Text(BoneMock.name));

                final city = cities[index];
                return ListTile(
                  title: Text(city.name),
                  onTap: () => context.pop(city),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
