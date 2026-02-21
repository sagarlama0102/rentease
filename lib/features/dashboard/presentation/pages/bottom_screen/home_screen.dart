
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rentease/features/dashboard/presentation/pages/property_details_screen.dart';
import 'package:rentease/features/dashboard/presentation/view_model/property_viewmodel.dart';
import 'package:rentease/features/dashboard/presentation/state/property_state.dart';
import 'package:rentease/widgets/best_offer_card.dart';
import 'package:rentease/widgets/home_header.dart';
import 'package:rentease/widgets/home_search_bar.dart';

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
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: Text(
                    "Real Estate Offers",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),

                // Property Section (now a vertical 2-column grid)
                _buildPropertyGrid(propertyState),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPropertyGrid(PropertyState state) {
    if (state.status == PropertyStatus.loading) {
      return const SizedBox(
        height: 250,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (state.status == PropertyStatus.error) {
      return Center(child: Text(state.errorMessage ?? "Error fetching data"));
    }

    if (state.properties.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text("No properties available right now."),
        ),
      );
    }

    // 2-column vertical grid
    return Padding(
      padding: const EdgeInsets.all(12),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: state.properties.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,        // 2 cards per row
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.75,   // Adjust depending on card height
        ),
        itemBuilder: (context, index) {
          final property = state.properties[index];
  
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PropertyDetailScreen(
            propertyId: property.propertyId ?? '',
          ),
        ),
      );
    },
    child: BestOfferCard(property: property),
  );
        },
      ),
    );
  }
}