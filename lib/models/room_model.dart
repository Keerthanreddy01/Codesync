/// Room Model - Battle Room
class RoomModel {
  final String id;
  final String code; // 4-character room code
  final String hostId;
  final List<String> participantIds;
  final Map<String, bool> readyStatus; // userId -> isReady
  final DateTime createdAt;
  final String? battleId;
  final int maxCapacity;
  final RoomStatus status;

  RoomModel({
    required this.id,
    required this.code,
    required this.hostId,
    required this.participantIds,
    required this.readyStatus,
    required this.createdAt,
    this.battleId,
    this.maxCapacity = 4,
    this.status = RoomStatus.waiting,
  });

  factory RoomModel.create({
    required String id,
    required String code,
    required String hostId,
  }) {
    return RoomModel(
      id: id,
      code: code,
      hostId: hostId,
      participantIds: [hostId],
      readyStatus: {hostId: false},
      createdAt: DateTime.now(),
    );
  }

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      id: json['id'] as String,
      code: json['code'] as String,
      hostId: json['hostId'] as String,
      participantIds: List<String>.from(json['participantIds'] as List),
      readyStatus: Map<String, bool>.from(json['readyStatus'] as Map),
      createdAt: DateTime.parse(json['createdAt'] as String),
      battleId: json['battleId'] as String?,
      maxCapacity: json['maxCapacity'] as int? ?? 4,
      status: RoomStatus.values.byName(json['status'] as String? ?? 'waiting'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'hostId': hostId,
      'participantIds': participantIds,
      'readyStatus': readyStatus,
      'createdAt': createdAt.toIso8601String(),
      'battleId': battleId,
      'maxCapacity': maxCapacity,
      'status': status.name,
    };
  }

  bool isHost(String userId) => hostId == userId;
  bool isFull() => participantIds.length >= maxCapacity;
  bool isParticipant(String userId) => participantIds.contains(userId);
  bool isUserReady(String userId) => readyStatus[userId] ?? false;
  bool areAllReady() => participantIds.every((id) => readyStatus[id] == true);

  RoomModel copyWith({
    String? id,
    String? code,
    String? hostId,
    List<String>? participantIds,
    Map<String, bool>? readyStatus,
    DateTime? createdAt,
    String? battleId,
    int? maxCapacity,
    RoomStatus? status,
  }) {
    return RoomModel(
      id: id ?? this.id,
      code: code ?? this.code,
      hostId: hostId ?? this.hostId,
      participantIds: participantIds ?? this.participantIds,
      readyStatus: readyStatus ?? this.readyStatus,
      createdAt: createdAt ?? this.createdAt,
      battleId: battleId ?? this.battleId,
      maxCapacity: maxCapacity ?? this.maxCapacity,
      status: status ?? this.status,
    );
  }
}

enum RoomStatus {
  waiting,
  starting,
  inProgress,
  completed,
}
