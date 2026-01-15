import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/theme/app_theme.dart';

/// Screen for customizing and sharing a reflection as an image
/// Fullscreen editor style (like Instagram Stories)
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

enum _ExpandedControl { none, background, font, size }

class _ShareImageScreenState extends State<ShareImageScreen> {
  final ScreenshotController _screenshotController = ScreenshotController();
  final ImagePicker _imagePicker = ImagePicker();

  int _selectedBackgroundIndex = 0;
  int _selectedFontIndex = 0;
  File? _customBackgroundImage;
  bool _isSharing = false;
  bool _showControls = true;
  _ExpandedControl _expandedControl = _ExpandedControl.none;

  // Text transformation - Instagram-style
  double _scale = 1.0;
  double _baseScale = 1.0;
  Offset _offset = Offset.zero;
  Offset _lastFocalPoint = Offset.zero;
  double _fontSize = 20.0; // Same as Story

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
  static const List<String> _fontNames = ['Lora', 'Playfair', 'Nunito', 'Merri'];

  TextStyle _getSelectedFont({
    double fontSize = 20,
    FontWeight fontWeight = FontWeight.normal,
    Color color = Colors.white,
    double height = 1.5,
  }) {
    switch (_selectedFontIndex) {
      case 0:
        return GoogleFonts.lora(fontSize: fontSize, fontWeight: fontWeight, color: color, height: height);
      case 1:
        return GoogleFonts.playfairDisplay(fontSize: fontSize, fontWeight: fontWeight, color: color, height: height);
      case 2:
        return GoogleFonts.nunito(fontSize: fontSize, fontWeight: fontWeight, color: color, height: height);
      case 3:
        return GoogleFonts.merriweather(fontSize: fontSize, fontWeight: fontWeight, color: color, height: height);
      default:
        return GoogleFonts.lora(fontSize: fontSize, fontWeight: fontWeight, color: color, height: height);
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
          _selectedBackgroundIndex = -1;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: AppTheme.errorColor),
        );
      }
    }
  }

  void _showShareOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A2E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),

            // Share option
            _buildShareOption(
              icon: Icons.share_outlined,
              label: 'Compartir',
              onTap: () {
                Navigator.pop(context);
                _executeShare();
              },
            ),

            // Save to gallery option
            _buildShareOption(
              icon: Icons.download_outlined,
              label: 'Guardar en galería',
              onTap: () {
                Navigator.pop(context);
                _saveToGallery();
              },
            ),

            SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
          ],
        ),
      ),
    );
  }

  Widget _buildShareOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
      title: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      onTap: onTap,
    );
  }

  Future<Uint8List?> _captureImage() async {
    setState(() {
      _isSharing = true;
      _showControls = false;
    });
    await Future.delayed(const Duration(milliseconds: 100));

    try {
      return await _screenshotController.capture(pixelRatio: 3.0);
    } finally {
      if (mounted) {
        setState(() {
          _isSharing = false;
          _showControls = true;
        });
      }
    }
  }

  Future<void> _executeShare() async {
    if (_isSharing) return;

    try {
      final imageBytes = await _captureImage();
      if (imageBytes == null) throw Exception('No se pudo capturar');

      final directory = await getTemporaryDirectory();
      final imagePath = '${directory.path}/reflexion_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File(imagePath);
      await file.writeAsBytes(imageBytes);

      await Share.shareXFiles([XFile(imagePath)]);
    } catch (e) {
      _showError('Error al compartir: $e');
    }
  }

  Future<void> _saveToGallery() async {
    if (_isSharing) return;

    try {
      final imageBytes = await _captureImage();
      if (imageBytes == null) throw Exception('No se pudo capturar');

      final directory = await getTemporaryDirectory();
      final imagePath = '${directory.path}/reflexion_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File(imagePath);
      await file.writeAsBytes(imageBytes);

      await Gal.putImage(imagePath);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Imagen guardada en galería'),
            backgroundColor: Colors.green.shade700,
          ),
        );
      }
    } catch (e) {
      _showError('Error al guardar: $e');
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: AppTheme.errorColor),
      );
    }
  }

  void _resetTransform() {
    setState(() {
      _scale = 1.0;
      _offset = Offset.zero;
      _fontSize = 20.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // FULLSCREEN: Screenshot area (the actual shareable image)
          Positioned.fill(
            child: Screenshot(
              controller: _screenshotController,
              child: _buildShareableImage(),
            ),
          ),

          // TOP CONTROLS: Semi-transparent panel
          if (_showControls)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _buildTopControls(),
            ),

          // BOTTOM: Share button
          if (_showControls)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildBottomBar(),
            ),
        ],
      ),
    );
  }

  Widget _buildShareableImage() {
    return Container(
      // Background
      decoration: _selectedBackgroundIndex >= 0
          ? BoxDecoration(gradient: _backgrounds[_selectedBackgroundIndex].gradient)
          : null,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Custom background image
          if (_selectedBackgroundIndex < 0 && _customBackgroundImage != null)
            Image.file(_customBackgroundImage!, fit: BoxFit.cover),

          // Dark overlay
          Container(
            color: Colors.black.withOpacity(_selectedBackgroundIndex >= 0 ? 0.3 : 0.5),
          ),

          // Content with gestures - OverflowBox allows content to exceed bounds without error
          GestureDetector(
            onTap: () {
              // Close expanded options when tapping on the image
              if (_expandedControl != _ExpandedControl.none) {
                setState(() => _expandedControl = _ExpandedControl.none);
              }
            },
            onScaleStart: (details) {
              _baseScale = _scale;
              _lastFocalPoint = details.focalPoint;
            },
            onScaleUpdate: (details) {
              setState(() {
                _scale = (_baseScale * details.scale).clamp(0.5, 3.0);
                final delta = details.focalPoint - _lastFocalPoint;
                _offset += delta;
                _lastFocalPoint = details.focalPoint;
              });
            },
            child: Container(
              color: Colors.transparent,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return OverflowBox(
                    maxWidth: constraints.maxWidth, // Keep width constrained for text wrapping
                    maxHeight: double.infinity, // Only allow vertical overflow
                    child: Center(
                  child: Transform.translate(
                    offset: _offset,
                    child: Transform.scale(
                      scale: _scale,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Title
                            Text(
                              widget.title,
                              style: _getSelectedFont(
                                fontSize: _fontSize * 0.9,
                                fontWeight: FontWeight.w500,
                                color: Colors.white.withOpacity(0.8),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),

                            // Decorative line
                            Container(
                              width: 60,
                              height: 2,
                              decoration: BoxDecoration(
                                gradient: AppTheme.goldGradient,
                                borderRadius: BorderRadius.circular(1),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Main content
                            Text(
                              '"${widget.content}"',
                              style: _getSelectedFont(
                                fontSize: _fontSize,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),

                            // Reference
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.white.withOpacity(0.2)),
                              ),
                              child: Text(
                                '📖 ${widget.reference}',
                                style: _getSelectedFont(
                                  fontSize: _fontSize * 0.7,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Signature
                            Text(
                              '— Biblia Chat',
                              style: _getSelectedFont(
                                fontSize: _fontSize * 0.65,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopControls() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.7),
            Colors.black.withOpacity(0.0),
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header row: Close + Icons + Reset
              Row(
                children: [
                  // Close button
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: Colors.white, size: 26),
                  ),
                  const Spacer(),

                  // Background icon
                  _buildControlIcon(
                    icon: Icons.palette_outlined,
                    isActive: _expandedControl == _ExpandedControl.background,
                    onTap: () => _toggleControl(_ExpandedControl.background),
                  ),
                  const SizedBox(width: 8),

                  // Font icon
                  _buildTextControlIcon(
                    text: 'Aa',
                    isActive: _expandedControl == _ExpandedControl.font,
                    onTap: () => _toggleControl(_ExpandedControl.font),
                  ),
                  const SizedBox(width: 8),

                  // Size icon
                  _buildTextControlIcon(
                    text: 'A',
                    fontSize: 18,
                    showSizeIndicator: true,
                    isActive: _expandedControl == _ExpandedControl.size,
                    onTap: () => _toggleControl(_ExpandedControl.size),
                  ),
                  const SizedBox(width: 12),

                  // Reset button (only when transformed)
                  if (_scale != 1.0 || _offset != Offset.zero || _fontSize != 20.0)
                    GestureDetector(
                      onTap: _resetTransform,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Text(
                          'Reset',
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      ),
                    ),
                ],
              ),

              // Expanded options
              AnimatedSize(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                child: _buildExpandedOptions(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleControl(_ExpandedControl control) {
    setState(() {
      if (_expandedControl == control) {
        _expandedControl = _ExpandedControl.none;
      } else {
        _expandedControl = control;
      }
    });
  }

  Widget _buildControlIcon({
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isActive ? AppTheme.primaryColor.withOpacity(0.3) : Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isActive ? AppTheme.primaryColor : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Icon(
          icon,
          color: isActive ? AppTheme.primaryColor : Colors.white70,
          size: 22,
        ),
      ),
    );
  }

  Widget _buildTextControlIcon({
    required String text,
    required bool isActive,
    required VoidCallback onTap,
    double fontSize = 16,
    bool showSizeIndicator = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isActive ? AppTheme.primaryColor.withOpacity(0.3) : Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isActive ? AppTheme.primaryColor : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Center(
          child: showSizeIndicator
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'A',
                      style: TextStyle(
                        color: isActive ? AppTheme.primaryColor : Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'A',
                      style: TextStyle(
                        color: isActive ? AppTheme.primaryColor : Colors.white70,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                )
              : Text(
                  text,
                  style: TextStyle(
                    color: isActive ? AppTheme.primaryColor : Colors.white70,
                    fontSize: fontSize,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildExpandedOptions() {
    switch (_expandedControl) {
      case _ExpandedControl.background:
        return Padding(
          padding: const EdgeInsets.only(top: 12),
          child: SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: _backgrounds.length + 1,
              itemBuilder: (context, index) {
                if (index == _backgrounds.length) return _buildPhotoPickerButton();
                return _buildBackgroundOption(index);
              },
            ),
          ),
        );

      case _ExpandedControl.font:
        return Padding(
          padding: const EdgeInsets.only(top: 12),
          child: SizedBox(
            height: 36,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: _fontNames.length,
              itemBuilder: (context, index) => _buildFontChip(index),
            ),
          ),
        );

      case _ExpandedControl.size:
        return Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            children: [
              const SizedBox(width: 8),
              const Text('Aa', style: TextStyle(color: Colors.white70, fontSize: 14)),
              Expanded(
                child: Slider(
                  value: _fontSize,
                  min: 14,
                  max: 32,
                  activeColor: AppTheme.primaryColor,
                  inactiveColor: Colors.white24,
                  onChanged: (value) => setState(() => _fontSize = value),
                ),
              ),
              Text(
                '${_fontSize.round()}',
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(width: 8),
            ],
          ),
        );

      case _ExpandedControl.none:
        return const SizedBox.shrink();
    }
  }

  Widget _buildBottomBar() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.black.withOpacity(0.7),
            Colors.black.withOpacity(0.0),
          ],
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _isSharing ? null : _showShareOptions,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: AppTheme.textOnPrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              child: _isSharing
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.share, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Compartir imagen',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackgroundOption(int index) {
    final isSelected = _selectedBackgroundIndex == index;
    return GestureDetector(
      onTap: () => setState(() {
        _selectedBackgroundIndex = index;
        _customBackgroundImage = null;
      }),
      child: Container(
        width: 44,
        height: 44,
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          gradient: _backgrounds[index].gradient,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.transparent,
            width: 2,
          ),
        ),
        child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 20) : null,
      ),
    );
  }

  Widget _buildPhotoPickerButton() {
    final isSelected = _selectedBackgroundIndex == -1 && _customBackgroundImage != null;
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.white38,
            width: 2,
          ),
          image: _customBackgroundImage != null
              ? DecorationImage(image: FileImage(_customBackgroundImage!), fit: BoxFit.cover)
              : null,
        ),
        child: _customBackgroundImage == null
            ? const Icon(Icons.add_photo_alternate, color: Colors.white70, size: 20)
            : null,
      ),
    );
  }

  Widget _buildFontChip(int index) {
    final isSelected = _selectedFontIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedFontIndex = index),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor.withOpacity(0.3) : Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : Colors.transparent,
          ),
        ),
        child: Text(
          _fontNames[index],
          style: TextStyle(
            color: isSelected ? AppTheme.primaryColor : Colors.white70,
            fontSize: 13,
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
  const _BackgroundOption({required this.name, required this.gradient});
}
