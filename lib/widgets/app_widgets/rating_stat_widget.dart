import 'package:flutter/material.dart';

import '../../config/colors.dart';

class RatingStatWidget extends StatelessWidget {
  const RatingStatWidget({super.key, required this.ratings});

  final List<int> ratings;

  int get totalRatings => ratings.fold(0, (previousValue, element) => previousValue + element);

  @override
  Widget build(BuildContext context) {

    // Determine if the current theme is light or dark
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    // Choose the color based on the theme
    ThemeColors currentColors = isDarkTheme ? darkColors : lightColors;

    return
      totalRatings == 0 ? Container(
        child: Center(
          child: Text('No ratings yet',
            style: TextStyle(
              color: currentColors.oppositeColor.withOpacity(0.6),
              fontSize: 16,
              fontWeight: FontWeight.w500
            ),
          ),
        ),
      ) :
      Container(
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: currentColors.oppositeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 3,),
                Padding(
                  padding: const EdgeInsets.only(left: 3.0, right: 3.0),
                  child: Text('5',
                    style: TextStyle(
                      fontSize: 14,
                      color: currentColors.oppositeColor.withOpacity(0.6),
                      fontWeight: FontWeight.w500
                    )
                  ),
                ),
                // SizedBox(height: 5,),
                Padding(
                  padding: const EdgeInsets.only(left: 3.0, right: 3.0),
                  child: Text('4',
                      style: TextStyle(
                          fontSize: 14,
                          color: currentColors.oppositeColor.withOpacity(0.6),
                          fontWeight: FontWeight.w500
                      )
                  ),
                ),
                // SizedBox(height: 5,),

                Padding(
                  padding: const EdgeInsets.only(left: 3.0, right: 3.0),
                  child: Text('3',
                      style: TextStyle(
                          fontSize: 14,
                          color: currentColors.oppositeColor.withOpacity(0.6),
                          fontWeight: FontWeight.w500
                      )
                  ),
                ),
                // SizedBox(height: 5,),

                Padding(
                  padding: const EdgeInsets.only(left: 3.0, right: 3.0),
                  child: Text('2',
                      style: TextStyle(
                          fontSize: 14,
                          color: currentColors.oppositeColor.withOpacity(0.6),
                          fontWeight: FontWeight.w500
                      )
                  ),
                ),
                // SizedBox(height: 5,),

                Padding(
                  padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                  child: Text('1',
                      style: TextStyle(
                          fontSize: 14,
                          color: currentColors.oppositeColor.withOpacity(0.6),
                          fontWeight: FontWeight.w500
                      )
                  ),
                ),
                const SizedBox(height: 3,),

              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 10,
                      width: (MediaQuery.of(context).size.width - 120) * (ratings[4]/totalRatings) ,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.green,
                      ),
                      child: const SizedBox(),
                    ),
                    const SizedBox(width: 10,),
                    Text('${ratings[4]}')
                  ],
                ),
              ),
              // SizedBox(height:5,),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 10,
                      width: (MediaQuery.of(context).size.width - 120) * (ratings[3]/totalRatings),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.yellow,
                      ),
                      child: const SizedBox(),
                    ),
                    const SizedBox(width: 10,),
                    Text('${ratings[3]}')
                  ],
                ),
              ),
              // SizedBox(height: 5,),

              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 10,
                      width: (MediaQuery.of(context).size.width - 120) * (ratings[2]/totalRatings),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.amber,
                      ),
                      child: const SizedBox(),
                    ),
                    const SizedBox(width: 10,),
                    Text('${ratings[2]}')
                  ],
                ),
              ),
              // SizedBox(height: 5,),

              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 10,
                      width: (MediaQuery.of(context).size.width - 120) * (ratings[1]/totalRatings),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepOrange,
                      ),
                      child: const SizedBox(),
                    ),
                    const SizedBox(width: 10,),
                    Text('${ratings[1]}')
                  ],
                ),
              ),
              // SizedBox(height: 5,),

              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 10,
                      width: (MediaQuery.of(context).size.width - 120) * (ratings[0]/totalRatings),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.red,
                      ),
                      child: const SizedBox(),
                    ),
                    const SizedBox(width: 10,),
                    Text('${ratings[0]}')
                  ],
                ),
              ),




            ],
          ),
        ],
      ),
    );
  }
}
