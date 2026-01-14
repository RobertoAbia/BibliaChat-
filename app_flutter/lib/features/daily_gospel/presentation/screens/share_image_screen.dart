import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/theme/app_theme.dart';

/// Screen for customizing and sharing a reflection as an image
class ShareImageScreen extends StatefulWidget {
  final String title;
  final String content;
  final String reference;

  const ShareImageScreen({
    super.key,
    required this.title,
    required this.content,
    required this.reference,
  });

  @override
  State<ShareImageScreen> createState() => _ShareImageScreenState();
}

class _ShareImageScreenState extends State<ShareImageScreen> {
  final ScreenshotController _screenshotController = ScreenshotController();
  final ImagePicker _imagePicker = ImagePicker();

  int _selectedBackgroundIndex = 0;
  int _selectedFontIndex = 0;
  File? _customBackgroundImage;
  bool _isSharing = false;

  // Predefined gradient backgrounds
  static const List<_BackgroundOption> _backgrounds = [
    _BackgroundOption(
      name: 'Noche',
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF1A1A2E), Color(0xFF16162A), Color(0xFF0F0F1A)],
      ),
    ),
    _BackgroundOption(
      name: 'Dorado',
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF8B6914), Color(0xFFD4AF37), Color(0xFF8B6914)],
      ),
    ),
    _BackgroundOption(
      name: 'Púrpura',
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF2D1B4E), Color(0xFF4A2C7A), Color(0xFF1A1030)],
      ),
    ),
    _BackgroundOption(
      name: 'Esperanza',
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF1B4D3E), Color(0xFF2D7A5E), Color(0xFF143D30)],
      ),
    ),
    _BackgroundOption(
      name: 'Atardecer',
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF4A1C40), Color(0xFF8B3A62), Color(0xFF2D1020)],
      ),
    ),
  ];

  // Available fonts
  static const List<String> _fontNames = [
    'Lora',
    'Playfair Display',
    'Nunito',
    'Merriweather',
  ];

  TextStyle _getSelectedFont({
    double fontSize = 24,
    FontWeight fontWeight = FontWeight.normal,
    Color color = Colors.white,
    double height = 1.5,
  }) {
    switch (_selectedFontIndex) {
      case 0:
        return GoogleFonts.lora(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          height: height,
        );
      case 1:
        return GoogleFonts.playfairDisplay(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          height: height,
        );
      case 2:
        return GoogleFonts.nunito(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          height: height,
        );
      case 3:
        return GoogleFonts.merriweather(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          height: height,
        );
      default:
        return GoogleFonts.lora(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          height: height,
        );
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _customBackgroundImage = File(image.path);
          _selectedBackgroundIndex = -1; // Custom image selected
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al seleccionar imagen: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  Future<void> _shareImage() async {
    if (_isSharing) return;

    setState(() => _isSharing = true);

    try {
      // Capture the widget as image
      final Uint8List? imageBytes = await _screenshotController.capture(
        pixelRatio: 3.0, // High resolution
      );

      if (imageBytes == null) {
        throw Exception('No se pudo capturar la imagen');
      }

      // Save to temporary directory
      final directory = await getTemporaryDirectory();
      final imagePath = '${directory.path}/reflexion_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File(imagePath);
      await file.writeAsBytes(imageBytes);

      // Share the image
      await Share.shareXFiles(
        [XFile(imagePath)],
        text: '${widget.content}\n\n📖 ${widget.reference}\n\n— Biblia Chat',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al compartir: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSharing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(),

              // Preview
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: 9 / 16,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Screenshot(
                          controller: _screenshotController,
                          child: _buildShareableImage(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Controls
              _buildControls(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 20, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppTheme.surfaceLight.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                color: AppTheme.textPrimary,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Compartir reflexión',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  // Calculate dynamic font size based on content length
  double _getContentFontSize() {
    final length = widget.content.length;
    if (length < 100) return 28;
    if (length < 200) return 24;
    if (length < 300) return 20;
    if (length < 400) return 18;
    if (length < 500) return 16;
    return 14;
  }

  Widget _buildShareableImage() {
    final contentFontSize = _getContentFontSize();

    return Container(
      width: 1080,
      height: 1920,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background
          if (_selectedBackgroundIndex >= 0)
            Container(
              decoration: BoxDecoration(
                gradient: _backgrounds[_selectedBackgroundIndex].gradient,
              ),
            )
          else if (_customBackgroundImage != null)
            Image.file(
              _customBackgroundImage!,
              fit: BoxFit.cover,
            ),

          // Dark overlay for readability
          Container(
            color: Colors.black.withOpacity(
              _selectedBackgroundIndex >= 0 ? 0.3 : 0.5,
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 60),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Title
                Text(
                  widget.title,
                  style: _getSelectedFont(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(0.8),
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 20),

                // Decorative line
                Container(
                  width: 60,
                  height: 2,
                  decoration: BoxDecoration(
                    gradient: AppTheme.goldGradient,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),

                const SizedBox(height: 24),

                // Main content with quotes - flexible to avoid overflow
                Flexible(
                  child: Center(
                    child: Text(
                      '"${widget.content}"',
                      style: _getSelectedFont(
                        fontSize: contentFontSize,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Bible reference
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                    ),
                  ),
                  child: Text(
                    '📖 ${widget.reference}',
                    style: _getSelectedFont(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // App signature
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        gradient: AppTheme.goldGradient,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.auto_stories,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Biblia Chat',
                      style: _getSelectedFont(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Background selector
          Text(
            'Fondo',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppTheme.textSecondary,
                ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _backgrounds.length + 1, // +1 for photo picker
              itemBuilder: (context, index) {
                if (index == _backgrounds.length) {
                  // Photo picker button
                  return _buildPhotoPickerButton();
                }
                return _buildBackgroundOption(index);
              },
            ),
          ),

          const SizedBox(height: 20),

          // Font selector
          Text(
            'Fuente',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppTheme.textSecondary,
                ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: List.generate(
              _fontNames.length,
              (index) => _buildFontChip(index),
            ),
          ),

          const SizedBox(height: 24),

          // Share button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _isSharing ? null : _shareImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: AppTheme.textOnPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: _isSharing
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.textOnPrimary,
                        ),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.share, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Compartir imagen',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: AppTheme.textOnPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundOption(int index) {
    final isSelected = _selectedBackgroundIndex == index;
    final bg = _backgrounds[index];

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedBackgroundIndex = index;
          _customBackgroundImage = null;
        });
      },
      child: Container(
        width: 60,
        height: 60,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          gradient: bg.gradient,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : Colors.transparent,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ]
              : null,
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
  }

  Widget _buildPhotoPickerButton() {
    final isSelected = _selectedBackgroundIndex == -1 && _customBackgroundImage != null;

    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: AppTheme.surfaceLight.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : AppTheme.surfaceLight,
            width: 2,
          ),
          image: _customBackgroundImage != null
              ? DecorationImage(
                  image: FileImage(_customBackgroundImage!),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: _customBackgroundImage == null
            ? const Icon(
                Icons.add_photo_alternate_outlined,
                color: AppTheme.textSecondary,
                size: 24,
              )
            : isSelected
                ? Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 24,
                    ),
                  )
                : null,
      ),
    );
  }

  Widget _buildFontChip(int index) {
    final isSelected = _selectedFontIndex == index;
    final fontName = _fontNames[index];

    return GestureDetector(
      onTap: () {
        setState(() => _selectedFontIndex = index);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryColor.withOpacity(0.2)
              : AppTheme.surfaceLight.withOpacity(0.3),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppTheme.primaryColor
                : Colors.transparent,
          ),
        ),
        child: Text(
          fontName,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
        ),
      ),
    );
  }
}

class _BackgroundOption {
  final String name;
  final LinearGradient gradient;

  const _BackgroundOption({
    required this.name,
    required this.gradient,
  });
}
