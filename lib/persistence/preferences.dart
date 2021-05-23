import 'dart:io';
import 'dart:math';

import 'package:charts_common/common.dart' as common;
import 'package:charts_flutter/flutter.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart' as painting;
import 'package:preferences/preferences.dart';
import '../utils/constants.dart';
import '../utils/display.dart';

Color getTranslucent(Color c) {
  return Color(r: c.r, g: c.g, b: c.b, a: 120, darker: c.darker, lighter: c.lighter);
}

final sevenLightBgPalette = [
  getTranslucent(MaterialPalette.blue.shadeDefault.lighter),
  getTranslucent(MaterialPalette.teal.shadeDefault.lighter),
  getTranslucent(MaterialPalette.cyan.shadeDefault.lighter),
  getTranslucent(MaterialPalette.lime.shadeDefault.lighter),
  getTranslucent(MaterialPalette.yellow.shadeDefault.lighter),
  getTranslucent(MaterialPalette.red.shadeDefault.lighter),
  getTranslucent(MaterialPalette.pink.shadeDefault.lighter),
];

final sevenDarkBgPalette = [
  getTranslucent(MaterialPalette.indigo.shadeDefault.darker),
  getTranslucent(MaterialPalette.teal.shadeDefault.darker),
  getTranslucent(MaterialPalette.cyan.shadeDefault.darker),
  getTranslucent(MaterialPalette.green.shadeDefault.darker),
  getTranslucent(MaterialPalette.deepOrange.shadeDefault.darker),
  getTranslucent(MaterialPalette.red.shadeDefault.darker),
  getTranslucent(MaterialPalette.purple.shadeDefault.darker),
];

final sevenLightFgPalette = [
  MaterialPalette.indigo.shadeDefault.darker,
  MaterialPalette.teal.shadeDefault.darker,
  MaterialPalette.cyan.shadeDefault.darker,
  MaterialPalette.green.shadeDefault.darker,
  MaterialPalette.deepOrange.shadeDefault.darker,
  MaterialPalette.red.shadeDefault.darker,
  MaterialPalette.purple.shadeDefault.darker,
];

final sevenDarkFgPalette = [
  MaterialPalette.blue.shadeDefault.lighter,
  MaterialPalette.teal.shadeDefault.lighter,
  MaterialPalette.cyan.shadeDefault.lighter,
  MaterialPalette.lime.shadeDefault.lighter,
  MaterialPalette.yellow.shadeDefault.lighter,
  MaterialPalette.red.shadeDefault.lighter,
  MaterialPalette.pink.shadeDefault.lighter,
];

final fiveLightBgPalette = [
  getTranslucent(MaterialPalette.blue.shadeDefault.lighter),
  getTranslucent(MaterialPalette.cyan.shadeDefault.lighter),
  getTranslucent(MaterialPalette.lime.shadeDefault.lighter),
  getTranslucent(MaterialPalette.yellow.shadeDefault.lighter),
  getTranslucent(MaterialPalette.red.shadeDefault.lighter),
];

final fiveDarkBgPalette = [
  getTranslucent(MaterialPalette.indigo.shadeDefault.darker),
  getTranslucent(MaterialPalette.teal.shadeDefault.darker),
  getTranslucent(MaterialPalette.green.shadeDefault.darker),
  getTranslucent(MaterialPalette.deepOrange.shadeDefault.darker),
  getTranslucent(MaterialPalette.red.shadeDefault.darker),
];

final fiveLightFgPalette = [
  MaterialPalette.indigo.shadeDefault.darker,
  MaterialPalette.teal.shadeDefault.darker,
  MaterialPalette.green.shadeDefault.darker,
  MaterialPalette.deepOrange.shadeDefault.darker,
  MaterialPalette.red.shadeDefault.darker,
];

final fiveDarkFgPalette = [
  MaterialPalette.blue.shadeDefault.lighter,
  MaterialPalette.cyan.shadeDefault.lighter,
  MaterialPalette.lime.shadeDefault.lighter,
  MaterialPalette.yellow.shadeDefault.lighter,
  MaterialPalette.red.shadeDefault.lighter,
];

final sevenLightPiePalette = [
  MaterialPalette.blue.shadeDefault,
  MaterialPalette.teal.shadeDefault,
  MaterialPalette.cyan.shadeDefault,
  MaterialPalette.lime.shadeDefault,
  MaterialPalette.yellow.shadeDefault,
  MaterialPalette.red.shadeDefault,
  MaterialPalette.pink.shadeDefault,
];

final fiveLightPiePalette = [
  MaterialPalette.blue.shadeDefault,
  MaterialPalette.cyan.shadeDefault,
  MaterialPalette.lime.shadeDefault,
  MaterialPalette.yellow.shadeDefault,
  MaterialPalette.red.shadeDefault,
];

final sevenDarkPiePalette = [
  MaterialPalette.indigo.shadeDefault,
  MaterialPalette.teal.shadeDefault,
  MaterialPalette.cyan.shadeDefault,
  MaterialPalette.green.shadeDefault,
  MaterialPalette.deepOrange.shadeDefault,
  MaterialPalette.red.shadeDefault,
  MaterialPalette.purple.shadeDefault,
];

final fiveDarkPiePalette = [
  MaterialPalette.indigo.shadeDefault,
  MaterialPalette.teal.shadeDefault,
  MaterialPalette.green.shadeDefault,
  MaterialPalette.deepOrange.shadeDefault,
  MaterialPalette.red.shadeDefault,
];

// https://stackoverflow.com/questions/57481767/dart-rounding-errors
double decimalRound(double value, {int precision = 100}) {
  return (value * precision).round() / precision;
}

class PreferencesSpec {
  static const THRESHOLD_CAPITAL = ' Threshold ';
  static const ZONES_CAPITAL = ' Zones (list of % of threshold)';
  static const PADDLE_SPORT = "Paddle";
  static const SPORT_PREFIXES = [
    ActivityType.Ride,
    ActivityType.Run,
    PADDLE_SPORT,
    ActivityType.Swim
  ];
  static const THRESHOLD_PREFIX = 'threshold_';
  static const ZONES_POSTFIX = '_zones';
  static const METRICS = ['power', 'speed', 'cadence', 'hr'];
  static const ZONE_INDEX_DISPLAY_TAG_POSTFIX = "zone_index_display";
  static const ZONE_INDEX_DISPLAY_TEXT = "Zone Index Display";
  static const ZONE_INDEX_DISPLAY_DESCRIPTION_PART1 = "Display the Zone Index Next to the ";
  static const ZONE_INDEX_DISPLAY_DESCRIPTION_PART2 = " Measurement Value";
  static const ZONE_INDEX_DISPLAY_DEFAULT = false;

  static final slowSpeeds = {
    ActivityType.Ride: 5.0,
    ActivityType.Run: 3.0,
    PADDLE_SPORT: 2.0,
    ActivityType.Swim: 1.0,
  };

  static final _preferencesSpecsTemplate = [
    PreferencesSpec(
      metric: METRICS[0],
      title: 'Power',
      unit: 'W',
      thresholdTagPostfix: THRESHOLD_PREFIX + METRICS[0],
      thresholdDefaultInts: {
        SPORT_PREFIXES[0]: 360,
        SPORT_PREFIXES[1]: 360,
        SPORT_PREFIXES[2]: 120,
        SPORT_PREFIXES[3]: 120,
      },
      zonesTagPostfix: METRICS[0] + ZONES_POSTFIX,
      zonesDefaultInts: {
        SPORT_PREFIXES[0]: [55, 75, 90, 105, 120, 150],
        SPORT_PREFIXES[1]: [55, 75, 90, 105, 120, 150],
        SPORT_PREFIXES[2]: [55, 75, 90, 105, 120, 150],
        SPORT_PREFIXES[3]: [55, 75, 90, 105, 120, 150],
      },
      icon: Icons.bolt,
      indexDisplayDefault: false,
    ),
    PreferencesSpec(
      metric: METRICS[1],
      title: 'Speed',
      unit: 'mph',
      thresholdTagPostfix: THRESHOLD_PREFIX + METRICS[1],
      thresholdDefaultInts: {
        SPORT_PREFIXES[0]: 32,
        SPORT_PREFIXES[1]: 16,
        SPORT_PREFIXES[2]: 7,
        SPORT_PREFIXES[3]: 1,
      },
      zonesTagPostfix: METRICS[1] + ZONES_POSTFIX,
      zonesDefaultInts: {
        SPORT_PREFIXES[0]: [55, 75, 90, 105, 120, 150],
        SPORT_PREFIXES[1]: [55, 75, 90, 105, 120, 150],
        SPORT_PREFIXES[2]: [55, 75, 90, 105, 120, 150],
        SPORT_PREFIXES[3]: [55, 75, 90, 105, 120, 150],
      },
      icon: Icons.speed,
      indexDisplayDefault: false,
    ),
    PreferencesSpec(
      metric: METRICS[2],
      title: 'Cadence',
      unit: 'rpm',
      thresholdTagPostfix: THRESHOLD_PREFIX + METRICS[2],
      thresholdDefaultInts: {
        SPORT_PREFIXES[0]: 120,
        SPORT_PREFIXES[1]: 180,
        SPORT_PREFIXES[2]: 90,
        SPORT_PREFIXES[3]: 90,
      },
      zonesTagPostfix: METRICS[2] + ZONES_POSTFIX,
      zonesDefaultInts: {
        SPORT_PREFIXES[0]: [25, 37, 50, 75, 100, 120],
        SPORT_PREFIXES[1]: [25, 37, 50, 75, 100, 120],
        SPORT_PREFIXES[2]: [25, 37, 50, 75, 100, 120],
        SPORT_PREFIXES[3]: [25, 37, 50, 75, 100, 120],
      },
      icon: Icons.directions_bike,
      indexDisplayDefault: false,
    ),
    PreferencesSpec(
      metric: METRICS[3],
      title: 'Heart Rate',
      unit: 'bpm',
      thresholdTagPostfix: THRESHOLD_PREFIX + METRICS[3],
      thresholdDefaultInts: {
        SPORT_PREFIXES[0]: 180,
        SPORT_PREFIXES[1]: 180,
        SPORT_PREFIXES[2]: 180,
        SPORT_PREFIXES[3]: 180,
      },
      zonesTagPostfix: METRICS[3] + ZONES_POSTFIX,
      zonesDefaultInts: {
        SPORT_PREFIXES[0]: [50, 60, 70, 80, 90, 100],
        SPORT_PREFIXES[1]: [50, 60, 70, 80, 90, 100],
        SPORT_PREFIXES[2]: [50, 60, 70, 80, 90, 100],
        SPORT_PREFIXES[3]: [50, 60, 70, 80, 90, 100],
      },
      icon: Icons.favorite,
      indexDisplayDefault: false,
    ),
  ].toList(growable: false);

  final String metric;
  String title;
  String unit;
  String multiLineUnit;
  final String thresholdTagPostfix;
  final Map<String, int> thresholdDefaultInts;
  final String zonesTagPostfix;
  final Map<String, List<int>> zonesDefaultInts;
  final bool indexDisplayDefault;
  bool indexDisplay;
  double threshold;
  List<int> zonePercents;
  List<double> zoneBounds;
  List<double> zoneLower;
  List<double> zoneUpper;
  IconData icon;
  bool si;
  String sport;
  bool flipZones;

  List<common.AnnotationSegment> annotationSegments;

  PreferencesSpec({
    @required this.metric,
    @required this.title,
    @required this.unit,
    @required this.thresholdTagPostfix,
    @required this.thresholdDefaultInts,
    @required this.zonesTagPostfix,
    @required this.zonesDefaultInts,
    @required this.indexDisplayDefault,
    @required this.icon,
  })  : assert(metric != null),
        assert(title != null),
        assert(unit != null),
        assert(thresholdTagPostfix != null),
        assert(thresholdDefaultInts != null),
        assert(zonesTagPostfix != null),
        assert(zonesDefaultInts != null),
        assert(indexDisplayDefault != null),
        assert(icon != null) {
    flipZones = false;
    updateMultiLineUnit();
    annotationSegments = [];
    indexDisplay = indexDisplayDefault;
  }

  String get fullTitle => '$title ($unit)';
  String get kmhTitle => '$title (kmh)';
  String get histogramTitle => '$title zones (%)';

  String get zoneIndexText => '$title $ZONE_INDEX_DISPLAY_TEXT';
  String get zoneIndexTag => metric + '_$ZONE_INDEX_DISPLAY_TAG_POSTFIX';
  String get zoneIndexDescription =>
      '$ZONE_INDEX_DISPLAY_DESCRIPTION_PART1 $title $ZONE_INDEX_DISPLAY_DESCRIPTION_PART2';

  static String sport2Sport(String sport) {
    return sport == ActivityType.Kayaking ||
            sport == ActivityType.Canoeing ||
            sport == ActivityType.Rowing
        ? PADDLE_SPORT
        : sport;
  }

  String thresholdDefault(String sport) {
    return thresholdDefaultInts[sport2Sport(sport)].toString();
  }

  String zonesDefault(String sport) {
    return zonesDefaultInts[sport2Sport(sport)].map((z) => z.toString()).join(",");
  }

  String thresholdTag(String sport) {
    return sport2Sport(sport) + "_" + thresholdTagPostfix;
  }

  String zonesTag(String sport) {
    return sport2Sport(sport) + "_" + zonesTagPostfix;
  }

  static String slowSpeedTag(String sport) {
    return SLOW_SPEED_TAG_PREFIX + sport2Sport(sport);
  }

  void updateMultiLineUnit() {
    multiLineUnit = unit.replaceAll(" ", "\n");
  }

  void updateUnit(String newUnit) {
    unit = newUnit;
    updateMultiLineUnit();
  }

  void calculateZones(bool si, String sport) {
    this.si = si;
    this.sport = sport;
    flipZones = sport != ActivityType.Ride && metric == "speed";
    final thresholdString = PrefService.getString(thresholdTag(sport));
    threshold = double.tryParse(thresholdString);
    if (metric == "speed") {
      threshold = speedOrPace(threshold, si, sport);
    }

    final zonesSpecStr = PrefService.getString(zonesTag(sport));
    zonePercents = zonesSpecStr.split(',').map((zs) => int.tryParse(zs)).toList(growable: false);
    zoneBounds =
        zonePercents.map((z) => decimalRound(z / 100.0 * threshold)).toList(growable: false);
    if (flipZones) {
      zoneBounds = zoneBounds.reversed.toList(growable: false);
    }
    indexDisplay = PrefService.getBool(zoneIndexTag) ?? indexDisplayDefault;
  }

  void calculateBounds(double minVal, double maxVal, bool isLight) {
    zoneLower = [...zoneBounds];
    zoneUpper = [...zoneBounds];

    final zoneMin = flipZones ? zoneUpper.last : zoneLower[0];
    if (minVal < 0 || minVal > 0 && minVal > zoneMin) {
      minVal = zoneMin * 0.7;
    }

    final zoneMax = flipZones ? zoneLower[0] : zoneUpper.last;
    if (maxVal < 0 || maxVal > 0 && maxVal < zoneMax) {
      maxVal = zoneMax * 1.2;
    }

    if (flipZones) {
      zoneLower.insert(0, decimalRound(maxVal));
      zoneUpper.add(decimalRound(minVal));
    } else {
      zoneLower.insert(0, decimalRound(minVal));
      zoneUpper.add(decimalRound(maxVal));
    }

    final textColor = isLight ? MaterialPalette.black : MaterialPalette.white;
    final chartTextStyle = TextStyleSpec(color: textColor);
    List<common.AnnotationSegment> segments = [];
    segments.addAll(List.generate(
      binCount,
      (i) => RangeAnnotationSegment(
        zoneLower[i],
        zoneUpper[i],
        RangeAnnotationAxisType.measure,
        color: bgColorByBin(i, isLight),
        startLabel: zoneLower[i].toString(),
        labelAnchor: AnnotationLabelAnchor.start,
        labelStyleSpec: chartTextStyle,
      ),
    ));
    segments.addAll(List.generate(
      binCount,
      (i) => LineAnnotationSegment(
        zoneUpper[i],
        RangeAnnotationAxisType.measure,
        startLabel: zoneUpper[i].toString(),
        labelAnchor: AnnotationLabelAnchor.end,
        strokeWidthPx: 1.0,
        color: textColor,
        labelStyleSpec: chartTextStyle,
      ),
    ));
    annotationSegments = segments.toList(growable: false);
  }

  int get binCount => zonePercents.length + 1;

  int transformedBinIndex(int bin) {
    bin = min(max(0, bin), zonePercents.length - 1);
    return flipZones ? zonePercents.length - 1 - bin : bin;
  }

  int binIndex(num value) {
    int i = 0;
    for (; i < zoneBounds.length; i++) {
      if (value < zoneBounds[i]) {
        return i;
      }
    }

    return i;
  }

  Color bgColorByBin(int bin, bool isLight) {
    if (zonePercents.length <= 5) {
      bin = min(bin, 4);
      return isLight ? fiveLightBgPalette[bin] : fiveDarkBgPalette[bin];
    }

    bin = min(bin, 6);
    return isLight ? sevenLightBgPalette[bin] : sevenDarkBgPalette[bin];
  }

  Color fgColorByBin(int bin, bool isLight) {
    if (zonePercents.length <= 5) {
      bin = min(bin, 4);
      final trIndex = transformedBinIndex(bin);
      return isLight ? fiveLightFgPalette[trIndex] : fiveDarkFgPalette[trIndex];
    }

    bin = min(bin, 6);
    final trIndex = transformedBinIndex(bin);
    return isLight ? sevenLightFgPalette[trIndex] : sevenDarkFgPalette[trIndex];
  }

  Color fgColorByValue(num value, bool isLight) {
    final bin = binIndex(value);
    return fgColorByBin(bin, isLight);
  }

  Color pieBgColorByBin(int bin, bool isLight) {
    if (zonePercents.length <= 5) {
      bin = min(bin, 4);
      final trIndex = transformedBinIndex(bin);
      return isLight ? fiveLightPiePalette[trIndex] : fiveDarkPiePalette[trIndex];
    }

    bin = min(bin, 6);
    final trIndex = transformedBinIndex(bin);
    return isLight ? sevenLightPiePalette[trIndex] : sevenDarkPiePalette[trIndex];
  }

  static List<PreferencesSpec> get preferencesSpecs => _preferencesSpecsTemplate;

  static List<PreferencesSpec> getPreferencesSpecs(bool si, String sport) {
    var prefSpecs = [...preferencesSpecs];
    prefSpecs[1].updateUnit(getSpeedUnit(si, sport));
    prefSpecs[1].title = speedTitle(sport);
    prefSpecs[2].icon = getIcon(sport);
    prefSpecs[2].unit = getCadenceUnit(sport);
    prefSpecs.forEach((prefSpec) => prefSpec.calculateZones(si, sport));
    return prefSpecs;
  }
}

const PREFERENCES_VERSION_TAG = "version";
const PREFERENCES_VERSION_DEFAULT = 1;
const PREFERENCES_VERSION_SPORT_THRESHOLDS = 1;
const PREFERENCES_VERSION_EQUIPMENT_REMEMBRANCE_PER_SPORT = 2;
const PREFERENCES_VERSION_NEXT = PREFERENCES_VERSION_DEFAULT + 1;

const UX_PREFERENCES = "UI / UX Preferences";

const UNIT_SYSTEM = "Unit System";
const UNIT_SYSTEM_TAG = "unit_system";
const UNIT_SYSTEM_DEFAULT = false;
const UNIT_SYSTEM_DESCRIPTION =
    "On: metric (km/h speed, meters distance), Off: imperial (mp/h speed, miles distance).";

const INSTANT_SCAN = "Instant Scanning";
const INSTANT_SCAN_TAG = "instant_scan";
const INSTANT_SCAN_DEFAULT = true;
const INSTANT_SCAN_DESCRIPTION = "On: the app will automatically start "
    "scanning for equipment after application start.";

const SCAN_DURATION = "Scan Duration";
const SCAN_DURATION_TAG = "scan_duration";
const SCAN_DURATION_DEFAULT = 3;
const SCAN_DURATION_DESCRIPTION =
    "Duration in seconds the app will spend looking Bluetooth Low Energy exercise equipment.";

const AUTO_CONNECT = "Auto Connect";
const AUTO_CONNECT_TAG = "auto_connect";
const AUTO_CONNECT_DEFAULT = false;
const AUTO_CONNECT_DESCRIPTION = "On: if there's only a single " +
    "equipment after scan, or one of the devices match the " +
    "last exercise machine the app will automatically move to the " +
    "measurement screen to start recording.";

const LAST_EQUIPMENT_ID_TAG = "last_equipment";
const LAST_EQUIPMENT_ID_TAG_PREFIX = LAST_EQUIPMENT_ID_TAG + "_";
const LAST_EQUIPMENT_ID_DEFAULT = "";

const INSTANT_MEASUREMENT_START = "Instant Measurement Start";
const INSTANT_MEASUREMENT_START_TAG = "instant_measurement_start";
const INSTANT_MEASUREMENT_START_DEFAULT = true;
const INSTANT_MEASUREMENT_START_DESCRIPTION = "On: when navigating to the measurement screen the " +
    "workout recording will start immediately. Off: the workout has to be started manually by " +
    "pressing the play button.";

const INSTANT_UPLOAD = "Instant Upload";
const INSTANT_UPLOAD_TAG = "instant_upload";
const INSTANT_UPLOAD_DEFAULT = false;
const INSTANT_UPLOAD_DESCRIPTION = "On: when Strava is authenticated and " +
    "the device is connected then activity upload is automatically " +
    "attempted at the end of workout";

const SIMPLER_UI = "Simplify Measurement UI";
const SIMPLER_UI_TAG = "simpler_ui";
const SIMPLER_UI_FAST_DEFAULT = false;
const SIMPLER_UI_SLOW_DEFAULT = true;
const SIMPLER_UI_DESCRIPTION = "On: the track visualization and the real-time" +
    " graphs won't be featured at the bottom of the measurement " +
    "screen. This can help old / slow phones.";

const DEVICE_FILTERING = "Device Filtering";
const DEVICE_FILTERING_TAG = "device_filtering";
const DEVICE_FILTERING_DEFAULT = true;
const DEVICE_FILTERING_DESCRIPTION =
    "Off: the app won't filter the list of Bluetooth device while scanning. " +
        "Useful if your equipment has an unexpected Bluetooth name.";

const MULTI_SPORT_DEVICE_SUPPORT = "Multi-Sport Device Support";
const MULTI_SPORT_DEVICE_SUPPORT_TAG = "multi_sport_device_support";
const MULTI_SPORT_DEVICE_SUPPORT_DEFAULT = false;
const MULTI_SPORT_DEVICE_SUPPORT_DESCRIPTION =
    "Turn this on only if you use a device (like Genesis Port) with multiple equipment of " +
        "different sport (like Kayaking, Canoeing, Rowing, and Swimming). In that case you'll " +
        "be prompted to select a sport before every workout.";

const TUNING_PREFERENCES = "Tuning";
const WORKAROUND_PREFERENCES = "Workarounds";

const MEASUREMENT_PANELS_EXPANDED_TAG = "measurement_panels_expanded";
const MEASUREMENT_PANELS_EXPANDED_DEFAULT = "00001";

const MEASUREMENT_DETAIL_SIZE_TAG = "measurement_detail_size";
const MEASUREMENT_DETAIL_SIZE_DEFAULT = "00000";

const EXTEND_TUNING = "Extend Power Tuning If Applicable";
const EXTEND_TUNING_TAG = "extend_tuning";
const EXTEND_TUNING_DEFAULT = false;
const EXTEND_TUNING_DESCRIPTION =
    "Apply power tuning to other attributes (speed, distance) as well when applicable. " +
        "Note that depending on the equipment the tuning might already affect multiple attributes " +
        "if they depend on each other like when calories or speed is calculated from power. " +
        "Also note when both calorie and power tuning applied then their effect may combine.";

const STROKE_RATE_SMOOTHING = "Stroke Rate Smoothing";
const STROKE_RATE_SMOOTHING_TAG = "stroke_rate_smoothing";
const STROKE_RATE_SMOOTHING_DEFAULT_INT = 10;
const STROKE_RATE_SMOOTHING_DEFAULT = "$STROKE_RATE_SMOOTHING_DEFAULT_INT";
const STROKE_RATE_SMOOTHING_DESCRIPTION = "Ergometers may provide too jittery data. Averaging " +
    "these over time soothes the data. This setting tells the window size by how many samples " +
    "could be in the smoothing queue. 1 means no smoothing.";

const DATA_STREAM_GAP_WATCHDOG = "Data Stream Gap Watchdog Timer";
const DATA_STREAM_GAP_WATCHDOG_TAG = "data_stream_gap_watchdog_timer";
const DATA_STREAM_GAP_WATCHDOG_DEFAULT_INT = 5;
const DATA_STREAM_GAP_WATCHDOG_DEFAULT = "$DATA_STREAM_GAP_WATCHDOG_DEFAULT_INT";
const DATA_STREAM_GAP_WATCHDOG_DESCRIPTION = "How many seconds of data gap considered " +
    "as a disconnection. A watchdog would finish the workout and can trigger sound warnings as well. " +
    "Zero means disabled";

const DATA_STREAM_GAP_ACTIVITY_AUTO_STOP = "Data Stream Gap Activity Auto Stop";
const DATA_STREAM_GAP_ACTIVITY_AUTO_STOP_TAG = "data_stream_gap_activity_auto_stop";
const DATA_STREAM_GAP_ACTIVITY_AUTO_STOP_DEFAULT = false;
const DATA_STREAM_GAP_ACTIVITY_AUTO_STOP_DESCRIPTION =
    "The workout is automatically stopped when the data stream gap timeout occurs.";

const SOUND_EFFECT_NONE = "none";
const SOUND_EFFECT_NONE_DESCRIPTION = "No sound effect.";
const SOUND_EFFECT_ONE_TONE = "one_tone_beep";
const SOUND_EFFECT_ONE_TONE_DESCRIPTION = "A single tone 1200Hz beep.";
const SOUND_EFFECT_TWO_TONE = "two_tone_beep";
const SOUND_EFFECT_TWO_TONE_DESCRIPTION = "Two beep tones repeated twice";
const SOUND_EFFECT_THREE_TONE = "three_tone_beep";
const SOUND_EFFECT_THREE_TONE_DESCRIPTION = "Three beep tones after one another";
const SOUND_EFFECT_BLEEP = "media_bleep";
const SOUND_EFFECT_BLEEP_DESCRIPTION = "A Media Call type bleep.";

const DATA_STREAM_GAP_SOUND_EFFECT = "Data Stream Gap Audio Warning";
const DATA_STREAM_GAP_SOUND_EFFECT_TAG = "data_stream_gap_sound_effect";
const DATA_STREAM_GAP_SOUND_EFFECT_DESCRIPTION =
    "Select the type of sound effect played when data acquisition timeout happens.";
const DATA_STREAM_GAP_SOUND_EFFECT_DEFAULT = SOUND_EFFECT_THREE_TONE;

const CADENCE_GAP_WORKAROUND = "Cadence Data Gap Workaround";
const CADENCE_GAP_WORKAROUND_TAG = "cadence_data_gap_workaround";
const CADENCE_GAP_WORKAROUND_DEFAULT = true;
const CADENCE_GAP_WORKAROUND_DESCRIPTION = "On: When speed / pace is non zero but the " +
    "cadence / stroke rate is zero the application will substitute the zero with the last " +
    "positive cadence reading. " +
    "Off: Zero cadence will be recorded without modification.";

const HEART_RATE_GAP_WORKAROUND = "Heart Rate Data Gap Workaround Selection";
const HEART_RATE_GAP_WORKAROUND_TAG = "heart_rate_gap_workaround";
const DATA_GAP_WORKAROUND_LAST_POSITIVE_VALUE = "last_positive_value";
const DATA_GAP_WORKAROUND_LAST_POSITIVE_VALUE_DESCRIPTION =
    "Persist the last known positive reading when a zero intermittent reading is encountered.";
const DATA_GAP_WORKAROUND_NO_WORKAROUND = "no_workaround";
const DATA_GAP_WORKAROUND_NO_WORKAROUND_DESCRIPTION =
    "Persist any values (including zeros) just as they are read from the device.";
const DATA_GAP_WORKAROUND_DO_NOT_WRITE_ZEROS = "do_not_write_zeros";
const DATA_GAP_WORKAROUND_DO_NOT_WRITE_ZEROS_DESCRIPTION =
    "Don't output any reading when zero data is recorded. Certain standards may not support that.";
const HEART_RATE_GAP_WORKAROUND_DEFAULT = DATA_GAP_WORKAROUND_LAST_POSITIVE_VALUE;

const HEART_RATE_UPPER_LIMIT = "Heart Rate Upper Limit";
const HEART_RATE_UPPER_LIMIT_TAG = "heart_rate_upper_limit";
const HEART_RATE_UPPER_LIMIT_DEFAULT_INT = 0;
const HEART_RATE_UPPER_LIMIT_DEFAULT = "$HEART_RATE_UPPER_LIMIT_DEFAULT_INT";
const HEART_RATE_UPPER_LIMIT_DESCRIPTION = "This is a heart rate upper bound where the methods " +
    "bellow would be applied. 0 means no upper limiting is performed.";

const HEART_RATE_LIMITING_METHOD = "Heart Rate Limiting Method Selection";
const HEART_RATE_LIMITING_METHOD_TAG = "heart_rate_limiting_method";
const HEART_RATE_LIMITING_WRITE_ZERO = "write_zero";
const HEART_RATE_LIMITING_WRITE_ZERO_DESCRIPTION =
    "Persist zero when the heart rate limit is reached.";
const HEART_RATE_LIMITING_WRITE_NOTHING = "write_nothing";
const HEART_RATE_LIMITING_WRITE_NOTHING_DESCRIPTION =
    "Don't persist any heart rate when the limit is reached.";
const HEART_RATE_LIMITING_CAP_AT_LIMIT = "cap_at_limit";
const HEART_RATE_LIMITING_CAP_AT_LIMIT_DESCRIPTION =
    "Cap the value at the level configured bellow.";
const HEART_RATE_LIMITING_NO_LIMIT = "no_limit";
const HEART_RATE_LIMITING_NO_LIMIT_DESCRIPTION = "Don't apply any limiting.";
const HEART_RATE_LIMITING_METHOD_DEFAULT = HEART_RATE_LIMITING_NO_LIMIT;

const TARGET_HEART_RATE_MODE = "Target Heart Rate Mode";
const TARGET_HEART_RATE_MODE_TAG = "target_heart_rate_mode";
const TARGET_HEART_RATE_MODE_DESCRIPTION =
    "You can configure target heart rate BPM range or zone range. " +
        "The app will alert visually (and optionally audio as well) when you are outside of the range. " +
        "The lower and upper zone can be the same if you want to target just one zone.";
const TARGET_HEART_RATE_MODE_NONE = "none";
const TARGET_HEART_RATE_MODE_NONE_DESCRIPTION = "Target heart rate alert is turned off.";
const TARGET_HEART_RATE_MODE_BPM = "bpm";
const TARGET_HEART_RATE_MODE_BPM_DESCRIPTION =
    "Bounds are specified by explicit beat per minute numbers.";
const TARGET_HEART_RATE_MODE_ZONES = "zones";
const TARGET_HEART_RATE_MODE_ZONES_DESCRIPTION = "Bounds are specified by HR zone numbers.";
const TARGET_HEART_RATE_MODE_DEFAULT = TARGET_HEART_RATE_MODE_NONE;

const TARGET_HEART_RATE_LOWER_BPM = "Target Heart Rate Lower BPM";
const TARGET_HEART_RATE_LOWER_BPM_TAG = "target_heart_rate_bpm_lower";
const TARGET_HEART_RATE_LOWER_BPM_DEFAULT_INT = 120;
const TARGET_HEART_RATE_LOWER_BPM_DEFAULT = "$TARGET_HEART_RATE_LOWER_BPM_DEFAULT_INT";
const TARGET_HEART_RATE_LOWER_BPM_DESCRIPTION =
    "Lower bpm of the target heart rate (for bpm target mode).";

const TARGET_HEART_RATE_UPPER_BPM = "Target Heart Rate Upper BPM";
const TARGET_HEART_RATE_UPPER_BPM_TAG = "target_heart_rate_bpm_upper";
const TARGET_HEART_RATE_UPPER_BPM_DEFAULT_INT = 140;
const TARGET_HEART_RATE_UPPER_BPM_DEFAULT = "$TARGET_HEART_RATE_UPPER_BPM_DEFAULT_INT";
const TARGET_HEART_RATE_UPPER_BPM_DESCRIPTION =
    "Upper bpm of the target heart rate (for bpm target mode).";

const TARGET_HEART_RATE_LOWER_ZONE = "Target Heart Rate Lower Zone";
const TARGET_HEART_RATE_LOWER_ZONE_TAG = "target_heart_rate_zone_lower";
const TARGET_HEART_RATE_LOWER_ZONE_DEFAULT_INT = 3;
const TARGET_HEART_RATE_LOWER_ZONE_DEFAULT = "$TARGET_HEART_RATE_LOWER_ZONE_DEFAULT_INT";
const TARGET_HEART_RATE_LOWER_ZONE_DESCRIPTION =
    "Lower zone of the target heart rate (for zone target mode).";

const TARGET_HEART_RATE_UPPER_ZONE = "Target Heart Rate Upper Zone";
const TARGET_HEART_RATE_UPPER_ZONE_TAG = "target_heart_rate_zone_upper";
const TARGET_HEART_RATE_UPPER_ZONE_DEFAULT_INT = 3;
const TARGET_HEART_RATE_UPPER_ZONE_DEFAULT = "$TARGET_HEART_RATE_UPPER_ZONE_DEFAULT_INT";
const TARGET_HEART_RATE_UPPER_ZONE_DESCRIPTION =
    "Upper zone of the target heart rate (for zone target mode).";

const TARGET_HEART_RATE_AUDIO = "Target Heart Rate Audio";
const TARGET_HEART_RATE_AUDIO_TAG = "target_heart_rate_audio";
const TARGET_HEART_RATE_AUDIO_DEFAULT = false;
const TARGET_HEART_RATE_AUDIO_DESCRIPTION = "Should a sound effect play when HR is out of range.";

const TARGET_HEART_RATE_AUDIO_PERIOD = "Target HR Audio Period (seconds)";
const TARGET_HEART_RATE_AUDIO_PERIOD_TAG = "target_heart_rate_audio_period";
const TARGET_HEART_RATE_AUDIO_PERIOD_DEFAULT_INT = 0;
const TARGET_HEART_RATE_AUDIO_PERIOD_DEFAULT = "$TARGET_HEART_RATE_AUDIO_PERIOD_DEFAULT_INT";
const TARGET_HEART_RATE_AUDIO_PERIOD_DESCRIPTION =
    "0 or 1: no periodicity. Larger than 1 seconds: " +
        "the selected sound effect will play with the periodicity until the HR is back in range.";

const TARGET_HEART_RATE_SOUND_EFFECT = "Target Heart Rate Out of Range Sound Effect";
const TARGET_HEART_RATE_SOUND_EFFECT_TAG = "target_heart_rate_sound_effect";
const TARGET_HEART_RATE_SOUND_EFFECT_DESCRIPTION =
    "Select the type of sound effect played when the HR gets out of range.";
const TARGET_HEART_RATE_SOUND_EFFECT_DEFAULT = SOUND_EFFECT_TWO_TONE;

const AUDIO_VOLUME = "Audio Volume (%)";
const AUDIO_VOLUME_TAG = "audio_volume";
const AUDIO_VOLUME_DEFAULT_INT = 50;
const AUDIO_VOLUME_DEFAULT = "$AUDIO_VOLUME_DEFAULT_INT";
const AUDIO_VOLUME_DESCRIPTION = "Volume base of the audio effects.";

const LEADERBOARD_FEATURE = "Leaderboard Feature";
const LEADERBOARD_FEATURE_TAG = "leaderboard_feature";
const LEADERBOARD_FEATURE_DEFAULT = false;
const LEADERBOARD_FEATURE_DESCRIPTION =
    "Leaderboard registry: should the app record workout entries for leaderboard purposes.";

const RANK_RIBBON_VISUALIZATION = "Display Rank Ribbons Above the Speed Graph";
const RANK_RIBBON_VISUALIZATION_TAG = "rank_ribbon_visualization";
const RANK_RIBBON_VISUALIZATION_DEFAULT = true;
const RANK_RIBBON_VISUALIZATION_DESCRIPTION =
    "Should the app provide UI feedback by ribbons above the speed graph. " +
        "Blue color means behind the top leaderboard, green marks record pace.";

const RANKING_FOR_DEVICE = "Ranking Based on the Actual Device";
const RANKING_FOR_DEVICE_TAG = "ranking_for_device";
const RANKING_FOR_DEVICE_DEFAULT = true;
const RANKING_FOR_DEVICE_DESCRIPTION =
    "Should the app display ranking for the particular device. " +
        "This affects both the ribbon type and the track visualization.";

const RANKING_FOR_SPORT = "Ranking Based on the Whole Sport";
const RANKING_FOR_SPORT_TAG = "ranking_for_sport";
const RANKING_FOR_SPORT_DEFAULT = false;
const RANKING_FOR_SPORT_DESCRIPTION =
    "Should the app display ranking for all devices for the sport. " +
        "This affects both the ribbon type and the track visualization.";

const RANK_TRACK_VISUALIZATION = "Visualize Rank Positions on the Track";
const RANK_TRACK_VISUALIZATION_TAG = "rank_track_visualization";
const RANK_TRACK_VISUALIZATION_DEFAULT = false;
const RANK_TRACK_VISUALIZATION_DESCRIPTION =
    "For performance reasons only the position right ahead (green color) and right behind " +
        "(blue color) of the current effort is displayed. Both positions have a the rank " +
        "number inside their dot.";

const LEADERBOARD_LIMIT = 25;

const EXPERT_PREFERENCES = "Expert Preferences";

const APP_DEBUG_MODE = "Application Debug Mode";
const APP_DEBUG_MODE_TAG = "app_debug_mode";
const APP_DEBUG_MODE_DEFAULT = false;
const APP_DEBUG_MODE_DESCRIPTION =
    "On: The Recording UI runs on simulated data, no equipment required. " +
        "Off: The recording works as it should in release.";

const DATA_CONNECTION_ADDRESSES = "Data Connection Addresses";
const DATA_CONNECTION_ADDRESSES_TAG = "data_connection_addresses";
const DATA_CONNECTION_ADDRESSES_DEFAULT =
    "52.44.84.95,54.160.234.139,52.87.57.116,3.93.102.29,54.157.131.119,3.226.9.14";

const DATA_CONNECTION_ADDRESSES_DESCRIPTION =
    "Following is a comma separated list of IP addresses with optional comma separated port " +
        "numbers. Lack of a port number will mean 443 (HTTPS). " +
        "The application will reach out to these endpoints to determine if there " +
        "is really a data connection.";

const ZONE_PREFERENCES = " Zone Preferences";

const SLOW_SPEED_POSTFIX = " Speed (kmh) Considered Too Slow to Display";
const SLOW_SPEED_TAG_PREFIX = "slow_speed_";

const THEME_SELECTION = "Theme Selection (System / Light / Dark)";
const THEME_SELECTION_TAG = "theme_selection";
const THEME_SELECTION_DESCRIPTION =
    "Should the theme match the system default, be light, or be dark.";
const THEME_SELECTION_SYSTEM = "system";
const THEME_SELECTION_SYSTEM_DESCRIPTION = "Matching the system default theme.";
const THEME_SELECTION_LIGHT = "light";
const THEME_SELECTION_LIGHT_DESCRIPTION = "Light theme.";
const THEME_SELECTION_DARK = "dark";
const THEME_SELECTION_DARK_DESCRIPTION = "Dark theme.";
const THEME_SELECTION_DEFAULT = THEME_SELECTION_SYSTEM;

Future<bool> getSimplerUiDefault() async {
  var simplerUiDefault = SIMPLER_UI_FAST_DEFAULT;
  if (Platform.isAndroid) {
    var androidInfo = await DeviceInfoPlugin().androidInfo;
    if (androidInfo.version.sdkInt < 26) {
      // Remove complexities for very old Android devices
      simplerUiDefault = SIMPLER_UI_SLOW_DEFAULT;
    }
  }
  return simplerUiDefault;
}

painting.Color paletteToPaintColor(common.Color paletteColor) {
  return painting.Color.fromARGB(paletteColor.a, paletteColor.r, paletteColor.g, paletteColor.b);
}

const KM2MI = 0.621371;
const MI2KM = 1 / KM2MI;
const M2MILE = KM2MI / 1000.0;

extension DurationDisplay on Duration {
  String toDisplay() {
    return this.toString().split('.').first.padLeft(8, "0");
  }
}
