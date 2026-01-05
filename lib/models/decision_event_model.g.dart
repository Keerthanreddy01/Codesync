// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'decision_event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DecisionEventMetadata _$DecisionEventMetadataFromJson(
        Map<String, dynamic> json) =>
    DecisionEventMetadata(
      linesChanged: (json['linesChanged'] as num?)?.toInt(),
      filesTouched: (json['filesTouched'] as num?)?.toInt(),
      reason: json['reason'] as String?,
      errorType: json['errorType'] as String?,
      testsPassed: (json['testsPassed'] as num?)?.toInt(),
      testsFailed: (json['testsFailed'] as num?)?.toInt(),
      executionTime: (json['executionTime'] as num?)?.toDouble(),
      additionalData: json['additionalData'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$DecisionEventMetadataToJson(
        DecisionEventMetadata instance) =>
    <String, dynamic>{
      'linesChanged': instance.linesChanged,
      'filesTouched': instance.filesTouched,
      'reason': instance.reason,
      'errorType': instance.errorType,
      'testsPassed': instance.testsPassed,
      'testsFailed': instance.testsFailed,
      'executionTime': instance.executionTime,
      'additionalData': instance.additionalData,
    };

DecisionEvent _$DecisionEventFromJson(Map<String, dynamic> json) =>
    DecisionEvent(
      id: json['id'] as String,
      teamId: json['teamId'] as String,
      branchId: json['branchId'] as String,
      userId: json['userId'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      eventType: $enumDecode(_$DecisionEventTypeEnumMap, json['eventType']),
      metadata: DecisionEventMetadata.fromJson(
          json['metadata'] as Map<String, dynamic>),
      sequenceNumber: (json['sequenceNumber'] as num).toInt(),
    );

Map<String, dynamic> _$DecisionEventToJson(DecisionEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'teamId': instance.teamId,
      'branchId': instance.branchId,
      'userId': instance.userId,
      'timestamp': instance.timestamp.toIso8601String(),
      'eventType': _$DecisionEventTypeEnumMap[instance.eventType]!,
      'metadata': instance.metadata,
      'sequenceNumber': instance.sequenceNumber,
    };

const _$DecisionEventTypeEnumMap = {
  DecisionEventType.strategyChange: 'strategy_change',
  DecisionEventType.merge: 'merge',
  DecisionEventType.rollback: 'rollback',
  DecisionEventType.testFail: 'test_fail',
  DecisionEventType.testPass: 'test_pass',
  DecisionEventType.branchCreate: 'branch_create',
  DecisionEventType.codePush: 'code_push',
  DecisionEventType.syntaxError: 'syntax_error',
};

DecisionTimeline _$DecisionTimelineFromJson(Map<String, dynamic> json) =>
    DecisionTimeline(
      battleId: json['battleId'] as String,
      events: (json['events'] as List<dynamic>)
          .map((e) => DecisionEvent.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalEvents: (json['totalEvents'] as num).toInt(),
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String),
    );

Map<String, dynamic> _$DecisionTimelineToJson(DecisionTimeline instance) =>
    <String, dynamic>{
      'battleId': instance.battleId,
      'events': instance.events,
      'totalEvents': instance.totalEvents,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
    };
