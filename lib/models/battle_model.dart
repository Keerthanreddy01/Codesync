/// Battle Model
class BattleModel {
  final String id;
  final String roomId;
  final String problemId;
  final List<String> participantIds;
  final Map<String, String> submissions; // userId -> code
  final Map<String, bool> submittedStatus; // userId -> hasSubmitted
  final Map<String, int> scores; // userId -> score
  final DateTime startTime;
  final DateTime? endTime;
  final int timeLimitSeconds;
  final BattleStatus status;

  BattleModel({
    required this.id,
    required this.roomId,
    required this.problemId,
    required this.participantIds,
    required this.submissions,
    required this.submittedStatus,
    required this.scores,
    required this.startTime,
    this.endTime,
    this.timeLimitSeconds = 600, // 10 minutes default
    this.status = BattleStatus.inProgress,
  });

  factory BattleModel.create({
    required String id,
    required String roomId,
    required String problemId,
    required List<String> participantIds,
    int timeLimitSeconds = 600,
  }) {
    return BattleModel(
      id: id,
      roomId: roomId,
      problemId: problemId,
      participantIds: participantIds,
      submissions: {},
      submittedStatus: {for (var id in participantIds) id: false},
      scores: {},
      startTime: DateTime.now(),
      timeLimitSeconds: timeLimitSeconds,
    );
  }

  factory BattleModel.fromJson(Map<String, dynamic> json) {
    return BattleModel(
      id: json['id'] as String,
      roomId: json['roomId'] as String,
      problemId: json['problemId'] as String,
      participantIds: List<String>.from(json['participantIds'] as List),
      submissions: Map<String, String>.from(json['submissions'] as Map? ?? {}),
      submittedStatus: Map<String, bool>.from(json['submittedStatus'] as Map),
      scores: Map<String, int>.from(json['scores'] as Map? ?? {}),
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime'] as String) : null,
      timeLimitSeconds: json['timeLimitSeconds'] as int? ?? 600,
      status: BattleStatus.values.byName(json['status'] as String? ?? 'inProgress'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'roomId': roomId,
      'problemId': problemId,
      'participantIds': participantIds,
      'submissions': submissions,
      'submittedStatus': submittedStatus,
      'scores': scores,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'timeLimitSeconds': timeLimitSeconds,
      'status': status.name,
    };
  }

  bool hasUserSubmitted(String userId) => submittedStatus[userId] ?? false;
  bool haveAllSubmitted() => participantIds.every((id) => submittedStatus[id] == true);
  int getRemainingSeconds() {
    final elapsed = DateTime.now().difference(startTime).inSeconds;
    return (timeLimitSeconds - elapsed).clamp(0, timeLimitSeconds);
  }

  BattleModel copyWith({
    String? id,
    String? roomId,
    String? problemId,
    List<String>? participantIds,
    Map<String, String>? submissions,
    Map<String, bool>? submittedStatus,
    Map<String, int>? scores,
    DateTime? startTime,
    DateTime? endTime,
    int? timeLimitSeconds,
    BattleStatus? status,
  }) {
    return BattleModel(
      id: id ?? this.id,
      roomId: roomId ?? this.roomId,
      problemId: problemId ?? this.problemId,
      participantIds: participantIds ?? this.participantIds,
      submissions: submissions ?? this.submissions,
      submittedStatus: submittedStatus ?? this.submittedStatus,
      scores: scores ?? this.scores,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      timeLimitSeconds: timeLimitSeconds ?? this.timeLimitSeconds,
      status: status ?? this.status,
    );
  }
}

enum BattleStatus {
  inProgress,
  completed,
  cancelled,
}
