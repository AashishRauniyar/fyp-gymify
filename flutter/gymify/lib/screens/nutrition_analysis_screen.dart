import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gymify/utils/custom_appbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:gymify/providers/nutrition_analysis_provider.dart';
import 'package:gymify/models/nutrition_analysis_model.dart';

class NutritionAnalysisScreen extends StatefulWidget {
  const NutritionAnalysisScreen({super.key});

  @override
  State<NutritionAnalysisScreen> createState() =>
      _NutritionAnalysisScreenState();
}

class _NutritionAnalysisScreenState extends State<NutritionAnalysisScreen> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image =
        await _picker.pickImage(source: source, imageQuality: 85);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
      Provider.of<NutritionAnalysisProvider>(context, listen: false).reset();
    }
  }

  void _analyze() {
    if (_selectedImage != null) {
      Provider.of<NutritionAnalysisProvider>(context, listen: false)
          .analyzeImage(_selectedImage!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = Provider.of<NutritionAnalysisProvider>(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: const CustomAppBar(title: 'AI NutriScan'),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'GYMIFY NutriScan',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Snap or upload food to get instant nutrition facts',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Container(
                  width: 260,
                  height: 180,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: theme.colorScheme.primary.withOpacity(0.15),
                      width: 2,
                    ),
                  ),
                  child: _selectedImage == null
                      ? Center(
                          child: Text(
                            'No image selected',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.5),
                            ),
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.file(_selectedImage!,
                              fit: BoxFit.cover, width: 260, height: 180),
                        ),
                ),
                if (_selectedImage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: TextButton.icon(
                      onPressed: provider.isLoading
                          ? null
                          : () {
                              setState(() {
                                _selectedImage = null;
                              });
                              provider.reset();
                            },
                      icon: const Icon(Icons.close),
                      label: const Text('Remove'),
                    ),
                  ),
                const SizedBox(height: 32),
                // Centered beautiful buttons
                if (_selectedImage == null) ...[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 2,
                    children: [
                      _BeautifulButton(
                        icon: Icons.camera_alt,
                        label: 'Take Photo',
                        onTap: () => _pickImage(ImageSource.camera),
                        color1: theme.colorScheme.primary,
                        color2: theme.colorScheme.primary.withOpacity(0.8),
                      ),
                      const SizedBox(width: 16),
                      _BeautifulButton(
                        icon: Icons.upload,
                        label: 'Upload',
                        onTap: () => _pickImage(ImageSource.gallery),
                        color1: Colors.teal,
                        color2: Colors.teal.shade700,
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shield,
                          color: theme.colorScheme.primary, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        'Your photos are processed securely',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Tooltip(
                        message:
                            'NutriScan uses AI to estimate nutrition from your food photos. No images are stored.',
                        child: Icon(Icons.info_outline,
                            size: 18, color: theme.colorScheme.primary),
                      ),
                    ],
                  ),
                ],
                if (_selectedImage != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 8.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.analytics),
                        label: provider.isLoading
                            ? const Text('Analyzing...')
                            : const Text('Analyze'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: provider.isLoading ? null : _analyze,
                      ),
                    ),
                  ),
                const SizedBox(height: 24),
                if (provider.isLoading) const CircularProgressIndicator(),
                if (provider.error != null)
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      provider.error!,
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                  ),
                if (provider.result != null)
                  _NutritionResultCard(result: provider.result!),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BeautifulButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color1;
  final Color color2;

  const _BeautifulButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.color1,
    required this.color2,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(16),
      elevation: 6,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color1, color2],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            child: Row(
              children: [
                Icon(icon, color: Colors.white, size: 22),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NutritionResultCard extends StatelessWidget {
  final NutritionAnalysis result;
  const _NutritionResultCard({required this.result});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isHealthy = result.isHealthy;
    final color = isHealthy ? Colors.green : Colors.red;
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: theme.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              result.foodName,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Text(
                '${result.calories}',
                style: theme.textTheme.displaySmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text('calories', style: theme.textTheme.bodyMedium),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _MacroCircle(
                  label: 'Protein',
                  value: result.protein,
                  color: Colors.blue,
                ),
                _MacroCircle(
                  label: 'Carbs',
                  value: result.carbs,
                  color: Colors.amber.shade700,
                ),
                _MacroCircle(
                  label: 'Fat',
                  value: result.fat,
                  color: Colors.redAccent,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _NutrientText('Fiber', '${result.fiber}g'),
                _NutrientText('Sugar', '${result.sugar}g'),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _NutrientText('Sodium', '${result.sodium}mg'),
                _NutrientText('Potassium', '${result.potassium}mg'),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isHealthy ? Icons.check_circle : Icons.warning,
                  color: color,
                ),
                const SizedBox(width: 8),
                Text(
                  isHealthy ? 'Healthy Choice' : 'Unhealthy',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (result.healthBenefits.isNotEmpty)
              Column(
                children: [
                  Text('Health Benefits:', style: theme.textTheme.bodyMedium),
                  const SizedBox(height: 4),
                  Text(
                    result.healthBenefits,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.8),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _MacroCircle extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  const _MacroCircle(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: color.withOpacity(0.13),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '${value}g',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}

class _NutrientText extends StatelessWidget {
  final String label;
  final String value;
  const _NutrientText(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}
