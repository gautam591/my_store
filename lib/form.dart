import 'package:flutter/material.dart';
import 'package:my_store_app/screens/home_screen.dart';

class FormSlideShow extends StatefulWidget {
  @override
  _FormSlideShowState createState() => _FormSlideShowState();
}

class _FormSlideShowState extends State<FormSlideShow> {
  PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Future.delayed(Duration(seconds: 2), () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (BuildContext context) => HomeScreen(),
                ),
              );
            });// Navigate back to the previous screen/page
          },
        ),
        title: Text("inputs detail information"),
        backgroundColor: Colors.green,
      ),

      body: PageView(
        controller: _pageController,
        onPageChanged: (page) {
          setState(() {
            _currentPage = page;
          });
        },
        children: <Widget>[
          FormPage1(),
          FormPage2(),
          FormPage3(),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                if (_currentPage > 0) {
                  _pageController.previousPage(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.ease,
                  );
                }
              },
            ),
            IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: () {
                if (_currentPage < 2) {
                  _pageController.nextPage(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.ease,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class FormPage1 extends StatelessWidget {
  final TextEditingController itemController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  void _addItem() {
    // Handle form submission for the first form
    String item = itemController.text;
    String quantity = quantityController.text;
    // Implement your logic here
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              controller: itemController,
              decoration: InputDecoration(labelText: 'Item Name'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              controller: quantityController,
              decoration: InputDecoration(labelText: 'Quantity'),
            ),
          ),
          ElevatedButton(
            onPressed: _addItem,
            child: Text('Submit'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
          ),
        ],
      ),
    );
  }
}

class FormPage2 extends StatelessWidget {
  final TextEditingController itemController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController dateBuyingController = TextEditingController();
  final TextEditingController dateManufactureController = TextEditingController();
  final TextEditingController dateExpiryController = TextEditingController();

  void _addItem() {
    // Handle form submission for the second form
    String item = itemController.text;
    String quantity = quantityController.text;
    String dateBuying = dateBuyingController.text;
    String dateManufacture = dateManufactureController.text;
    String dateExpiry = dateExpiryController.text;
    // Implement your logic here
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              controller: itemController,
              decoration: InputDecoration(labelText: 'Item Name'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              controller: quantityController,
              decoration: InputDecoration(labelText: 'Quantity'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              controller: dateBuyingController,
              decoration: InputDecoration(labelText: 'Date of Buying'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              controller: dateManufactureController,
              decoration: InputDecoration(labelText: 'Date of Manufacture'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              controller: dateExpiryController,
              decoration: InputDecoration(labelText: 'Date of Expiry'),
            ),
          ),
          ElevatedButton(
            onPressed: _addItem,
            child: Text('Submit'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
          ),
        ],
      ),
    );
  }
}

class FormPage3 extends StatelessWidget {
  final TextEditingController itemController = TextEditingController();
  final TextEditingController sellingPriceController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  void _addItem() {
    // Handle form submission for the third form
    String item = itemController.text;
    String sellingPrice = sellingPriceController.text;
    String date = dateController.text;
    // Implement your logic here
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
          children: [
      Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        controller: itemController,
        decoration: InputDecoration(labelText: 'Item Name'),
      ),
    ),
            Padding(
              padding: const EdgeInsets.all(10.0), // This is the correct format
              child: TextFormField(
                controller: itemController,
                decoration: InputDecoration(labelText: 'Item Name'),
              ),
            ),
    Padding(
    padding: const EdgeInsets.all(10.0),
    child: TextFormField(
    controller: dateController,
    decoration: InputDecoration(labelText: 'Date'),
    ),
    ),
    ElevatedButton(
    onPressed: _addItem,
    child: Text('Submit'),
    style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
    ),
    ],
    ),
    );
  }
}
