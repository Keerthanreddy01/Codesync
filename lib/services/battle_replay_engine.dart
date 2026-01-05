/// Battle Replay Engine
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/decision_event_model.dart';

/// State for replay playback
enum ReplayPlaybackState {
  idle,
  playing,
  paused,
  finished,
}

/// Replay state manager
class BattleReplayEngine {
  final String battleId;
  final List<DecisionEvent> events;
  
  ReplayPlaybackState _playbackState = ReplayPlaybackState.idle;
  int _currentEventIndex = 0;
  DateTime? _playbackStartTime;
  Duration _currentTime = Duration.zero;

  BattleReplayEngine({
    required this.battleId,
    required this.events,
  });

  /// Start replay from beginning
  void play() {
    _playbackState = ReplayPlaybackState.playing;
    _playbackStartTime = DateTime.now();
    _currentEventIndex = 0;
  }

  /// Pause current replay
  void pause() {
    _playbackState = ReplayPlaybackState.paused;
  }

  /// Resume paused replay
  void resume() {
    if (_playbackState == ReplayPlaybackState.paused) {
      _playbackState = ReplayPlaybackState.playing;
      _playbackStartTime = DateTime.now();
    }
  }

  /// Seek to specific time in replay
  void seekTo(Duration time) {
    _currentTime = time;
    _updateCurrentEventIndex();
  }

  /// Get current event
  DecisionEvent? getCurrentEvent() {
    if (_currentEventIndex < events.length) {
      return events[_currentEventIndex];
    }
    return null;
  }

  /// Get all events up to current time
  List<DecisionEvent> getEventsUntilNow() {
    return events.take(_currentEventIndex + 1).toList();
  }

  /// Get events in range for visualization
  List<DecisionEvent> getEventsInRange(Duration start, Duration end) {
    return events.where((event) {
      final eventTime = event.timestamp.difference(events.first.timestamp);
      return eventTime.compareTo(start) >= 0 && eventTime.compareTo(end) <= 0;
    }).toList();
  }

  /// Get statistics for replay
  Map<String, dynamic> getReplayStats() {
    return {
      'totalEvents': events.length,
      'currentIndex': _currentEventIndex,
      'duration': _calculateTotalDuration(),
      'eventCounts': _countEventsByType(),
      'timeline': _buildTimeline(),
    };
  }

  /// Jump to specific event
  void jumpToEvent(int eventIndex) {
    if (eventIndex >= 0 && eventIndex < events.length) {
      _currentEventIndex = eventIndex;
      _currentTime =
          events[eventIndex].timestamp.difference(events.first.timestamp);
    }
  }

  /// Get next significant event (test, merge, etc)
  DecisionEvent? getNextSignificantEvent() {
    final significantTypes = [
      DecisionEventType.testPass,
      DecisionEventType.testFail,
      DecisionEventType.merge,
    ];

    for (int i = _currentEventIndex + 1; i < events.length; i++) {
      if (significantTypes.contains(events[i].eventType)) {
        return events[i];
      }
    }
    return null;
  }

  /// Get timeline markers for UI
  List<ReplayMarker> getTimelineMarkers() {
    final markers = <ReplayMarker>[];
    final groupedEvents = <DecisionEventType, List<DecisionEvent>>{};

    for (var event in events) {
      if (!groupedEvents.containsKey(event.eventType)) {
        groupedEvents[event.eventType] = [];
      }
      groupedEvents[event.eventType]!.add(event);
    }

    groupedEvents.forEach((type, eventList) {
      for (var event in eventList) {
        markers.add(ReplayMarker(
          eventType: type,
          time: event.timestamp.difference(events.first.timestamp),
          label: _getLabelForEvent(event),
        ));
      }
    });

    markers.sort((a, b) => a.time.compareTo(b.time));
    return markers;
  }

  // Private methods
  void _updateCurrentEventIndex() {
    for (int i = 0; i < events.length; i++) {
      final eventTime = events[i].timestamp.difference(events.first.timestamp);
      if (eventTime.compareTo(_currentTime) > 0) {
        _currentEventIndex = (i - 1).clamp(0, events.length - 1);
        return;
      }
    }
    _currentEventIndex = events.length - 1;
  }

  Duration _calculateTotalDuration() {
    if (events.isEmpty) return Duration.zero;
    return events.last.timestamp.difference(events.first.timestamp);
  }

  Map<String, int> _countEventsByType() {
    final counts = <String, int>{};
    for (var event in events) {
      final key = event.eventType.toString().split('.').last;
      counts[key] = (counts[key] ?? 0) + 1;
    }
    return counts;
  }

  List<dynamic> _buildTimeline() {
    return events
        .map((e) => {
              'time': e.timestamp.difference(events.first.timestamp),
              'type': e.eventType.toString(),
              'description': _getLabelForEvent(e),
            })
        .toList();
  }

  String _getLabelForEvent(DecisionEvent event) {
    switch (event.eventType) {
      case DecisionEventType.testPass:
        return 'Tests Passed';
      case DecisionEventType.testFail:
        return 'Test Failed';
      case DecisionEventType.merge:
        return 'Merged';
      case DecisionEventType.rollback:
        return 'Rollback';
      case DecisionEventType.strategyChange:
        return 'Strategy Changed';
      case DecisionEventType.branchCreate:
        return 'Branch Created';
      case DecisionEventType.codePush:
        return 'Code Pushed';
      case DecisionEventType.syntaxError:
        return 'Syntax Error';
    }
  }
}

/// Marker for timeline visualization
class ReplayMarker {
  final DecisionEventType eventType;
  final Duration time;
  final String label;

  ReplayMarker({
    required this.eventType,
    required this.time,
    required this.label,
  });
}

/// Riverpod provider for replay engine
final battleReplayProvider = StateNotifierProvider.family<
    BattleReplayNotifier,
    BattleReplayEngine,
    (String battleId, List<DecisionEvent> events)>((ref, args) {
  return BattleReplayNotifier(
    battleId: args.$1,
    events: args.$2,
  );
});

class BattleReplayNotifier extends StateNotifier<BattleReplayEngine> {
  BattleReplayNotifier({
    required String battleId,
    required List<DecisionEvent> events,
  }) : super(BattleReplayEngine(battleId: battleId, events: events));

  void play() {
    state.play();
    state = state;
  }

  void pause() {
    state.pause();
    state = state;
  }

  void resume() {
    state.resume();
    state = state;
  }

  void seekTo(Duration time) {
    state.seekTo(time);
    state = state;
  }

  void jumpToEvent(int eventIndex) {
    state.jumpToEvent(eventIndex);
    state = state;
  }

  void updatePlayback(Duration elapsed) {
    state._currentTime = elapsed;
    state._updateCurrentEventIndex();
    state = state;
  }
}
