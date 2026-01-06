import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class BubbleAvatarGroup extends StatelessWidget {
  final List<String> imageURL;
  final int maxDisplay;
  final double avatarSize;
  final double overlapAmount;

  const BubbleAvatarGroup({
    super.key,
    required this.imageURL,
    this.maxDisplay = 3,
    this.avatarSize = 40, // Increased for better quality
    this.overlapAmount = 24,
  });

  Widget _buildSingleAvatar(String imageURL, BuildContext context) {
    final hasImage = imageURL.isNotEmpty && imageURL != 'null';

    return Container(
      width: avatarSize,
      height: avatarSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: ClipOval(
        child: hasImage
            ? _buildAvatarImage(imageURL, context)
            : _buildFallbackAvatar(context),
      ),
    );
  }

  Widget _buildAvatarImage(String imageURL, BuildContext context) {
    return Image(
      image: _getImageProvider(imageURL),
      width: avatarSize,
      height: avatarSize,
      fit: BoxFit.cover,
      filterQuality: FilterQuality.high,
      gaplessPlayback: true, // Prevents flickering
      errorBuilder: (context, error, stackTrace) {
        debugPrint('Image loading failed: $error');
        return _buildFallbackAvatar(context);
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        // Show loading indicator while image loads
        return Container(
          color: Colors.grey.shade200,
          child: Center(
            child: SizedBox(
              width: avatarSize * 0.4,
              height: avatarSize * 0.4,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFallbackAvatar(BuildContext context) {
    return Container(
      color: Colors.grey.shade300,
      child: Icon(
        Icons.person,
        size: avatarSize * 0.6,
        color: Theme.of(context).iconTheme.color?.withValues(alpha: 0.7),
      ),
    );
  }

  ImageProvider _getImageProvider(String imageData) {
    if (imageData.startsWith('data:image/')) {
      try {
        final decodedBytes = _decodeImage(imageData);
        return MemoryImage(decodedBytes);
      } catch (e) {
        return AssetImage('asset/images/logo.png');
      }
    } else if (imageData.startsWith('http')) {
      return NetworkImage(imageData);
    } else {
      return AssetImage('asset/images/logo.png');
    }
  }

  Widget _buildCounterBubble(int count) {
    return Container(
      width: avatarSize,
      height: avatarSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey.shade500,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Center(
        child: Text(
          '+$count',
          style: TextStyle(
            color: Colors.white,
            fontSize: avatarSize * 0.25, // Slightly smaller for better fit
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Uint8List _decodeImage(String imageData) {
    final base64Data =
        imageData.replaceFirst(RegExp(r'data:image/[^;]+;base64,'), '');
    return base64Decode(base64Data);
  }

  @override
  Widget build(BuildContext context) {
    final displayAvatars = imageURL.take(maxDisplay).toList();
    final remainingCount = imageURL.length - maxDisplay;

    return SizedBox(
      height: avatarSize,
      child: Stack(
        children: [
          // Display avatars
          for (int i = 0; i < displayAvatars.length; i++)
            Positioned(
              left: i * overlapAmount,
              child: _buildSingleAvatar(displayAvatars[i], context),
            ),

          // Counter for remaining avatars
          if (remainingCount > 0)
            Positioned(
              left: displayAvatars.length * overlapAmount,
              child: _buildCounterBubble(remainingCount),
            ),
        ],
      ),
    );
  }
}
