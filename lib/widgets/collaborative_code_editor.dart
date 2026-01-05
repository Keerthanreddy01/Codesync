/// Collaborative Code Editor Widget
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/app_colors.dart';
import '../../config/app_text_styles.dart';
import '../../providers/branch_providers.dart';
import '../../providers/room_providers.dart';
import '../../models/branch_model.dart';

class CollaborativeCodeEditor extends ConsumerStatefulWidget {
  final bool readOnly;
  final String? initialCode;

  const CollaborativeCodeEditor({
    super.key,
    this.readOnly = false,
    this.initialCode,
  });

  @override
  ConsumerState<CollaborativeCodeEditor> createState() =>
      _CollaborativeCodeEditorState();
}

class _CollaborativeCodeEditorState
    extends ConsumerState<CollaborativeCodeEditor> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isLocalEdit = false;
  int _lastCursorPosition = 0;

  @override
  void initState() {
    super.initState();
    if (widget.initialCode != null) {
      _controller.text = widget.initialCode!;
    }

    _controller.addListener(_onLocalCodeChange);
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onLocalCodeChange() {
    if (!_isLocalEdit) return;

    final userId = ref.read(currentUserIdProvider) ?? 'user123';
    final code = _controller.text;

    // Update typing status
    final branchActions = ref.read(branchActionsProvider);
    branchActions.updateStatus(
      userId: userId,
      status: MemberStatus.typing,
      isTyping: true,
    );

    // Sync code with debouncing
    final syncManager = ref.read(codeSyncProvider);
    syncManager.syncCode(code, userId);

    // Update cursor position
    final cursorPosition = _controller.selection.baseOffset;
    final cursorLine = _getCursorLine(code, cursorPosition);
    
    branchActions.updateCursor(
      userId: userId,
      position: cursorPosition,
      line: cursorLine,
    );

    _lastCursorPosition = cursorPosition;

    // Reset typing status after delay
    Future.delayed(const Duration(seconds: 2), () {
      branchActions.updateStatus(
        userId: userId,
        status: MemberStatus.idle,
        isTyping: false,
      );
    });
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      setState(() {});
    }
  }

  int _getCursorLine(String code, int position) {
    if (position <= 0) return 0;
    return code.substring(0, position).split('\n').length - 1;
  }

  @override
  Widget build(BuildContext context) {
    final branchAsync = ref.watch(currentBranchProvider);

    return branchAsync.when(
      data: (branch) {
        // Update editor when remote changes detected
        if (branch != null && !_isLocalEdit) {
          if (_controller.text != branch.code) {
            final previousSelection = _controller.selection;
            _controller.text = branch.code;
            
            // Restore cursor position if valid
            if (previousSelection.baseOffset <= branch.code.length) {
              _controller.selection = previousSelection;
            }
          }
        }

        return Stack(
          children: [
            // Code Editor
            TextField(
              controller: _controller,
              focusNode: _focusNode,
              enabled: !widget.readOnly && (branch?.canEdit(ref.read(currentUserIdProvider) ?? '') ?? false),
              maxLines: null,
              expands: true,
              style: AppTextStyles.code.copyWith(
                color: AppColors.textPrimary,
                height: 1.5,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '// Write your code here...',
                hintStyle: AppTextStyles.code.copyWith(
                  color: AppColors.textTertiary,
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
              onChanged: (value) {
                _isLocalEdit = true;
                Future.delayed(const Duration(milliseconds: 100), () {
                  _isLocalEdit = false;
                });
              },
            ),

            // Cursor Overlays
            if (branch != null && _focusNode.hasFocus)
              Positioned.fill(
                child: IgnorePointer(
                  child: _buildCursorOverlays(branch),
                ),
              ),

            // Read-only overlay
            if (widget.readOnly || (branch != null && !branch.canEdit(ref.read(currentUserIdProvider) ?? '')))
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'READ ONLY',
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(
        child: Text(
          'Error loading editor: $err',
          style: AppTextStyles.body2.copyWith(color: AppColors.error),
        ),
      ),
    );
  }

  Widget _buildCursorOverlays(BranchModel branch) {
    final currentUserId = ref.read(currentUserIdProvider) ?? 'user123';
    final colors = [
      AppColors.primary,
      AppColors.success,
      AppColors.warning,
      Colors.purple,
      Colors.pink,
      Colors.cyan,
    ];

    return CustomPaint(
      painter: CursorPainter(
        members: branch.members,
        currentUserId: currentUserId,
        colors: colors,
        textStyle: AppTextStyles.code,
      ),
    );
  }
}

class CursorPainter extends CustomPainter {
  final Map<String, BranchMember> members;
  final String currentUserId;
  final List<Color> colors;
  final TextStyle textStyle;

  CursorPainter({
    required this.members,
    required this.currentUserId,
    required this.colors,
    required this.textStyle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    int colorIndex = 0;
    
    for (final member in members.values) {
      if (member.userId == currentUserId) continue;
      if (!member.isActive()) continue;

      final color = colors[colorIndex % colors.length];
      colorIndex++;

      // Draw cursor line
      final x = _getCursorX(member.cursorPosition);
      final y = _getCursorY(member.cursorLine);

      final paint = Paint()
        ..color = color
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;

      canvas.drawLine(
        Offset(x, y),
        Offset(x, y + 20),
        paint,
      );

      // Draw member name label
      final textPainter = TextPainter(
        text: TextSpan(
          text: member.username,
          style: TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      
      textPainter.layout();
      
      // Background for label
      final labelBg = Paint()..color = color;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y - 20, textPainter.width + 8, 16),
          const Radius.circular(4),
        ),
        labelBg,
      );
      
      textPainter.paint(canvas, Offset(x + 4, y - 18));
    }
  }

  double _getCursorX(int position) {
    // Simplified: calculate based on character width
    // In real implementation, measure actual text width
    return 16 + (position % 80) * 8.0;
  }

  double _getCursorY(int line) {
    // Calculate Y position based on line number
    final lineHeight = textStyle.height ?? 1.5;
    final fontSize = textStyle.fontSize ?? 14;
    return 16 + (line * fontSize * lineHeight);
  }

  @override
  bool shouldRepaint(CursorPainter oldDelegate) => true;
}
