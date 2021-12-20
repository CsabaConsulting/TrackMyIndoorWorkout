import '../preferences/generic.dart';

const MEASUREMENT_PANELS_EXPANDED_TAG = "measurement_panels_expanded";
const MEASUREMENT_PANELS_EXPANDED_DEFAULT = "00001";

const MEASUREMENT_DETAIL_SIZE_TAG = "measurement_detail_size";
const MEASUREMENT_DETAIL_SIZE_DEFAULT = "00000";

const USE_HR_MONITOR_REPORTED_CALORIES = "Use heart rate monitor reported calories";
const USE_HR_MONITOR_REPORTED_CALORIES_TAG = "use_heart_rate_monitor_reported_calories";
const USE_HR_MONITOR_REPORTED_CALORIES_DEFAULT = false;
const USE_HR_MONITOR_REPORTED_CALORIES_DESCRIPTION =
    "Only very enhanced heart rate monitors are capable reporting calories."
    "In such case should that calorie count take precedence over the value "
    "calculated by the fitness equipment (explicitly or deducted from the power reading).";

const USE_HEART_RATE_BASED_CALORIE_COUNTING = "Use heart rate based calorie counting";
const USE_HEART_RATE_BASED_CALORIE_COUNTING_TAG = "heart_rate_based_calorie_counting";
const USE_HEART_RATE_BASED_CALORIE_COUNTING_DEFAULT = false;
const USE_HEART_RATE_BASED_CALORIE_COUNTING_DESCRIPTION =
    "This method also requires configured athlete weight, age, and gender. "
    "Optional VO2max could make the calculation even more precise.";

const STROKE_RATE_SMOOTHING = "Stroke Rate Smoothing";
const STROKE_RATE_SMOOTHING_TAG = "stroke_rate_smoothing";
const STROKE_RATE_SMOOTHING_INT_TAG = STROKE_RATE_SMOOTHING_TAG + intTagPostfix;
const STROKE_RATE_SMOOTHING_MIN = 1;
const STROKE_RATE_SMOOTHING_DEFAULT = 10;
const STROKE_RATE_SMOOTHING_MAX = 50;
const STROKE_RATE_SMOOTHING_DESCRIPTION = "Ergometers may provide too jittery data. Averaging "
    "these over time soothes the data. This setting tells the window size by how many samples "
    "could be in the smoothing queue. 1 means no smoothing.";

const DATA_STREAM_GAP_WATCHDOG = "Data Stream Gap Watchdog Timer";
const DATA_STREAM_GAP_WATCHDOG_TAG = "data_stream_gap_watchdog_timer";
const DATA_STREAM_GAP_WATCHDOG_INT_TAG = DATA_STREAM_GAP_WATCHDOG_TAG + intTagPostfix;
const DATA_STREAM_GAP_WATCHDOG_MIN = 0;
const DATA_STREAM_GAP_WATCHDOG_OLD_DEFAULT = 5;
const DATA_STREAM_GAP_WATCHDOG_DEFAULT = 30;
const DATA_STREAM_GAP_WATCHDOG_MAX = 50;
const DATA_STREAM_GAP_WATCHDOG_DESCRIPTION = "How many seconds of data gap considered "
    "as a disconnection. A watchdog would finish the workout and can trigger sound warnings as well. "
    "Zero means disabled.";

const SOUND_EFFECT_NONE = "none";
const SOUND_EFFECT_NONE_DESCRIPTION = "No sound effect";
const SOUND_EFFECT_ONE_TONE = "one_tone_beep";
const SOUND_EFFECT_ONE_TONE_DESCRIPTION = "A single tone 1200Hz beep";
const SOUND_EFFECT_TWO_TONE = "two_tone_beep";
const SOUND_EFFECT_TWO_TONE_DESCRIPTION = "Two beep tones repeated twice";
const SOUND_EFFECT_THREE_TONE = "three_tone_beep";
const SOUND_EFFECT_THREE_TONE_DESCRIPTION = "Three beep tones after one another";
const SOUND_EFFECT_BLEEP = "media_bleep";
const SOUND_EFFECT_BLEEP_DESCRIPTION = "A Media Call type bleep";

const DATA_STREAM_GAP_SOUND_EFFECT = "Data Stream Gap Audio Warning:";
const DATA_STREAM_GAP_SOUND_EFFECT_TAG = "data_stream_gap_sound_effect";
const DATA_STREAM_GAP_SOUND_EFFECT_DESCRIPTION =
    "Select the type of sound effect played when data acquisition timeout happens:";
const DATA_STREAM_GAP_SOUND_EFFECT_DEFAULT = SOUND_EFFECT_THREE_TONE;

const CADENCE_GAP_WORKAROUND = "Cadence Data Gap Workaround:";
const CADENCE_GAP_WORKAROUND_TAG = "cadence_data_gap_workaround";
const CADENCE_GAP_WORKAROUND_DEFAULT = true;
const CADENCE_GAP_WORKAROUND_DESCRIPTION = "On: When speed / pace is non zero but the "
    "cadence / stroke rate is zero the application will substitute the zero with the last "
    "positive cadence reading. "
    "Off: Zero cadence will be recorded without modification.";

const HEART_RATE_GAP_WORKAROUND = "Heart Rate Data Gap Workaround";
const HEART_RATE_GAP_WORKAROUND_TAG = "heart_rate_gap_workaround";
const HEART_RATE_GAP_WORKAROUND_SELECTION = "Heart Rate Data Gap Workaround Selection:";
const DATA_GAP_WORKAROUND_LAST_POSITIVE_VALUE = "last_positive_value";
const DATA_GAP_WORKAROUND_LAST_POSITIVE_VALUE_DESCRIPTION =
    "Hold the last known positive reading when a zero intermittent reading is encountered";
const DATA_GAP_WORKAROUND_NO_WORKAROUND = "no_workaround";
const DATA_GAP_WORKAROUND_NO_WORKAROUND_DESCRIPTION =
    "Record any values (including zeros) just as they are read from the device";
const DATA_GAP_WORKAROUND_DO_NOT_WRITE_ZEROS = "do_not_write_zeros";
const DATA_GAP_WORKAROUND_DO_NOT_WRITE_ZEROS_DESCRIPTION =
    "Don't output any reading when zero data is recorded. Certain standards may not support that";
const HEART_RATE_GAP_WORKAROUND_DEFAULT = DATA_GAP_WORKAROUND_LAST_POSITIVE_VALUE;

const HEART_RATE_UPPER_LIMIT = "Heart Rate Upper Limit";
const HEART_RATE_UPPER_LIMIT_TAG = "heart_rate_upper_limit";
const HEART_RATE_UPPER_LIMIT_INT_TAG = HEART_RATE_UPPER_LIMIT_TAG + intTagPostfix;
const HEART_RATE_UPPER_LIMIT_MIN = 0;
const HEART_RATE_UPPER_LIMIT_DEFAULT = 0;
const HEART_RATE_UPPER_LIMIT_MAX = 300;
const HEART_RATE_UPPER_LIMIT_DESCRIPTION = "This is a heart rate upper bound where the methods "
    "bellow would be applied. 0 means no upper limiting is performed.";

const HEART_RATE_LIMITING_METHOD = "Heart Rate Limiting Method Selection:";
const HEART_RATE_LIMITING_METHOD_TAG = "heart_rate_limiting_method";
const HEART_RATE_LIMITING_WRITE_ZERO = "write_zero";
const HEART_RATE_LIMITING_WRITE_ZERO_DESCRIPTION =
    "Record zero when the heart rate limit is reached";
const HEART_RATE_LIMITING_WRITE_NOTHING = "write_nothing";
const HEART_RATE_LIMITING_WRITE_NOTHING_DESCRIPTION =
    "Don't record any heart rate when the limit is reached";
const HEART_RATE_LIMITING_CAP_AT_LIMIT = "cap_at_limit";
const HEART_RATE_LIMITING_CAP_AT_LIMIT_DESCRIPTION = "Cap the value at the level configured bellow";
const HEART_RATE_LIMITING_NO_LIMIT = "no_limit";
const HEART_RATE_LIMITING_NO_LIMIT_DESCRIPTION = "Don't apply any limiting";
const HEART_RATE_LIMITING_METHOD_DEFAULT = HEART_RATE_LIMITING_NO_LIMIT;

const TARGET_HEART_RATE_MODE = "Target Heart Rate Mode:";
const TARGET_HEART_RATE_MODE_TAG = "target_heart_rate_mode";
const TARGET_HEART_RATE_MODE_DESCRIPTION =
    "You can configure target heart rate BPM range or zone range. "
    "The app will alert visually (and optionally audio as well) when you are outside of the range. "
    "The lower and upper zone can be the same if you want to target just one zone.";
const TARGET_HEART_RATE_MODE_NONE = "none";
const TARGET_HEART_RATE_MODE_NONE_DESCRIPTION = "Target heart rate alert is turned off";
const TARGET_HEART_RATE_MODE_BPM = "bpm";
const TARGET_HEART_RATE_MODE_BPM_DESCRIPTION =
    "Bounds are specified by explicit beat per minute numbers";
const TARGET_HEART_RATE_MODE_ZONES = "zones";
const TARGET_HEART_RATE_MODE_ZONES_DESCRIPTION = "Bounds are specified by HR zone numbers";
const TARGET_HEART_RATE_MODE_DEFAULT = TARGET_HEART_RATE_MODE_NONE;

const TARGET_HEART_RATE_LOWER_BPM = "Target Heart Rate Lower BPM";
const TARGET_HEART_RATE_LOWER_BPM_TAG = "target_heart_rate_bpm_lower";
const TARGET_HEART_RATE_LOWER_BPM_INT_TAG = TARGET_HEART_RATE_LOWER_BPM_TAG + intTagPostfix;
const TARGET_HEART_RATE_LOWER_BPM_MIN = 0;
const TARGET_HEART_RATE_LOWER_BPM_DEFAULT = 120;
const TARGET_HEART_RATE_LOWER_BPM_DESCRIPTION =
    "Lower bpm of the target heart rate (for bpm target mode).";

const TARGET_HEART_RATE_UPPER_BPM = "Target Heart Rate Upper BPM";
const TARGET_HEART_RATE_UPPER_BPM_TAG = "target_heart_rate_bpm_upper";
const TARGET_HEART_RATE_UPPER_BPM_INT_TAG = TARGET_HEART_RATE_UPPER_BPM_TAG + intTagPostfix;
const TARGET_HEART_RATE_UPPER_BPM_DEFAULT = 140;
const TARGET_HEART_RATE_UPPER_BPM_MAX = 300;
const TARGET_HEART_RATE_UPPER_BPM_DESCRIPTION =
    "Upper bpm of the target heart rate (for bpm target mode).";

const TARGET_HEART_RATE_LOWER_ZONE = "Target Heart Rate Lower Zone";
const TARGET_HEART_RATE_LOWER_ZONE_TAG = "target_heart_rate_zone_lower";
const TARGET_HEART_RATE_LOWER_ZONE_INT_TAG = TARGET_HEART_RATE_LOWER_ZONE_TAG + intTagPostfix;
const TARGET_HEART_RATE_LOWER_ZONE_MIN = 0;
const TARGET_HEART_RATE_LOWER_ZONE_DEFAULT = 3;
const TARGET_HEART_RATE_LOWER_ZONE_DESCRIPTION =
    "Lower zone of the target heart rate (for zone target mode).";

const TARGET_HEART_RATE_UPPER_ZONE = "Target Heart Rate Upper Zone";
const TARGET_HEART_RATE_UPPER_ZONE_TAG = "target_heart_rate_zone_upper";
const TARGET_HEART_RATE_UPPER_ZONE_INT_TAG = TARGET_HEART_RATE_UPPER_ZONE_TAG + intTagPostfix;
const TARGET_HEART_RATE_UPPER_ZONE_DEFAULT = 3;
const TARGET_HEART_RATE_UPPER_ZONE_MAX = 7;
const TARGET_HEART_RATE_UPPER_ZONE_DESCRIPTION =
    "Upper zone of the target heart rate (for zone target mode).";

const TARGET_HEART_RATE_AUDIO = "Target Heart Rate Audio";
const TARGET_HEART_RATE_AUDIO_TAG = "target_heart_rate_audio";
const TARGET_HEART_RATE_AUDIO_DEFAULT = false;
const TARGET_HEART_RATE_AUDIO_DESCRIPTION = "Should a sound effect play when HR is out of range.";

const TARGET_HEART_RATE_AUDIO_PERIOD = "Target HR Audio Period (seconds)";
const TARGET_HEART_RATE_AUDIO_PERIOD_TAG = "target_heart_rate_audio_period";
const TARGET_HEART_RATE_AUDIO_PERIOD_INT_TAG = TARGET_HEART_RATE_AUDIO_PERIOD_TAG + intTagPostfix;
const TARGET_HEART_RATE_AUDIO_PERIOD_MIN = 0;
const TARGET_HEART_RATE_AUDIO_PERIOD_DEFAULT = 0;
const TARGET_HEART_RATE_AUDIO_PERIOD_MAX = 10;
const TARGET_HEART_RATE_AUDIO_PERIOD_DESCRIPTION = "0 or 1: no periodicity. Larger than 1 seconds: "
    "the selected sound effect will play with the periodicity until the HR is back in range.";

const TARGET_HEART_RATE_SOUND_EFFECT = "Target Heart Rate Out of Range Sound Effect:";
const TARGET_HEART_RATE_SOUND_EFFECT_TAG = "target_heart_rate_sound_effect";
const TARGET_HEART_RATE_SOUND_EFFECT_DESCRIPTION =
    "Select the type of sound effect played when the HR gets out of range:";
const TARGET_HEART_RATE_SOUND_EFFECT_DEFAULT = SOUND_EFFECT_TWO_TONE;

const AUDIO_VOLUME = "Audio Volume (%)";
const AUDIO_VOLUME_TAG = "audio_volume";
const AUDIO_VOLUME_INT_TAG = AUDIO_VOLUME_TAG + intTagPostfix;
const AUDIO_VOLUME_MIN = 0;
const AUDIO_VOLUME_DEFAULT = 50;
const AUDIO_VOLUME_MAX = 100;
const AUDIO_VOLUME_DESCRIPTION = "Volume base of the audio effects.";

const LEADERBOARD_FEATURE = "Leaderboard Feature";
const LEADERBOARD_FEATURE_TAG = "leaderboard_feature";
const LEADERBOARD_FEATURE_DEFAULT = false;
const LEADERBOARD_FEATURE_DESCRIPTION =
    "Leaderboard registry: should the app record workout entries for leaderboard purposes.";

const RANK_RIBBON_VISUALIZATION = "Display Rank Ribbons Above the Speed Graph";
const RANK_RIBBON_VISUALIZATION_TAG = "rank_ribbon_visualization";
const RANK_RIBBON_VISUALIZATION_DEFAULT = false;
const RANK_RIBBON_VISUALIZATION_DESCRIPTION =
    "Should the app provide UI feedback by ribbons above the speed graph. "
    "Blue color means behind the top leaderboard, green marks record pace.";

const RANKING_FOR_DEVICE = "Ranking Based on the Actual Device";
const RANKING_FOR_DEVICE_TAG = "ranking_for_device";
const RANKING_FOR_DEVICE_DEFAULT = false;
const RANKING_FOR_DEVICE_DESCRIPTION = "Should the app display ranking for the particular device. "
    "This affects both the ribbon type and the track visualization.";

const RANKING_FOR_SPORT = "Ranking Based on the Whole Sport";
const RANKING_FOR_SPORT_TAG = "ranking_for_sport";
const RANKING_FOR_SPORT_DEFAULT = false;
const RANKING_FOR_SPORT_DESCRIPTION =
    "Should the app display ranking for all devices for the sport. "
    "This affects both the ribbon type and the track visualization.";

const RANK_TRACK_VISUALIZATION = "Visualize Rank Positions on the Track";
const RANK_TRACK_VISUALIZATION_TAG = "rank_track_visualization";
const RANK_TRACK_VISUALIZATION_DEFAULT = false;
const RANK_TRACK_VISUALIZATION_DESCRIPTION =
    "For performance reasons only the position right ahead (green color) and right behind "
    "(blue color) of the current effort is displayed. Both positions have a the rank "
    "number inside their dot.";

const RANK_INFO_ON_TRACK =
    "Display rank information at the center of the track (on top of positions)";
const RANK_INFO_ON_TRACK_TAG = "rank_info_on_track";
const RANK_INFO_ON_TRACK_DEFAULT = true;
const RANK_INFO_ON_TRACK_DESCRIPTION =
    "On: when rank position is enabled this switch will display extra information "
    "in the middle of the track: it'll list the preceding and following positions "
    "along with the distance compared to the athlete's current position";

const DISPLAY_LAP_COUNTER = "Display the number of lamps";
const DISPLAY_LAP_COUNTER_TAG = "display_lap_counter";
const DISPLAY_LAP_COUNTER_DEFAULT = false;
const DISPLAY_LAP_COUNTER_DESCRIPTION =
    "On: the number of lamps passed will be displayed in the middle of the track";

const APP_DEBUG_MODE = "Application Debug Mode";
const APP_DEBUG_MODE_TAG = "app_debug_mode";
const APP_DEBUG_MODE_DEFAULT = false;
const APP_DEBUG_MODE_DESCRIPTION =
    "On: The Recording UI runs on simulated data, no equipment required. "
    "Off: The recording works as it should in release.";

const DATA_CONNECTION_ADDRESSES = "Data Connection Check Endpoints";
const DATA_CONNECTION_ADDRESSES_TAG = "data_connection_addresses";
const DATA_CONNECTION_ADDRESSES_DEFAULT = "";
const DATA_CONNECTION_ADDRESSES_OLD_DEFAULT =
    "52.44.84.95,54.160.234.139,52.87.57.116,3.93.102.29,54.157.131.119,3.226.9.14";

const DATA_CONNECTION_ADDRESSES_DESCRIPTION =
    "Following is a comma separated list of IP addresses with optional comma "
    "separated port numbers. Lack of a port number will mean 443 (HTTPS). "
    "The application will reach out to these endpoints to determine if "
    "there is really a data connection.";

const THEME_SELECTION = "Theme Selection (System / Light / Dark):";
const THEME_SELECTION_TAG = "theme_selection";
const THEME_SELECTION_DESCRIPTION =
    "Should the theme match the system default, be light, or be dark:";
const THEME_SELECTION_SYSTEM = "system";
const THEME_SELECTION_SYSTEM_DESCRIPTION = "System's theme";
const THEME_SELECTION_LIGHT = "light";
const THEME_SELECTION_LIGHT_DESCRIPTION = "Light theme";
const THEME_SELECTION_DARK = "dark";
const THEME_SELECTION_DARK_DESCRIPTION = "Dark theme";
const THEME_SELECTION_DEFAULT = THEME_SELECTION_SYSTEM;

const ZONE_INDEX_DISPLAY_COLORING = "Color the measurement based on zones";
const ZONE_INDEX_DISPLAY_COLORING_TAG = "zone_index_display_coloring";
const ZONE_INDEX_DISPLAY_COLORING_DEFAULT = true;
const ZONE_INDEX_DISPLAY_COLORING_DESCRIPTION =
    "On: The measurement font and background is color modified to reflect the zone value. "
    "Off: The zone is displayed without any re-coloring, this is less performance intensive.";
