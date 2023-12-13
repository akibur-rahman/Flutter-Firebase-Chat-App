import 'package:flutter/material.dart';

class CheckParity extends StatefulWidget {
  final String encodedMessage;

  const CheckParity({
    Key? key,
    required this.encodedMessage,
  }) : super(key: key);

  @override
  _CheckParityState createState() => _CheckParityState();
}

class _CheckParityState extends State<CheckParity> {
  String _parityResult = '';
  String _modifiableEncodedMessage = '';
  TextEditingController _encodedMessageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _modifiableEncodedMessage = widget.encodedMessage;
    _encodedMessageController.text = _modifiableEncodedMessage;
  }

  void _checkParity() {
    // Implement your parity check logic here
    // For demonstration purposes, let's assume a simple even parity check
    int countOnes = _modifiableEncodedMessage.replaceAll('0', '').length;
    bool isEvenParity = countOnes % 2 == 0;

    setState(() {
      _parityResult =
          isEvenParity ? 'Parity is correct' : 'Parity error detected';
    });
  }

  Future<void> _changeEncodedMessage() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Encoded Message'),
          content: TextField(
            controller: _encodedMessageController,
            decoration: InputDecoration(labelText: 'New Encoded Message'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                    context); // Close the dialog without saving changes
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Save the changes and close the dialog
                setState(() {
                  _modifiableEncodedMessage = _encodedMessageController.text;
                });
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Encoded Message:',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  _modifiableEncodedMessage,
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  _checkParity();
                },
                child: Text('Check Parity'),
              ),
              SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  _changeEncodedMessage();
                },
                child: Text('Edit Message'),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            'Parity Result: $_parityResult',
            style: TextStyle(
              fontSize: 16,
              color: _parityResult == 'Parity is correct'
                  ? Colors.green
                  : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
