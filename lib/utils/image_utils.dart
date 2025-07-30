import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'constants.dart';

/// A utility class for handling product images without watermarks
class ProductImageUtils {
  /// Removes any watermark from an image URL by applying transformations
  static String cleanImageUrl(String url) {
    // This is a placeholder for any URL transformations that might be needed
    // In a real app, you might need to modify the URL to point to a clean version
    return url;
  }
  
  /// Creates a widget that displays a product image without watermarks
  static Widget buildCleanProductImage(
    String imageUrl, {
    BoxFit fit = BoxFit.contain,
    double? width,
    double? height,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final actualWidth = width ?? constraints.maxWidth;
        final actualHeight = height ?? constraints.maxHeight;
        
        return SizedBox(
          width: actualWidth,
          height: actualHeight,
          child: Stack(
            children: [
              // Main image
              Positioned.fill(
                child: CachedNetworkImage(
                  imageUrl: cleanImageUrl(imageUrl),
                  fit: fit,
                  placeholder: (context, url) => Container(
                    color: AppColors.border,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: AppColors.border,
                    child: const Icon(Icons.error),
                  ),
                ),
              ),
              
              // Mask to cover the watermark text on the right side
              if (!AppConfig.showWatermarks)
                Positioned(
                  top: 0,
                  bottom: 0,
                  right: 0,
                  width: actualWidth * 0.45, // Increase to 45% of the right side
                  child: Container(
                    color: Colors.white, // Match the background color
                  ),
                ),
            ],
          ),
        );
      }
    );
  }
} 