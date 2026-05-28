import 'package:flutter/material.dart';
import 'package:markmymovie/data/local_db/isar_service.dart';

class SettingsScreen extends StatefulWidget {
  final IsarService isarService;

  const SettingsScreen({super.key, required this.isarService});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _autoBackupEnabled = false;
  bool _darkModeEnabled = true;
  bool _highQualityImages = true;
  String _selectedLanguage = 'English';
  String _selectedRegion = 'US';
  String _displayName = 'Movie Lover';

  final String _appVersion = '1.0.0';
  final String _buildNumber = '1';

  // ── Language & Region options ──────────────────────────────────────────────

  final List<String> _languages = [
    'English', 'Hindi', 'Spanish', 'French', 'German',
    'Japanese', 'Korean', 'Portuguese', 'Italian', 'Arabic',
  ];

  final List<Map<String, String>> _regions = [
    {'code': 'US', 'name': 'United States'},
    {'code': 'IN', 'name': 'India'},
    {'code': 'GB', 'name': 'United Kingdom'},
    {'code': 'CA', 'name': 'Canada'},
    {'code': 'AU', 'name': 'Australia'},
    {'code': 'DE', 'name': 'Germany'},
    {'code': 'FR', 'name': 'France'},
    {'code': 'JP', 'name': 'Japan'},
    {'code': 'KR', 'name': 'South Korea'},
    {'code': 'BR', 'name': 'Brazil'},
  ];

  // ── Content filter state ───────────────────────────────────────────────────

  final Map<String, bool> _ageRatings = {
    'G': true, 'PG': true, 'PG-13': true, 'R': true, 'NC-17': false,
  };

  final Map<String, bool> _genres = {
    'Action': true, 'Comedy': true, 'Drama': true, 'Horror': false,
    'Sci-Fi': true, 'Romance': true, 'Thriller': true, 'Animation': true,
  };

  // ── Helpers ────────────────────────────────────────────────────────────────

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor:
        isError ? const Color(0xFFE50914) : const Color(0xFF2E2E2E),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // BUILD
  // ══════════════════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileSection(),
            const SizedBox(height: 32),

            _buildSectionHeader('Content & Display'),
            _buildSettingsGroup([
              _buildNavigationTile(
                icon: Icons.language_outlined,
                title: 'Language',
                subtitle: _selectedLanguage,
                onTap: _showLanguageDialog,
              ),
              _buildNavigationTile(
                icon: Icons.public_outlined,
                title: 'Region',
                subtitle:
                'Content availability: $_selectedRegion',
                onTap: _showRegionDialog,
              ),
              _buildNavigationTile(
                icon: Icons.movie_filter_outlined,
                title: 'Content Filters',
                subtitle: 'Manage age ratings and genres',
                onTap: _showContentFilters,
              ),
            ]),
            const SizedBox(height: 32),

            _buildSectionHeader('Data & Backup'),
            _buildSettingsGroup([
              _buildSwitchTile(
                icon: Icons.backup_outlined,
                title: 'Auto Backup',
                subtitle: 'Automatically backup your data weekly',
                value: _autoBackupEnabled,
                onChanged: (value) =>
                    setState(() => _autoBackupEnabled = value),
              ),
              _buildNavigationTile(
                icon: Icons.cloud_upload_outlined,
                title: 'Backup Database',
                subtitle: 'Export your movies and folders',
                onTap: _backupDatabase,
                showChevron: false,
              ),
              _buildNavigationTile(
                icon: Icons.cloud_download_outlined,
                title: 'Restore Database',
                subtitle: 'Import previously backed up data',
                onTap: _restoreDatabase,
                showChevron: false,
              ),
              _buildNavigationTile(
                icon: Icons.storage_outlined,
                title: 'Storage Usage',
                subtitle: 'View app storage and cache',
                onTap: _showStorageInfo,
              ),
            ]),
            const SizedBox(height: 32),

            _buildSectionHeader('Account & Sync'),
            _buildSettingsGroup([
              _buildNavigationTile(
                icon: Icons.account_circle_outlined,
                title: 'Account',
                subtitle: 'Sign in to sync across devices',
                onTap: _showAccountOptions,
                trailing: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD600).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFFFD600).withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: const Text(
                    'SOON',
                    style: TextStyle(
                      color: Color(0xFFFFD600),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ]),
            const SizedBox(height: 32),

            _buildSectionHeader('Support & About'),
            _buildSettingsGroup([
              _buildNavigationTile(
                icon: Icons.help_outline,
                title: 'Help & Support',
                subtitle: 'FAQs and contact information',
                onTap: _showHelpSupport,
              ),
              _buildNavigationTile(
                icon: Icons.star_outline,
                title: 'Rate App',
                subtitle: 'Love the app? Leave us a review',
                onTap: _rateApp,
              ),
              _buildNavigationTile(
                icon: Icons.share_outlined,
                title: 'Share App',
                subtitle: 'Tell your friends about Mark My Movie',
                onTap: _shareApp,
              ),
              _buildNavigationTile(
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy Policy',
                subtitle: 'How we protect your data',
                onTap: _showPrivacyPolicy,
              ),
              _buildNavigationTile(
                icon: Icons.description_outlined,
                title: 'Terms of Service',
                subtitle: 'App usage terms and conditions',
                onTap: _showTermsOfService,
              ),
              _buildNavigationTile(
                icon: Icons.info_outline,
                title: 'About',
                subtitle: 'Version $_appVersion ($_buildNumber)',
                onTap: _showAboutDialogCustom,
              ),
            ]),
            const SizedBox(height: 32),

            _buildSectionHeader('Danger Zone', isDestructive: true),
            _buildSettingsGroup([
              _buildNavigationTile(
                icon: Icons.delete_sweep_outlined,
                title: 'Clear Cache',
                subtitle: 'Free up storage space',
                onTap: _clearCache,
                showChevron: false,
                isDestructive: true,
              ),
              _buildNavigationTile(
                icon: Icons.restore_outlined,
                title: 'Reset App',
                subtitle: 'Delete all data and start fresh',
                onTap: _resetApp,
                showChevron: false,
                isDestructive: true,
              ),
            ]),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // REUSABLE WIDGETS
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildProfileSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFE50914).withOpacity(0.2),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: const Color(0xFFE50914).withOpacity(0.5),
                width: 2,
              ),
            ),
            child:
            const Icon(Icons.person, color: Color(0xFFE50914), size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _displayName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Local Account',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: _editProfile,
            icon:
            const Icon(Icons.edit, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {bool isDestructive = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          color: isDestructive
              ? const Color(0xFFE50914)
              : Colors.white.withOpacity(0.9),
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSettingsGroup(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        borderRadius: BorderRadius.circular(16),
        border:
        Border.all(color: Colors.white.withOpacity(0.05), width: 1),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        leading: _tileIcon(icon),
        title: Text(title,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500)),
        subtitle: Text(subtitle,
            style: TextStyle(
                color: Colors.white.withOpacity(0.6), fontSize: 14)),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFFE50914),
          activeTrackColor: const Color(0xFFE50914).withOpacity(0.3),
          inactiveThumbColor: Colors.white.withOpacity(0.6),
          inactiveTrackColor: Colors.white.withOpacity(0.1),
        ),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }

  Widget _buildNavigationTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Widget? trailing,
    bool showChevron = true,
    bool isDestructive = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: ListTile(
          leading: _tileIcon(icon, isDestructive: isDestructive),
          title: Text(title,
              style: TextStyle(
                  color: isDestructive
                      ? const Color(0xFFE50914)
                      : Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500)),
          subtitle: Text(subtitle,
              style: TextStyle(
                  color: isDestructive
                      ? const Color(0xFFE50914).withOpacity(0.7)
                      : Colors.white.withOpacity(0.6),
                  fontSize: 14)),
          trailing: trailing ??
              (showChevron
                  ? const Icon(Icons.chevron_right,
                  color: Colors.white54, size: 20)
                  : null),
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        ),
      ),
    );
  }

  Widget _tileIcon(IconData icon, {bool isDestructive = false}) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF121212).withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        icon,
        color: isDestructive
            ? const Color(0xFFE50914)
            : Colors.white.withOpacity(0.8),
        size: 20,
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // ACTION METHODS
  // ══════════════════════════════════════════════════════════════════════════

  // ── Profile ────────────────────────────────────────────────────────────────

  void _editProfile() {
    final controller = TextEditingController(text: _displayName);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1F1F1F),
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Edit Profile',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          cursorColor: const Color(0xFFE50914),
          decoration: InputDecoration(
            hintText: 'Enter your name',
            hintStyle:
            TextStyle(color: Colors.white.withOpacity(0.4)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
              BorderSide(color: Colors.white.withOpacity(0.2)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
              const BorderSide(color: Color(0xFFE50914)),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel',
                style: TextStyle(color: Colors.white.withOpacity(0.6))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE50914),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                setState(() => _displayName = name);
              }
              Navigator.pop(ctx);
            },
            child: const Text('Save',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ── Language ───────────────────────────────────────────────────────────────

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1F1F1F),
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Select Language',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _languages.length,
            itemBuilder: (_, i) {
              final lang = _languages[i];
              final selected = lang == _selectedLanguage;
              return ListTile(
                title: Text(lang,
                    style: TextStyle(
                        color:
                        selected ? const Color(0xFFE50914) : Colors.white,
                        fontWeight: selected
                            ? FontWeight.bold
                            : FontWeight.normal)),
                trailing: selected
                    ? const Icon(Icons.check, color: Color(0xFFE50914))
                    : null,
                onTap: () {
                  setState(() => _selectedLanguage = lang);
                  Navigator.pop(ctx);
                  _showSnackBar('Language set to $lang');
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel',
                style: TextStyle(color: Colors.white.withOpacity(0.6))),
          ),
        ],
      ),
    );
  }

  // ── Region ─────────────────────────────────────────────────────────────────

  void _showRegionDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1F1F1F),
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Select Region',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _regions.length,
            itemBuilder: (_, i) {
              final region = _regions[i];
              final selected = region['code'] == _selectedRegion;
              return ListTile(
                leading: Text(region['code']!,
                    style: TextStyle(
                        color: selected
                            ? const Color(0xFFE50914)
                            : Colors.white54,
                        fontWeight: FontWeight.bold,
                        fontSize: 13)),
                title: Text(region['name']!,
                    style: TextStyle(
                        color:
                        selected ? const Color(0xFFE50914) : Colors.white,
                        fontWeight: selected
                            ? FontWeight.bold
                            : FontWeight.normal)),
                trailing: selected
                    ? const Icon(Icons.check, color: Color(0xFFE50914))
                    : null,
                onTap: () {
                  setState(() => _selectedRegion = region['code']!);
                  Navigator.pop(ctx);
                  _showSnackBar('Region set to ${region['name']}');
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel',
                style: TextStyle(color: Colors.white.withOpacity(0.6))),
          ),
        ],
      ),
    );
  }

  // ── Content Filters ────────────────────────────────────────────────────────

  void _showContentFilters() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1F1F1F),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.65,
          maxChildSize: 0.9,
          builder: (_, scrollCtrl) => SingleChildScrollView(
            controller: scrollCtrl,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Content Filters',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),

                // Age Ratings
                Text('Age Ratings',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _ageRatings.entries.map((e) {
                    return FilterChip(
                      label: Text(e.key),
                      selected: e.value,
                      onSelected: (val) {
                        setSheetState(
                                () => _ageRatings[e.key] = val);
                        setState(() => _ageRatings[e.key] = val);
                      },
                      selectedColor:
                      const Color(0xFFE50914).withOpacity(0.3),
                      checkmarkColor: const Color(0xFFE50914),
                      backgroundColor:
                      Colors.white.withOpacity(0.05),
                      labelStyle: TextStyle(
                          color: e.value
                              ? const Color(0xFFE50914)
                              : Colors.white70),
                      side: BorderSide(
                          color: e.value
                              ? const Color(0xFFE50914)
                              : Colors.white24),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // Genres
                Text('Genres',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _genres.entries.map((e) {
                    return FilterChip(
                      label: Text(e.key),
                      selected: e.value,
                      onSelected: (val) {
                        setSheetState(() => _genres[e.key] = val);
                        setState(() => _genres[e.key] = val);
                      },
                      selectedColor:
                      const Color(0xFFE50914).withOpacity(0.3),
                      checkmarkColor: const Color(0xFFE50914),
                      backgroundColor:
                      Colors.white.withOpacity(0.05),
                      labelStyle: TextStyle(
                          color: e.value
                              ? const Color(0xFFE50914)
                              : Colors.white70),
                      side: BorderSide(
                          color: e.value
                              ? const Color(0xFFE50914)
                              : Colors.white24),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE50914),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      Navigator.pop(ctx);
                      _showSnackBar('Content filters saved');
                    },
                    child: const Text('Save Filters',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Backup / Restore ───────────────────────────────────────────────────────

  Future<void> _backupDatabase() async {
    _showSnackBar('Backup started…');
    try {
      // await widget.isarService.backupDatabase();
      await Future.delayed(const Duration(seconds: 1)); // simulate
      _showSnackBar('✓ Backup completed successfully');
    } catch (e) {
      _showSnackBar('Backup failed: $e', isError: true);
    }
  }

  Future<void> _restoreDatabase() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1F1F1F),
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Restore Database',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Text(
            'This will replace all current data with the backup. Continue?',
            style:
            TextStyle(color: Colors.white.withOpacity(0.7))),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text('Cancel',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.6)))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE50914)),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Restore',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      _showSnackBar('Restore started…');
      try {
        // await widget.isarService.restoreDatabase();
        await Future.delayed(const Duration(seconds: 1));
        _showSnackBar('✓ Restore completed successfully');
      } catch (e) {
        _showSnackBar('Restore failed: $e', isError: true);
      }
    }
  }

  // ── Storage ────────────────────────────────────────────────────────────────

  void _showStorageInfo() {
    // Replace mock values with real data from isarService if available
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1F1F1F),
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Storage Usage',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _storageRow('Database', '12.4 MB'),
            _storageRow('Image Cache', '48.2 MB'),
            _storageRow('Backups', '8.1 MB'),
            const Divider(color: Colors.white24, height: 24),
            _storageRow('Total', '68.7 MB', highlight: true),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close',
                style: TextStyle(color: Color(0xFFE50914))),
          ),
        ],
      ),
    );
  }

  Widget _storageRow(String label, String value,
      {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  color: highlight
                      ? Colors.white
                      : Colors.white.withOpacity(0.7),
                  fontWeight: highlight
                      ? FontWeight.bold
                      : FontWeight.normal)),
          Text(value,
              style: TextStyle(
                  color: highlight
                      ? const Color(0xFFE50914)
                      : Colors.white70,
                  fontWeight: highlight
                      ? FontWeight.bold
                      : FontWeight.normal)),
        ],
      ),
    );
  }

  // ── Account ────────────────────────────────────────────────────────────────

  void _showAccountOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1F1F1F),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFD600).withOpacity(0.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(Icons.lock_clock_outlined,
                  color: Color(0xFFFFD600), size: 40),
            ),
            const SizedBox(height: 16),
            const Text('Coming Soon!',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              'Account sync across devices is in development.\nStay tuned for future updates!',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white.withOpacity(0.6), height: 1.5),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD600),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Got it!',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Help & Support ─────────────────────────────────────────────────────────

  void _showHelpSupport() {
    final faqs = [
      {
        'q': 'How do I add a movie?',
        'a': 'Tap the + button on the home screen and search for a movie by name.'
      },
      {
        'q': 'Can I organise movies into folders?',
        'a': 'Yes! Long-press a movie and select "Move to folder", or create folders from the home screen.'
      },
      {
        'q': 'How do I backup my data?',
        'a': 'Go to Settings → Data & Backup → Backup Database to export your data.'
      },
      {
        'q': 'Is my data stored online?',
        'a': 'All data is stored locally on your device. No account is required.'
      },
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1F1F1F),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        builder: (_, ctrl) => SingleChildScrollView(
          controller: ctrl,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Help & Support',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              ...faqs.map((faq) => _faqItem(faq['q']!, faq['a']!)),
              const SizedBox(height: 24),
              const Divider(color: Colors.white12),
              const SizedBox(height: 16),
              Text('Still need help?',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Text('support@markmymovie.app',
                  style: const TextStyle(
                      color: Color(0xFFE50914),
                      fontSize: 15,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _faqItem(String question, String answer) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
        splashColor: Colors.transparent,
      ),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        title: Text(question,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500)),
        iconColor: const Color(0xFFE50914),
        collapsedIconColor: Colors.white54,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(answer,
                style: TextStyle(
                    color: Colors.white.withOpacity(0.65),
                    height: 1.5)),
          ),
        ],
      ),
    );
  }

  // ── Rate / Share ───────────────────────────────────────────────────────────

  void _rateApp() {
    // TODO: Use url_launcher → store URL
    _showSnackBar('Opening App Store… (add url_launcher)');
  }

  void _shareApp() {
    // TODO: Use share_plus
    _showSnackBar('Sharing… (add share_plus package)');
  }

  // ── Privacy / Terms ────────────────────────────────────────────────────────

  void _showPrivacyPolicy() => _showTextSheet(
    'Privacy Policy',
    'Mark My Movie stores all data locally on your device.\n\n'
        'We do not collect, transmit, or sell any personal information. '
        'Movie metadata is fetched from TMDB solely to display posters and '
        'details within the app.\n\n'
        'No analytics or tracking SDKs are included. Your watchlist is yours.',
  );

  void _showTermsOfService() => _showTextSheet(
    'Terms of Service',
    'By using Mark My Movie you agree to use it for personal, '
        'non-commercial purposes only.\n\n'
        'The app is provided "as is" without warranties of any kind. '
        'We are not responsible for data loss — please use the backup '
        'feature regularly.\n\n'
        'Movie data is sourced from TMDB. All trademarks belong to their '
        'respective owners.',
  );

  void _showTextSheet(String title, String body) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1F1F1F),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.55,
        maxChildSize: 0.85,
        builder: (_, ctrl) => SingleChildScrollView(
          controller: ctrl,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Text(body,
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      height: 1.6,
                      fontSize: 15)),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ── About ──────────────────────────────────────────────────────────────────

  void _showAboutDialogCustom() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1F1F1F),
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE50914).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.movie,
                  color: Color(0xFFE50914), size: 40),
            ),
            const SizedBox(height: 16),
            const Text('Mark My Movie',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('Version $_appVersion (build $_buildNumber)',
                style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 13)),
            const SizedBox(height: 12),
            Text(
              'Your personal movie vault.\nMade with ❤️ for movie lovers.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white.withOpacity(0.65), height: 1.5),
            ),
            const SizedBox(height: 8),
            Text('© 2024 Mark My Movie',
                style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 12)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close',
                style: TextStyle(color: Color(0xFFE50914))),
          ),
        ],
      ),
    );
  }

  // ── Danger Zone ────────────────────────────────────────────────────────────

  Future<void> _clearCache() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1F1F1F),
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Clear Cache',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Text('This will remove all cached images. Continue?',
            style:
            TextStyle(color: Colors.white.withOpacity(0.7))),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text('Cancel',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.6)))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE50914)),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Clear',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      // TODO: implement real cache clear (e.g. DefaultCacheManager().emptyCache())
      await Future.delayed(const Duration(milliseconds: 500));
      _showSnackBar('✓ Cache cleared');
    }
  }

  Future<void> _resetApp() async {
    // Step 1 – first warning
    final step1 = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1F1F1F),
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('⚠️ Reset App',
            style: TextStyle(color: Color(0xFFE50914), fontWeight: FontWeight.bold)),
        content: Text(
            'This will permanently delete ALL your movies, folders and settings. '
                'This action cannot be undone.',
            style:
            TextStyle(color: Colors.white.withOpacity(0.7))),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text('Cancel',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.6)))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE50914)),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Continue',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (step1 != true) return;

    // Step 2 – final confirmation
    final step2 = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1F1F1F),
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Are you absolutely sure?',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Text(
            'Type RESET to confirm.\n\n(In a real app, wire up a TextField here.)',
            style:
            TextStyle(color: Colors.white.withOpacity(0.7))),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Go Back',
                  style: TextStyle(color: Colors.white54))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE50914)),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Reset Everything',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (step2 != true) return;

    try {
      // await widget.isarService.clearAll();
      await Future.delayed(const Duration(milliseconds: 500));
      _showSnackBar('App has been reset');
    } catch (e) {
      _showSnackBar('Reset failed: $e', isError: true);
    }
  }
}