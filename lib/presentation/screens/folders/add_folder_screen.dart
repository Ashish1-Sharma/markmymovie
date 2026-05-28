import 'package:flutter/material.dart';
import 'package:markmymovie/data/local_db/isar_service.dart';
import 'package:markmymovie/data/models/folder_model.dart';

class AddFolderScreen extends StatefulWidget {
  final IsarService isarService;

  const AddFolderScreen({super.key, required this.isarService});

  @override
  State<AddFolderScreen> createState() => _AddFolderScreenState();
}

class _AddFolderScreenState extends State<AddFolderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  IconData _selectedIcon = Icons.folder;
  Color _selectedColor = const Color(0xFFE50914); // Netflix red
  bool _isLoading = false;

  // Predefined folder templates
  final List<FolderTemplate> _templates = [
    FolderTemplate(
      name: 'Weekend Watch',
      description: 'Movies for cozy weekend nights',
      icon: Icons.weekend,
      color: Color(0xFFE50914),
    ),
    FolderTemplate(
      name: 'Action Packed',
      description: 'High-octane thrills and adventures',
      icon: Icons.local_fire_department,
      color: Color(0xFFFF5722),
    ),
    FolderTemplate(
      name: 'Date Night',
      description: 'Perfect for romantic evenings',
      icon: Icons.favorite,
      color: Color(0xFFE91E63),
    ),
    FolderTemplate(
      name: 'Family Time',
      description: 'Movies everyone can enjoy',
      icon: Icons.family_restroom,
      color: Color(0xFF4CAF50),
    ),
    FolderTemplate(
      name: 'Sci-Fi Collection',
      description: 'Mind-bending future worlds',
      icon: Icons.rocket_launch,
      color: Color(0xFF3F51B5),
    ),
    FolderTemplate(
      name: 'Horror Nights',
      description: 'Spine-chilling scary movies',
      icon: Icons.nightlight,
      color: Color(0xFF9C27B0),
    ),
  ];

  // Available colors
  final List<Color> _colors = [
    const Color(0xFFE50914), // Netflix red
    const Color(0xFFFF5722), // Deep orange
    const Color(0xFFE91E63), // Pink
    const Color(0xFF9C27B0), // Purple
    const Color(0xFF3F51B5), // Indigo
    const Color(0xFF2196F3), // Blue
    const Color(0xFF009688), // Teal
    const Color(0xFF4CAF50), // Green
    const Color(0xFFFFD600), // Amber
    const Color(0xFFFF9800), // Orange
  ];

  // Available icons
  final List<IconData> _icons = [
    Icons.folder,
    Icons.movie,
    Icons.favorite,
    Icons.star,
    Icons.weekend,
    Icons.local_fire_department,
    Icons.rocket_launch,
    Icons.nightlight,
    Icons.family_restroom,
    Icons.theater_comedy,
    Icons.camera_roll,
    Icons.video_library,
    Icons.trending_up,
    Icons.grade,
    Icons.bookmark,
    Icons.watch_later,
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _useTemplate(FolderTemplate template) {
    setState(() {
      _nameController.text = template.name;
      _descriptionController.text = template.description;
      _selectedIcon = template.icon;
      _selectedColor = template.color;
    });
  }

  Future<void> _saveFolder() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // try {
      // TODO: Replace with actual Isar database save
      await Future.delayed(const Duration(milliseconds: 800));


      final newFolder = FolderModel(
        modifiedTime: DateTime.now(),
        name: _nameController.text.trim(),
        createdAt: DateTime.now(),
        colorValue: _selectedColor.value,
        iconCodePoint: _selectedIcon.codePoint,
        iconFontFamily:  _selectedIcon.fontFamily!
      );


      // TODO: Save to database using widget.isarService
await widget.isarService.saveFolder(newFolder);
      if (mounted) {
        Navigator.pop(context, newFolder);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Folder "${newFolder.name}" created successfully!'),
            backgroundColor: const Color(0xFF00C853),
          ),
        );
      }
//     } catch (e) {
//       setState(() => _isLoading = false);
// print(e);
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: const Text('Failed to create folder. Please try again.'),
//             backgroundColor: Colors.red[600],
//           ),
//         );
//       }
//     }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Create Folder',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveFolder,
            child: _isLoading
                ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE50914)),
              ),
            )
                : const Text(
              'Save',
              style: TextStyle(
                color: Color(0xFFE50914),
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Folder Preview
              _buildFolderPreview(),

              const SizedBox(height: 32),

              // Quick Templates
              _buildQuickTemplates(),

              const SizedBox(height: 32),

              // Custom Fields
              _buildCustomFields(),

              const SizedBox(height: 32),

              // Icon Selection
              _buildIconSelection(),

              const SizedBox(height: 32),

              // Color Selection
              _buildColorSelection(),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFolderPreview() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF1F1F1F),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Icon with color
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: _selectedColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _selectedColor, width: 2),
              ),
              child: Icon(
                _selectedIcon,
                size: 40,
                color: _selectedColor,
              ),
            ),

            const SizedBox(height: 16),

            // Preview name
            Text(
              _nameController.text.isEmpty ? 'Folder Name' : _nameController.text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            // Preview description
            Text(
              _descriptionController.text.isEmpty
                  ? 'Add a description...'
                  : _descriptionController.text,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
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

  Widget _buildQuickTemplates() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Templates',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _templates.length,
            itemBuilder: (context, index) {
              final template = _templates[index];
              return GestureDetector(
                onTap: () => _useTemplate(template),
                child: Container(
                  width: 100,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1F1F1F),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: template.color.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        template.icon,
                        color: template.color,
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        template.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCustomFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Folder Details',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),

        // Name field
        TextFormField(
          controller: _nameController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: 'Folder Name',
            labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
            hintText: 'e.g., Weekend Watch',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
            filled: true,
            fillColor: const Color(0xFF1F1F1F),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE50914), width: 2),
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a folder name';
            }
            if (value.trim().length < 2) {
              return 'Folder name must be at least 2 characters';
            }
            return null;
          },
          onChanged: (value) => setState(() {}), // Trigger preview update
        ),

        const SizedBox(height: 16),

        // Description field
        TextFormField(
          controller: _descriptionController,
          style: const TextStyle(color: Colors.white),
          maxLines: 3,
          decoration: InputDecoration(
            labelText: 'Description (Optional)',
            labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
            hintText: 'Describe what movies you\'ll save here...',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
            filled: true,
            fillColor: const Color(0xFF1F1F1F),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE50914), width: 2),
            ),
          ),
          onChanged: (value) => setState(() {}), // Trigger preview update
        ),
      ],
    );
  }

  Widget _buildIconSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choose Icon',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _icons.map((icon) {
            final isSelected = icon == _selectedIcon;
            return GestureDetector(
              onTap: () => setState(() => _selectedIcon = icon),
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: isSelected
                      ? _selectedColor.withOpacity(0.2)
                      : const Color(0xFF1F1F1F),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? _selectedColor
                        : Colors.white.withOpacity(0.1),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Icon(
                  icon,
                  color: isSelected ? _selectedColor : Colors.white.withOpacity(0.7),
                  size: 28,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildColorSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choose Color',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: _colors.map((color) {
            final isSelected = color == _selectedColor;
            return GestureDetector(
              onTap: () => setState(() => _selectedColor = color),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: isSelected
                      ? Border.all(color: Colors.white, width: 3)
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: isSelected
                    ? const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 24,
                )
                    : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// Helper classes
class FolderTemplate {
  final String name;
  final String description;
  final IconData icon;
  final Color color;

  FolderTemplate({
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
  });
}
