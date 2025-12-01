import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hemo/_shared/services/csc/csc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class StatesModal extends WatchingStatefulWidget {
  const StatesModal._(this.countryId);

  static Future<Province?> show(BuildContext context, int countryId) {
    return showModalBottomSheet<Province?>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      builder: (context) => StatesModal._(countryId),
    );
  }

  final int countryId;

  @override
  State<StatesModal> createState() => _StatesModalState();
}

class _StatesModalState extends State<StatesModal> {
  final CscService _cscService = di<CscService>();

  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cscService.getStates.run(widget.countryId);
    _searchController.addListener(() {
      _cscService.searchStates.run(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final states = watchValue((CscService c) => c.filteredStatesInCountry);
    final isRunning = watchValue((CscService c) => c.getStates.isRunning);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16).r,
          child: SearchBar(
            enabled: !isRunning,
            controller: _searchController,
            hintText: 'Search for a state',
          ),
        ),
        8.verticalSpace,
        Expanded(
          child: Skeletonizer(
            enabled: isRunning,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: isRunning ? 3 : states.length,
              itemBuilder: (context, index) {
                if (isRunning) return ListTile(title: Text(BoneMock.name));

                final state = states[index];
                return ListTile(
                  title: Text(state.name),
                  onTap: () => context.pop(state),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
