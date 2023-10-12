import 'package:flutter/material.dart';

class HourlyChart extends StatelessWidget {
  final String valu;
  final IconData ico;
  final String valuee;
  const HourlyChart({
    super.key,
    required this.valu,
    required this.ico,
    required this.valuee,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Card(
        color: const Color.fromARGB(255, 26, 130, 214),
        child: Column(
          children: [
            const SizedBox(
              width: 85,
            ),
            Text(
              valu,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 8,
            ),
            Icon(ico),
            const SizedBox(
              height: 8,
            ),
            Container(
              margin: const EdgeInsets.only(
                bottom: 5,
              ),
              child: Text(
                valuee,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
