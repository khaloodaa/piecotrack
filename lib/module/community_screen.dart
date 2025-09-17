// community_screen.dart
import 'package:flutter/material.dart';

class CommunityScreen extends StatelessWidget {
  final List<Map<String, dynamic>> posts = [
    {
      "user": "Ahmed Ali",
      "text": "Just completed a recycling challenge today! 🌍💚",
      "image": "assets/images/tree.png",
      "likes": 12,
      "comments": 4,
      "shares": 1,
    },

    {
      "user": "Omar Khaled",
      "text": "Planted 3 new trees in my garden 🌱",
      "image": null,
      "likes": 12,
      "comments": 4,
      "shares": 1,
    },
    {
      "user": "Laila Hassan",
      "text": "Used public transport all week, feeling proud! 🚌",
      "image": null,
      "likes": 5,
      "comments": 1,
      "shares": 1,
    },
    {
      "user": "Sara Mohamed",
      "text": "Went to work by bike instead of car 🚴‍♂️",
      "image": "assets/images/bike.png",
      "likes": 20,
      "comments": 5,
      "shares": 0,
    },
    {
      "user": "Mostafa Nabil",
      "text": "Turned off unnecessary lights and saved energy 💡",
      "image": null,
      "likes": 8,
      "comments": 4,
      "shares": 3,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Community"),
        backgroundColor: const Color(0xFF4CAF50),
      ),
      body: Column(
        children: [
          // خانة "بما تفكر؟" زي الفيسبوك
          Card(
            margin: const EdgeInsets.all(12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: "What's on your mind?",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.image, color: Colors.blueAccent),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              backgroundColor: Colors.green,
                              child: Icon(Icons.person, color: Colors.white),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              post["user"],
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(post["text"]),
                        if (post["image"] != null) ...[
                          const SizedBox(height: 10),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              post["image"],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextButton.icon(
                              onPressed: () {
                                // setState(() {
                                //   post["likes"] += 1;
                                // });
                              },
                              icon: const Icon(Icons.thumb_up_alt_outlined, size: 20),
                              label: Text("${post["likes"]}"),
                            ),
                            TextButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Comments feature coming soon!")),
                                );
                              },
                              icon: const Icon(Icons.comment_outlined, size: 20),
                              label: Text("${post["comments"]}"),
                            ),
                            TextButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Post shared!")),
                                );
                              },
                              icon: const Icon(Icons.share_outlined, size: 20),
                              label: Text("${post["shares"]}"),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
