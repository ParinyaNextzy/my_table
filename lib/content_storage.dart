import 'dart:math';

import 'package:flutter/material.dart';

class ContentStorage extends ChangeNotifier {
  ContentStorage() {
    addFakeData();
  }

  final List<FakeData> _data = [];
  List<FakeData> get data {
    final List<FakeData> sort = List.from(_data);
    isSortAsc
        ? sort.sort((a, b) => a.campaignName.compareTo(b.campaignName))
        : sort.sort((a, b) => b.campaignName.compareTo(a.campaignName));
    return sort;
  }

  final List<FakeData> _selectedData = [];
  List<FakeData> get selectedData => _selectedData;

  bool _isSortAsc = true;
  bool get isSortAsc => _isSortAsc;

  bool get isSelectedAll => _selectedData.length == _data.length && _selectedData.isNotEmpty;

  void addFakeData([int count = 10]) {
    _data.addAll(List.generate(count, (index) {
      return FakeData(
        campaignName: "Campaign name ${index + 1}",
        createAt: DateTime.now(),
        endAt: DateTime.now(),
        gameName: 'Fortune Wheel',
        gameType: 'Gacha',
        isPublish: Random().nextBool(),
      );
    }));
    notifyListeners();
  }

  void toggleSelected(FakeData data) {
    if (_selectedData.contains(data)) {
      _selectedData.remove(data);
    } else {
      _selectedData.add(data);
    }
    notifyListeners();
  }

  void toggleSelectedAll() {
    if (isSelectedAll) {
      _selectedData.clear();
    } else {
      _selectedData.clear();
      _selectedData.addAll(_data);
    }
    notifyListeners();
  }

  void toggelSort() {
    _isSortAsc = !_isSortAsc;
    notifyListeners();
  }
}

class FakeData {
  FakeData({
    required this.campaignName,
    required this.createAt,
    required this.endAt,
    required this.gameName,
    required this.gameType,
    required this.isPublish,
  });

  final String campaignName;
  final DateTime createAt;
  final DateTime endAt;
  final String gameName;
  final String gameType;
  final bool isPublish;

  @override
  int get hashCode => Object.hashAll([
        campaignName,
        createAt,
        endAt,
        gameName,
        gameType,
        isPublish,
      ]);
}
