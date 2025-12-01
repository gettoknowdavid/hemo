import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hemo/_shared/services/csc/csc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CountriesModal extends WatchingStatefulWidget {
  const CountriesModal._();

  static Future<Country?> show(BuildContext context) {
    return showModalBottomSheet<Country?>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      builder: (context) => const CountriesModal._(),
    );
  }

  @override
  State<CountriesModal> createState() => _CountriesModalState();
}

class _CountriesModalState extends State<CountriesModal> {
  final CscService _cscService = di<CscService>();

  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    di<CscService>().getCountries.run();

    _searchController.addListener(() {
      _cscService.searchCountries.run(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final countries = watchValue((CscService c) => c.filteredCountries);
    final isRunning = watchValue((CscService c) => c.getCountries.isRunning);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16).r,
          child: SearchBar(
            enabled: !isRunning,
            controller: _searchController,
            hintText: 'Search for a country',
          ),
        ),
        8.verticalSpace,
        Expanded(
          child: Skeletonizer(
            enabled: isRunning,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: isRunning ? 3 : countries.length,
              itemBuilder: (context, index) {
                if (isRunning) return ListTile(title: Text(BoneMock.name));

                final country = countries[index];
                return ListTile(
                  title: Text(country.name),
                  onTap: () => context.pop(country),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
