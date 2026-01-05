/// Feature Flags System
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// All feature flags available in the system
enum Feature {
  // Timeline & Decision Events
  decisionTimeline('decision_timeline', true),
  timelineReplay('timeline_replay', true),

  // Risk & Momentum
  branchRiskScoring('branch_risk_scoring', true),
  momentumSystem('momentum_system', true),

  // Analytics
  typingVelocityTracking('typing_velocity_tracking', true),
  fileHeatmap('file_heatmap', true),
  teamChemistry('team_chemistry', true),
  codeDNAProfiling('code_dna_profiling', false), // Expensive, off by default

  // Judgement
  advancedJudging('advanced_judging', true),
  multiCriteriaScoring('multi_criteria_scoring', true),

  // Replay
  fullReplayEngine('full_replay_engine', true),
  replayTimeScrub('replay_time_scrub', true),

  // Anti-Cheat
  antiCheatDetection('anti_cheat_detection', true),
  pasteBurstDetection('paste_burst_detection', true),
  tokenSimilarityCheck('token_similarity_check', true),

  // Performance
  performanceOptimization('performance_optimization', true),
  diffOnlyWebSocket('diff_only_websocket', true),

  // Spectator
  spectatorMode('spectator_mode', true),
  liveCommentary('live_commentary', false), // Requires backend
  spectatorAnalytics('spectator_analytics', true);

  const Feature(this.id, this.enabledByDefault);

  final String id;
  final bool enabledByDefault;
}

/// Feature flag state
class FeatureFlagState {
  final Map<Feature, bool> flags;
  final DateTime lastUpdated;

  FeatureFlagState({
    required this.flags,
    required this.lastUpdated,
  });

  bool isEnabled(Feature feature) => flags[feature] ?? feature.enabledByDefault;

  FeatureFlagState copyWith({
    Map<Feature, bool>? flags,
    DateTime? lastUpdated,
  }) {
    return FeatureFlagState(
      flags: flags ?? this.flags,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  /// Create with all defaults
  factory FeatureFlagState.defaults() {
    return FeatureFlagState(
      flags: {
        for (var feature in Feature.values) feature: feature.enabledByDefault
      },
      lastUpdated: DateTime.now(),
    );
  }
}

/// Feature flag manager
class FeatureFlagManager {
  final FeatureFlagState _state;

  FeatureFlagManager({FeatureFlagState? initialState})
      : _state = initialState ?? FeatureFlagState.defaults();

  /// Check if feature is enabled
  bool isEnabled(Feature feature) {
    return _state.isEnabled(feature);
  }

  /// Get all enabled features
  List<Feature> getEnabledFeatures() {
    return Feature.values.where((f) => isEnabled(f)).toList();
  }

  /// Get all disabled features
  List<Feature> getDisabledFeatures() {
    return Feature.values.where((f) => !isEnabled(f)).toList();
  }

  /// Toggle feature on/off
  FeatureFlagState toggleFeature(Feature feature) {
    final newFlags = Map<Feature, bool>.from(_state.flags);
    newFlags[feature] = !_state.isEnabled(feature);
    return _state.copyWith(
      flags: newFlags,
      lastUpdated: DateTime.now(),
    );
  }

  /// Enable specific feature
  FeatureFlagState enableFeature(Feature feature) {
    if (isEnabled(feature)) return _state;
    final newFlags = Map<Feature, bool>.from(_state.flags);
    newFlags[feature] = true;
    return _state.copyWith(
      flags: newFlags,
      lastUpdated: DateTime.now(),
    );
  }

  /// Disable specific feature
  FeatureFlagState disableFeature(Feature feature) {
    if (!isEnabled(feature)) return _state;
    final newFlags = Map<Feature, bool>.from(_state.flags);
    newFlags[feature] = false;
    return _state.copyWith(
      flags: newFlags,
      lastUpdated: DateTime.now(),
    );
  }

  /// Enable multiple features
  FeatureFlagState enableFeatures(List<Feature> features) {
    var state = _state;
    for (var feature in features) {
      final newFlags = Map<Feature, bool>.from(state.flags);
      newFlags[feature] = true;
      state = state.copyWith(
        flags: newFlags,
        lastUpdated: DateTime.now(),
      );
    }
    return state;
  }

  /// Disable multiple features
  FeatureFlagState disableFeatures(List<Feature> features) {
    var state = _state;
    for (var feature in features) {
      final newFlags = Map<Feature, bool>.from(state.flags);
      newFlags[feature] = false;
      state = state.copyWith(
        flags: newFlags,
        lastUpdated: DateTime.now(),
      );
    }
    return state;
  }

  /// Reset to defaults
  FeatureFlagState resetToDefaults() {
    return FeatureFlagState.defaults();
  }

  /// Export flags as JSON for admin panel
  Map<String, dynamic> toJson() {
    return {
      'flags': {
        for (var feature in Feature.values)
          feature.id: isEnabled(feature)
      },
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  /// Get current state
  FeatureFlagState getCurrentState() => _state;

  DateTime get lastUpdated => _state.lastUpdated;
}

/// Riverpod providers
final featureFlagProvider =
    StateNotifierProvider<FeatureFlagNotifier, FeatureFlagState>((ref) {
  return FeatureFlagNotifier();
});

/// Check if specific feature is enabled
final isFeatureEnabledProvider =
    StateProvider.family<bool, Feature>((ref, feature) {
  final flags = ref.watch(featureFlagProvider);
  return flags.isEnabled(feature);
});

class FeatureFlagNotifier extends StateNotifier<FeatureFlagState> {
  FeatureFlagNotifier() : super(FeatureFlagState.defaults());

  void toggleFeature(Feature feature) {
    final manager = FeatureFlagManager(initialState: state);
    state = manager.toggleFeature(feature);
  }

  void enableFeature(Feature feature) {
    final manager = FeatureFlagManager(initialState: state);
    state = manager.enableFeature(feature);
  }

  void disableFeature(Feature feature) {
    final manager = FeatureFlagManager(initialState: state);
    state = manager.disableFeature(feature);
  }

  void enableFeatures(List<Feature> features) {
    final manager = FeatureFlagManager(initialState: state);
    state = manager.enableFeatures(features);
  }

  void disableFeatures(List<Feature> features) {
    final manager = FeatureFlagManager(initialState: state);
    state = manager.disableFeatures(features);
  }

  void resetToDefaults() {
    state = FeatureFlagState.defaults();
  }

  void loadFromAdmin(Map<String, bool> flags) {
    final newFlags = <Feature, bool>{};
    for (var feature in Feature.values) {
      newFlags[feature] = flags[feature.id] ?? feature.enabledByDefault;
    }
    state = state.copyWith(
      flags: newFlags,
      lastUpdated: DateTime.now(),
    );
  }
}
