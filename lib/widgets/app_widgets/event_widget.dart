import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:club_app/models/event_model.dart';
import 'package:club_app/screens/event_page.dart';
import 'package:flutter/material.dart';

class EventWidget extends StatelessWidget {
  const EventWidget({super.key, required this.event});

  final EventModel event;

  // Future<bool> isBright() async {
  //   final PaletteGenerator paletteGenerator = await PaletteGenerator
  //       .fromImageProvider(
  //     CachedNetworkImageProvider(event.clubImageUrl),);
  //     return paletteGenerator.dominantColor!.color.computeLuminance() > 0.5;
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async{
        // final iconColor = await isBright() ? Colors.black : Colors.white;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EventPage(eventId: event.id)),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          // color: Colors.white,
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          child:
          Stack(
            children: [

              Positioned.fill(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18.0),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(event.clubImageUrl),
                      opacity: 0.07,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18.0),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(50.0),
                                    child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      width: 40,
                                      height: 40,
                                      imageUrl: event.clubImageUrl,
                                    ),
                                  ),
                                  const SizedBox(width: 10.0),
                                  Expanded(
                                    child: Text(event.clubName,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold, fontSize: 17.0)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10.0),
                              Text(event.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 20.0)),
                              const SizedBox(height: 5.0),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_month_outlined,
                                  ),
                                  const SizedBox(width: 5.0),
                                  Text(event.formattedDate,
                                      style: const TextStyle(
                                          fontSize: 15.0, fontWeight: FontWeight.w500)),
                                ],
                              ),
                              const SizedBox(height: 5.0),
                              Row(
                                children: [
                                  const Icon(Icons.location_on_outlined),
                                  const SizedBox(width: 5.0),
                                  Text(event.location,
                                      style: const TextStyle(
                                          fontSize: 15.0, fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: CachedNetworkImage(
                              width: 110,
                              height: 110,
                              fit: BoxFit.cover,
                              imageUrl: event.bannerUrl),
                        ),
                      )
                    ]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
