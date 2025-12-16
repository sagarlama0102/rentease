import 'package:flutter/material.dart';
import 'package:rentease/models/property.dart';
import 'package:rentease/widgets/best_offer_card.dart';
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
              Padding(padding: const EdgeInsets.all(12), child: _buildHeader()),

              Padding(
                padding: const EdgeInsets.all(12),
                child: _buildSearchBar(),
              ),

              Padding(
                padding: const EdgeInsets.all(12),
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
                padding: const EdgeInsets.all(12),
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
              ...nearestProperties
                  .map(
                    (property) => Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                      child: NearestPropertyRow(property: property),
                    ),
                  )
                  .toList(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Your Location",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 4),
              Text(
                "Softwarica College, Dillibazar",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
        CircleAvatar(radius: 20, backgroundColor: Colors.grey.shade200),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.grey),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search address, city, location",
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
