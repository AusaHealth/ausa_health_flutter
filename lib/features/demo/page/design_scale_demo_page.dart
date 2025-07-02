import 'package:flutter/material.dart';
import '../../../constants/constants.dart';

/// Demo page showcasing the design scale system
/// Shows how typography, spacing, radius, and shadows scale together
class DesignScaleDemoPage extends StatefulWidget {
  const DesignScaleDemoPage({super.key});

  @override
  State<DesignScaleDemoPage> createState() => _DesignScaleDemoPageState();
}

class _DesignScaleDemoPageState extends State<DesignScaleDemoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Design Scale Demo',
          style: AppTypography.title1(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Scale Selector Section
            _buildScaleSelector(),

            SizedBox(height: AppSpacing.xl3),

            // Demo Card
            Center(child: _buildDemoCard()),

            SizedBox(height: AppSpacing.xl2),

            // Info Section
            _buildInfoSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildScaleSelector() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: DesignScaleManager.scaleValue(8),
            offset: Offset(0, DesignScaleManager.scaleValue(2)),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         
          SizedBox(height: AppSpacing.md),
          DropdownButtonFormField<DesignScale>(
            value: DesignScaleManager.currentScale,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: AppRadius.circular(AppRadius.sm),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
            ),
            items:
                DesignScaleManager.availableScales.map((scale) {
                  return DropdownMenuItem<DesignScale>(
                    value: scale,
                    child: Text(
                      '${scale.displayName} (${scale.multiplier}x)',
                      style: AppTypography.body(),
                    ),
                  );
                }).toList(),
            onChanged: (DesignScale?
             newScale) {
              if (newScale != null) {
                setState(() {
                  DesignScaleManager.setScale(newScale);
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDemoCard() {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(maxWidth: DesignScaleManager.scaleValue(400)),
      padding: EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.circular(AppRadius.xl),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: DesignScaleManager.scaleValue(20),
            offset: Offset(0, DesignScaleManager.scaleValue(10)),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: DesignScaleManager.scaleValue(5),
            offset: Offset(0, DesignScaleManager.scaleValue(2)),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon with scaled spacing
          Container(
            width: DesignScaleManager.scaleValue(80),
            height: DesignScaleManager.scaleValue(80),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: AppRadius.circular(AppRadius.lg),
            ),
            child: Icon(
              Icons.design_services,
              size: DesignScaleManager.scaleValue(40),
              color: Colors.blue,
            ),
          ),

          SizedBox(height: AppSpacing.lg),

          // Typography examples
          Text(
            'Design Scale Demo',
            style: AppTypography.title2(color: Colors.black87),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: AppSpacing.sm),

          Text(
            'This card demonstrates how all design tokens scale together',
            style: AppTypography.body(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: AppSpacing.lg),

          // Spacing demonstration
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSpacingBox('XS', AppSpacing.xs),
              _buildSpacingBox('SM', AppSpacing.sm),
              _buildSpacingBox('MD', AppSpacing.md),
              _buildSpacingBox('LG', AppSpacing.lg),
            ],
          ),

          SizedBox(height: AppSpacing.lg),

          // Radius demonstration
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildRadiusBox('SM', AppRadius.sm),
              _buildRadiusBox('MD', AppRadius.md),
              _buildRadiusBox('LG', AppRadius.lg),
              _buildRadiusBox('XL', AppRadius.xl),
            ],
          ),

          SizedBox(height: AppSpacing.xl),

          // Action button
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Current scale: ${DesignScaleManager.currentScale.displayName}',
                    style: AppTypography.callout(color: Colors.white),
                  ),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.circular(AppRadius.sm),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.xl,
                vertical: AppSpacing.md,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: AppRadius.circular(AppRadius.lg),
              ),
            ),
            child: Text(
              'Test Scale',
              style: AppTypography.callout(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpacingBox(String label, double spacing) {
    return Column(
      children: [
        Container(
          width: spacing,
          height: DesignScaleManager.scaleValue(20),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: AppRadius.circular(AppRadius.sm),
          ),
        ),
        SizedBox(height: AppSpacing.xs),
        Text(label, style: AppTypography.callout(color: Colors.grey[600])),
        Text(
          '${spacing.toStringAsFixed(0)}px',
          style: AppTypography.callout(color: Colors.grey[500]),
        ),
      ],
    );
  }

  Widget _buildRadiusBox(String label, double radius) {
    return Column(
      children: [
        Container(
          width: DesignScaleManager.scaleValue(40),
          height: DesignScaleManager.scaleValue(40),
          decoration: BoxDecoration(
            color: Colors.purple,
            borderRadius: AppRadius.circular(radius),
          ),
        ),
        SizedBox(height: AppSpacing.xs),
        Text(label, style: AppTypography.callout(color: Colors.grey[600])),
        Text(
          '${radius.toStringAsFixed(0)}px',
          style: AppTypography.callout(color: Colors.grey[500]),
        ),
      ],
    );
  }

  Widget _buildInfoSection() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: DesignScaleManager.scaleValue(8),
            offset: Offset(0, DesignScaleManager.scaleValue(2)),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What\'s Scaling?',
            style: AppTypography.headline(color: Colors.black87),
          ),
          SizedBox(height: AppSpacing.md),
          _buildInfoItem('Typography', 'All text sizes scale proportionally'),
          _buildInfoItem(
            'Spacing',
            'Padding, margins, and gaps scale together',
          ),
          _buildInfoItem('Radius', 'Border radius maintains proportions'),
          _buildInfoItem(
            'Shadows',
            'Shadow blur and offset scale with content',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String title, String description) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: DesignScaleManager.scaleValue(8),
            height: DesignScaleManager.scaleValue(8),
            margin: EdgeInsets.only(top: AppSpacing.xs, right: AppSpacing.sm),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: AppRadius.circular(AppRadius.full),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.callout(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  description,
                  style: AppTypography.callout(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
