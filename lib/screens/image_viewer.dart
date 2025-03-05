import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageViewer extends StatelessWidget {
  const ImageViewer({super.key, required this.image});

  final String image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
        elevation: 1,
        backgroundColor: const Color.fromRGBO(255, 255, 255, 0.1),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.close,
              color: Color.fromRGBO(255, 255, 255, 0.6),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: InteractiveViewer(
        panEnabled: true,
        child: Stack(
          children: [
            Center(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Color.fromRGBO(0, 0, 0, 0.8),
              ),
            ),
            Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: const SizedBox(
                    width: 10,
                    height: 10,
                  ),
                )),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                color: const Color.fromRGBO(0, 0, 0, 0),
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 0, vertical: 40.0),
              child: Center(
                  child:
                  CachedNetworkImage(
                    imageUrl: image,
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
