import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class NotificationCenterScreen extends StatefulWidget {
  const NotificationCenterScreen({super.key});

  @override
  State<NotificationCenterScreen> createState() => _NotificationCenterScreenState();
}

class _NotificationCenterScreenState extends State<NotificationCenterScreen> {
  final List<Map<String, dynamic>> _notifications = [
    {
      'id': '1',
      'title': 'Chart Prepared — PNR 8472910384',
      'body': 'Final reservation chart prepared for 12952 Mumbai Rajdhani. Your coach B1 berth 24 (Side Lower) is confirmed.',
      'time': '10 mins ago',
      'type': 'chart',
      'isRead': false,
    },
    {
      'id': '2',
      'title': 'Booking Confirmed!',
      'body': 'Tickets for 12009 Shatabdi Express on 15 Oct 2026 confirmed. PNR: 4928174019.',
      'time': '2 hours ago',
      'type': 'booking',
      'isRead': true,
    },
    {
      'id': '3',
      'title': 'Train On-Time Status',
      'body': '12952 Mumbai Rajdhani is running on time. Expected arrival at NDLS 08:32 AM.',
      'time': 'Yesterday',
      'type': 'delay',
      'isRead': true,
    },
    {
      'id': '4',
      'title': 'Refund Processed',
      'body': 'Refund of ₹1,445.00 for cancelled PNR 2948103851 has been initiated to your UPI account.',
      'time': '3 days ago',
      'type': 'refund',
      'isRead': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Notification Center', style: TextStyle(fontWeight: FontWeight.w800)),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                for (var n in _notifications) {
                  n['isRead'] = true;
                }
              });
            },
            child: const Text('Mark All Read', style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.primaryBlue)),
          ),
        ],
      ),
      body: _notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF1F5F9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.notifications_none_rounded, size: 36, color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 16),
                  const Text('No Notifications Yet', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  const Text('Booking alerts, live PNR updates and schedule alerts will appear here.', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notif = _notifications[index];
                final isRead = notif['isRead'] as bool;
                final type = notif['type'] as String;

                IconData icon;
                Color iconColor;
                Color bgColor;

                switch (type) {
                  case 'chart':
                    icon = Icons.event_available_rounded;
                    iconColor = AppColors.seatAvailable;
                    bgColor = const Color(0xFFF0FDF4);
                    break;
                  case 'booking':
                    icon = Icons.confirmation_number_rounded;
                    iconColor = AppColors.primaryBlue;
                    bgColor = const Color(0xFFEFF6FF);
                    break;
                  case 'refund':
                    icon = Icons.account_balance_wallet_rounded;
                    iconColor = AppColors.accentOrange;
                    bgColor = const Color(0xFFFFF7ED);
                    break;
                  default:
                    icon = Icons.train_rounded;
                    iconColor = AppColors.primaryBlue;
                    bgColor = const Color(0xFFEFF6FF);
                }

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isRead ? Colors.white : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isRead ? AppColors.borderLight : AppColors.primaryBlue.withOpacity(0.3),
                      width: isRead ? 1.0 : 1.5,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(icon, color: iconColor, size: 22),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    notif['title'],
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: isRead ? FontWeight.w700 : FontWeight.w900,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                                Text(
                                  notif['time'],
                                  style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              notif['body'],
                              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.3),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
