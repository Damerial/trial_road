import 'package:flutter/material.dart';

class ViewStatus extends StatelessWidget {
  const ViewStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("View Status"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row( // Main Row
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.image, size: 50), // Placeholder for an image
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column( // Text Column
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Severity: High",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        )
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Location: Main Street",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        )
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Status: Pending",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        )
                      ),
                    ],
                  ),
                ),
                Column( // Icons Column
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        // Handle edit action
                      },
                      child: Icon(Icons.edit, color: Colors.orange),
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        // Handle delete action
                      },
                      child: Icon(Icons.delete, color: Colors.red),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
