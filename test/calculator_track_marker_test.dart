import 'dart:math';

import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:track_my_indoor_exercise/track/calculator.dart';
import 'package:track_my_indoor_exercise/track/constants.dart';
import 'package:track_my_indoor_exercise/track/tracks.dart';
import 'package:track_my_indoor_exercise/utils/constants.dart';
import 'utils.dart';

void main() {
  const minPixel = 150;
  const maxPixel = 400;

  group('trackMarker start point is invariant', () {
    final rnd = Random();
    for (var lengthFactor in getRandomDoubles(REPETITION, 1.5, rnd)) {
      lengthFactor += 0.7;
      final track = TrackDescriptor(
        radiusBoost: 0.65 + rnd.nextDouble(),
        lengthFactor: lengthFactor,
      );
      final calculator = TrackCalculator(track: track);
      final size = Size(
        minPixel + rnd.nextDouble() * maxPixel,
        minPixel + rnd.nextDouble() * maxPixel,
      );
      calculator.calculateConstantsOnDemand(size);

      test("${track.radiusBoost} $lengthFactor", () async {
        final marker = calculator.trackMarker(0)!;

        expect(
            marker.dx, closeTo(thick + calculator.trackOffset!.dx + calculator.trackRadius!, EPS));
        expect(marker.dy, closeTo(size.height - thick - calculator.trackOffset!.dy, EPS));
      });
    }
  });

  group('trackMarker whole laps are at the start point', () {
    final rnd = Random();
    for (var lengthFactor in getRandomDoubles(REPETITION, 1.5, rnd)) {
      lengthFactor += 0.7;
      final track = TrackDescriptor(
        radiusBoost: 0.65 + rnd.nextDouble(),
        lengthFactor: lengthFactor,
      );
      final calculator = TrackCalculator(track: track);
      final size = Size(
        minPixel + rnd.nextDouble() * maxPixel,
        minPixel + rnd.nextDouble() * maxPixel,
      );
      calculator.calculateConstantsOnDemand(size);

      final laps = rnd.nextInt(100);

      test("${track.radiusBoost} $lengthFactor $laps", () async {
        final marker = calculator.trackMarker(laps * trackLength * lengthFactor)!;

        expect(
            marker.dx, closeTo(thick + calculator.trackOffset!.dx + calculator.trackRadius!, EPS));
        expect(marker.dy, closeTo(size.height - thick - calculator.trackOffset!.dy, EPS));
      });
    }
  });

  group('trackMarkers on the first (bottom) straight are placed proportionally', () {
    final rnd = Random();
    for (var lengthFactor in getRandomDoubles(REPETITION, 1.5, rnd)) {
      lengthFactor += 0.7;
      final track = TrackDescriptor(
        radiusBoost: 0.65 + rnd.nextDouble(),
        lengthFactor: lengthFactor,
      );
      final calculator = TrackCalculator(track: track);
      final size = Size(
        minPixel + rnd.nextDouble() * maxPixel,
        minPixel + rnd.nextDouble() * maxPixel,
      );
      calculator.calculateConstantsOnDemand(size);

      final laps = rnd.nextInt(100);
      final positionRatio = rnd.nextDouble();
      final trackLen = trackLength * lengthFactor;
      final distance = laps * trackLen + positionRatio * track.laneLength;
      final d = distance % trackLen;
      final r = calculator.trackRadius!;
      final displacement = d * r / track.radius;

      test("${track.radiusBoost} $lengthFactor $laps $distance", () async {
        final marker = calculator.trackMarker(distance)!;

        expect(marker.dx, closeTo(thick + calculator.trackOffset!.dx + r + displacement, EPS));
        expect(marker.dy, closeTo(size.height - thick - calculator.trackOffset!.dy, EPS));
      });
    }
  });

  group('trackMarkers on the first (right) chicane are placed as expected', () {
    final rnd = Random();
    for (var lengthFactor in getRandomDoubles(REPETITION, 1.5, rnd)) {
      lengthFactor += 0.7;
      final track = TrackDescriptor(
        radiusBoost: 0.65 + rnd.nextDouble(),
        lengthFactor: lengthFactor,
      );
      final calculator = TrackCalculator(track: track);
      final size = Size(
        minPixel + rnd.nextDouble() * maxPixel,
        minPixel + rnd.nextDouble() * maxPixel,
      );
      calculator.calculateConstantsOnDemand(size);

      final laps = rnd.nextInt(100);
      final positionRatio = rnd.nextDouble();
      final trackLen = trackLength * lengthFactor;
      final distance = laps * trackLen + track.laneLength + positionRatio * track.halfCircle;
      final d = distance % trackLen;
      final rad = (d - track.laneLength) / track.halfCircle * pi;
      final r = calculator.trackRadius!;

      test("${track.radiusBoost} $lengthFactor $laps $distance", () async {
        final marker = calculator.trackMarker(distance)!;

        expect(marker.dx,
            closeTo(size.width - (thick + calculator.trackOffset!.dx + r) + sin(rad) * r, EPS));
        expect(marker.dy, closeTo(r + thick + calculator.trackOffset!.dy + cos(rad) * r, EPS));
      });
    }
  });

  group('trackMarkers on the second (top) straight are placed proportionally', () {
    final rnd = Random();
    for (var lengthFactor in getRandomDoubles(REPETITION, 1.5, rnd)) {
      lengthFactor += 0.7;
      final track = TrackDescriptor(
        radiusBoost: 0.65 + rnd.nextDouble(),
        lengthFactor: lengthFactor,
      );
      final calculator = TrackCalculator(track: track);
      final size = Size(
        minPixel + rnd.nextDouble() * maxPixel,
        minPixel + rnd.nextDouble() * maxPixel,
      );
      calculator.calculateConstantsOnDemand(size);

      final laps = rnd.nextInt(100);
      final positionRatio = rnd.nextDouble();
      final trackLen = trackLength * lengthFactor;
      final distance = (laps + 0.5) * trackLen + positionRatio * track.laneLength;
      final d = distance % trackLen;
      final r = calculator.trackRadius!;
      final displacement = (d - trackLen / 2) * r / track.radius;

      test("${track.radiusBoost} $lengthFactor $laps $distance", () async {
        final marker = calculator.trackMarker(distance)!;

        expect(marker.dx,
            closeTo(size.width - (thick + calculator.trackOffset!.dx + r) - displacement, EPS));
        expect(marker.dy, closeTo(thick + calculator.trackOffset!.dy, EPS));
      });
    }
  });

  group('trackMarkers on the second (left) chicane are placed as expected', () {
    final rnd = Random();
    for (var lengthFactor in getRandomDoubles(REPETITION, 1.5, rnd)) {
      lengthFactor += 0.7;
      final track = TrackDescriptor(
        radiusBoost: 0.65 + rnd.nextDouble(),
        lengthFactor: lengthFactor,
      );
      final calculator = TrackCalculator(track: track);
      final size = Size(
        minPixel + rnd.nextDouble() * maxPixel,
        minPixel + rnd.nextDouble() * maxPixel,
      );
      calculator.calculateConstantsOnDemand(size);

      final laps = rnd.nextInt(100);
      final positionRatio = rnd.nextDouble();
      final trackLen = trackLength * lengthFactor;
      final distance =
          (laps + 0.5) * trackLen + track.laneLength + positionRatio * track.halfCircle;
      final d = distance % trackLen;
      final r = calculator.trackRadius!;
      final rad = (trackLen - d) / track.halfCircle * pi;

      test("${track.radiusBoost} $lengthFactor $laps $distance", () async {
        final marker = calculator.trackMarker(distance)!;

        expect(marker.dx, closeTo((1 - sin(rad)) * r + thick + calculator.trackOffset!.dx, EPS));
        expect(marker.dy, closeTo((cos(rad) + 1) * r + thick + calculator.trackOffset!.dy, EPS));
      });
    }
  });

  group('trackMarker always in bounds', () {
    final rnd = Random();
    for (var lengthFactor in getRandomDoubles(REPETITION, 1.5, rnd)) {
      lengthFactor += 0.7;
      final track = TrackDescriptor(
        radiusBoost: 0.65 + rnd.nextDouble(),
        lengthFactor: lengthFactor,
      );
      final calculator = TrackCalculator(track: track);
      test("${track.radiusBoost} $lengthFactor", () async {
        for (final distance in 1.to((trackLength * 2).round())) {
          final size = Size(
            minPixel + rnd.nextDouble() * maxPixel,
            minPixel + rnd.nextDouble() * maxPixel,
          );
          calculator.calculateConstantsOnDemand(size);

          final marker = calculator.trackMarker(distance.toDouble())!;

          expect(marker.dx, greaterThanOrEqualTo(thick));
          expect(marker.dx, lessThanOrEqualTo(size.width - thick));
          expect(marker.dy, greaterThanOrEqualTo(thick));
          expect(marker.dy, lessThanOrEqualTo(size.height - thick));
        }
      });
    }
  });

  group('trackMarker top continuity', () {
    final rnd = Random();
    for (var lengthFactor in getRandomDoubles(REPETITION, 1.5, rnd)) {
      lengthFactor += 0.7;
      final track = TrackDescriptor(
        radiusBoost: 0.65 + rnd.nextDouble(),
        lengthFactor: lengthFactor,
      );
      final calculator = TrackCalculator(track: track);
      final size = Size(
        minPixel + rnd.nextDouble() * maxPixel,
        minPixel + rnd.nextDouble() * maxPixel,
      );
      calculator.calculateConstantsOnDemand(size);

      final laps = rnd.nextInt(100);
      final trackLen = trackLength * lengthFactor;
      final distance = laps * trackLen + track.laneLength;
      final unitDistance = calculator.trackRadius! / track.radius;
      final uDSquare = unitDistance * unitDistance;
      test("$size ${track.radiusBoost} $lengthFactor ${calculator.trackRadius}", () async {
        final markerA = calculator.trackMarker((distance - 0.5).toDouble())!;
        final markerB = calculator.trackMarker((distance + 0.5).toDouble())!;
        final dx = markerA.dx - markerB.dx;
        final dy = markerA.dy - markerB.dy;

        expect(dx * dx + dy * dy, closeTo(uDSquare, trackLen * DISPLAY_EPS));
      });
    }
  });

  group('trackMarker bottom continuity', () {
    final rnd = Random();
    for (var lengthFactor in getRandomDoubles(REPETITION, 1.5, rnd)) {
      lengthFactor += 0.7;
      final track = TrackDescriptor(
        radiusBoost: 0.65 + rnd.nextDouble(),
        lengthFactor: lengthFactor,
      );
      final calculator = TrackCalculator(track: track);
      final size = Size(
        minPixel + rnd.nextDouble() * maxPixel,
        minPixel + rnd.nextDouble() * maxPixel,
      );
      calculator.calculateConstantsOnDemand(size);

      final laps = rnd.nextInt(100);
      final trackLen = trackLength * lengthFactor;
      final distance = (laps + 0.5) * trackLen + track.laneLength;
      final unitDistance = calculator.trackRadius! / track.radius;
      final uDSquare = unitDistance * unitDistance;
      test("$size ${track.radiusBoost} $lengthFactor ${calculator.trackRadius}", () async {
        final markerA = calculator.trackMarker((distance - 0.5).toDouble())!;
        final markerB = calculator.trackMarker((distance + 0.5).toDouble())!;
        final dx = markerA.dx - markerB.dx;
        final dy = markerA.dy - markerB.dy;

        expect(dx * dx + dy * dy, closeTo(uDSquare, trackLen * DISPLAY_EPS));
      });
    }
  });

  group('trackMarker continuity straight vs chicane', () {
    final rnd = Random();
    for (var lengthFactor in getRandomDoubles(REPETITION, 1.5, rnd)) {
      lengthFactor += 0.7;
      final track = TrackDescriptor(
        radiusBoost: 0.65 + rnd.nextDouble(),
        lengthFactor: lengthFactor,
      );
      final calculator = TrackCalculator(track: track);
      final size = Size(
        minPixel + rnd.nextDouble() * maxPixel,
        minPixel + rnd.nextDouble() * maxPixel,
      );
      calculator.calculateConstantsOnDemand(size);

      test("$size ${track.radiusBoost} $lengthFactor ${calculator.trackRadius}", () async {
        final straightMarkerA = calculator.trackMarker((track.laneHalf - 0.1).toDouble())!;
        final straightMarkerB = calculator.trackMarker((track.laneHalf + 0.1).toDouble())!;
        final sdx = (straightMarkerA.dx - straightMarkerB.dx).abs();
        final sdy = straightMarkerA.dy - straightMarkerB.dy;
        expect(sdy, closeTo(0.0, DISPLAY_EPS));

        final chicaneMarkerA =
            calculator.trackMarker((track.laneLength + track.halfCircle / 2 - 0.1).toDouble())!;
        final chicaneMarkerB =
            calculator.trackMarker((track.laneLength + track.halfCircle / 2 + 0.1).toDouble())!;
        final cdx = chicaneMarkerA.dx - chicaneMarkerB.dx;
        final cdy = (chicaneMarkerA.dy - chicaneMarkerB.dy).abs();

        expect(cdx, closeTo(0.0, DISPLAY_EPS));
        expect(sdx, closeTo(cdy, DISPLAY_EPS));
      });
    }
  });

  group('trackMarker general continuity', () {
    final rnd = Random();
    for (var lengthFactor in getRandomDoubles(REPETITION, 1.5, rnd)) {
      lengthFactor += 0.7;
      final track = TrackDescriptor(
        radiusBoost: 0.65 + rnd.nextDouble(),
        lengthFactor: lengthFactor,
      );
      final calculator = TrackCalculator(track: track);
      final size = Size(
        minPixel + rnd.nextDouble() * maxPixel,
        minPixel + rnd.nextDouble() * maxPixel,
      );
      calculator.calculateConstantsOnDemand(size);

      final unitDistance = calculator.trackRadius! / track.radius;
      final uDSquare = unitDistance * unitDistance;
      test("$size ${track.radiusBoost} $lengthFactor ${calculator.trackRadius}", () async {
        for (final distance in 1.to((trackLength * 2).round())) {
          final markerA = calculator.trackMarker(distance.toDouble())!;
          final markerB = calculator.trackMarker((distance + 1).toDouble())!;
          final dx = markerA.dx - markerB.dx;
          final dy = markerA.dy - markerB.dy;

          expect(dx * dx + dy * dy, closeTo(uDSquare, trackLength * DISPLAY_EPS));
        }
      });
    }
  });
}
