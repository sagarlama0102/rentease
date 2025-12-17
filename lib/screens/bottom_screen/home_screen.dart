import 'package:flutter/material.dart';
import 'package:rentease/models/property.dart';
import 'package:rentease/widgets/best_offer_card.dart';
import 'package:rentease/widgets/home_header.dart';
import 'package:rentease/widgets/home_search_bar.dart';
import 'package:rentease/widgets/nearest_property_row.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
 

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(top: 20, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: const EdgeInsets.all(12), child: HomeHeader()),

              Padding(
                padding: const EdgeInsets.all(12),
                child: HomeSearchBar(),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Text(
                  "Best Offers",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Text(
                  "Discover unbeatable deals on your nearest area",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: SizedBox(
                  height: 250,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: bestOffers.length,
                    itemBuilder: (context, index) {
                      return BestOfferCard(property: bestOffers[index]);
                    },
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  "Nearest by your location",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: nearestProperties.length,
                 itemBuilder: (context,index){
                return Padding(padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: NearestPropertyRow(property: nearestProperties[index],
                ),
                );
              },
              ),
    
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
