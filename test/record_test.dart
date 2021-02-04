import 'package:flutter_test/flutter_test.dart';
import 'package:mock_data/mock_data.dart';
import 'package:mockito/mockito.dart';
import '../lib/persistence/models/record.dart';
import '../lib/persistence/preferences.dart';
import '../lib/tcx/activity_type.dart';

class MockRecord extends Mock implements Record {}

extension RangeExtension on int {
  List<int> to(int maxInclusive, {int step = 1}) =>
      [for (int i = this; i <= maxInclusive; i += step) i];
}

void main() {
  group("hydrate should initialize dt based on timeStamp:", () {
    1.to(10).forEach((input) {
      final randomDateTime = mockDate();
      test("$input -> $randomDateTime", () {
        var record = Record(timeStamp: randomDateTime.millisecondsSinceEpoch);
        record.hydrate();
        expect(record.dt, randomDateTime);
      });
    });

    test('no hydrate leaves dt as null', () async {
      final record = Record();
      expect(record.dt, null);
    });
  });

  final speeds = [
    0.0,
    1.0,
    2.0,
    5.0,
    10.0,
    12.0,
    15.0,
    20.0,
  ];
  group("speedByUnit for metric system and riding:", () {
    final sports = [ActivityType.Ride, ActivityType.VirtualRide];
    speeds.forEach((speed) {
      sports.forEach((sport) {
        final expected = speed;
        test("$speed -> $expected", () {
          final record = Record(speed: speed);
          expect(record.speedByUnit(true, sport), expected);
        });
      });
    });
  });

  group("speedByUnit for imperial system and riding:", () {
    final sports = [ActivityType.Ride, ActivityType.VirtualRide];
    speeds.forEach((speed) {
      sports.forEach((sport) {
        final expected = speed * KM2MI;
        test("$speed -> $expected", () {
          final record = Record(speed: speed);
          expect(record.speedByUnit(false, sport), expected);
        });
      });
    });
  });

  group("speedByUnit for metric system and running:", () {
    final sports = [ActivityType.Run, ActivityType.VirtualRun];
    speeds.forEach((speed) {
      sports.forEach((sport) {
        final expected = speed.abs() < 10e-4 ? 0 : 60 / speed;
        test("$speed -> $expected", () {
          final record = Record(speed: speed);
          expect(record.speedByUnit(true, sport), expected);
        });
      });
    });
  });

  group("speedByUnit for imperial system and running:", () {
    final sports = [ActivityType.Run, ActivityType.VirtualRun];
    speeds.forEach((speed) {
      sports.forEach((sport) {
        final expected = speed.abs() < 10e-4 ? 0 : 60 / speed / KM2MI;
        test("$speed -> $expected", () {
          final record = Record(speed: speed);
          expect(record.speedByUnit(false, sport), expected);
        });
      });
    });
  });

  group("speedByUnit for water sports:", () {
    final sports = [
      ActivityType.Kayaking,
      ActivityType.Canoeing,
      ActivityType.Rowing
    ];
    speeds.forEach((speed) {
      sports.forEach((sport) {
        final expected = speed.abs() < 10e-4 ? 0 : 30 / speed;
        test("$speed -> $expected", () {
          final record = Record(speed: speed);
          // There's no imperial for water sports, it's always 500m
          expect(record.speedByUnit(false, sport), expected);
          expect(record.speedByUnit(true, sport), expected);
        });
      });
    });
  });

  group("speedByUnit for elliptical sports:", () {
    speeds.forEach((speed) {
      test("$speed", () {
        final record = Record(speed: speed);
        // There's no imperial for water sports, it's always 500m
        expect(record.speedByUnit(false, ActivityType.Elliptical), speed);
        expect(record.speedByUnit(true, ActivityType.Elliptical), speed);
      });
    });
  });
}
