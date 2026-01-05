# Git-Style Branch System - Implementation Guide

## Overview
The CodeSync Arena branch system allows teams to collaborate on code in real-time during battles, similar to Google Docs but for competitive programming.

## Core Features Implemented

### 1. **Branch Model** (`lib/models/branch_model.dart`)
- **BranchModel**: Stores branch metadata (id, battleId, teamId, teamName, branchName, code, status, timestamps)
- **BranchMember**: Tracks individual member activity (userId, username, cursorPosition, cursorLine, isTyping, status, lastActivity)
- **BranchStats**: Performance metrics (lineCount, lastEdit, testRuns, testsPassed, testsFailed)
- **Enums**:
  - `BranchStatus`: active, submitted, judging
  - `MemberStatus`: idle, typing, testing, submitted

### 2. **Branch Service** (`lib/services/branch_service.dart`)
Firebase Realtime Database operations:
- `createBranch()`: Creates new branch with starter code
- `streamBranch()`: Real-time updates for single branch
- `streamAllBranches()`: Real-time updates for all branches in battle
- `updateCode()`: Updates code with line count tracking
- `updateCursor()`: Updates member cursor position (throttled)
- `updateMemberStatus()`: Updates typing/testing/submitted status
- `updateTestStats()`: Records test execution results
- `submitBranch()`: Locks branch for submission
- `areAllBranchesSubmitted()`: Checks if all teams submitted

**Database Structure:**
```
battles/{battleId}/branches/{teamId}/
  ├─ code: string
  ├─ members: {userId: {cursor_position, cursor_line, is_typing, status}}
  ├─ stats: {line_count, last_edit, test_runs, tests_passed, tests_failed}
  ├─ status: "active" | "submitted" | "judging"
```

### 3. **Branch Providers** (`lib/providers/branch_providers.dart`)
State management with Riverpod:
- **CodeSyncManager**: Debounces code updates to 500ms to prevent excessive Firebase writes
- **BranchActions**: Business logic for branches
  - `createBranchesForBattle()`: Creates one branch per team
  - `updateCursor()`: Throttled to 100ms for smooth tracking
  - `updateStatus()`: Updates member activity status
  - `submitBranch()`: Submits and locks branch
  - `updateTestStats()`: Records test results
  - `canUserEditBranch()`: Permission check

**Key Providers:**
- `currentBranchProvider`: StreamProvider for real-time branch updates
- `allBranchesProvider`: StreamProvider for all branches in battle
- `codeSyncProvider`: CodeSyncManager for debounced sync
- `branchActionsProvider`: Business operations

### 4. **Collaborative Code Editor** (`lib/widgets/collaborative_code_editor.dart`)
Real-time multi-user text editor:
- **Features**:
  - Real-time code synchronization via Firebase
  - Live cursor tracking for all team members
  - Member status updates (typing/idle/testing/submitted)
  - Color-coded cursors (6 colors cycling)
  - Member name labels on cursors
  - Read-only mode when branch submitted
  - Debounced code sync (500ms)
  - Throttled cursor updates (100ms)
  - Auto status reset to idle after 2 seconds

**CursorPainter**: Custom painter that renders:
- Colored vertical lines at cursor positions
- Rounded rectangle labels with member names
- Only active members (within 30 seconds)
- Skips current user's cursor

### 5. **Branch Comparison View** (`lib/widgets/branch_comparison_view.dart`)
Side-by-side view of all competing branches:
- **Grid Layout**: 2x2 grid of branch cards
- **Branch Cards**:
  - Branch name with color indicator
  - Status badge (ACTIVE/SUBMITTED/JUDGING)
  - Team member list with status icons
  - Statistics (lines, test runs, active members)
  - Code preview (8 lines)
  - Expand button for full code dialog
- **Real-time Updates**: Watches `allBranchesProvider` stream

### 6. **Member Status Indicator** (`lib/widgets/member_status_indicator.dart`)
Shows real-time team member activity:
- **Full View**: List with avatars, names, and status
- **Compact View**: Just status dots
- **Status Icons**:
  - 🟢 Idle (gray circle)
  - ✏️ Typing (purple edit icon with animation)
  - ▶️ Testing (blue play icon)
  - ✅ Submitted (green checkmark)
- **Animations**:
  - Pulsing dot for typing members
  - Animated dots while typing
- **Activity Tracking**: Shows "Active", "Xm ago", or "Idle"

### 7. **Arena Screen Integration** (`lib/screens/battle/arena_screen.dart`)
Updated to use collaborative system:
- **Branch Context Setup**: Sets battleId and teamId on init
- **Collaborative Editor**: Replaced TextField with CollaborativeCodeEditor
- **Branch Comparison Toggle**: IconButton to switch between editor and comparison view
- **Right Sidebar**: MemberStatusIndicator for team members
- **Test Integration**: Updates branch stats when tests run
- **Submit Integration**: Locks branch on submission

### 8. **Battle Start Flow** (`lib/screens/battle/team_lobby_screen.dart`)
Automatic branch creation:
- **Updated _startBattle()**: Creates branches for all teams
- **Parameters**: battleId, teams map, starterCode
- **Sets Branch Context**: Prepares for collaborative editing

## Technical Details

### Real-Time Synchronization
- **Debouncing**: 500ms for code updates (prevents excessive Firebase writes during typing)
- **Throttling**: 100ms for cursor updates (smooth but efficient)
- **Conflict Resolution**: Last-write-wins (Firebase built-in)
- **Offline Support**: Planned for future (queue-based retry logic)

### Performance Optimizations
- Stream providers for efficient real-time updates
- Debounced sync manager prevents Firebase overload
- Throttled cursor updates balance smoothness vs cost
- Silent failures for non-critical updates (cursor, status)
- Local edit flag prevents infinite loops

### Permission System
- **canEdit()**: Checks if user is team member AND branch not submitted
- **isTeamMember()**: Validates user belongs to team
- **isSubmitted()**: Locks editing after submission
- **Read-only Mode**: Overlay badge for submitted branches

### Activity Tracking
- **isActive()**: Member active if lastActivity within 30 seconds
- **Auto-reset**: Status resets to idle after 2 seconds of no typing
- **Last Activity**: Timestamp updated on every interaction

## Usage Flow

### 1. Create Room → Start Battle
```dart
// In team_lobby_screen.dart _startBattle()
final branchActions = ref.read(branchActionsProvider);
await branchActions.createBranchesForBattle(
  battleId: battle.id,
  teams: {teamId: [userId1, userId2, ...]},
  starterCode: problem.starterCode,
);
```

### 2. Collaborative Editing
```dart
// In arena_screen.dart
CollaborativeCodeEditor(
  readOnly: _hasSubmitted,
)
```
- User types → Local change detected
- Status set to "typing"
- Code synced with 500ms debounce
- Cursor position updated with 100ms throttle
- Other team members see changes in real-time

### 3. Run Tests
```dart
// In arena_screen.dart _runTests()
await branchActions.updateStatus(userId, MemberStatus.testing);
final results = await battleActions.runTests();
await branchActions.updateTestStats(passed, failed);
```

### 4. Submit Solution
```dart
// In arena_screen.dart _submitSolution()
await branchActions.submitBranch(userId); // Locks branch
await branchActions.updateStatus(userId, MemberStatus.submitted);
final allSubmitted = await branchActions.areAllBranchesSubmitted();
if (allSubmitted) {
  // Navigate to results
}
```

### 5. View Other Branches
- Click "View All Branches" button in AppBar
- Shows BranchComparisonView with all team branches
- Real-time updates as teams code
- Click "View Full Code" to see complete solution

## Firebase Rules (Recommended)

```json
{
  "rules": {
    "battles": {
      "$battleId": {
        "branches": {
          "$teamId": {
            // Allow read for all battle participants
            ".read": "auth != null",
            
            // Allow write only for team members
            ".write": "auth != null && (
              data.child('members').child(auth.uid).exists() ||
              !data.exists()
            )",
            
            "code": {
              ".validate": "newData.isString()"
            },
            
            "status": {
              ".validate": "newData.val() == 'active' || 
                            newData.val() == 'submitted' || 
                            newData.val() == 'judging'"
            }
          }
        }
      }
    }
  }
}
```

## Future Enhancements

### 1. **Operational Transformation (OT)**
- Conflict-free text editing
- Preserve user intent during simultaneous edits
- Handle complex cases (inserts, deletes at same position)

### 2. **Branch Visualization Widget**
- GitHub-style network graph
- Colored branch lines
- Interactive branch selection
- Animated branch creation

### 3. **Offline Sync Service**
- Queue pending changes during offline periods
- Retry failed operations with exponential backoff
- Sync status indicator (synced/syncing/offline)
- Conflict resolution UI

### 4. **Advanced Cursor Features**
- Selection highlighting (not just cursor position)
- Cursor color customization
- Hover to see member details
- Follow mode (follow teammate's cursor)

### 5. **Branch History**
- Timeline of code changes
- Revert to previous versions
- Diff view between versions
- Blame view (who edited what)

### 6. **Code Review Features**
- Inline comments on code
- Suggestion mode (like Google Docs)
- Approve/reject changes
- Team discussions

### 7. **Performance Analytics**
- Typing speed metrics
- Code quality scores
- Test success rate over time
- Team collaboration metrics

## Testing Checklist

### Unit Tests
- [ ] BranchModel serialization/deserialization
- [ ] BranchService CRUD operations
- [ ] CodeSyncManager debouncing logic
- [ ] Permission checks (canEdit, isTeamMember)

### Integration Tests
- [ ] Branch creation on battle start
- [ ] Real-time code synchronization
- [ ] Cursor position tracking
- [ ] Member status updates
- [ ] Branch submission flow

### E2E Tests
- [ ] Full battle flow with branches
- [ ] Multi-user collaborative editing
- [ ] Branch comparison view
- [ ] Test execution with stats
- [ ] Submit and judge flow

## Known Limitations

1. **No Operational Transformation**: Uses last-write-wins, can lose edits during conflicts
2. **Cursor Position Simplified**: Character offset, not visual position (doesn't account for word wrap)
3. **No Offline Support**: Requires active internet connection
4. **Limited History**: No code versioning or undo across sessions
5. **Basic Permissions**: Only team member check, no roles (editor/viewer)
6. **Fixed Debounce/Throttle**: Not configurable based on network conditions

## Troubleshooting

### Issue: Cursor positions not syncing
- **Check**: Firebase permissions allow writes to `members/{userId}/cursor_position`
- **Check**: Throttle timer (100ms) may be delaying updates
- **Fix**: Ensure `updateCursor()` is called on text change

### Issue: Code not syncing to other users
- **Check**: Debounce timer (500ms) may be delaying sync
- **Check**: Firebase connection status
- **Check**: User has write permissions to branch
- **Fix**: Verify `syncCode()` is called and Firebase writes succeed

### Issue: Member status stuck on "typing"
- **Check**: Auto-reset timer (2 seconds) should reset to idle
- **Check**: `lastActivity` timestamp updating correctly
- **Fix**: Manually call `updateStatus()` with `MemberStatus.idle`

### Issue: Branch comparison view not updating
- **Check**: `allBranchesProvider` StreamProvider is active
- **Check**: Firebase listener attached correctly
- **Fix**: Re-read provider to refresh stream

## API Reference

### BranchModel
```dart
BranchModel.create({
  required String battleId,
  required String teamId,
  required String teamName,
  required String starterCode,
  required List<String> memberIds,
})
```

### BranchService
```dart
Future<BranchModel> createBranch({...})
Stream<BranchModel?> streamBranch(String battleId, String teamId)
Future<void> updateCode({String battleId, String teamId, String code, String userId})
Future<void> updateCursor({String battleId, String teamId, String userId, int position, int line})
Future<void> submitBranch({String battleId, String teamId, String userId})
```

### BranchActions
```dart
Future<void> createBranchesForBattle({String battleId, Map<String, List<String>> teams, String starterCode})
Future<void> updateCursor(String userId, int position, int line)
Future<void> updateStatus(String userId, MemberStatus status, {bool isTyping = false})
Future<void> submitBranch(String userId)
Future<bool> areAllBranchesSubmitted()
```

### CollaborativeCodeEditor
```dart
CollaborativeCodeEditor({
  required bool readOnly,
  String? initialCode,
})
```

## Credits
Inspired by:
- Google Docs collaborative editing
- GitHub branching model
- VS Code Live Share
- Operational Transformation research
