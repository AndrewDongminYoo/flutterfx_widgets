import 'package:flutter/material.dart';

class NotificationItem {
  NotificationItem({
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.time,
  });
  final String name;
  final String description;
  final String icon;
  final Color color;
  final String time;
}

class AnimatedNotificationList extends StatefulWidget {
  const AnimatedNotificationList({
    super.key,
    required this.notifications,
    this.delay = const Duration(milliseconds: 1000),
  });
  final List<NotificationItem> notifications;
  final Duration delay;

  @override
  State<AnimatedNotificationList> createState() => _AnimatedNotificationListState();
}

class _AnimatedNotificationListState extends State<AnimatedNotificationList> {
  final List<NotificationItem> _visibleNotifications = [];
  static const double cardHeight = 92; // Height of card + padding

  @override
  void initState() {
    super.initState();
    // ignore: discarded_futures
    _startAddingNotifications();
  }

  Future<void> _startAddingNotifications() async {
    for (final notification in widget.notifications) {
      if (!mounted) {
        return;
      }
      await Future<void>.delayed(widget.delay);
      setState(() {
        _visibleNotifications.insert(0, notification);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Stack(
        children: List.generate(_visibleNotifications.length, (index) {
          return AnimatedNotificationCard(
            key: ValueKey(_visibleNotifications[index].hashCode),
            item: _visibleNotifications[index],
            index: index,
            topOffset: index * cardHeight,
          );
        }),
      ),
    );
  }
}

class AnimatedNotificationCard extends ImplicitlyAnimatedWidget {
  const AnimatedNotificationCard({
    super.key,
    required this.item,
    required this.index,
    required this.topOffset,
  }) : super(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
  final NotificationItem item;
  final int index;
  final double topOffset;

  @override
  AnimatedNotificationCardState createState() => AnimatedNotificationCardState();
}

class AnimatedNotificationCardState extends AnimatedWidgetBaseState<AnimatedNotificationCard> {
  Tween<double>? _topTween;
  Tween<double>? _slideTween;

  @override
  void initState() {
    super.initState();
    _slideTween = Tween<double>(begin: -100, end: 0);
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _topTween = visitor(
      _topTween,
      widget.topOffset,
      (dynamic value) => Tween<double>(begin: value as double),
    ) as Tween<double>?;

    _slideTween = visitor(
      _slideTween,
      0.0,
      (dynamic value) => Tween<double>(begin: value as double),
    ) as Tween<double>?;
  }

  @override
  Widget build(BuildContext context) {
    final topOffset = _topTween?.evaluate(animation) ?? widget.topOffset;
    final slideOffset = _slideTween?.evaluate(animation) ?? 0.0;

    return Positioned(
      top: topOffset,
      left: 0,
      right: 0,
      child: Transform.translate(
        offset: Offset(slideOffset, 0),
        child: Opacity(
          opacity: 1 - (slideOffset.abs() / 100),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: NotificationCard(
              item: widget.item,
              index: widget.index,
            ),
          ),
        ),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
    required this.item,
    required this.index,
  });
  final NotificationItem item;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.grey[850],
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: item.color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      item.icon,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text('·'),
                          const SizedBox(width: 4),
                          Text(
                            item.time,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.description,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
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

class NotificationDemo extends StatelessWidget {
  NotificationDemo({super.key});
  final List<NotificationItem> notifications = [
    NotificationItem(
      name: 'Cha-ching! 💰',
      description: 'Someone actually paid! Time to buy that yacht... or maybe just coffee',
      time: '15m ago',
      icon: '💸',
      color: const Color(0xFF00C9A7),
    ),
    NotificationItem(
      name: 'Fresh ..err, user!',
      description: 'Another brave soul joins our awesome chaos',
      time: '10m ago',
      icon: '👤',
      color: const Color(0xFFFFB800),
    ),
    NotificationItem(
      name: 'Inbox invasion!',
      description: "Someone's spamming... with love ❤️",
      time: '5m ago',
      icon: '💬',
      color: const Color(0xFFFF3D71),
    ),
    NotificationItem(
      name: 'Plot twist ahead!',
      description: 'Breaking news: Developer finds missing semicolon',
      time: '2m ago',
      icon: '🗞️',
      color: const Color(0xFF1E86FF),
    ),
    NotificationItem(
      name: 'Money shower! 🚿',
      description: 'Ka-ching! Time to make it rain... responsibly',
      time: '15m ago',
      icon: '💸',
      color: const Color(0xFF00C9A7),
    ),
    NotificationItem(
      name: 'New player entered!',
      description: 'Welcome to the circus! Grab your popcorn 🍿',
      time: '10m ago',
      icon: '👤',
      color: const Color(0xFFFFB800),
    ),
    NotificationItem(
      name: 'Urgent message!',
      description: 'Your cat posted on your behalf again',
      time: '5m ago',
      icon: '💬',
      color: const Color(0xFFFF3D71),
    ),
    NotificationItem(
      name: 'Stop the presses!',
      description: 'Coffee machine is now accepting high-fives',
      time: '2m ago',
      icon: '🗞️',
      color: const Color(0xFF1E86FF),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: AnimatedNotificationList(
            notifications: notifications,
          ),
        ),
      ),
    );
  }
}
