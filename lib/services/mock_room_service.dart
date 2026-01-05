/// Mock Room Service - For testing without Firebase
import 'dart:math';
import '../models/room_model.dart';

class MockRoomService {
  // In-memory storage
  static final Map<String, RoomModel> _rooms = {};
  static final Map<String, String> _codeToRoomId = {};

  /// Generate unique 4-character room code
  String generateRoomCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final random = Random();
    String code;
    do {
      code = List.generate(4, (_) => chars[random.nextInt(chars.length)]).join();
    } while (_codeToRoomId.containsKey(code));
    return code;
  }

  /// Create new room
  Future<RoomModel> createRoom(String hostId) async {
    await Future.delayed(const Duration(milliseconds: 300)); // Simulate network delay
    
    final roomId = 'room_${DateTime.now().millisecondsSinceEpoch}';
    final code = generateRoomCode();
    
    final room = RoomModel.create(
      id: roomId,
      code: code,
      hostId: hostId,
    );

    _rooms[roomId] = room;
    _codeToRoomId[code] = roomId;
    
    print('Mock Room Created: ${room.code} (ID: ${room.id})');
    return room;
  }

  /// Join room by code
  Future<RoomModel> joinRoom(String code, String userId) async {
    await Future.delayed(const Duration(milliseconds: 300)); // Simulate network delay
    
    final roomId = _codeToRoomId[code.toUpperCase()];
    if (roomId == null) {
      throw Exception('Room not found');
    }

    final room = _rooms[roomId];
    if (room == null) {
      throw Exception('Room not found');
    }

    if (room.isFull()) {
      throw Exception('Room is full');
    }

    if (room.isParticipant(userId)) {
      return room; // Already in room
    }

    final updatedRoom = room.copyWith(
      participantIds: [...room.participantIds, userId],
      readyStatus: {...room.readyStatus, userId: false},
    );

    _rooms[roomId] = updatedRoom;
    print('User $userId joined room: ${room.code}');
    
    return updatedRoom;
  }

  /// Get room by code
  Future<RoomModel?> getRoomByCode(String code) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    final roomId = _codeToRoomId[code.toUpperCase()];
    if (roomId == null) return null;
    
    return _rooms[roomId];
  }

  /// Get room by ID
  Future<RoomModel?> getRoom(String roomId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _rooms[roomId];
  }

  /// Toggle ready status
  Future<void> toggleReady(String roomId, String userId, bool isReady) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    final room = _rooms[roomId];
    if (room == null) throw Exception('Room not found');

    final updatedReadyStatus = {...room.readyStatus, userId: isReady};
    _rooms[roomId] = room.copyWith(readyStatus: updatedReadyStatus);
    
    print('User $userId ready status: $isReady');
  }

  /// Leave room
  Future<void> leaveRoom(String roomId, String userId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    final room = _rooms[roomId];
    if (room == null) return;

    final updatedParticipants = room.participantIds.where((id) => id != userId).toList();
    final updatedReadyStatus = Map<String, bool>.from(room.readyStatus)..remove(userId);

    if (updatedParticipants.isEmpty) {
      // Delete room if empty
      _rooms.remove(roomId);
      _codeToRoomId.remove(room.code);
      print('Room ${room.code} deleted (empty)');
    } else {
      // Update host if current host leaves
      String newHostId = room.hostId;
      if (userId == room.hostId) {
        newHostId = updatedParticipants.first;
      }

      _rooms[roomId] = room.copyWith(
        hostId: newHostId,
        participantIds: updatedParticipants,
        readyStatus: updatedReadyStatus,
      );
      print('User $userId left room ${room.code}');
    }
  }

  /// Update room status
  Future<void> updateRoomStatus(String roomId, RoomStatus status) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    final room = _rooms[roomId];
    if (room == null) throw Exception('Room not found');

    _rooms[roomId] = room.copyWith(status: status);
  }

  /// Stream room updates (simulated with polling)
  Stream<RoomModel?> streamRoom(String roomId) async* {
    while (true) {
      await Future.delayed(const Duration(seconds: 1));
      yield _rooms[roomId];
    }
  }

  /// Get all active rooms
  List<RoomModel> getAllRooms() {
    return _rooms.values.where((room) => room.status == RoomStatus.waiting).toList();
  }

  /// Clear all rooms (for testing)
  static void clearAll() {
    _rooms.clear();
    _codeToRoomId.clear();
    print('All mock rooms cleared');
  }
}
