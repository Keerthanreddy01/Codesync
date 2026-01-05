/// Branch Model - Git-style team branch
class BranchModel {
  final String id;
  final String battleId;
  final String teamId;
  final String teamName;
  final String branchName;
  final String code;
  final BranchStatus status;
  final DateTime createdAt;
  final Map<String, BranchMember> members;
  final BranchStats stats;
  final DateTime? submittedAt;
  final String? lastEditor;

  BranchModel({
    required this.id,
    required this.battleId,
    required this.teamId,
    required this.teamName,
    required this.branchName,
    required this.code,
    required this.status,
    required this.createdAt,
    required this.members,
    required this.stats,
    this.submittedAt,
    this.lastEditor,
  });

  factory BranchModel.create({
    required String id,
    required String battleId,
    required String teamId,
    required String teamName,
    required String starterCode,
    required List<String> memberIds,
  }) {
    final branchName = '${teamName.toLowerCase().replaceAll(' ', '-')}-solution';
    return BranchModel(
      id: id,
      battleId: battleId,
      teamId: teamId,
      teamName: teamName,
      branchName: branchName,
      code: starterCode,
      status: BranchStatus.active,
      createdAt: DateTime.now(),
      members: {
        for (var memberId in memberIds)
          memberId: BranchMember(
            userId: memberId,
            username: 'User $memberId',
            cursorPosition: 0,
            cursorLine: 0,
            isTyping: false,
            status: MemberStatus.idle,
            lastActivity: DateTime.now(),
          ),
      },
      stats: BranchStats.empty(),
    );
  }

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    return BranchModel(
      id: json['id'] as String,
      battleId: json['battleId'] as String,
      teamId: json['teamId'] as String,
      teamName: json['teamName'] as String,
      branchName: json['branchName'] as String,
      code: json['code'] as String,
      status: BranchStatus.values.byName(json['status'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      members: (json['members'] as Map<dynamic, dynamic>).map(
        (key, value) => MapEntry(
          key as String,
          BranchMember.fromJson(Map<String, dynamic>.from(value as Map)),
        ),
      ),
      stats: BranchStats.fromJson(Map<String, dynamic>.from(json['stats'] as Map)),
      submittedAt: json['submittedAt'] != null
          ? DateTime.parse(json['submittedAt'] as String)
          : null,
      lastEditor: json['lastEditor'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'battleId': battleId,
      'teamId': teamId,
      'teamName': teamName,
      'branchName': branchName,
      'code': code,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'members': members.map((key, value) => MapEntry(key, value.toJson())),
      'stats': stats.toJson(),
      'submittedAt': submittedAt?.toIso8601String(),
      'lastEditor': lastEditor,
    };
  }

  bool isTeamMember(String userId) => members.containsKey(userId);
  bool isSubmitted() => status == BranchStatus.submitted;
  bool canEdit(String userId) => isTeamMember(userId) && !isSubmitted();
  int getLineCount() => code.split('\n').length;
  int getActiveMembers() => members.values.where((m) => m.isActive()).length;

  BranchModel copyWith({
    String? id,
    String? battleId,
    String? teamId,
    String? teamName,
    String? branchName,
    String? code,
    BranchStatus? status,
    DateTime? createdAt,
    Map<String, BranchMember>? members,
    BranchStats? stats,
    DateTime? submittedAt,
    String? lastEditor,
  }) {
    return BranchModel(
      id: id ?? this.id,
      battleId: battleId ?? this.battleId,
      teamId: teamId ?? this.teamId,
      teamName: teamName ?? this.teamName,
      branchName: branchName ?? this.branchName,
      code: code ?? this.code,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      members: members ?? this.members,
      stats: stats ?? this.stats,
      submittedAt: submittedAt ?? this.submittedAt,
      lastEditor: lastEditor ?? this.lastEditor,
    );
  }
}

enum BranchStatus {
  active,
  submitted,
  judging,
}

class BranchMember {
  final String userId;
  final String username;
  final int cursorPosition;
  final int cursorLine;
  final bool isTyping;
  final MemberStatus status;
  final DateTime lastActivity;

  BranchMember({
    required this.userId,
    required this.username,
    required this.cursorPosition,
    required this.cursorLine,
    required this.isTyping,
    required this.status,
    required this.lastActivity,
  });

  factory BranchMember.fromJson(Map<String, dynamic> json) {
    return BranchMember(
      userId: json['userId'] as String,
      username: json['username'] as String,
      cursorPosition: json['cursorPosition'] as int,
      cursorLine: json['cursorLine'] as int,
      isTyping: json['isTyping'] as bool,
      status: MemberStatus.values.byName(json['status'] as String),
      lastActivity: DateTime.parse(json['lastActivity'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'cursorPosition': cursorPosition,
      'cursorLine': cursorLine,
      'isTyping': isTyping,
      'status': status.name,
      'lastActivity': lastActivity.toIso8601String(),
    };
  }

  bool isActive() {
    final now = DateTime.now();
    return now.difference(lastActivity).inSeconds < 30;
  }

  BranchMember copyWith({
    String? userId,
    String? username,
    int? cursorPosition,
    int? cursorLine,
    bool? isTyping,
    MemberStatus? status,
    DateTime? lastActivity,
  }) {
    return BranchMember(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      cursorPosition: cursorPosition ?? this.cursorPosition,
      cursorLine: cursorLine ?? this.cursorLine,
      isTyping: isTyping ?? this.isTyping,
      status: status ?? this.status,
      lastActivity: lastActivity ?? this.lastActivity,
    );
  }
}

enum MemberStatus {
  idle,
  typing,
  testing,
  submitted,
}

class BranchStats {
  final int lineCount;
  final DateTime lastEdit;
  final int testRuns;
  final int testsPassed;
  final int testsFailed;

  BranchStats({
    required this.lineCount,
    required this.lastEdit,
    required this.testRuns,
    required this.testsPassed,
    required this.testsFailed,
  });

  factory BranchStats.empty() {
    return BranchStats(
      lineCount: 0,
      lastEdit: DateTime.now(),
      testRuns: 0,
      testsPassed: 0,
      testsFailed: 0,
    );
  }

  factory BranchStats.fromJson(Map<String, dynamic> json) {
    return BranchStats(
      lineCount: json['lineCount'] as int,
      lastEdit: DateTime.parse(json['lastEdit'] as String),
      testRuns: json['testRuns'] as int,
      testsPassed: json['testsPassed'] as int? ?? 0,
      testsFailed: json['testsFailed'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lineCount': lineCount,
      'lastEdit': lastEdit.toIso8601String(),
      'testRuns': testRuns,
      'testsPassed': testsPassed,
      'testsFailed': testsFailed,
    };
  }

  BranchStats copyWith({
    int? lineCount,
    DateTime? lastEdit,
    int? testRuns,
    int? testsPassed,
    int? testsFailed,
  }) {
    return BranchStats(
      lineCount: lineCount ?? this.lineCount,
      lastEdit: lastEdit ?? this.lastEdit,
      testRuns: testRuns ?? this.testRuns,
      testsPassed: testsPassed ?? this.testsPassed,
      testsFailed: testsFailed ?? this.testsFailed,
    );
  }
}
