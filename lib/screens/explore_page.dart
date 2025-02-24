import 'package:flutter/material.dart';
import 'package:scrumlab_flutter_tindercard/scrumlab_flutter_tindercard.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  ExplorePageState createState() => ExplorePageState();
}

class ExplorePageState extends State<ExplorePage>
    with TickerProviderStateMixin {
  List<Color> cardColors = [
    Color(0xFF581C87),
    Color(0xFF6B21A8),
    Color(0xFF7E22CE),
    Color(0xFF9333EA),
    Color(0xFFA855F7),
    Color(0xFF7986CB),
    Color(0xFF64B5F6),
  ];

  List<Map<String, dynamic>> users = [
    {
      "name": "John Doe",
      "description": "Loves hiking and photography.",
      "image": "assets/avatar1.png",
      "phone": "123-456-7890",
      "email": "johndoe@example.com",
      "skills": ["Photography", "Hiking"],
      "school": "Harvard University",
      "experiences": ["Photographer at XYZ", "Freelancer"],
      "color": Color(0xFF581C87),
    },
    {
      "name": "Alice Smith",
      "description": "Passionate about technology.",
      "image": "assets/avatar2.png",
      "phone": "987-654-3210",
      "email": "alice@example.com",
      "skills": ["Programming", "AI Research"],
      "school": "MIT",
      "experiences": ["Software Engineer at ABC", "AI Researcher"],
      "color": Color(0xFF6B21A8),
    },
    {
      "name": "Michael Johnson",
      "description": "Aspiring musician and artist.",
      "image": "assets/avatar3.png",
      "phone": "456-789-0123",
      "email": "michael@example.com",
      "skills": ["Music Composition", "Guitar"],
      "school": "Juilliard School",
      "experiences": ["Music Teacher", "Band Member"],
      "color": Color(0xFF7E22CE),
    },
  ];

  @override
  Widget build(BuildContext context) {
    CardController controller;

    return Scaffold(
      backgroundColor: Color(0xFFfffffe),
      body: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: users.isNotEmpty
              ? TinderSwapCard(
                  swipeUp: false,
                  swipeDown: false,
                  orientation: AmassOrientation.bottom,
                  totalNum: users.length,
                  stackNum: 3,
                  swipeEdge: 4.0,
                  maxWidth: MediaQuery.of(context).size.width * 0.98,
                  maxHeight: MediaQuery.of(context).size.height * 0.85,
                  minWidth: MediaQuery.of(context).size.width * 0.95,
                  minHeight: MediaQuery.of(context).size.height * 0.8,
                  cardBuilder: (context, index) => Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProfilePage(user: users[index]),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: users[index]["color"],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.all(16),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 100,
                              backgroundImage:
                                  AssetImage(users[index]["image"]),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              users[index]["name"],
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Fustat ExtraBold',
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              users[index]["description"],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                                fontFamily: 'Fustat Regular',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  cardController: controller = CardController(),
                  swipeCompleteCallback:
                      (CardSwipeOrientation orientation, int index) {
                    if (orientation == CardSwipeOrientation.left) {
                      // Action for swipe left
                      //print("Swiped left on: ${users[index]["name"]}");
                    } else if (orientation == CardSwipeOrientation.right) {
                      // Action for swipe right
                      //print("Swiped right on: ${users[index]["name"]}");
                    }
                    // Optional: Remove card after swipe
                    setState(() {
                      users.removeAt(index);
                    });
                  },
                )
              : Center(
                  child: Text(
                    "You are all caught up!",
                    style: TextStyle(
                      fontSize: 24,
                      color: const Color.fromARGB(26, 0, 0, 0),
                      fontFamily: 'Fustat ExtraBold',
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  final Map<String, dynamic> user;

  const ProfilePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFfffffe),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 80,
                backgroundImage: AssetImage(user["image"]),
              ),
              const SizedBox(height: 20),
              Text(
                user["name"],
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text("Email: ${user["email"]}"),
              Text("Phone: ${user["phone"]}"),
              Text("School: ${user["school"]}"),
              const SizedBox(height: 10),
              Text("Skills: ${user["skills"].join(", ")}"),
              const SizedBox(height: 10),
              Text("Experience: ${user["experiences"].join(", ")}"),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Back"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
