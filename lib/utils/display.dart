import '../utils/constants.dart';
import '../persistence/preferences.dart';
import '../tcx/activity_type.dart';

double speedOrPace(double speed, bool si, String sport) {
  if (sport == ActivityType.Ride) {
    if (si) return speed;

    return speed * KM2MI;
  } else {
    if (speed.abs() < DISPLAY_EPS) return 0.0;

    if (sport == ActivityType.Run) {
      final pace = 60.0 / speed;

      if (si) return pace;

      return pace / KM2MI; // mph is lower than kmh but pace is reciprocal
    } else if (sport == ActivityType.Kayaking ||
        sport == ActivityType.Canoeing ||
        sport == ActivityType.Rowing) {
      return 30.0 / speed;
    } else if (sport == ActivityType.Swim) {
      return 6.0 / speed;
    }
    return speed;
  }
}

String speedOrPaceString(double speed, bool si, String sport) {
  final spd = speedOrPace(speed, si, sport);
  if (sport == ActivityType.Ride) {
    return spd.toStringAsFixed(2);
  } else if (sport == ActivityType.Run ||
      sport == ActivityType.Kayaking ||
      sport == ActivityType.Canoeing ||
      sport == ActivityType.Rowing ||
      sport == ActivityType.Swim) {
    if (speed.abs() < DISPLAY_EPS) return "0:00";
    var pace = 60.0 / speed;
    if (sport == ActivityType.Kayaking ||
        sport == ActivityType.Canoeing ||
        sport == ActivityType.Rowing) {
      pace /= 2.0;
    } else if (sport == ActivityType.Swim) {
      pace /= 10.0;
    } else if (!si) {
      pace /= KM2MI;
    }
    return paceString(pace);
  }
  return spd.toStringAsFixed(2);
}

String paceString(double pace) {
  final minutes = pace.truncate();
  final seconds = ((pace - minutes) * 60.0).truncate();
  return "$minutes:" + seconds.toString().padLeft(2, "0");
}
