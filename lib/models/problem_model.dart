/// Problem Model - Coding Challenge
class ProblemModel {
  final String id;
  final String title;
  final String description;
  final String difficulty;
  final List<TestCase> testCases;
  final String starterCode;
  final List<String> tags;

  ProblemModel({
    required this.id,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.testCases,
    required this.starterCode,
    this.tags = const [],
  });

  factory ProblemModel.fromJson(Map<String, dynamic> json) {
    return ProblemModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      difficulty: json['difficulty'] as String,
      testCases: (json['testCases'] as List)
          .map((tc) => TestCase.fromJson(tc as Map<String, dynamic>))
          .toList(),
      starterCode: json['starterCode'] as String,
      tags: List<String>.from(json['tags'] as List? ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'difficulty': difficulty,
      'testCases': testCases.map((tc) => tc.toJson()).toList(),
      'starterCode': starterCode,
      'tags': tags,
    };
  }
}

class TestCase {
  final String input;
  final String expectedOutput;
  final bool isHidden;

  TestCase({
    required this.input,
    required this.expectedOutput,
    this.isHidden = false,
  });

  factory TestCase.fromJson(Map<String, dynamic> json) {
    return TestCase(
      input: json['input'] as String,
      expectedOutput: json['expectedOutput'] as String,
      isHidden: json['isHidden'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'input': input,
      'expectedOutput': expectedOutput,
      'isHidden': isHidden,
    };
  }
}
