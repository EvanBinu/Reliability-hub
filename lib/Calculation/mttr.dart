import 'package:flutter/material.dart';
import 'package:reliability_hub/Calculation/reliability_calculator.dart';
import 'package:reliability_hub/screens/result.dart';
import 'package:reliability_hub/screens/import.dart';
class MTTR extends StatefulWidget {
  const MTTR({super.key});

  @override
  State<MTTR> createState() => _MTTRState();
}

class _MTTRState extends State<MTTR> {
  final TextEditingController _operationalTimeController =
      TextEditingController();
  final TextEditingController _maintenanceTimeController =
      TextEditingController();
  final TextEditingController _repairsController = TextEditingController();

  @override
  void dispose() {
    _operationalTimeController.dispose();
    _maintenanceTimeController.dispose();
    _repairsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3FEF7),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Increased spacing between input fields
              const Text(
                'Total Maintenance Time:',
                style: TextStyle(fontSize: 18),
              ),
              TextFormField(
                controller: _maintenanceTimeController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter total maintenance time',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(
                  height: 30), // Increased spacing between input fields
              const Text(
                'Total Number of Repairs:',
                style: TextStyle(fontSize: 18),
              ),
              TextFormField(
                controller: _repairsController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter total number of repairs',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(
                  height: 30), // Increased spacing before the buttons
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        final double operationalTime =
                            double.tryParse(_operationalTimeController.text) ??
                                0.0;
                        final double maintenanceTime =
                            double.tryParse(_maintenanceTimeController.text) ??
                                0.0;
                        final int repairs =
                            int.tryParse(_repairsController.text) ?? 0;

                        // Create an instance of ReliabilityCalculator with the required parameters
                        ReliabilityCalculator reliabilityCalculator =
                            ReliabilityCalculator(
                          operationalTime: operationalTime,
                          maintenanceTime: maintenanceTime,
                          totalRepairs: repairs,
                        );

                        // Calculate MTBF, MTTR, and Availability using ReliabilityCalculator
                        final double mtbf =
                            reliabilityCalculator.calculateMTBF();
                        final double mttr =
                            reliabilityCalculator.calculateMTTR();
                        final double availability =
                            reliabilityCalculator.calculateAvailability();

                        // Navigate to ResultScreen and pass the calculated values along with the inputs
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResultScreen(
                              mttr: double.parse(mttr.toStringAsFixed(2)),
                              maintenanceTime: double.parse(
                                  maintenanceTime.toStringAsFixed(2)),
                              totalRepairs: repairs,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF135D66),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15),
                      ),
                      child: const Text(
                        'Submit',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Import()),
                      );},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF135D66),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15),
                      ),
                      child: const Text(
                        'Import',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
