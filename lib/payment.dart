import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({
    Key? key,
  }) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Set your Plan'),
      ),
      body: Container(
        color: Colors.black87,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Card(
                // First Card with a specific size
                elevation: 5,
                child: SizedBox(
                  width: 320, // Set the width of the card
                  height: 150, // Set the height of the card
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Add content for the first card here
                        Text(
                          "\$15/month",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),

                        // Add more widgets as needed
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Card(
                // Second Card with a specific size
                elevation: 5,
                child: SizedBox(
                  width: 320, // Set the width of the card
                  height: 150, // Set the height of the card
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Add content for the second card here
                        Text(
                          "\$10/month",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        // Add more widgets as needed
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Card(
                // First Card with a specific size
                elevation: 5,
                child: SizedBox(
                  width: 320, // Set the width of the card
                  height: 150, // Set the height of the card
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Add content for the first card here
                        Text(
                          "Onetime Pay: \$30",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        // Add more widgets as needed
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  // Handle button press
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
