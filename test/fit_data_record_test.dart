import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:track_my_indoor_exercise/export/export_record.dart';
import 'package:track_my_indoor_exercise/export/fit/definitions/fit_data_record.dart';
import 'package:track_my_indoor_exercise/export/fit/fit_message.dart';
import 'package:track_my_indoor_exercise/export/fit/fit_serializable.dart';
import 'package:track_my_indoor_exercise/persistence/preferences.dart';

void main() {
  test('FitDataRecord has the expected global message number', () async {
    final dataRecord = FitDataRecord(
      0,
      HEART_RATE_GAP_WORKAROUND_DEFAULT,
      HEART_RATE_UPPER_LIMIT_DEFAULT_INT,
      HEART_RATE_LIMITING_NO_LIMIT,
    );

    expect(dataRecord.globalMessageNumber, FitMessage.Record);
  });

  test('FitDataRecord data has the expected length', () async {
    final rng = Random();
    final dataRecord = FitDataRecord(
      0,
      HEART_RATE_GAP_WORKAROUND_DEFAULT,
      HEART_RATE_UPPER_LIMIT_DEFAULT_INT,
      HEART_RATE_LIMITING_NO_LIMIT,
    );
    final now = DateTime.now();
    final exportRecord = ExportRecord()
      ..timeStampInteger = FitSerializable.fitDateTime(now)
      ..date = now
      ..latitude = rng.nextDouble()
      ..longitude = rng.nextDouble()
      ..cadence = 0
      ..distance = 0.0
      ..speed = 0.0
      ..power = 0.0;

    final output = dataRecord.serializeData(exportRecord);
    final expected = dataRecord.fields.fold(0, (accu, field) => accu + field.size);

    expect(output.length, expected + 1);
  });
}