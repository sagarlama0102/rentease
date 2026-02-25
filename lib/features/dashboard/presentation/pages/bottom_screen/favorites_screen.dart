import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rentease/core/api/api_endpoints.dart';
import 'package:rentease/features/favourites/presentation/view_model/favourite_view_model.dart';
import 'package:rentease/features/favourites/presentation/state/favourite_state.dart';

class FavouritesScreen extends ConsumerStatefulWidget {
  const FavouritesScreen({super.key});

  @override
  ConsumerState<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends ConsumerState<FavouritesScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch the list of favourites when the screen is first loaded
    Future.microtask(
      () => ref.read(favouriteViewModelProvider.notifier).getAllFavourites(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final favouriteState = ref.watch(favouriteViewModelProvider);

    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5), // Light grey background
      appBar: AppBar(
        title: const Text(
          "My Wishlist",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: _buildBody(favouriteState),
    );
  }

  Widget _buildBody(FavouriteState state) {
    // 1. Loading State
    if (state.status == FavouriteStatusState.loading && state.favourites.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xff99DAB3)),
      );
    }

    // 2. Error State
    if (state.status == FavouriteStatusState.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Oops! ${state.errorMessage}"),
            ElevatedButton(
              onPressed: () => ref.read(favouriteViewModelProvider.notifier).getAllFavourites(),
              child: const Text("Retry"),
            )
          ],
        ),
      );
    }

    // 3. Empty State
    if (state.favourites.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            const Text(
              "Your wishlist is empty",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    // 4. Success State (List of Favourites)
    return RefreshIndicator(
      onRefresh: () => ref.read(favouriteViewModelProvider.notifier).getAllFavourites(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.favourites.length,
        itemBuilder: (context, index) {
          final favourite = state.favourites[index];
          
          // Assuming you have a PropertyCard widget
          // You can wrap it in a Dismissible to allow "Swipe to Remove"
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: ListTile(
                contentPadding: const EdgeInsets.all(10),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    // Update this logic based on how your FavouriteEntity stores images
                    "${ApiEndpoints.baseUrlOnly}${favourite.propertyImages[0]}",
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
                  ),
                ),
                title: Text(
                  favourite.propertyTitle ?? "Property",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () {
                    // Quick remove from favourites
                    ref.read(favouriteViewModelProvider.notifier)
                       .toggleFavourite(favourite.propertyId);
                  },
                ),
                onTap: () {
                  // Navigate to details if they click the card
                  Navigator.pushNamed(context, '/property_details', arguments: favourite.propertyId);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}