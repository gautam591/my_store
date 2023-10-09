import 'package:flutter/material.dart';
class stoke extends StatefulWidget {
  @override
  _ItemTableState createState() => _ItemTableState();
}

class _ItemTableState extends State<stoke> {
  final List<DataRow> _rows = [];

  TextEditingController itemNameController = TextEditingController();
  TextEditingController itemPriceController = TextEditingController();
  TextEditingController expiryDateController = TextEditingController();

  @override
  void dispose() {
    itemNameController.dispose();
    itemPriceController.dispose();
    expiryDateController.dispose();
    super.dispose();
  }

  void _addItem() {
    setState(() {
      _rows.add(DataRow(
        cells: [
          DataCell(Text(itemNameController.text)),
          DataCell(Text(itemPriceController.text)),
          DataCell(Text(expiryDateController.text)),
        ],
      ));
      itemNameController.clear();
      itemPriceController.clear();
      expiryDateController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              controller: itemNameController,
              decoration: InputDecoration(labelText: 'Item Name'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              controller: itemPriceController,
              decoration: InputDecoration(labelText: 'Item Price'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              controller: expiryDateController,
              decoration: InputDecoration(labelText: 'Expiry Date'),
            ),
          ),
          ElevatedButton(
            onPressed: _addItem,
            child: Text('Add Item'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent)
          ),
          DataTable(
            columns: [
              DataColumn(label: Text('Item Name')),
              DataColumn(label: Text('Item Price')),
              DataColumn(label: Text('Expiry Date')),
            ],
            rows: _rows,
          ),
        ],
      ),
    );
  }
}