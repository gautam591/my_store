import 'package:flutter/material.dart';
class home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SectionHeading(headingText: 'Section 1'),
          GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of columns
            ),
            itemCount: 2, // Number of blocks
            shrinkWrap: true, // Ensure that the GridView takes only the required space
            physics: NeverScrollableScrollPhysics(), // Disable scrolling of the GridView itself
            itemBuilder: (context, index) {
              // Return a rounded block widget for each index
              return RoundedBlock(
                title: 'Block $index',
                color: Colors.lightGreenAccent,
                // Background color of the block
              );
            },
          ),
          SectionHeading(headingText: 'Section 2'),
          GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of columns
            ),
            itemCount: 2, // Number of blocks
            shrinkWrap: true, // Ensure that the GridView takes only the required space
            physics: NeverScrollableScrollPhysics(), // Disable scrolling of the GridView itself
            itemBuilder: (context, index) {
              // Return a rounded block widget for each index
              return RoundedBlock(
                title: 'Block $index',
                color: Colors.lightBlueAccent,
                // Background color of the block
              );
            },
          ),
        ],
      ),
    );
  }
}

class SectionHeading extends StatelessWidget {
  final String headingText;

  SectionHeading({required this.headingText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Text(
        headingText,
        style: TextStyle(
          fontSize: 20.0, // Adjust the heading font size
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class RoundedBlock extends StatelessWidget {
  final String title;
  final Color color;

  RoundedBlock({required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    // Create a rounded block with a title
    return Container(
      margin: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: color, // Background color of the block
        borderRadius: BorderRadius.circular(16.0),
        // Rounded border
      ),
      padding: EdgeInsets.all(10.0), // Adjust padding for size
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.black, // Text color
              fontSize: 15.0, // Adjust the block font size
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.0), // Spacing between title and content
          // Make the content scrollable if it overflows
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Add your block content here
                  // You can add any other widgets you want inside the block
                  // For example, you can add a long text that overflows
                  // and becomes scrollable inside the block.
                  Text(
                    'This is a long text that will overflow and become scrollable inside the block. ' * 10,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
