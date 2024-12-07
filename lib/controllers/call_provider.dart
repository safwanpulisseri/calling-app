import 'package:flutter_riverpod/flutter_riverpod.dart';

final mutedProvider = StateProvider<bool>((ref) => false);
final viewPanelProvider = StateProvider<bool>((ref) => false);
final usersProvider = StateProvider<List<int>>((ref) => []);
final infoStringProvider = StateProvider<List<String>>((ref) => []);
