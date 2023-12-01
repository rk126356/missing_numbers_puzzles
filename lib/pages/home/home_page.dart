import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../admin/edit_quizzes.dart';
import '../../data/firebase_api.dart';
import '../../models/number_puzzle_model.dart';
import '../../providers/sound_provider.dart';
import '../../widgets/custom_app_bar_widget.dart';
import '../play/play_page.dart';
import '../settings/settings_page.dart';
import '../shop/shop_page.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({Key? key}) : super(key: key);

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

List<NumberPuzzle> questionsList = [];
bool _isLoading = false;

class _HomePageScreenState extends State<HomePageScreen>
    with WidgetsBindingObserver {
  void fetch() async {
    setState(() {
      _isLoading = true;
    });
    List<NumberPuzzle> fetchedQuestions = await FetchQuestions.fetchQuestions();

    questionsList = fetchedQuestions;
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetch();
    WidgetsBinding.instance!.addObserver(this);
  }

  bool _isInForeground = true;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final music = Provider.of<AudioProvider>(context, listen: false);
    switch (state) {
      case AppLifecycleState.resumed:
        if (music.isMusicTurnedOn) {
          if (music.isQuizMusicPlaying) {
            music.playQuizMusic();
          } else {
            music.playMusic();
          }
        }
        if (kDebugMode) {
          print("app in resumed");
        }
        break;
      case AppLifecycleState.inactive:
        if (kDebugMode) {
          print("app in inactive");
        }
        if (music.isMusicTurnedOn) {
          music.stopMusic();
          music.stopQuizMusic();
        }
        break;
      case AppLifecycleState.paused:
        if (kDebugMode) {
          print("app in paused");
        }
        if (music.isMusicTurnedOn) {
          music.stopMusic();
          music.stopQuizMusic();
        }
        break;
      case AppLifecycleState.detached:
        if (kDebugMode) {
          print("app in detached");
        }
        break;
      case AppLifecycleState.hidden:
        if (kDebugMode) {
          print("app in hidden");
        }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final music = Provider.of<AudioProvider>(context, listen: false);
    Future.delayed(const Duration(seconds: 2), () {
      if (music.isMusicTurnedOn) {
        music.playMusic();
      } else {
        music.stopMusic();
      }
    });

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: const CustomAppBar(
          title: "Missing Letters Puzzles",
          showBackButton: false,
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              fit: StackFit.expand,
              children: [
                // Background Image
                Image.asset(
                  'assets/images/app_bg.png',
                  fit: BoxFit.cover,
                ),

                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 380),

                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PlayPageScreen()),
                          );
                        },
                        icon: const Icon(
                          Icons.play_circle_fill,
                          size: 30,
                        ),
                        label: const Text(
                          'Play',
                          style: TextStyle(fontSize: 18),
                        ),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blueAccent, // Text color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                        ),
                      ),
                      const SizedBox(
                          height: 20), // Adjust spacing between buttons
                      // Shop Button
                      ElevatedButton.icon(
                        onPressed: () async {
                          // SharedPreferences preferences =
                          //     await SharedPreferences.getInstance();
                          // await preferences.clear();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ShopPageScreen()),
                          );
                        },
                        icon: const Icon(
                          Icons.shopping_cart,
                          size: 30,
                        ),
                        label: const Text(
                          'Shop',
                          style: TextStyle(fontSize: 18),
                        ),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.green, // Text color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                        ),
                      ),
                      const SizedBox(
                          height: 20), // Adjust spacing between buttons
                      // Settings Button
                      ElevatedButton.icon(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const SettingsScreen();
                              });
                        },
                        icon: const Icon(
                          Icons.settings,
                          size: 30,
                        ),
                        label: const Text(
                          'Settings',
                          style: TextStyle(fontSize: 18),
                        ),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.redAccent, // Text color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                        ),
                      ),
                      if (kDebugMode)
                        ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const EditQuizzes()),
                              );
                            },
                            child: const Text('Admin'))
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
