import 'dart:html' as html;

import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextEditingController _urlController = TextEditingController();
  String? imageUrl;
  bool _isMenuOpen = false;

  void _setImageUrl() {
    setState(() {
      imageUrl = _urlController.text;
    });
  }

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }

  void _enterFullScreen() {
    html.document.documentElement?.requestFullscreen();
    _toggleMenu();
  }

  void _exitFullScreen() {
    html.document.exitFullscreen();
    _toggleMenu();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('Image Fullscreen'),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 250,
                  child: TextField(
                    controller: _urlController,
                    decoration: const InputDecoration(
                      hintText: 'Enter Image URL',
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: _setImageUrl,
              ),
            ],
          ),
          body: Center(
            child: imageUrl != null
                ? GestureDetector(
                    onDoubleTap: () {
                      if (html.document.fullscreenElement != null) {
                        html.document.exitFullscreen();
                      } else {
                        html.document.documentElement?.requestFullscreen();
                      }
                    },
                    child: HtmlElementView.fromTagName(
                      tagName: 'img',
                      onElementCreated: (Object element) {
                        final imgElement = element as html.ImageElement;
                        imgElement.src = imageUrl!;
                        imgElement.style.width = '100%';
                        imgElement.style.height = '100%';
                        imgElement.style.objectFit = 'cover';
                      },
                    ),
                  )
                : const Text(
                    'No image loaded \n example: https://picsum.photos/200/300',
                    style: TextStyle(fontSize: 18),
                  ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _toggleMenu,
            child: const Icon(Icons.add),
          ),
        ),
        if (_isMenuOpen) ...[
          GestureDetector(
            onTap: _toggleMenu,
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          Positioned(
            bottom: 80,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FloatingActionButton.extended(
                  heroTag: 'enter',
                  onPressed: _enterFullScreen,
                  label: const Text('Enter Fullscreen'),
                  icon: const Icon(Icons.fullscreen),
                ),
                const SizedBox(height: 8),
                FloatingActionButton.extended(
                  heroTag: 'exit',
                  onPressed: _exitFullScreen,
                  label: const Text('   Exit Fullscreen'),
                  icon: const Icon(Icons.fullscreen_exit),
                ),
              ],
            ),
          ),
        ]
      ],
    );
  }
}
