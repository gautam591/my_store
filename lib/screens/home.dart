import 'package:flutter/material.dart';
import 'package:flutter/src/material/colors.dart';
import 'package:my_store_app/form.dart';

class home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(child: BlockWidget("Stock", Colors.lightGreenAccent)),
                Expanded(child: BlockWidget("Sold", Colors.blue.shade100,)),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(child: BlockWidget("Expired", Colors.red.shade100)),
                Expanded(child: BlockWidget("To be Purchased", Colors.orange.shade100)),
              ],
            ),
          ),
          AddButton(),
        ],
      ),
    );
  }
}



class BlockWidget extends StatelessWidget {
  final String heading;
  final Color color;

  BlockWidget(this.heading, this.color);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              heading,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: TableWidget(),
            ),
          ],
        ),
      ),
      color: color,
    );
  }
}

class TableWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          DataColumn(label: Text('Header 1')),
          DataColumn(label: Text('Header 2')),
        ],
        rows: [
          DataRow(cells: [
            DataCell(Text('Item, Price')),
            DataCell(Text('Item, price')),
          ]),
          DataRow(cells: [
            DataCell(Text('Item , price')),
            DataCell(Text('Item, price')),
          ]),
        ],
      ),
    );
  }
}

class AddButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: FloatingActionButton(
          onPressed: () {
            Future.delayed(Duration(seconds: 2), () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (BuildContext context) => FormSlideShow(),
                ),
              );
            });
            // Add your logic to handle the addition of information
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.green,
        ),
      ),
    );
  }
}
