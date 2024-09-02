import 'package:flutter/material.dart';

// Import the pages you want to navigate to
import 'screens/system_of_components_page.dart';
import 'screens/individual_component_page.dart';
import 'screens/history_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF135D66),
        title: const Text(
          'Reliability Hub',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        centerTitle: true,
        elevation: 10.0,
        shadowColor: Colors.black.withOpacity(0.5),
      ),
      body: Container(
        color: const Color(0xFFE3FEF7),
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SystemOfComponentsPage()),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 50,top:40,right: 50,bottom: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF77B0AA),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.account_tree_rounded,
                              size: 40,
                              color: Colors.white,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'System of Components',
                              style: TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const IndividualComponentPage()),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 50,top:20,right: 50,bottom: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF77B0AA),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_box_rounded,
                              size: 40,
                              color: Colors.white,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Individual Component',
                              style: TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HistoryPage()),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 50,top:10,right: 50,bottom: 40),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF77B0AA),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.history,
                              size: 40,
                              color: Colors.white,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'History',
                              style: TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
