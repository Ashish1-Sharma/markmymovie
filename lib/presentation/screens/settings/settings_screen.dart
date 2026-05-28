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

  // App info (you can get these from package_info_plus)
  final String _appVersion = '1.0.0';
  final String _buildNumber = '1';

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
            // Profile Section
            _buildProfileSection(),

            // const SizedBox(height: 32),

            // General Settings
            // _buildSectionHeader('General'),
            // _buildSettingsGroup([
            //   _buildSwitchTile(
            //     icon: Icons.notifications_outlined,
            //     title: 'Notifications',
            //     subtitle: 'Get notified about new movies and reminders',
            //     value: _notificationsEnabled,
            //     onChanged: (value) => setState(() => _notificationsEnabled = value),
            //   ),
            //   _buildSwitchTile(
            //     icon: Icons.dark_mode_outlined,
            //     title: 'Dark Mode',
            //     subtitle: 'Cinematic dark theme for better viewing',
            //     value: _darkModeEnabled,
            //     onChanged: (value) => setState(() => _darkModeEnabled = value),
            //   ),
            //   _buildSwitchTile(
            //     icon: Icons.high_quality_outlined,
            //     title: 'High Quality Images',
            //     subtitle: 'Download higher resolution movie posters',
            //     value: _highQualityImages,
            //     onChanged: (value) => setState(() => _highQualityImages = value),
            //   ),
            // ]),

            const SizedBox(height: 32),

            // Content & Display
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
                subtitle: 'Content availability: $_selectedRegion',
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

            // Data & Backup
            _buildSectionHeader('Data & Backup'),
            _buildSettingsGroup([
              _buildSwitchTile(
                icon: Icons.backup_outlined,
                title: 'Auto Backup',
                subtitle: 'Automatically backup your data weekly',
                value: _autoBackupEnabled,
                onChanged: (value) => setState(() => _autoBackupEnabled = value),
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

            // Account & Sync (Future feature)
            _buildSectionHeader('Account & Sync'),
            _buildSettingsGroup([
              _buildNavigationTile(
                icon: Icons.account_circle_outlined,
                title: 'Account',
                subtitle: 'Sign in to sync across devices',
                onTap: _showAccountOptions,
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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

            // Support & About
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
                onTap: _showAboutDialog,
              ),
            ]),

            const SizedBox(height: 32),

            // Danger Zone
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

            // App branding
            _buildAppBranding(),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Profile avatar
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
            child: const Icon(
              Icons.person,
              color: Color(0xFFE50914),
              size: 32,
            ),
          ),

          const SizedBox(width: 16),

          // Profile info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Movie Lover', // Replace with actual user name
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Local Account', // Replace with account type
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Edit profile button
          IconButton(
            onPressed: _editProfile,
            icon: const Icon(
              Icons.edit,
              color: Colors.white,
              size: 20,
            ),
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
        border: Border.all(
          color: Colors.white.withOpacity(0.05),
          width: 1,
        ),
      ),
      child: Column(
        children: children,
      ),
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
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF121212).withOpacity(0.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Colors.white.withOpacity(0.8),
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 14,
          ),
        ),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFFE50914),
          activeTrackColor: const Color(0xFFE50914).withOpacity(0.3),
          inactiveThumbColor: Colors.white.withOpacity(0.6),
          inactiveTrackColor: Colors.white.withOpacity(0.1),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
          leading: Container(
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
          ),
          title: Text(
            title,
            style: TextStyle(
              color: isDestructive
                  ? const Color(0xFFE50914)
                  : Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              color: isDestructive
                  ? const Color(0xFFE50914).withOpacity(0.7)
                  : Colors.white.withOpacity(0.6),
              fontSize: 14,
            ),
          ),
          trailing: trailing ?? (showChevron ? const Icon(
            Icons.chevron_right,
            color: Colors.white54,
            size: 20,
          ) : null),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        ),
      ),
    );
  }

  Widget _buildAppBranding() {
    return Center(
      child: Column(
        children: [
          // App icon
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE50914).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFE50914).withOpacity(0.3),
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.movie,
              color: Color(0xFFE50914),
              size: 40,
            ),
          ),

          const SizedBox(height: 16),

          // App name and tagline
          const Text(
            'Mark My Movie',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            'Your personal movie vault',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Made with ❤️ for movie lovers',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // ACTION METHODS (Implement your logic here)

  void _editProfile() {
    // TODO: Navigate to profile edit screen
    print('Edit profile');
  }

  void _showLanguageDialog() {
    // TODO: Show language selection dialog
    print('Show language options');
  }

  void _showRegionDialog() {
    // TODO: Show region selection dialog
    print('Show region options');
  }

  void _showContentFilters() {
    // TODO: Navigate to content filters screen
    print('Show content filters');
  }

  void _backupDatabase() {
    // TODO: Implement your backup logic here
    print('Backup database');
    // You can call widget.isarService.backupDatabase() here
  }

  void _restoreDatabase() {
    // TODO: Implement your restore logic here
    print('Restore database');
    // You can call widget.isarService.restoreDatabase() here
  }

  void _showStorageInfo() {
    // TODO: Show storage usage dialog
    print('Show storage info');
  }

  void _showAccountOptions() {
    // TODO: Navigate to account screen or show coming soon
    print('Show account options');
  }

  void _showHelpSupport() {
    // TODO: Navigate to help screen or open support URL
    print('Show help and support');
  }

  void _rateApp() {
    // TODO: Open app store for rating
    print('Rate app');
  }

  void _shareApp() {
    // TODO: Share app with others
    print('Share app');
  }

  void _showPrivacyPolicy() {
    // TODO: Show privacy policy
    print('Show privacy policy');
  }

  void _showTermsOfService() {
    // TODO: Show terms of service
    print('Show terms of service');
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'Mark My Movie',
      applicationVersion: _appVersion,
      applicationLegalese: '© 2024 Mark My Movie\nMade with love for movie enthusiasts',
      children: [
        const SizedBox(height: 16),
        const Text('A beautiful app to organize and track your favorite movies.'),
      ],
    );
  }

  void _clearCache() {
    // TODO: Show confirmation and clear cache
    print('Clear cache');
  }

  void _resetApp() {
    // TODO: Show warning and reset app
    print('Reset app');
  }
}