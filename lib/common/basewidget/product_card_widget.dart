import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/add_to_cart_button_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_asset_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/domain/models/product_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/widgets/favourite_button_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/shop/domain/models/shop_navigation_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:provider/provider.dart';

class ProductCardWidget extends StatelessWidget {
  final Product product;
  final bool isBestSelling;
  final bool isNew;
  final SellerNavigationModel? sellerNavigationModel;
  /// Stretch to the height given by the parent and pin the add-to-cart button to
  /// the bottom, so cards in the same row share one height. Needs bounded height.
  final bool fillHeight;

  const ProductCardWidget({
    super.key,
    required this.product,
    this.isBestSelling = false,
    this.isNew = false,
    this.sellerNavigationModel,
    this.fillHeight = false,
  });

  @override
  Widget build(BuildContext context) {
    final double rating = (product.rating?.isNotEmpty ?? false) ? double.tryParse('${product.rating?[0].average}') ?? 0 : 0;
    final int reviewCount = product.reviewCount ?? 0;
    final double discount = (product.clearanceSale?.discountAmount ?? product.discount) ?? 0;
    final String? discountType = (product.clearanceSale?.discountAmount ?? 0) > 0 ? product.clearanceSale?.discountType ?? 'amount' : product.discountType;
    final String productPrice = PriceConverter.convertPrice(context, product.unitPrice ?? 0, discount: discount, discountType: discountType);
    final bool hasDiscount = discount > 0;
    final String? originalPrice = hasDiscount ? PriceConverter.convertPrice(context, product.unitPrice) : null;
    // PriceConverter.convertPrice(context, product.unitPrice)

    return InkWell(
          borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
          onTap: () => RouterHelper.getProductDetailsRoute(action: RouteAction.push, productId: product.id, slug: product.slug),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 16, offset: const Offset(0, 6)),
              ],
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: fillHeight ? MainAxisSize.max : MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(Dimensions.radiusExtraLarge),
                    topRight: Radius.circular(Dimensions.radiusExtraLarge),
                  ),
                  child: Stack(
                    children: [
                    AspectRatio(
                      aspectRatio: 1.15,
                      child: CustomImageWidget(
                        width: double.infinity,
                        height: double.infinity,
                        image: product.thumbnailFullUrl?.path ?? '',
                        fit: BoxFit.cover,
                      ),
                    ),

                    if (product.currentStock == 0 && product.productType == 'physical') ...[
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.4),
                            borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusSmall)),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.error.withValues(alpha: 0.4),
                            borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(Dimensions.radiusSmall),
                                bottomLeft: Radius.circular(Dimensions.radiusSmall)
                            ),
                          ),
                          child: Text(
                            getTranslated('out_of_stock', context) ?? 'Out of Stock',
                            textAlign: TextAlign.center,
                            style: titilliumBold.copyWith(
                              color: Theme.of(context).cardColor,
                              fontSize: Dimensions.fontSizeSmall,
                            ),
                          ),
                        ),
                      ),
                    ],

                    if (isBestSelling || isNew)
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: DecoratedBox(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(Dimensions.radiusDefault),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.paddingSizeSmall,
                              vertical: 2,
                            ),
                            child: Row(
                              children: [
                                if (isBestSelling)
                                  CustomAssetImageWidget(Images.bestSellingTag, height: 15),
                                if (isNew && !isBestSelling)
                                  CustomAssetImageWidget(Images.newTag, height: 15),
                              ],
                            ),
                          ),
                        ),
                      ),

                    Positioned(
                      top: Dimensions.paddingSizeExtraSmall,
                      right: Dimensions.paddingSizeExtraSmall,
                      child: FavouriteButtonWidget(
                        sellerNavigationModel: sellerNavigationModel,
                        productId: product.id,
                        iconSize: Dimensions.iconSizeExtraSmall,
                        backgroundColor:
                        Provider.of<ThemeController>(context, listen: false).darkTheme ? Theme.of(context).cardColor : Theme.of(context).primaryColor,
                      ),
                    ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                _expandIf(fillHeight, Padding(
                  padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeSmall, 0, Dimensions.paddingSizeSmall, Dimensions.paddingSizeSmall),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: fillHeight ? MainAxisSize.max : MainAxisSize.min,
                  children: [
                    Text(product.name ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: titilliumRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        height: 1.35,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeExtraExtraSmall),

                    if (rating > 0 && reviewCount > 0) ...[
                      Row(mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.star, color: Theme.of(context).colorScheme.secondary, size: Dimensions.iconSizeExtraSmall),
                          Text(rating.toStringAsFixed(1),
                            style: titilliumRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                              color: Theme.of(context).textTheme.bodyMedium?.color,
                            ),
                          ),
                          const SizedBox(width: Dimensions.paddingSizeExtraExtraSmall),

                          Expanded(
                            child: Text('($reviewCount ${getTranslated('review', context)!})',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: titilliumRegular.copyWith(
                                color: Theme.of(context).hintColor,
                                fontSize: Dimensions.fontSizeSmall,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: Dimensions.paddingSizeExtraExtraSmall),
                    ],

                    // Original (struck-through) price sits next to the price so a discount
                    // doesn't add a line to the card.
                    Row(crossAxisAlignment: CrossAxisAlignment.baseline, textBaseline: TextBaseline.alphabetic, children: [
                      Flexible(
                        child: Text(productPrice,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: titilliumBold.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                      ),

                      if (hasDiscount && originalPrice != null) ...[
                        const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                        Flexible(
                          child: Text(
                            originalPrice,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: titilliumRegular.copyWith(
                              fontSize: Dimensions.fontSizeExtraSmall,
                              color: Theme.of(context).hintColor,
                              decoration: TextDecoration.lineThrough,
                              decorationColor: Theme.of(context).hintColor,
                            ),
                          ),
                        ),
                      ],
                    ]),
                    if (fillHeight) const Spacer(),
                    if (!(product.currentStock == 0 && product.productType == 'physical')) ...[
                      const SizedBox(height: 10),
                      AddToCartButtonWidget(product: product),
                    ],
                  ],
                  ),
                )),
              ],
            ),
          ),
        );
  }

  static Widget _expandIf(bool expand, Widget child) => expand ? Expanded(child: child) : child;

  /// Height that fits the tallest variant of this card (two-line name, rating,
  /// price row and add-to-cart button) at [width]. Use it as a fixed grid
  /// cell height together with [fillHeight] so every card gets the same height.
  /// Keep in sync with the layout in [build].
  static double maxHeightFor(BuildContext context, double width) {
    final TextScaler scaler = MediaQuery.textScalerOf(context);
    double lineHeight(TextStyle style) {
      final TextPainter painter = TextPainter(
        text: TextSpan(text: 'Agأب', style: style),
        textDirection: TextDirection.ltr,
        textScaler: scaler,
        maxLines: 1,
      )..layout();
      return painter.height;
    }

    final double regular = lineHeight(titilliumRegular.copyWith(fontSize: Dimensions.fontSizeSmall));
    final double bold = lineHeight(titilliumBold.copyWith(fontSize: Dimensions.fontSizeSmall));
    final double nameLine = lineHeight(titilliumRegular.copyWith(fontSize: Dimensions.fontSizeSmall, height: 1.35));

    return width / 1.15 // image (AspectRatio 1.15)
        + 10 // gap under the image
        + nameLine * 2 + Dimensions.paddingSizeExtraExtraSmall // name
        + (regular > Dimensions.iconSizeExtraSmall ? regular : Dimensions.iconSizeExtraSmall) + Dimensions.paddingSizeExtraExtraSmall // rating
        + bold // price row (original price sits beside it)
        + 10 + 30 // add-to-cart button
        + Dimensions.paddingSizeSmall // bottom padding
        + 4; // safety margin for font rounding
  }
}
