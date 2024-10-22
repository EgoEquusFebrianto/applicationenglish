import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'game_provider.dart';

class ProgressBarWithIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var gameProv = Provider.of<GameProvider>(context);
    double progress = gameProv.progress.clamp(0, 25);
    double progressWidth = (18.5 * progress);
    
    return Row(
      children: [
        Expanded(
          child: Stack(
            children: [
              Container(
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              Container(
                height: 30,
                width: progressWidth,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue,
          ),
          child: Center(
            child: Text(
              "${progress.toInt()}",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
