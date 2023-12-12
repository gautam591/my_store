import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mero_store/request.dart';

class SummaryTab extends StatefulWidget {
  final Map<String, dynamic> user;

  const SummaryTab({
    super.key,
    required this.user,
  });

  @override
  State<SummaryTab> createState() => _SummaryTabState();
}

class _SummaryTabState extends State<SummaryTab> {
  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }

  List<DataRow> rowsStock = [];
  List<DataRow> rowsSales = [];
  List<DataRow> rowsExpiry = [];
  bool dataFetched = false;

  Future<void> getItemsData({bool refresh = true}) async {
    String itemsRaw = json.encode(await Requests.getItems(widget.user['uid'], refresh: refresh));
    String itemsSalesRaw = json.encode(await Requests.getSalesItems(widget.user['uid'], refresh: refresh));
    String itemsExpiryRaw = json.encode(await Requests.getExpiryItems(widget.user['uid'], refresh: refresh));

    setState(() {
      Map<String, dynamic> items = json.decode(itemsRaw)['data'];
      rowsStock = [];
      items.forEach((key, value) {
        rowsStock.add(DataRow(
          cells: [
            DataCell(Text('${value['name']}')),
            DataCell(Text('${value['quantity']}')),
            DataCell(Text('${value['price']}')),
            DataCell(Text('${value['purchase_date']}')),
            DataCell(Text('${value['expiry_date']}')),
            DataCell(Text('${value['description']}'))
          ],
        ));
      });

      Map<String, dynamic> itemsSales = json.decode(itemsSalesRaw)['data'];
      rowsSales = [];
      itemsSales.forEach((key, value) {
        rowsSales.add(DataRow(
          cells: [
            DataCell(Text('${value['name']}')),
            DataCell(Text('${value['quantity']}')),
            DataCell(Text('${value['price']}')),
            DataCell(Text('${value['sales_date']}')),
            DataCell(Text('${value['expiry_date']}')),
            DataCell(Text('${value['description']}'))
          ],
        ));
      });

      Map<String, dynamic> itemsExpiry = json.decode(itemsExpiryRaw)['data'];
      rowsExpiry = [];
      itemsExpiry.forEach((key, value) {
        rowsExpiry.add(DataRow(
          cells: [
            DataCell(Text('${value['name']}')),
            DataCell(Text('${value['quantity']}')),
            DataCell(Text('${value['price']}')),
            DataCell(Text('${value['purchase_date']}')),
            DataCell(Text('${value['expiry_date']}')),
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
    dataFetched = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: RefreshIndicator(
            onRefresh: getItemsData,
            child: ListView(
              children: [
                CardWidget(title: "Stock", color: Colors.green.shade100, rows: rowsStock),
                Row(
                  children: [
                    Expanded(child: CardWidget(title: 'Sales', color: Colors.blue.shade100, rows: rowsSales),),
                    Expanded(child: CardWidget(title: 'To be Expired', color: Colors.red.shade100, rows: rowsExpiry),),
                  ],
                ),
              ],
            ) // Your custom card widget
        )
    );
  }
}



class CardWidget extends StatelessWidget {
  final String title;
  final Color color;
  List<DataRow> rows = [];

  CardWidget({
    super.key,
    required this.title,
    required this.color,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(15.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: color,
      child: Column(
        children: [
          ListTile(
            title: Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(
            height: 235,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  horizontalMargin: 20,
                  columnSpacing: 20,
                  columns: const [
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Quantity')),
                    DataColumn(label: Text('Price')),
                    DataColumn(label: Text('Date')),
                    DataColumn(label: Text('Expiry Date')),
                    DataColumn(label: Text('Description')),
                  ],
                  rows: rows,
                ),
              )
            ),
          ),
        ],
      ),
    );
  }
}
