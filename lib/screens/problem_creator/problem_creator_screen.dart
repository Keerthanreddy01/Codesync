/// Problem Creator - Create Custom Coding Challenges
import 'package:flutter/material.dart';
import 'package:codesync_arena/config/app_colors.dart';
import 'package:codesync_arena/config/app_text_styles.dart';

class ProblemCreatorScreen extends StatefulWidget {
  const ProblemCreatorScreen({super.key});

  @override
  State<ProblemCreatorScreen> createState() => _ProblemCreatorScreenState();
}

class _ProblemCreatorScreenState extends State<ProblemCreatorScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final constraintsController = TextEditingController();
  
  final testCaseInputs = <TextEditingController>[TextEditingController()];
  final testCaseOutputs = <TextEditingController>[TextEditingController()];
  
  String selectedDifficulty = 'Medium';
  bool isPublic = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    constraintsController.dispose();
    for (var controller in testCaseInputs) {
      controller.dispose();
    }
    for (var controller in testCaseOutputs) {
      controller.dispose();
    }
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'CREATE PROBLEM',
          style: AppTextStyles.heading3.copyWith(
            color: AppColors.textPrimary,
            letterSpacing: 2.0,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textTertiary,
          tabs: const [
            Tab(text: 'Details'),
            Tab(text: 'Test Cases'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDetailsTab(),
          _buildTestCasesTab(),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColors.border),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.surface,
                  foregroundColor: AppColors.textPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: AppColors.border),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _publishProblem,
                child: const Text('Publish'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'Problem Title',
            style: AppTextStyles.body1.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: titleController,
            style: AppTextStyles.body1.copyWith(color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: 'e.g., Two Sum, Merge Sorted Arrays',
              hintStyle: AppTextStyles.body1.copyWith(
                color: AppColors.textTertiary,
              ),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.primary, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Description
          Text(
            'Problem Description',
            style: AppTextStyles.body1.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: descriptionController,
            style: AppTextStyles.body1.copyWith(color: AppColors.textPrimary),
            maxLines: 6,
            decoration: InputDecoration(
              hintText: 'Describe the problem statement, input format, and expected output',
              hintStyle: AppTextStyles.body1.copyWith(
                color: AppColors.textTertiary,
              ),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.primary, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Constraints
          Text(
            'Constraints',
            style: AppTextStyles.body1.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: constraintsController,
            style: AppTextStyles.body1.copyWith(color: AppColors.textPrimary),
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'e.g., 1 ≤ n ≤ 10^5, -10^9 ≤ nums[i] ≤ 10^9',
              hintStyle: AppTextStyles.body1.copyWith(
                color: AppColors.textTertiary,
              ),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.primary, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Difficulty
          Text(
            'Difficulty Level',
            style: AppTextStyles.body1.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: ['Easy', 'Medium', 'Hard'].map((difficulty) {
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => selectedDifficulty = difficulty),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: selectedDifficulty == difficulty
                          ? _getDifficultyColor(difficulty).withOpacity(0.2)
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: selectedDifficulty == difficulty
                            ? _getDifficultyColor(difficulty)
                            : AppColors.border,
                        width: selectedDifficulty == difficulty ? 2 : 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        difficulty,
                        style: AppTextStyles.body2.copyWith(
                          color: selectedDifficulty == difficulty
                              ? _getDifficultyColor(difficulty)
                              : AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // Share Settings
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Make Public',
                      style: AppTextStyles.body1.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'Share with other users',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
                Switch(
                  value: isPublic,
                  onChanged: (value) => setState(() => isPublic = value),
                  activeColor: AppColors.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestCasesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Test Cases',
            style: AppTextStyles.heading2.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(
            testCaseInputs.length,
            (index) => Column(
              key: ValueKey(index),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Test Case ${index + 1}',
                      style: AppTextStyles.body1.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (testCaseInputs.length > 1)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            testCaseInputs.removeAt(index);
                            testCaseOutputs.removeAt(index);
                          });
                        },
                        child: Icon(
                          Icons.delete_outline,
                          color: Colors.red.withOpacity(0.7),
                          size: 20,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                // Input
                Text(
                  'Input',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                TextField(
                  controller: testCaseInputs[index],
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.textPrimary,
                    fontFamily: 'monospace',
                  ),
                  maxLines: 3,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppColors.border),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Output
                Text(
                  'Expected Output',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                TextField(
                  controller: testCaseOutputs[index],
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.textPrimary,
                    fontFamily: 'monospace',
                  ),
                  maxLines: 3,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppColors.border),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                setState(() {
                  testCaseInputs.add(TextEditingController());
                  testCaseOutputs.add(TextEditingController());
                });
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Test Case'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: BorderSide(color: AppColors.primary),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _publishProblem() {
    if (titleController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        testCaseInputs.every((c) => c.text.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '✅ Problem "${titleController.text}" published!',
        ),
        backgroundColor: Colors.green,
      ),
    );

    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pop(context);
    });
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.amber;
      case 'hard':
        return Colors.red;
      default:
        return AppColors.primary;
    }
  }
}
