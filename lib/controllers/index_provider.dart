import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';


final validateErrorProvider = StateProvider<bool>((ref) => false);
final roleProvider = StateProvider<ClientRoleType>((ref) => ClientRoleType.clientRoleBroadcaster);
