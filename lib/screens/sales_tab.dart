import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../alert.dart';
import '../request.dart';

class SalesTab extends StatefulWidget {
  final Map<String, dynamic> user;

  const SalesTab({
    super.key,
    required this.user,
  });

  @override
  State<SalesTab> createState() => _SalesTabState();
}

class _SalesTabState extends State<SalesTab> {
  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }

  List<DataRow> _rows = [];
  final _formKeyItemAdd = GlobalKey<FormState>();
  List<String> dropdownMenuEntries = <String>[];
  Map<String, dynamic> items = {};
  Map<String, dynamic> itemsSales = {};
  String selectedItem = '';

  TextEditingController itemNameController = TextEditingController();
  TextEditingController itemPriceController = TextEditingController();
  TextEditingController itemExpiryDateController = TextEditingController();
  TextEditingController itemQuantityController = TextEditingController();
  TextEditingController itemDescriptionController = TextEditingController();
  TextEditingController itemAvailableQuantityController = TextEditingController();


  Future<void> _sellItem() async {
    FocusScope.of(context).unfocus();
    _formKeyItemAdd.currentState!.save();
    if(_formKeyItemAdd.currentState!.validate()) {
      final dateNow = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final data = {
        'username': '${widget.user['uid']}',
        'name': selectedItem,
        'price': '${items[selectedItem]['price']}',
        'available_quantity': '${items[selectedItem]['quantity']}',
        'quantity': itemQuantityController.text,
        'expiry_date': '${items[selectedItem]['expiry_date']}',
        'sales_date': dateNow,
        'purchase_date': '${items[selectedItem]['purchase_date']}',
        'description': '${items[selectedItem]['description']}'
      };
      Map<String, dynamic> response = await Requests.sellItem(data);
      if(response["status"] == true) {
        // setItemDropdown();
        Alerts.showSuccess("Item '${itemNameController.text}' successfully sold and added to sales data");
        _rows.add(DataRow(
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
      }
      else{
        Alerts.showError(response["messages"]["error"]);
      }
    }
  }

  Future<void> getItemsData({bool? refresh}) async {
    refresh = refresh ?? false;
    String itemsSalesRaw = json.encode(await Requests.getSalesItems(widget.user['uid'], refresh: refresh));
    setState(() {
      itemsSales = json.decode(itemsSalesRaw)['data'];
      _rows = [];
      itemsSales.forEach((key, value) {
        _rows.add(DataRow(
          cells: [
            DataCell(Text('${value['name']}')),
            DataCell(Text('${value['price']}')),
            DataCell(Text('${value['quantity']}')),
            DataCell(Text('${value['sales_date']}')),
            DataCell(Text('${value['purchase_date']}')),
            DataCell(Text('${value['expiry_date']}')),
            DataCell(Text('${value['description']}'))
          ],
        ));
      });
    });
  }

  Future<void> setItemDropdown({bool? refresh}) async {
    refresh = refresh ?? false;
    String itemsRaw = json.encode(await Requests.getItems(widget.user['uid'], refresh: refresh));
    setState(() {
      items = json.decode(itemsRaw)['data'];
      dropdownMenuEntries = [];
      items.forEach((key, value) {
        dropdownMenuEntries.add('${value['name']}');
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getItemsData();
    setItemDropdown();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                        // textAlign: TextAlign.start,
                        text: const TextSpan(
                          children: [
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Icon(
                                  Icons.add_circle_outline_rounded,
                                  size: 22,
                                  color: Colors.black
                              ),
                            ),
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Text(
                                '  Add Sold Item',
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                DropdownMenu(
                                  hintText: 'Choose item to sell*',
                                  onSelected: (String? value) {
                                    setState(() {
                                      selectedItem = value!;
                                      itemAvailableQuantityController.text = '    Available Quantity: ${items[value]['quantity']}';
                                    });
                                  },
                                  dropdownMenuEntries: dropdownMenuEntries.map<DropdownMenuEntry<String>>((String value) {
                                    return DropdownMenuEntry<String>(value: value, label: value);
                                  }).toList(),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(child: TextFormField(
                                  controller: itemQuantityController,
                                  decoration: const InputDecoration(
                                    labelText: 'Quantity*',
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter quantity for the item';
                                    }
                                    if (selectedItem == ''){
                                      return "You must first select item to sell from above dropdown";
                                    }
                                    if (int.parse(items[selectedItem]['quantity'].toString()) < int.parse(value)){
                                      return "Greater than available quantity";
                                    }
                                    return null;
                                  },
                                ),),
                                Expanded(child: TextFormField(
                                  controller: itemAvailableQuantityController,
                                  style: const TextStyle(fontSize:15),
                                  readOnly: true,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                  )
                                ))
                              ],
                            ),
                            
                            const SizedBox(height: 16),
                            ElevatedButton(
                                onPressed: _sellItem,
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                                child: const Text('Sell Item')
                            ),
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
                          DataColumn(label: Text('Sold Item')),
                          DataColumn(label: Text('Price')),
                          DataColumn(label: Text('Quantity')),
                          DataColumn(label: Text('Sales Date')),
                          DataColumn(label: Text('Purchase Date')),
                          DataColumn(label: Text('Expiry Date')),
                          DataColumn(label: Text('Description/Remarks')),
                        ],
                        rows: _rows,
                      ),
                    )
                  ],
                ),
              )
          ),
        )
    );
  }
}