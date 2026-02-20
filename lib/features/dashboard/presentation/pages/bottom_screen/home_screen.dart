// import 'package:flutter/material.dart';
// import 'package:rentease/app/theme/app_colors.dart';
// import 'package:rentease/models/property.dart';
// import 'package:rentease/widgets/best_offer_card.dart';
// import 'package:rentease/widgets/home_header.dart';
// import 'package:rentease/widgets/home_search_bar.dart';
// import 'package:rentease/widgets/nearest_property_row.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});
 

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox.expand(
//       child: SafeArea(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.only(top: 20, bottom: 20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(padding: const EdgeInsets.all(12), child: HomeHeader()),

//               Padding(
//                 padding: const EdgeInsets.all(12),
//                 child: HomeSearchBar(),
//               ),

//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//                 child: Text(
//                   "Best Offers",
//                   style: TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                     color: AppColors.darkTextSecondary,
//                   ),
//                 ),
//               ),

//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                 child: Text(
//                   "Discover unbeatable deals on your nearest area",
//                   style: TextStyle(fontSize: 14, color: Colors.grey),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(12),
//                 child: SizedBox(
//                   height: 250,
//                   child: ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemCount: bestOffers.length,
//                     itemBuilder: (context, index) {
//                       return BestOfferCard(property: bestOffers[index]);
//                     },
//                   ),
//                 ),
//               ),

//               Padding(
//                 padding: const EdgeInsets.all(12),
//                 child: Text(
//                   "Nearest by your location",
//                   style: TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                     color: AppColors.darkTextSecondary,
//                   ),
//                 ),
//               ),
//               ListView.builder(
//                 shrinkWrap: true,
//                 physics: NeverScrollableScrollPhysics(),
//                 itemCount: nearestProperties.length,
//                  itemBuilder: (context,index){
//                 return Padding(padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                 child: NearestPropertyRow(property: nearestProperties[index],
//                 ),
//                 );
//               },
//               ),
    
//               SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rentease/features/dashboard/presentation/view_model/property_viewmodel.dart';
import 'package:rentease/features/dashboard/presentation/state/property_state.dart';
import 'package:rentease/widgets/best_offer_card.dart';
import 'package:rentease/widgets/home_header.dart';
import 'package:rentease/widgets/home_search_bar.dart';
// ... other imports
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {

  @override
  void initState() {
    super.initState();

    // Runs only once when screen loads
    Future.microtask(() {
      ref.read(propertyViewModelProvider.notifier).getAllProperties();
    });
  }

  @override
  Widget build(BuildContext context) {
    final propertyState = ref.watch(propertyViewModelProvider);

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () =>
              ref.read(propertyViewModelProvider.notifier).getAllProperties(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                    padding: EdgeInsets.all(12), child: HomeHeader()),
                const Padding(
                    padding: EdgeInsets.all(12), child: HomeSearchBar()),

                const Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: Text(
                    "Real Estate Offers",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                ),

                _buildPropertySection(propertyState),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPropertySection(PropertyState state) {
    if (state.status == PropertyStatus.loading) {
      return const SizedBox(
        height: 250,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (state.status == PropertyStatus.error) {
      return Center(
          child: Text(state.errorMessage ?? "Error fetching data"));
    }

    if (state.properties.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text("No properties available right now."),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(12),
      child: SizedBox(
        height: 280,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: state.properties.length,
          itemBuilder: (context, index) {
            return BestOfferCard(
                property: state.properties[index]);
          },
        ),
      ),
    );
  }
}