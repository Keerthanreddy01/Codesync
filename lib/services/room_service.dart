/// Room Service - Firebase Realtime Database operations
import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import '../models/room_model.dart';

class RoomService {
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  DatabaseReference get _roomsRef => _database.ref('rooms');

  /// Generate unique 4-character room code
  String generateRoomCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final random = Random();
    return List.generate(4, (_) => chars[random.nextInt(chars.length)]).join();
  }

  /// Create new room
  Future<RoomModel> createRoom(String hostId) async {
    try {
      final roomRef = _roomsRef.push();
      final code = generateRoomCode();
      
      // Check if code already exists (very unlikely)
      final existingRoom = await getRoomByCode(code);
      if (existingRoom != null) {
        // Recursively generate new code
        return createRoom(hostId);
      }

      final room = RoomModel.create(
        id: roomRef.key!,
        code: code,
        hostId: hostId,
      );

      await roomRef.set(room.toJson());
      return room;
    } catch (e) {
      throw Exception('Failed to create room: $e');
    }
  }

  /// Join room by code
  Future<RoomModel> joinRoom(String code, String userId) async {
    try {
      final room = await getRoomByCode(code);
      if (room == null) {
        throw Exception('Room not found');
      }

      if (room.isFull()) {
        throw Exception('Room is full');
      }

      if (room.isParticipant(userId)) {
        throw Exception('Already in room');
      }

      if (room.status != RoomStatus.waiting) {
        throw Exception('Room is not accepting new members');
      }

      final updatedParticipants = [...room.participantIds, userId];
      final updatedReadyStatus = {...room.readyStatus, userId: false};

      await _roomsRef.child(room.id).update({
        'participantIds': updatedParticipants,
        'readyStatus': updatedReadyStatus,
      });

      return room.copyWith(
        participantIds: updatedParticipants,
        readyStatus: updatedReadyStatus,
      );
    } catch (e) {
      throw Exception('Failed to join room: $e');
    }
  }

  /// Get room by code
  Future<RoomModel?> getRoomByCode(String code) async {
    try {
      final snapshot = await _roomsRef
          .orderByChild('code')
          .equalTo(code.toUpperCase())
          .once();

      if (snapshot.snapshot.value == null) return null;

      final roomsMap = snapshot.snapshot.value as Map<dynamic, dynamic>;
      final roomData = roomsMap.values.first as Map<dynamic, dynamic>;
      
      return RoomModel.fromJson(Map<String, dynamic>.from(roomData));
    } catch (e) {
      throw Exception('Failed to get room: $e');
    }
  }

  /// Get room by ID
  Future<RoomModel?> getRoom(String roomId) async {
    try {
      final snapshot = await _roomsRef.child(roomId).once();
      if (snapshot.snapshot.value == null) return null;

      final data = snapshot.snapshot.value as Map<dynamic, dynamic>;
      return RoomModel.fromJson(Map<String, dynamic>.from(data));
    } catch (e) {
      throw Exception('Failed to get room: $e');
    }
  }

  /// Stream room updates
  Stream<RoomModel?> streamRoom(String roomId) {
    return _roomsRef.child(roomId).onValue.map((event) {
      if (event.snapshot.value == null) return null;
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      return RoomModel.fromJson(Map<String, dynamic>.from(data));
    });
  }

  /// Toggle ready status
  Future<void> toggleReady(String roomId, String userId, bool isReady) async {
    try {
      await _roomsRef.child(roomId).child('readyStatus').update({
        userId: isReady,
      });
    } catch (e) {
      throw Exception('Failed to update ready status: $e');
    }
  }

  /// Leave room
  Future<void> leaveRoom(String roomId, String userId) async {
    try {
      final room = await getRoom(roomId);
      if (room == null) return;

      final updatedParticipants = room.participantIds.where((id) => id != userId).toList();
      final updatedReadyStatus = Map<String, bool>.from(room.readyStatus)..remove(userId);

      if (updatedParticipants.isEmpty) {
        // Delete room if empty
        await _roomsRef.child(roomId).remove();
        return;
      }

      // If host left, assign new host
      String newHostId = room.hostId;
      if (room.isHost(userId)) {
        newHostId = updatedParticipants.first;
      }

      await _roomsRef.child(roomId).update({
        'hostId': newHostId,
        'participantIds': updatedParticipants,
        'readyStatus': updatedReadyStatus,
      });
    } catch (e) {
      throw Exception('Failed to leave room: $e');
    }
  }

  /// Start battle
  Future<void> startBattle(String roomId, String battleId) async {
    try {
      await _roomsRef.child(roomId).update({
        'battleId': battleId,
        'status': RoomStatus.inProgress.name,
      });
    } catch (e) {
      throw Exception('Failed to start battle: $e');
    }
  }

  /// Delete room
  Future<void> deleteRoom(String roomId) async {
    try {
      await _roomsRef.child(roomId).remove();
    } catch (e) {
      throw Exception('Failed to delete room: $e');
    }
  }
}
