import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/not_logged_in_bottom_sheet_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/cart/controllers/cart_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/cart/domain/models/cart_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/domain/models/product_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

class AddToCartButtonWidget extends StatefulWidget {
  final Product product;

  const AddToCartButtonWidget({super.key, required this.product});

  @override
  State<AddToCartButtonWidget> createState() => _AddToCartButtonWidgetState();
}

class _AddToCartButtonWidgetState extends State<AddToCartButtonWidget> {
  bool _isLoading = false;

  bool get _hasVariant => (widget.product.choiceOptions?.isNotEmpty ?? false) || (widget.product.colors?.isNotEmpty ?? false);

  Future<void> _addToCart(BuildContext context) async {
    final bool isLoggedIn = Provider.of<AuthController>(context, listen: false).isLoggedIn();
    final splashController = Provider.of<SplashController>(context, listen: false);

    if (splashController.configModel?.guestCheckOut == 0 && !isLoggedIn) {
      showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (_) => const NotLoggedInBottomSheetWidget(),
      );
      return;
    }

    setState(() => _isLoading = true);

    // addToCartAPI pops the top route on success (it's designed to close a bottom sheet),
    // so a transparent dummy route absorbs that pop instead of the current screen.
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      barrierDismissible: false,
      builder: (_) => const SizedBox.shrink(),
    );

    final response = await Provider.of<CartController>(context, listen: false).addToCartAPI(
      CartModelBody(productId: widget.product.id, variant: '', color: '', quantity: widget.product.minimumOrderQuantity ?? 1),
      context,
      widget.product.choiceOptions ?? [],
      [],
    );

    if (context.mounted && (response.response == null || response.response!.statusCode != 200)) {
      Navigator.of(context, rootNavigator: true).pop();
    }
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartController>(
      builder: (context, cartController, _) {
        final bool isInCart = cartController.cartList.any((item) => item.productId == widget.product.id);

        return GestureDetector(
          onTap: _isLoading ? null : () {
            if (_hasVariant) {
              RouterHelper.getProductDetailsRoute(action: RouteAction.push, productId: widget.product.id, slug: widget.product.slug);
            } else {
              _addToCart(context);
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: double.infinity,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isInCart ? Theme.of(context).primaryColor.withValues(alpha: 0.08) : Theme.of(context).primaryColor,
              border: Border.all(color: Theme.of(context).primaryColor, width: 1),
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            ),
            child: _isLoading
                ? SizedBox(
                    width: 15,
                    height: 15,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(isInCart ? Theme.of(context).primaryColor : Colors.white),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isInCart ? CupertinoIcons.checkmark_alt : CupertinoIcons.cart_badge_plus,
                        size: Dimensions.fontSizeSmall + 2,
                        color: isInCart ? Theme.of(context).primaryColor : Colors.white,
                      ),
                      const SizedBox(width: Dimensions.paddingSizeExtraExtraSmall),
                      Flexible(
                        child: Text(
                          getTranslated(isInCart ? 'added_to_cart' : 'add_to_cart', context) ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: titilliumSemiBold.copyWith(
                            fontSize: Dimensions.fontSizeExtraSmall,
                            color: isInCart ? Theme.of(context).primaryColor : Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
