import 'package:flutter/material.dart';
import 'individual_component_page.dart';

bool parallel = true;
bool series = true;


class SystemOfComponentsPage extends StatefulWidget {
  const SystemOfComponentsPage({super.key});

  @override
  State<SystemOfComponentsPage> createState() => _SystemOfComponentsPageState();
}

class _SystemOfComponentsPageState extends State<SystemOfComponentsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF135D66),
        title: const Text(
          'Reliability Hub',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
                    parallel = true;
                    series = false;

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const IndividualComponentPage()),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 50, top: 100, right: 50, bottom: 10),
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
                              'Parallel',
                              style:
                              TextStyle(fontSize: 20, color: Colors.white),
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
                    parallel = false;
                    series = true;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const IndividualComponentPage()),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 50, top: 10, right: 50, bottom: 100),
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
                              Icons.link,
                              size: 40,
                              color: Colors.white,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Series',
                              style:
                              TextStyle(fontSize: 20, color: Colors.white),
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