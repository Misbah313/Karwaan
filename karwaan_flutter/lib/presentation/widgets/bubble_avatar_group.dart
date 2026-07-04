import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class BubbleAvatarGroup extends StatelessWidget {
  final List<String> imageURL;
  final List<String> userNames; // ← Add this
  final int maxDisplay;
  final double avatarSize;
  final double overlapAmount;

  const BubbleAvatarGroup({
    super.key,
    required this.imageURL,
    required this.userNames, // ← Make it required
    this.maxDisplay = 3,
    this.avatarSize = 40,
    this.overlapAmount = 24,
  });

  Widget _buildSingleAvatar({
    required String imageURL,
    required String userName,
    required BuildContext context,
  }) {
    final hasImage = imageURL.isNotEmpty && imageURL != 'null';

    return Container(
      width: avatarSize,
      height: avatarSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: ClipOval(
        child: hasImage
            ? _buildAvatarImage(imageURL, userName, context)
            : _buildFallbackAvatar(userName, context), // ← Pass userName
      ),
    );
  }

  Widget _buildAvatarImage(
      String imageURL, String userName, BuildContext context) {
    return Image(
      image: _getImageProvider(imageURL),
      width: avatarSize,
      height: avatarSize,
      fit: BoxFit.cover,
      filterQuality: FilterQuality.high,
      gaplessPlayback: true,
      errorBuilder: (context, error, stackTrace) {
        debugPrint('Image loading failed: $error');
        return _buildFallbackAvatar(
            userName, context); // ← Show letter on error
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
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

  Widget _buildFallbackAvatar(String userName, BuildContext context) {
    return Container(
      color: Theme.of(context)
          .colorScheme
          .secondary
          .withValues(alpha: 0.5),
      child: Center(
        child: Text(
          userName.isNotEmpty ? userName[0].toUpperCase() : '?',
          style: TextStyle(
            color: Colors.white,
            fontSize: avatarSize * 0.4,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  ImageProvider _getImageProvider(String imageData) {
    if (imageData.startsWith('data:image/')) {
      try {
        final decodedBytes = _decodeImage(imageData);
        return MemoryImage(decodedBytes);
      } catch (e) {
        return const AssetImage('asset/images/logo.png');
      }
    } else if (imageData.startsWith('http')) {
      return NetworkImage(imageData);
    } else {
      return const AssetImage('asset/images/logo.png');
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
            fontSize: avatarSize * 0.25,
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
    // Make sure lists are same length
    assert(imageURL.length == userNames.length,
        'imageURL and userNames must have same length');

    final displayCount = imageURL.length.clamp(0, maxDisplay);
    final displayUrls = imageURL.take(displayCount).toList();
    final displayNames = userNames.take(displayCount).toList();
    final remainingCount = imageURL.length - maxDisplay;

    return SizedBox(
      height: avatarSize,
      child: Stack(
        children: [
          // Display avatars
          for (int i = 0; i < displayUrls.length; i++)
            Positioned(
              left: i * overlapAmount,
              child: _buildSingleAvatar(
                imageURL: displayUrls[i],
                userName: displayNames[i],
                context: context,
              ),
            ),

          // Counter for remaining avatars
          if (remainingCount > 0)
            Positioned(
              left: displayUrls.length * overlapAmount,
              child: _buildCounterBubble(remainingCount),
            ),
        ],
      ),
    );
  }
}
