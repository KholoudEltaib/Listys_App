import 'package:flutter/material.dart';
import 'package:listys_app/core/localization/app_localizations.dart';
import 'package:listys_app/core/theme/app_color.dart';
import 'package:listys_app/features/destination/domain/entities/place.dart';

class Reviews extends StatelessWidget {
  final Place place;

  const Reviews({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            ReviewsListSection(place: place),
          ],
        ),
      ),
    );
  }
}

class ReviewsListSection extends StatelessWidget {
  final Place place;

  const ReviewsListSection({
    super.key,
    required this.place,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final reviews = place.reviews ?? [];
    final reviewCount = place.reviewsCount ?? reviews.length;
    final averageRating = place.averageRating ?? 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: AppColors.primaryColor),
              ),
              child: Text(
                '${averageRating.toStringAsFixed(1)}/5',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '($reviewCount ${loc.reviews})',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        
        // Check if reviews exist
        if (reviews.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40.0),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.reviews,
                    color: Colors.grey[600],
                    size: 60,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No reviews yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Be the first to review this place!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: reviews.length,
            separatorBuilder: (context, index) => const SizedBox(height: 20),
            itemBuilder: (context, index) {
              return ReviewCard(review: reviews[index]);
            },
          ),
      ],
    );
  }
}

class ReviewCard extends StatelessWidget {
  final Review review;

  const ReviewCard({
    super.key,
    required this.review,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0x07FFFFFF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x09FFFFFF), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rating stars and date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStars(review.rating),
              Text(
                review.createdAt,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Review comment
          Text(
            review.comment,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),

          // Author with profile image
          Row(
            children: [
              // User profile image
              if (review.user.image != null && review.user.image!.isNotEmpty)
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(review.user.image!),
                  backgroundColor: Colors.grey[800],
                )
              else
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person,
                    color: AppColors.primaryColor,
                    size: 16,
                  ),
                ),
              const SizedBox(width: 8),
              Text(
                review.user.name,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStars(double rating) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating.round() ? Icons.star : Icons.star_border,
          color: AppColors.primaryColor,
          size: 16,
        );
      }),
    );
  }
}

























// // features/destination_details/presentation/widget/content/reviews.dart

// import 'package:flutter/material.dart';
// import 'package:listys_app/core/localization/app_localizations.dart';
// import 'package:listys_app/core/theme/app_color.dart';

// class Reviews extends StatelessWidget {
//   final int placeId;

//   const Reviews({super.key, required this.placeId});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Note: This is placeholder data
//             // TODO: Fetch real reviews from API using placeId
//             const SizedBox(height: 16),
//             // Reviews list
//             const ReviewsListSection(),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ReviewsListSection extends StatelessWidget {
//   const ReviewsListSection({super.key});

//   // Sample reviews data (TODO: Replace with real API data)
//   final List<Review> reviews = const [
//     Review(
//       rating: 5,
//       date: '01-07-2024',
//       comment:
//           'Great explanation and consistent support with practical training. Highly recommended!',
//       author: 'Ahmed',
//     ),
//     Review(
//       rating: 1,
//       date: '03-07-2024',
//       comment:
//           'Great explanation and consistent support with practical training. Highly recommended!',
//       author: 'Emad',
//     ),
//     Review(
//       rating: 4,
//       date: '04-07-2024',
//       comment:
//           'Great explanation and consistent support with practical training. Highly recommended!',
//       author: 'Yasser',
//     ),
//     Review(
//       rating: 3,
//       date: '05-07-2024',
//       comment:
//           'Great explanation and consistent support with practical training. Highly recommended!',
//       author: 'Kholoud',
//     ),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     final loc = AppLocalizations.of(context)!;
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//               decoration: BoxDecoration(
//                 color: AppColors.primaryColor.withOpacity(0.2),
//                 borderRadius: BorderRadius.circular(4),
//                 border: Border.all(color: AppColors.primaryColor),
//               ),
//               child: const Text(
//                 '4.5/5',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//             const SizedBox(width: 8),
//             Text(
//               '(${reviews.length} ${loc.reviews})',
//               style: const TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 20),
//         ListView.separated(
//           physics: const NeverScrollableScrollPhysics(),
//           shrinkWrap: true,
//           itemCount: reviews.length,
//           separatorBuilder: (context, index) => const SizedBox(height: 20),
//           itemBuilder: (context, index) {
//             return ReviewCard(review: reviews[index]);
//           },
//         ),
//       ],
//     );
//   }
// }

// class ReviewCard extends StatelessWidget {
//   final Review review;

//   const ReviewCard({
//     super.key,
//     required this.review,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: const Color(0x07FFFFFF),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: const Color(0x09FFFFFF), width: 1),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Rating stars and date
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               _buildStars(review.rating),
//               Text(
//                 review.date,
//                 style: const TextStyle(
//                   fontSize: 12,
//                   color: Colors.white,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),

//           // Review comment
//           Text(
//             review.comment,
//             style: const TextStyle(
//               fontSize: 14,
//               color: Colors.grey,
//               height: 1.4,
//             ),
//           ),
//           const SizedBox(height: 12),

//           // Author
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: AppColors.primaryColor.withOpacity(0.2),
//                   shape: BoxShape.circle,
//                 ),
//                 child: Icon(
//                   Icons.person,
//                   color: AppColors.primaryColor,
//                   size: 16,
//                 ),
//               ),
//               const SizedBox(width: 8),
//               Text(
//                 review.author,
//                 style: const TextStyle(
//                   fontSize: 14,
//                   color: Colors.white,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStars(int rating) {
//     return Row(
//       children: List.generate(5, (index) {
//         return Icon(
//           index < rating ? Icons.star : Icons.star_border,
//           color: AppColors.primaryColor,
//           size: 16,
//         );
//       }),
//     );
//   }
// }

// class Review {
//   final int rating;
//   final String date;
//   final String comment;
//   final String author;

//   const Review({
//     required this.rating,
//     required this.date,
//     required this.comment,
//     required this.author,
//   });
// }