import "package:flutter/material.dart";

class BoardsPage extends StatelessWidget {
  const BoardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Boards Page')),
      body: const Center(child: Text('Welcome to the Boards Page!')),
    );
  }
}
