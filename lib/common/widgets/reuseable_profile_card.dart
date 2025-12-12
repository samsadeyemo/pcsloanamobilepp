import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String email;
  final String? imageUrl;

  const ProfileCard({
    Key? key,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      // No fixed width here — it expands naturally
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: Colors.grey[200],

            backgroundImage: imageUrl != null || imageUrl != ""
                ? NetworkImage(imageUrl!)
                : null,
            child: 
            imageUrl == null || imageUrl == ""
              ? const Icon(Icons.person, color: Colors.grey, size: 30,)
              : null, 

          ),
          const SizedBox(width: 16),
          Expanded( // 👈 ensures text takes available space without overflow
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$firstName $lastName',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                  overflow: TextOverflow.ellipsis, // handles long emails gracefully
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
