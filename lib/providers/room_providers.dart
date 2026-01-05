/// Room Providers - State Management
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/room_model.dart';
import '../services/room_service.dart';
import '../services/mock_room_service.dart';

// Use mock service for now (until Firebase is configured)
const bool USE_MOCK = true;

// Room Service Provider
final roomServiceProvider = Provider<dynamic>((ref) {
  return USE_MOCK ? MockRoomService() : RoomService();
});

// Current Room ID Provider
final currentRoomIdProvider = StateProvider<String?>((ref) => null);

// Username Provider
final usernameProvider = StateProvider<String?>((ref) => null);

// Current User ID Provider (mock user ID for testing)
final currentUserIdProvider = StateProvider<String?>((ref) => 'user_${DateTime.now().millisecondsSinceEpoch}');

// Current Room Stream Provider
final currentRoomProvider = StreamProvider<RoomModel?>((ref) {
  final roomId = ref.watch(currentRoomIdProvider);
  if (roomId == null) return Stream.value(null);

  final service = ref.watch(roomServiceProvider);
  return service.streamRoom(roomId);
});

// Room Actions Provider
final roomActionsProvider = Provider<RoomActions>((ref) => RoomActions(ref));

/// Room Actions Class
class RoomActions {
  final Ref ref;

  RoomActions(this.ref);

  /// Create new room
  Future<RoomModel> createRoom() async {
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) {
      throw Exception('User ID not set');
    }

    final service = ref.read(roomServiceProvider);
    final room = await service.createRoom(userId);

    // Set current room
    ref.read(currentRoomIdProvider.notifier).state = room.id;

    return room;
  }

  /// Join room by code
  Future<RoomModel> joinRoom(String code) async {
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) {
      throw Exception('User ID not set');
    }

    final service = ref.read(roomServiceProvider);
    final room = await service.joinRoom(code, userId);

    // Set current room
    ref.read(currentRoomIdProvider.notifier).state = room.id;

    return room;
  }

  /// Toggle ready status
  Future<void> toggleReady(bool isReady) async {
    final roomId = ref.read(currentRoomIdProvider);
    final userId = ref.read(currentUserIdProvider);
    
    if (roomId == null || userId == null) {
      throw Exception('Room or User not set');
    }

    final service = ref.read(roomServiceProvider);
    await service.toggleReady(roomId, userId, isReady);
  }

  /// Leave room
  Future<void> leaveRoom() async {
    final roomId = ref.read(currentRoomIdProvider);
    final userId = ref.read(currentUserIdProvider);
    
    if (roomId == null || userId == null) return;

    final service = ref.read(roomServiceProvider);
    await service.leaveRoom(roomId, userId);

    // Clear current room
    ref.read(currentRoomIdProvider.notifier).state = null;
  }

  /// Save username to local storage
  Future<void> saveUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    ref.read(usernameProvider.notifier).state = username;
  }

  /// Load username from local storage
  Future<String?> loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    if (username != null) {
      ref.read(usernameProvider.notifier).state = username;
    }
    return username;
  }
}
