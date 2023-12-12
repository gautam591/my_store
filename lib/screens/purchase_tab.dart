import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../alert.dart';
import '../request.dart';

class PurchaseTab extends StatefulWidget {
  final Map<String, dynamic> user;

  const PurchaseTab({
    super.key,
    required this.user,
  });

  @override
  State<PurchaseTab> createState() => _PurchaseTabState();
}

class _PurchaseTabState extends State<PurchaseTab> {
  List<DataRow> _rows = [];
  final _formKeyItemAdd = GlobalKey<FormState>();

  TextEditingController itemNameController = TextEditingController();
  TextEditingController itemPriceController = TextEditingController();
  TextEditingController itemExpiryDateController = TextEditingController();
  TextEditingController itemQuantityController = TextEditingController();
  TextEditingController itemDescriptionController = TextEditingController();

  void _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        // DateFormat('yyyy-MM-dd').format(pickedDate)
        itemExpiryDateController.text = DateFormat('yyyy-MM-dd')
            .format(pickedDate); // {pickedDate.toLocal()} as String;
      });
    }
  }

  Future<void> _addItem() async {
    FocusScope.of(context).unfocus();
    _formKeyItemAdd.currentState!.save();
    if (_formKeyItemAdd.currentState!.validate()) {
      final dateNow = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final data = {
        'username': '${widget.user['uid']}',
        'name': itemNameController.text,
        'price': itemPriceController.text,
        'quantity': itemQuantityController.text,
        'expiry_date': itemExpiryDateController.text,
        'purchase_date': dateNow,
        'description': itemDescriptionController.text,
      };
      Map<String, dynamic> response = await Requests.addItem(data);
      if (response["status"] == true) {
        Alerts.showSuccess(
            "Item ${itemNameController.text} added successfully to the stock");
        setState(() {
          _rows.insert(0, DataRow(
            cells: [
              DataCell(Text(itemNameController.text)),
              DataCell(Text(itemPriceController.text)),
              DataCell(Text(itemQuantityController.text)),
              DataCell(Text(itemExpiryDateController.text)),
              DataCell(Text(dateNow)),
              DataCell(Text(itemDescriptionController.text))
            ],
          ));
          itemNameController.clear();
          itemPriceController.clear();
          itemQuantityController.clear();
          itemExpiryDateController.clear();
          itemDescriptionController.clear();
        });
      } else {
        Alerts.showError(response["messages"]["error"]);
      }
    }
  }

  Future<void> getItemsData({bool refresh = true}) async {
    String itemsRaw = json.encode(await Requests.getItems(widget.user['uid'], refresh: refresh));
    setState(() {
      Map<String, dynamic> items = json.decode(itemsRaw)['data'];
      _rows = [];
      items.forEach((key, value) {
        _rows.add(DataRow(
          cells: [
            DataCell(Text('${value['name']}')),
            DataCell(Text('${value['price']}')),
            DataCell(Text('${value['quantity']}')),
            DataCell(Text('${value['expiry_date']}')),
            DataCell(Text('${value['purchase_date']}')),
            DataCell(Text('${value['description']}'))
          ],
        ));
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getItemsData(refresh: false);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: getItemsData,
      child: ListView(
        children: [
          SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKeyItemAdd,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ExpansionTile(
                          title: RichText(
                            text: const TextSpan(
                              children: [
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: Icon(Icons.add_circle_outline_rounded,
                                      size: 22, color: Colors.black),
                                ),
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: Text(
                                    '  Add Purchased Item',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: itemNameController,
                                  decoration: const InputDecoration(
                                    labelText: 'Item Name*',
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.text,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter item name';
                                    }
                                    return null; // Return null if the input is valid
                                  },
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: itemPriceController,
                                  decoration: const InputDecoration(
                                    labelText: 'Price*',
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter the price for the item';
                                    }
                                    return null; // Return null if the input is valid
                                  },
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: itemQuantityController,
                                  decoration: const InputDecoration(
                                    labelText: 'Quantity*',
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.text,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter quantity for the item';
                                    }
                                    return null; // Return null if the input is valid
                                  },
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: itemExpiryDateController,
                                  decoration: const InputDecoration(
                                    labelText: 'Expiry Date',
                                    border: OutlineInputBorder(),
                                  ),
                                  readOnly: true,
                                  onTap: () => _selectDate(context),
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                    controller: itemDescriptionController,
                                    decoration: const InputDecoration(
                                      labelText: 'Description/Remarks',
                                      border: OutlineInputBorder(),
                                    ),
                                    keyboardType: TextInputType.text),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                    onPressed: _addItem,
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.redAccent),
                                    child: const Text('Add Item')),
                                const SizedBox(height: 16)
                              ],
                            ),
                          ],
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            horizontalMargin: 0,
                            columnSpacing: 20,
                            columns: const [
                              DataColumn(label: Text('Name')),
                              DataColumn(label: Text('Price')),
                              DataColumn(label: Text('Quantity')),
                              DataColumn(label: Text('Expiry Date')),
                              DataColumn(label: Text('Purchase Date')),
                              DataColumn(label: Text('Description/Remarks'))
                            ],
                            rows: _rows,
                          ),
                        )
                      ],
                    ),
                  )
                ),
              )
          )
        ],
      ),
    );
  }
}
