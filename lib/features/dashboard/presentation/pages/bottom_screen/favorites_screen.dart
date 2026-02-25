import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rentease/core/api/api_endpoints.dart';
import 'package:rentease/core/routes/app_route.dart';
import 'package:rentease/features/favourites/presentation/view_model/favourite_view_model.dart';
import 'package:rentease/features/favourites/presentation/state/favourite_state.dart';
import 'package:rentease/app/theme/theme_extensions.dart'; // Import your extension

class FavouritesScreen extends ConsumerStatefulWidget {
  const FavouritesScreen({super.key});

  @override
  ConsumerState<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends ConsumerState<FavouritesScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(favouriteViewModelProvider.notifier).getAllFavourites(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final favouriteState = ref.watch(favouriteViewModelProvider);

    return Scaffold(
      // FIX: Dynamically changes background color
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        title: Text(
          "My Wishlist",
          style: TextStyle(
            color: context.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        // FIX: backgroundColor is now transparent or theme-aware
        backgroundColor: context.surfaceColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: _buildBody(favouriteState),
    );
  }

  Widget _buildBody(FavouriteState state) {
    if (state.status == FavouriteStatusState.loading &&
        state.favourites.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xff99DAB3)),
      );
    }

    if (state.status == FavouriteStatusState.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Oops! ${state.errorMessage}",
              style: TextStyle(color: context.textPrimary),
            ),
            ElevatedButton(
              onPressed: () => ref
                  .read(favouriteViewModelProvider.notifier)
                  .getAllFavourites(),
              child: const Text("Retry"),
            ),
          ],
        ),
      );
    }

    if (state.favourites.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_rounded,
              size: 80,
              color: context.textTertiary.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              "Your wishlist is empty",
              style: TextStyle(fontSize: 18, color: context.textSecondary),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () =>
          ref.read(favouriteViewModelProvider.notifier).getAllFavourites(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.favourites.length,
        itemBuilder: (context, index) {
          final favourite = state.favourites[index];

          // MODERN PROPERTY CARD
          return Container(
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: context.surfaceColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: context.softShadow,
            ),
            child: InkWell(
              onTap: () => Navigator.pushNamed(
                context,
                AppRoute.propertyDetailRoute,
                arguments: favourite.propertyId,
              ),
              borderRadius: BorderRadius.circular(20),
              child: Row(
                children: [
                  // Image Section
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                    child: Image.network(
                      "${ApiEndpoints.baseUrlOnly}${favourite.propertyImages[0]}",
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 120,
                        height: 120,
                        color: context.borderColor,
                        child: const Icon(Icons.broken_image),
                      ),
                    ),
                  ),
                  // Content Section
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // Use MainAxisAlignment.spaceBetween to push the button to the bottom
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            favourite.propertyTitle ?? "Modern Apartment",
                            maxLines: 2, // Allow 2 lines for titles
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: context.textPrimary,
                            ),
                          ),

                          // Remove the Location Row and replace with a cleaner bottom section
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Styled View Details Action
                              InkWell(
                                onTap: () => Navigator.pushNamed(
                                  context,
                                  '/property_details',
                                  arguments: favourite.propertyId,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xff99DAB3,
                                    ).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    "View details",
                                    style: TextStyle(
                                      color: Color(0xff99DAB3),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),

                              // Favorite Toggle
                              IconButton(
                                constraints: const BoxConstraints(),
                                padding: EdgeInsets.zero,
                                icon: const Icon(
                                  Icons.favorite_rounded,
                                  color: Colors.redAccent,
                                  size: 24,
                                ),
                                onPressed: () {
                                  ref
                                      .read(favouriteViewModelProvider.notifier)
                                      .toggleFavourite(favourite.propertyId);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
