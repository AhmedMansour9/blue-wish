import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/product_card_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/controllers/category_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/domain/models/category_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/widgets/redesign/featured_products_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/widgets/redesign/home_title_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/controllers/product_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/domain/models/product_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

/// One horizontal product row per category, styled like [FeaturedProductsWidget].
/// Shares the per-category product cache with the home category tabs.
class CategoryProductsSections extends StatelessWidget {
  const CategoryProductsSections({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<CategoryController, List<CategoryModel>>(
      selector: (_, controller) => controller.categoryList,
      shouldRebuild: (_, __) => true,
      builder: (_, categories, __) => Column(
        children: categories
            .where((category) => category.id != null)
            .map((category) => _CategoryProductsSection(key: ValueKey(category.id), category: category))
            .toList(),
      ),
    );
  }
}

class _CategoryProductsSection extends StatefulWidget {
  final CategoryModel category;
  const _CategoryProductsSection({super.key, required this.category});

  @override
  State<_CategoryProductsSection> createState() => _CategoryProductsSectionState();
}

class _CategoryProductsSectionState extends State<_CategoryProductsSection> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  int get _categoryId => widget.category.id!;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Load the next page when the row is scrolled close to its end.
  void _onScroll() {
    if (_isLoadingMore || !_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels < position.maxScrollExtent - 200) return;

    final productController = Provider.of<ProductController>(context, listen: false);
    final ProductModel? model = productController.categoryProductsFor(_categoryId);
    final int loaded = model?.products?.length ?? 0;
    if (model == null || loaded >= (model.totalSize ?? 0)) return;

    setState(() => _isLoadingMore = true);
    productController.getCategoryProducts(_categoryId, (model.offset ?? 1) + 1).whenComplete(() {
      if (mounted) setState(() => _isLoadingMore = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final CategoryModel category = widget.category;
    final int categoryId = _categoryId;

    // Load-more appends to the same ProductModel instance, so select the length too
    // or the Selector would not rebuild when a new page arrives.
    return Selector<ProductController, (ProductModel?, int)>(
      selector: (_, controller) {
        final model = controller.categoryProductsFor(categoryId);
        return (model, model?.products?.length ?? 0);
      },
      builder: (context, selected, __) {
        final ProductModel? productModel = selected.$1;
        if (productModel == null) {
          // Not loaded yet (or the cache was cleared on pull-to-refresh) — fetch once;
          // getCategoryProducts ignores repeat calls while a request is in flight.
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Provider.of<ProductController>(context, listen: false).getCategoryProducts(categoryId, 1);
          });
        }

        final products = productModel?.products;
        if (productModel != null && (products == null || products.isEmpty)) return const SizedBox.shrink();

        return Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.homePagePadding),
            child: HomeTitleWidget(
              title: category.name ?? '',
              onViewAllTap: () => RouterHelper.getBrandCategoryRoute(
                action: RouteAction.push,
                isBrand: false,
                id: category.id,
                name: category.name,
                categoryModel: category,
                isAllProduct: true,
              ),
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          if (productModel == null)
            const FeaturedProductsShimmer()
          else
            // All cards in the row share the tallest card's height; the card pins its
            // add-to-cart button to the bottom so the extra space sits above the button.
            SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: Dimensions.homePagePadding, right: 15),
              child: IntrinsicHeight(child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                for (int index = 0; index < products!.length; index++) ...[
                  if (index > 0) const SizedBox(width: Dimensions.paddingSizeSmall),
                  SizedBox(width: 150, child: ProductCardWidget(product: products[index], fillHeight: true)),
                ],
                if (_isLoadingMore)
                  const SizedBox(
                    width: 60,
                    child: Center(child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))),
                  ),
              ])),
            ),
          const SizedBox(height: Dimensions.homePagePadding),
        ]);
      },
    );
  }
}
