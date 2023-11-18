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
  List<DropdownMenuEntry<String>> dropdownMenuItems = [];
  Map<String, dynamic> items = {};
  Map<String, dynamic> itemsSales = {};
  String selectedItem = '';

  TextEditingController itemQuantityController = TextEditingController();
  TextEditingController itemAvailableQuantityController = TextEditingController();
  TextEditingController dropdownController = TextEditingController();


  Future<void> _sellItem() async {
    FocusScope.of(context).unfocus();
    _formKeyItemAdd.currentState!.save();
    if(_formKeyItemAdd.currentState!.validate()) {
      final dateNow = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final data = {
        'username': '${widget.user['uid']}',
        'id': '${items[selectedItem]['id']}',
        'name': '${items[selectedItem]['name']}',
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
        setItemDropdown(refresh: true);
        Alerts.showSuccess("Item '${items[selectedItem]['name']}' successfully sold and added to sales data");
        setState(() {
          _rows.add(DataRow(
            cells: [
              DataCell(Text('${items[selectedItem]['name']}')),
              DataCell(Text('${items[selectedItem]['price']}')),
              DataCell(Text(itemQuantityController.text)),
              DataCell(Text(dateNow)),
              DataCell(Text('${items[selectedItem]['purchase_date']}')),
              DataCell(Text('${items[selectedItem]['expiry_date']}')),
              DataCell(Text('${items[selectedItem]['description']}')),
            ],
          ));
          itemQuantityController.clear();
          dropdownController.clear();
          itemAvailableQuantityController.clear();
          selectedItem = '';
        });
      }
      else{
        Alerts.showError(response["messages"]["error"]);
      }
    }
  }

  Future<void> getItemsData({bool refresh = true}) async {
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

  Future<void> setItemDropdown({bool refresh = true}) async {
    String itemsRaw = json.encode(await Requests.getItems(widget.user['uid'], refresh: refresh));
    setState(() {
      items = json.decode(itemsRaw)['data'];
      dropdownMenuItems = [];
      items.forEach((key, value) {
        dropdownMenuItems.add(DropdownMenuEntry<String>(
          value: '${value['id']}',
          label: '${value['name']}',
        ));
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getItemsData(refresh: false);
    setItemDropdown(refresh: false);
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
                                              itemAvailableQuantityController.text = '    Available Quantity: ${items[selectedItem]['quantity']}';
                                            });
                                          },
                                          dropdownMenuEntries: dropdownMenuItems,
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
              )
          ],
        ),
    );
  }
}