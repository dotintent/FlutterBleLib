library internal;

import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:async/async.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ble_lib/blemulator/blemulator.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:flutter_ble_lib/internal/bridge/internal_bridge_lib.dart';

part 'bridge/constants.dart';
part 'bridge/dart_to_platform_bridge.dart';
part 'bridge/platform_to_dart_bridge.dart';
part 'defaults.dart';
part 'scan_result.dart';
part 'simulation_manager.dart';
part 'simulation_manager_mixins/client_managing_mixin.dart';
part 'simulation_manager_mixins/discovery_mixin.dart';
part 'simulation_manager_mixins/error_checks_mixin.dart';
part 'simulation_manager_mixins/peripheral_connection_mixin.dart';
part 'simulation_manager_mixins/peripheral_scanning_mixin.dart';
part 'simulation_manager_mixins/characteristics_mixin.dart';
part 'simulation_manager_mixins/rssi_mixin.dart';
part 'simulation_manager_mixins/simulation_manager_base.dart';