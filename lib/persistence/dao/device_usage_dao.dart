import 'package:floor/floor.dart';
import '../models/device_usage.dart';

@dao
abstract class DeviceUsageDao {
  @Query('SELECT * FROM `$DEVICE_USAGE_TABLE_NAME` ORDER BY `time` DESC')
  Future<List<DeviceUsage>> findAllDeviceUsages();

  @Query('SELECT * FROM `$DEVICE_USAGE_TABLE_NAME` WHERE `id` = :id')
  Stream<DeviceUsage?> findDeviceUsageById(int id);

  @Query('SELECT * FROM `$DEVICE_USAGE_TABLE_NAME` WHERE `mac` = :mac ORDER BY `time` DESC LIMIT 1')
  Stream<DeviceUsage?> findDeviceUsageByMac(String mac);

  @Query(
      'SELECT * FROM `$DEVICE_USAGE_TABLE_NAME` ORDER BY `time` DESC LIMIT :limit OFFSET :offset')
  Future<List<DeviceUsage>> findDeviceUsages(int limit, int offset);

  @insert
  Future<int> insertDeviceUsage(DeviceUsage deviceUsage);

  @update
  Future<int> updateDeviceUsage(DeviceUsage deviceUsage);

  @delete
  Future<int> deleteDeviceUsage(DeviceUsage deviceUsage);
}
