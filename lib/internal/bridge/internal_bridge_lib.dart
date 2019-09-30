library internal_bridge_lib;

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ble_lib/error/ble_error.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:flutter_ble_lib/internal/containers.dart';
import 'package:flutter_ble_lib/internal/constants.dart';
import '../managers_for_classes.dart';
import 'dart:convert';

part 'lib_core.dart';
part 'scanning_mixin.dart';
part 'device_connection_mixin.dart';
part 'discovery_mixin.dart';
part 'log_level_mixin.dart';
part 'devices_mixin.dart';
part 'device_rssi_mixin.dart';
part 'bluetooth_state_mixin.dart';
part 'mtu_mixin.dart';
part 'characteristics_mixin.dart';
part '../internal_ble_manager.dart';
part '../base_entities.dart';