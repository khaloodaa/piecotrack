import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final rewards = [
      {"title": "Plant a Tree", "cost": 20, "icon": Icons.park},
      {"title": "Eco Badge", "cost": 15, "icon": Icons.emoji_events},
      {"title": "Discount Coupon", "cost": 30, "icon": Icons.card_giftcard},
      {"title": "Reusable Bottle", "cost": 25, "icon": Icons.local_drink},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Rewards"),
        flexibleSpace: Container(

          decoration: const BoxDecoration(

            gradient: LinearGradient(

              colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)], // أخضر فاتح وداكن

              begin: Alignment.topLeft,

              end: Alignment.bottomRight,

            ),

          ),

        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🟢 الرصيد
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 6,
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    const Icon(Icons.account_balance_wallet, size: 40, color: Colors.white),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Your Balance",
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white)),
                        const SizedBox(height: 4),
                        Text("120 Pi",
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ).animate().slideY(duration: 500.ms).fadeIn(),

            const SizedBox(height: 20),

            // 🟢 قائمة Rewards
            Expanded(
              child: GridView.builder(
                itemCount: rewards.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // تشتغل بشكل Responsive
                  childAspectRatio: 0.9,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  final reward = rewards[index];
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(reward["icon"] as IconData,
                              size: 48, color: Theme.of(context).colorScheme.primary),
                          const SizedBox(height: 12),
                          Text(
                            reward["title"] as String,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "${reward["cost"]} Pi",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: Theme.of(context).colorScheme.secondary),
                          ),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text("Redeem"),
                          )
                        ],
                      ),
                    ),
                  ).animate().fadeIn(delay: (100 * index).ms).scale(duration: 400.ms);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
