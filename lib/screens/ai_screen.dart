import 'package:flutter/material.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 20), 
          child: const Text(
            'NewzAssistant',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              
              child: Text(
                'Ask away!',
                textAlign: TextAlign.center, 
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.black.withOpacity(0.6),
                ),
              ),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(1),
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.red,
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Type something...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none, 
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send),
                    color: Colors.red,
                    onPressed: () {
                      
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
