import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:track_my_indoor_exercise/devices/gadgets/heart_rate_monitor.dart';
import 'package:track_my_indoor_exercise/devices/gatt_constants.dart';
import 'package:track_my_indoor_exercise/utils/constants.dart';
import 'infer_sport_from_characteristics_id_test.mocks.dart';

import 'utils.dart';

class TestPair {
  final String characteristicsId;
  final String? sport;

  TestPair({required this.characteristicsId, required this.sport});
}

@GenerateMocks([BluetoothDevice])
void main() {
  group('DeviceBase infers sport as expected from characteristics ID', () {
    [
      TestPair(characteristicsId: TREADMILL_ID, sport: ActivityType.Run),
      TestPair(characteristicsId: PRECOR_MEASUREMENT_ID, sport: ActivityType.Ride),
      TestPair(characteristicsId: INDOOR_BIKE_ID, sport: ActivityType.Ride),
      TestPair(characteristicsId: ROWER_DEVICE_ID, sport: ActivityType.Rowing),
      TestPair(characteristicsId: HEART_RATE_MEASUREMENT_ID, sport: null)
    ].forEach((testPair) {
      test("${testPair.characteristicsId} -> ${testPair.sport}", () async {
        await initPrefServiceForTest();
        final hrm = HeartRateMonitor(MockBluetoothDevice());
        hrm.characteristicsId = testPair.characteristicsId;

        expect(hrm.inferSportFromCharacteristicsId(), testPair.sport);
      });
    });
  });
}