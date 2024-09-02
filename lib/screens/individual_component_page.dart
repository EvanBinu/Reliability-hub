import 'package:flutter/material.dart';
import 'package:reliability_hub/Calculation/availability.dart';
import 'package:reliability_hub/Calculation/mtbf.dart';
import 'package:reliability_hub/Calculation/mttr.dart';

class IndividualComponentPage extends StatefulWidget {
  const IndividualComponentPage({super.key});

  @override
  State<IndividualComponentPage> createState() =>
      _IndividualComponentPageState();
}

class _IndividualComponentPageState extends State<IndividualComponentPage> {
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Availability()),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 50, top: 40, right: 50, bottom: 10),
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
                              Icons.add_chart_rounded,
                              size: 40,
                              color: Colors.white,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Availability',
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MTBF()),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 50, top: 20, right: 50, bottom: 20),
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
                              Icons.trending_up,
                              size: 40,
                              color: Colors.white,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'MTBF',
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MTTR()),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 50, top: 10, right: 50, bottom: 40),
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
                              Icons.repartition,
                              size: 40,
                              color: Colors.white,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'MTTR',
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
