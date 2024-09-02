import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final double? mtbf;
  final double? mttr;
  final double? availability;
  final double? operationalTime;
  final double? maintenanceTime;
  final int? totalRepairs;

  const ResultScreen({
    super.key,
    this.mtbf,
    this.mttr,
    this.availability,
    this.operationalTime,
    this.maintenanceTime,
    this.totalRepairs,
  });

  static const TextStyle commonTextStyle = TextStyle(
    fontSize: 25,
    fontWeight: FontWeight.bold,
    color: Colors.black, // Customize color as needed
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3FEF7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF135D66),
        title: const Text(
          'Results',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 10.0,
        shadowColor: Colors.black.withOpacity(0.5),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (mtbf != null) Text('MTBF: $mtbf', style: commonTextStyle),
            if (mttr != null) Text('MTTR: $mttr', style: commonTextStyle),
            if (availability != null) Text('Availability: $availability', style: commonTextStyle),
            if (operationalTime != null) Text('Operational Time: $operationalTime', style: commonTextStyle),
            if (maintenanceTime != null) Text('Maintenance Time: $maintenanceTime', style: commonTextStyle),
            if (totalRepairs != null) Text('Total Repairs: $totalRepairs', style: commonTextStyle),
          ],
        ),
      ),
    );
  }
}
