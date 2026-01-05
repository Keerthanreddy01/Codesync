/// Home Screen - Main Entry Point (Ultrahuman Design)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/app_colors.dart';
import '../../config/app_text_styles.dart';
import '../../providers/room_providers.dart';
import '../../widgets/ultrahuman_card.dart';
import '../practice/problem_selection_screen.dart';
import '../achievements/achievements_screen.dart';
import '../weekly_challenges/weekly_challenges_screen.dart';
import '../skill_rating/skill_rating_screen.dart';
import '../problem_creator/problem_creator_screen.dart';
import '../features_dashboard/features_dashboard_screen.dart';
import '../../widgets/codesync_logo.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeIn;
  late Animation<double> _slideUp;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideUp = Tween<double>(begin: 20.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: FadeTransition(
        opacity: _fadeIn,
        child: Transform.translate(
          offset: Offset(0, _slideUp.value),
          child: IndexedStack(
            index: _selectedIndex,
            children: [
              _buildTeamsTab(),
              _buildBattlesTab(),
              _buildLeaderboardTab(),
              _buildProfileTab(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      title: Row(
        children: [
          CodeSyncLogo(
            size: 36,
            color: Colors.white,
            showText: false,
          ),
          const SizedBox(width: 12),
          Text(
            'CODESYNC',
            style: AppTextStyles.heading3.copyWith(
              color: AppColors.textPrimary,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.grid_3x3, color: AppColors.textSecondary),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FeaturesDashboardScreen()),
          ),
          tooltip: 'All Features',
        ),
        IconButton(
          icon: Stack(
            children: [
              const Icon(Icons.notifications_outlined, color: AppColors.textSecondary),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          onPressed: () {},
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.border, width: 0.5),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.group_outlined, Icons.group, 'TEAMS'),
              _buildNavItem(1, Icons.sports_kabaddi_outlined, Icons.sports_kabaddi, 'BATTLES'),
              _buildNavItem(2, Icons.leaderboard_outlined, Icons.leaderboard, 'RANKS'),
              _buildNavItem(3, Icons.person_outline, Icons.person, 'PROFILE'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, IconData selectedIcon, String label) {
    final isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
        _animationController.forward(from: 0);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? selectedIcon : icon,
              color: isSelected ? AppColors.primary : AppColors.textTertiary,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: isSelected ? AppColors.primary : AppColors.textTertiary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          
          // Welcome Section
          Text(
            'Ready to Battle',
            style: AppTextStyles.display2.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Collaborate with teammates in real-time',
            style: AppTextStyles.body1.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Quick Actions
          UltrahumanGlowingCard(
            glowColor: AppColors.primary,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: AppColors.primaryGradient,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.add, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Create New Room',
                            style: AppTextStyles.heading3.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Start a new coding battle',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, color: AppColors.textTertiary, size: 18),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(color: AppColors.border, height: 1),
                const SizedBox(height: 16),
                InkWell(
                  onTap: _createRoom,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: AppColors.primaryGradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.rocket_launch, color: Colors.white, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Create Room',
                          style: AppTextStyles.button.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          UltrahumanCard(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: AppColors.secondaryGradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.login, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Join Room',
                        style: AppTextStyles.heading3.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Enter a room code to join',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: _showJoinRoomDialog,
                  icon: const Icon(Icons.arrow_forward_ios, color: AppColors.textTertiary, size: 18),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Features Section
          Text(
            'FEATURES',
            style: AppTextStyles.captionBold.copyWith(
              color: AppColors.textTertiary,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          
          _buildFeatureCard(
            icon: Icons.code,
            title: 'Real-time Collaboration',
            description: 'Code together with live cursors and updates',
            color: AppColors.primary,
          ),
          const SizedBox(height: 12),
          _buildFeatureCard(
            icon: Icons.account_tree,
            title: 'Git-Style Branches',
            description: 'Work on separate branches and merge solutions',
            color: AppColors.secondary,
          ),
          const SizedBox(height: 12),
          _buildFeatureCard(
            icon: Icons.timer,
            title: 'Timed Challenges',
            description: 'Race against the clock to solve problems',
            color: AppColors.warning,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return UltrahumanCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _createRoom() async {
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // Get room actions from ref
      final roomActions = ref.read(roomActionsProvider);
      
      // Create room
      final room = await roomActions.createRoom();
      
      if (mounted) {
        Navigator.pop(context); // Close loading
        
        // Show success with room code
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Room created! Code: ${room.code}'),
            backgroundColor: AppColors.success,
            duration: const Duration(seconds: 5),
          ),
        );
        
        // Navigate to lobby
        Navigator.pushNamed(context, '/room/lobby', arguments: room.id);
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _showJoinRoomDialog() {
    final codeController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Join Room'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: codeController,
              decoration: const InputDecoration(
                labelText: 'Room Code',
                hintText: 'ABCD',
                prefixIcon: Icon(Icons.key),
              ),
              textCapitalization: TextCapitalization.characters,
              maxLength: 4,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => _joinRoom(codeController.text),
            child: const Text('Join'),
          ),
        ],
      ),
    );
  }

  Future<void> _joinRoom(String code) async {
    if (code.trim().length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Room code must be 4 characters'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    Navigator.pop(context); // Close dialog
    
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final roomActions = ref.read(roomActionsProvider);
      
      final room = await roomActions.joinRoom(code.toUpperCase());
      
      if (mounted) {
        Navigator.pop(context); // Close loading
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Joined room: ${room.code}'),
            backgroundColor: AppColors.success,
          ),
        );
        
        Navigator.pushNamed(context, '/room/lobby', arguments: room.id);
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _navigateToSoloPractice() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProblemSelectionScreen(),
      ),
    );
  }

  Future<void> _navigateToTournament() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tournaments will be available in the next update!')),
    );
  }

  Widget _buildBattlesTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text(
            'Quick Battle',
            style: AppTextStyles.heading3.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          
          // Quick Battle Options
          Row(
            children: [
              Expanded(
                child: _buildBattleCard(
                  title: 'Create Room',
                  description: 'Start a new coding battle',
                  icon: Icons.add_circle,
                  color: AppColors.primary,
                  onTap: _createRoom,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildBattleCard(
                  title: 'Join Room',
                  description: 'Enter with room code',
                  icon: Icons.login,
                  color: AppColors.success,
                  onTap: _showJoinRoomDialog,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          Text(
            'Battle Modes',
            style: AppTextStyles.heading3.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          
          // Battle Modes
          _buildModeCard(
            title: 'Team Battle',
            description: 'Collaborate with teammates to solve problems',
            icon: Icons.group,
            color: AppColors.primary,
            features: ['Real-time collaboration', 'Branch system', 'Team scoring'],
          ),
          const SizedBox(height: 12),
          _buildModeCard(
            title: 'Solo Practice',
            description: 'Practice coding problems alone',
            icon: Icons.person,
            color: AppColors.info,
            features: ['No time pressure', 'All difficulty levels', 'Track progress'],
            onTap: _navigateToSoloPractice,
          ),
          const SizedBox(height: 12),
          _buildModeCard(
            title: 'Tournament',
            description: 'Compete in scheduled tournaments',
            icon: Icons.emoji_events,
            color: AppColors.warning,
            features: ['Multiple rounds', 'Leaderboards', 'Prizes'],
            onTap: _navigateToTournament,
          ),
          const SizedBox(height: 32),
          
          Text(
            'Unique Features',
            style: AppTextStyles.heading3.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          
          _buildModeCard(
            title: 'Achievements',
            description: 'Unlock badges, streaks, and milestones',
            icon: Icons.star,
            color: Colors.amber,
            features: ['Badges', 'Streaks', 'Performance stats'],
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AchievementsScreen()),
            ),
          ),
          const SizedBox(height: 12),
          _buildModeCard(
            title: 'Weekly Challenges',
            description: 'Limited-time coding challenges with rewards',
            icon: Icons.local_fire_department,
            color: Colors.deepOrange,
            features: ['Weekly problems', 'Leaderboards', 'Bonus XP'],
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const WeeklyChallengesScreen()),
            ),
          ),
          const SizedBox(height: 12),
          _buildModeCard(
            title: 'Skill Rating',
            description: 'Track your ELO rating and rank progression',
            icon: Icons.trending_up,
            color: Colors.blue,
            features: ['ELO System', 'Rank tiers', 'Analytics'],
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SkillRatingScreen()),
            ),
          ),
          const SizedBox(height: 12),
          _buildModeCard(
            title: 'Create Problem',
            description: 'Design custom coding challenges',
            icon: Icons.create,
            color: Colors.purple,
            features: ['Custom problems', 'Share with friends', 'Test cases'],
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProblemCreatorScreen()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBattleCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 12),
            Text(
              title,
              style: AppTextStyles.body1.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required List<String> features,
    bool comingSoon = false,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 32, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: AppTextStyles.body1.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (comingSoon) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'COMING SOON',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.warning,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: features.map((feature) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        feature,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildLeaderboardTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text(
            'Global Leaderboard',
            style: AppTextStyles.heading3.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          
          // Top 3
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withOpacity(0.1),
                  AppColors.secondary.withOpacity(0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primary.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                _buildPodiumCard(1, 'Team Alpha', 2850, AppColors.warning),
                const SizedBox(height: 8),
                _buildPodiumCard(2, 'Code Warriors', 2720, Colors.grey),
                const SizedBox(height: 8),
                _buildPodiumCard(3, 'Bug Hunters', 2680, Colors.brown),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          Text(
            'Your Stats',
            style: AppTextStyles.body1.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          
          Row(
            children: [
              Expanded(
                child: _buildStatCard('Battles', '0', Icons.sports_kabaddi),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard('Wins', '0', Icons.emoji_events),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard('Rank', '-', Icons.trending_up),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPodiumCard(int rank, String teamName, int points, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$rank',
                style: AppTextStyles.body1.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              teamName,
              style: AppTextStyles.body1.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            '$points pts',
            style: AppTextStyles.body1.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, size: 28, color: AppColors.primary),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.heading3.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    final userId = ref.watch(currentUserIdProvider) ?? 'Guest';
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 32),
          
          // Avatar
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.person,
                size: 50,
                color: Colors.white,
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          Text(
            'Player ${userId.substring(userId.length > 10 ? userId.length - 10 : 0)}',
            style: AppTextStyles.heading2.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          
          const SizedBox(height: 8),
          
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Beginner',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Stats Grid
          Row(
            children: [
              Expanded(
                child: _buildProfileStat('0', 'Battles Played', Icons.sports_kabaddi),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildProfileStat('0', 'Problems Solved', Icons.check_circle),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          Row(
            children: [
              Expanded(
                child: _buildProfileStat('0%', 'Win Rate', Icons.trending_up),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildProfileStat('0', 'Team Rank', Icons.leaderboard),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Action Buttons
          _buildProfileButton(
            'Edit Profile',
            Icons.edit,
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Coming soon!')),
              );
            },
          ),
          
          const SizedBox(height: 12),
          
          _buildProfileButton(
            'Settings',
            Icons.settings,
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Coming soon!')),
              );
            },
          ),
          
          const SizedBox(height: 12),
          
          _buildProfileButton(
            'About',
            Icons.info_outline,
            () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('CodeSync Arena'),
                  content: const Text(
                    'Version 1.0.0\n\nA real-time collaborative coding battle platform with Git-style branching.\n\nFeatures:\n• Team battles\n• Real-time code editing\n• Live cursor tracking\n• Branch comparison\n• Test execution',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProfileStat(String value, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, size: 24, color: AppColors.primary),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.heading3.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileButton(String label, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(width: 12),
            Text(
              label,
              style: AppTextStyles.body1.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}
