import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/product_card_shimmer_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/product_card_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/controllers/product_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/domain/models/product_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/widgets/redesign/home_title_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/enums/product_type.dart';
import 'package:flutter_sixvalley_ecommerce/helper/responsive_helper.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class FeaturedProductsWidget extends StatelessWidget {
  const FeaturedProductsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<ProductController, ProductModel?>(
      selector: (_, controller) => controller.featuredProductModel,
      builder: (_, featuredProductModel, __) {
        final products = featuredProductModel?.products;

        if (featuredProductModel == null) {
          return Column(children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.homePagePadding),
              child: HomeTitleWidget(
                title: getTranslated('featured_products', context)!,
                onViewAllTap: () => RouterHelper.getViewAllProductScreenRoute(productType: ProductType.featuredProduct, action: RouteAction.push),
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            const FeaturedProductsShimmer(),
            const SizedBox(height: Dimensions.homePagePadding),
          ]);
        }

        if (products == null || products.isEmpty) return const SizedBox.shrink();

        return Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.homePagePadding),
            child: HomeTitleWidget(
              title: getTranslated('featured_products', context)!,
              onViewAllTap: () => RouterHelper.getViewAllProductScreenRoute(productType: ProductType.featuredProduct, action: RouteAction.push),
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          // All cards in the row share the tallest card's height; the card pins its
          // add-to-cart button to the bottom so the extra space sits above the button.
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: Dimensions.homePagePadding, right: 15),
            child: IntrinsicHeight(child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              for (int index = 0; index < min(products.length, 4); index++) ...[
                if (index > 0) const SizedBox(width: Dimensions.paddingSizeSmall),
                SizedBox(width: 150, child: ProductCardWidget(product: products[index], fillHeight: true)),
              ],
            ])),
          ),
          const SizedBox(height: Dimensions.homePagePadding),
        ]);
      },
    );
  }
}

class FeaturedProductsShimmer extends StatelessWidget {
  const FeaturedProductsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: !ResponsiveHelper.isShortMobile(Get.context!) ? 245 : 235,
      child: Shimmer.fromColors(
        baseColor: Theme.of(context).cardColor,
        highlightColor: Colors.grey[300]!,
        enabled: true,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.only(left: Dimensions.homePagePadding, right: 15),
          itemCount: 4,
          separatorBuilder: (_, __) =>
          const SizedBox(width: Dimensions.paddingSizeSmall),
          itemBuilder: (_, __) => const SizedBox(
            width: 150,
            child: ProductCardShimmerWidget(),
          ),
        ),
      ),
    );
  }
}