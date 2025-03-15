import 'package:flutter/material.dart';

void showNotificationScreen(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        insetPadding: const EdgeInsets.all(20),
        child: NotificationsScreen(),
      );
    },
  );
}

class NotificationsScreen extends StatelessWidget {
  final List<String> notifications = [
    "Breaking: Major event happening now!",
    "Your daily news digest is ready.",
    "New article published: Tech Innovations 2025",
    "Live: Sports update happening now!",
    "Reminder: Check your saved articles.",
    "Breaking: Major event happening now!",
    "Your daily news digest is ready.",
    "New article published: Tech Innovations 2025",
    "Live: Sports update happening now!",
    "Reminder: Check your saved articles.",
  ];

  NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
        children: [
          // Header with Close Button
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 8, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Notifications",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Montserrat",
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 24),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          //const Divider(),
          // Notifications List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.circle, color: Colors.red, size: 12),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          notifications[index],
                          style: const TextStyle(fontSize: 14, fontFamily: "Montserrat"),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
