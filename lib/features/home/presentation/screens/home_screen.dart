import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listys_app/core/localization/app_localizations.dart';
import 'package:listys_app/core/theme/app_color.dart';
import 'package:listys_app/core/theme/shimmer_loading.dart';
import 'package:listys_app/features/all_countries/presentation/screen/all_countries_screen.dart';
import 'package:listys_app/features/favorite/presentation/cubit/favorite_cubit.dart';
import 'package:listys_app/features/home/presentation/cubit/home_state.dart';
import 'package:listys_app/features/home/presentation/screens/home_drawer.dart';
import 'package:listys_app/features/home/presentation/widgets/country_card.dart';
import 'package:listys_app/features/home/presentation/widgets/header.dart';
import 'package:listys_app/features/home/presentation/widgets/places_card.dart';
import 'package:listys_app/features/nearby_map/presentation/view/nearby_map_screen.dart';
import 'package:listys_app/features/search/presentation/view/search_screen.dart';
import 'package:listys_app/features/home/presentation/cubit/home_cubit.dart';

class HomeScreen extends StatefulWidget {
 final Function(bool)? onDrawerChanged; 
 final Function(int)? onNavigate;

  const HomeScreen({super.key, this.onDrawerChanged, this.onNavigate});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: CustomHomeDrawer(onNavigate: widget.onNavigate!,), 
      onEndDrawerChanged: widget.onDrawerChanged,
      backgroundColor: Colors.transparent,
      body: SafeArea(

        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            // 1. Loading State (Skeleton Shimmer)
            if (state is HomeLoading) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    
                    // Header & Menu Button (Static)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,     
                      children: [
                        const Header(), 
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white12,
                          ),
                          child: IconButton(
                            onPressed: () => _scaffoldKey.currentState?.openEndDrawer(), 
                            icon: const Icon(Icons.menu, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Search bar + Map button (Static)
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 56,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[700]!),
                              color: Colors.grey[900]?.withOpacity(0.3),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.search, color: Colors.grey[400]),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    loc.search_for_any_place ?? 'Search for any place...',
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          height: 56,
                          width: 56,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primaryColor,
                                AppColors.primaryColor.withOpacity(0.8),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryColor.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.explore,
                            color: Colors.black,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Popular Countries Section (Shimmer)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          loc.popular_countries ?? 'Popular Countries',
                          style: const TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          loc.see_all ?? 'See All Countries',
                          style: const TextStyle(
                            color: Color(0xFFF9B933),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const ShimmerHorizontalList(height: 230, width: 160), 
                    
                    const SizedBox(height: 32),

                    // Popular Places Section (Shimmer)
                    Text(
                      loc.translate('popular_places') ?? 'Popular Places',
                      style: const TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const ShimmerHorizontalList(height: 130, width: 280), 
                    
                    const SizedBox(height: 100),
                  ],
                ),
              );
            }

            // 2. Loaded State (Actual Data)
            if (state is HomeLoaded) {
              final home = state.home;

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,     
                      children: [
                        const Header(), 
                        
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white12,
                          ),
                          child: IconButton(
                            onPressed: () => _scaffoldKey.currentState?.openEndDrawer(), 
                            icon: const Icon(Icons.menu, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    // Search bar + Map button
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 56,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[700]!),
                              color: Colors.grey[900]?.withOpacity(0.3),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.search, color: Colors.grey[400]),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: TextField(
                                    readOnly: true,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const SearchScreen(),
                                        ),
                                      );
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: loc.search_for_any_place,
                                      hintStyle: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: 15,
                                      ),
                                    ),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        
                        // Filter button
                        Container(
                          height: 56,
                          width: 56,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primaryColor,
                                AppColors.primaryColor.withOpacity(0.8),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryColor.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.explore,
                              color: Colors.black,
                              size: 30,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const NearbyMapScreen(),
                                ),
                              );
                            },
                            tooltip: "Filter",
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Popular Countries Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          loc.popular_countries ?? 'Popular Countries',
                          style: const TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (newContext) => MultiBlocProvider(
                                  providers: [
                                    BlocProvider.value(
                                      value: context.read<HomeCubit>(),
                                    ),
                                    BlocProvider.value(
                                      value: context.read<FavoriteCubit>(),
                                    ),
                                  ],
                                  child: const AllCountriesScreen(),
                                ),
                              ),
                            );
                          },
                          child: Text(
                            loc.see_all ?? 'See All',
                            style: const TextStyle(
                              color: Color(0xFFF9B933),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    SizedBox(
                      height: 230,
                      child: home.popularCountries.isEmpty
                          ? Center(
                              child: Text(
                                "No countries available",
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            )
                          : ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: home.popularCountries.length,
                              separatorBuilder: (_, __) => const SizedBox(width: 12),
                              itemBuilder: (context, index) {
                                final country = home.popularCountries[index];
                                return CountryCard(country: country);
                              },
                            ),
                    ),

                    const SizedBox(height: 32),

                    // Popular Places Section
                    Text(
                      loc.translate('popular_places') ?? 'Popular Places',
                      style: const TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    SizedBox(
                      height: 130,
                      child: home.popularPlaces.isEmpty
                          ? Center(
                              child: Text(
                                "No places available",
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            )
                          : ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: home.popularPlaces.length,
                              separatorBuilder: (_, __) => const SizedBox(width: 12),
                              itemBuilder: (context, index) {
                                final place = home.popularPlaces[index];
                                return PlaceCard(place: place);
                              },
                            ),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              );
            }

            // 3. Error State
            if (state is HomeError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 64,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        "Oops! Something went wrong",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        state.message,
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton.icon(
                        onPressed: () {
                          context.read<HomeCubit>().loadHome();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.refresh),
                        label: Text(
                          loc.retry ?? 'Retry',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            // Fallback for other states
            return Center(
              child: Text(
                loc.error ?? 'Error',
                style: const TextStyle(color: Colors.white),
              ),
            );
          },
        ),
      ),
    );
  }
}