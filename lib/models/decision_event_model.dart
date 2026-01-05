/// Decision Events & Timeline Models
import 'package:json_annotation/json_annotation.dart';

part 'decision_event_model.g.dart';

/// Event types for decision timeline
enum DecisionEventType {
  @JsonValue('strategy_change')
  strategyChange,
  @JsonValue('merge')
  merge,
  @JsonValue('rollback')
  rollback,
  @JsonValue('test_fail')
  testFail,
  @JsonValue('test_pass')
  testPass,
  @JsonValue('branch_create')
  branchCreate,
  @JsonValue('code_push')
  codePush,
  @JsonValue('syntax_error')
  syntaxError,
}

@JsonSerializable()
class DecisionEventMetadata {
  final int? linesChanged;
  final int? filesTouched;
  final String? reason;
  final String? errorType;
  final int? testsPassed;
  final int? testsFailed;
  final double? executionTime;
  final Map<String, dynamic>? additionalData;

  DecisionEventMetadata({
    this.linesChanged,
    this.filesTouched,
    this.reason,
    this.errorType,
    this.testsPassed,
    this.testsFailed,
    this.executionTime,
    this.additionalData,
  });

  factory DecisionEventMetadata.fromJson(Map<String, dynamic> json) =>
      _$DecisionEventMetadataFromJson(json);
  Map<String, dynamic> toJson() => _$DecisionEventMetadataToJson(this);
}

@JsonSerializable()
class DecisionEvent {
  final String id;
  final String teamId;
  final String branchId;
  final String userId;
  final DateTime timestamp;
  final DecisionEventType eventType;
  final DecisionEventMetadata metadata;
  final int sequenceNumber;

  DecisionEvent({
    required this.id,
    required this.teamId,
    required this.branchId,
    required this.userId,
    required this.timestamp,
    required this.eventType,
    required this.metadata,
    required this.sequenceNumber,
  });

  factory DecisionEvent.fromJson(Map<String, dynamic> json) =>
      _$DecisionEventFromJson(json);
  Map<String, dynamic> toJson() => _$DecisionEventToJson(this);

  DecisionEvent copyWith({
    String? id,
    String? teamId,
    String? branchId,
    String? userId,
    DateTime? timestamp,
    DecisionEventType? eventType,
    DecisionEventMetadata? metadata,
    int? sequenceNumber,
  }) {
    return DecisionEvent(
      id: id ?? this.id,
      teamId: teamId ?? this.teamId,
      branchId: branchId ?? this.branchId,
      userId: userId ?? this.userId,
      timestamp: timestamp ?? this.timestamp,
      eventType: eventType ?? this.eventType,
      metadata: metadata ?? this.metadata,
      sequenceNumber: sequenceNumber ?? this.sequenceNumber,
    );
  }
}

/// Timeline for battle decision events
@JsonSerializable()
class DecisionTimeline {
  final String battleId;
  final List<DecisionEvent> events;
  final int totalEvents;
  final DateTime startTime;
  final DateTime? endTime;

  DecisionTimeline({
    required this.battleId,
    required this.events,
    required this.totalEvents,
    required this.startTime,
    this.endTime,
  });

  factory DecisionTimeline.fromJson(Map<String, dynamic> json) =>
      _$DecisionTimelineFromJson(json);
  Map<String, dynamic> toJson() => _$DecisionTimelineToJson(this);

  /// Get events in chronological order
  List<DecisionEvent> getOrderedEvents() {
    return events..sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }

  /// Get events by type
  List<DecisionEvent> getEventsByType(DecisionEventType type) {
    return events.where((e) => e.eventType == type).toList();
  }

  /// Get events in time range
  List<DecisionEvent> getEventsInRange(DateTime start, DateTime end) {
    return events
        .where((e) => e.timestamp.isAfter(start) && e.timestamp.isBefore(end))
        .toList();
  }
}
