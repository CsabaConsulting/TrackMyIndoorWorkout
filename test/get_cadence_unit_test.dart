import 'package:flutter_test/flutter_test.dart';
import 'package:track_my_indoor_exercise/tcx/activity_type.dart';
import 'package:track_my_indoor_exercise/utils/display.dart';
import 'utils.dart';

void main() {
  group("getCadenceUnit is rpm for Running and Riding, spm for everything else ", () {
    SPORTS.forEach((sport) {
      final expected = (sport == ActivityType.Kayaking ||
              sport == ActivityType.Canoeing ||
              sport == ActivityType.Rowing ||
              sport == ActivityType.Swim)
          ? "spm"
          : "rpm";
      test("$sport -> $expected", () {
        expect(getCadenceUnit(sport), expected);
      });
    });
  });
}