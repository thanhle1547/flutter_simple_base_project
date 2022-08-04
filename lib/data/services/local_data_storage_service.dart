import 'dart:convert' show JsonCodec;

import 'package:flutter_simple_base_project/core/constants/app_constants.dart';
import 'package:sp_util/sp_util.dart';

const _jsonCodec = JsonCodec();

Map<String, dynamic> _decodeStringData(String data) =>
    _jsonCodec.decode(data)['data'];

List _getListDataFromMap(
  Map<String, dynamic> mapData,
) =>
    mapData['data'];

const String _cityKey = 'city';
const String _lastTimeFetchCityDataKey = 'last_time_fetch_city_data';

class LocalDataStorageService {
  bool _hasExpired(String? lastTime) {
    if (lastTime != null) {
      if (lastTime.isEmpty) return true;

      DateTime? lastFetchDate = DateTime.tryParse(lastTime);
      if (lastFetchDate == null ||
          DateTime.now()
              .add(AppConst.timesToFetchCommonDataAgain)
              .isBefore(lastFetchDate)) return true;
    }

    return false;
  }

  /// --------------------------------------------------------------------------
  ///                                 City
  /// --------------------------------------------------------------------------

  bool containsCityData() =>
      !_hasExpired(SpUtil.getString(_lastTimeFetchCityDataKey));

  /// return List<Map<String, dynamic>>
  List getListCityData() =>
      _getListDataFromMap(_decodeStringData(SpUtil.getString(_cityKey)!));

  void saveCityResponeData(String response) {
    SpUtil.putString(_cityKey, response);
    SpUtil.putString(_lastTimeFetchCityDataKey, DateTime.now().toString());
  }
}
