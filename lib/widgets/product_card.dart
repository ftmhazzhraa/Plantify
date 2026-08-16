import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_assets.dart';
import '../models/models.dart';

class ProductCard extends StatelessWidget {
  final PlantProduct product;
  final VoidCallback onTap;

  const ProductCard({super.key, required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.cardBg,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        splashColor: AppColors.primaryDark.withOpacity(0.08),
        highlightColor: AppColors.primaryDark.withOpacity(0.04),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.divider, width: 0.5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image + badge
              Stack(children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                  child: Image.asset(product.image, width: double.infinity, height: 130, fit: BoxFit.cover),
                ),
                if (product.hasDiscount)
                  Positioned(top:8, right:8,
                    child: Image.asset(A.badge50, width:36, height:36)),
              ]),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(product.category, style: const TextStyle(fontSize:10, color:AppColors.textGrey)),
                  const SizedBox(height:2),
                  Text(product.name,
                    style: const TextStyle(fontSize:11, fontWeight:FontWeight.bold, color:AppColors.textDark, height:1.3),
                    maxLines:3, overflow:TextOverflow.ellipsis),
                  const SizedBox(height:4),
                  // Stars
                  Row(children: [
                    Icon(Icons.star, size:11, color:AppColors.starColor),
                    const SizedBox(width:2),
                    Text('${product.rating}  (${product.reviewCount})',
                      style: const TextStyle(fontSize:9, color:AppColors.textGrey)),
                  ]),
                  const SizedBox(height:5),
                  // Price
                  if (!product.hasDiscount)
                    Text('RM ${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize:12, fontWeight:FontWeight.bold, color:AppColors.primaryMed))
                  else
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('RM ${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize:10, color:AppColors.textStrike,
                          decoration:TextDecoration.lineThrough, decorationColor:AppColors.textStrike)),
                      Text('RM ${product.discountedPrice.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize:12, fontWeight:FontWeight.bold, color:AppColors.primaryMed)),
                    ]),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
