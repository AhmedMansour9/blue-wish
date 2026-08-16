import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/controllers/category_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/domain/models/category_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatelessWidget {
  final bool isBacButtonExist;

  const CategoryScreen({super.key, this.isBacButtonExist = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: getTranslated('CATEGORY', context), isBackButtonExist: isBacButtonExist),
      body: Consumer<CategoryController>(
        builder: (context, categoryProvider, child) {
          if (categoryProvider.categoryList.isEmpty) {
            return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)));
          }
          return GridView.builder(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            physics: const BouncingScrollPhysics(),
            itemCount: categoryProvider.categoryList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: Dimensions.paddingSizeDefault,
              crossAxisSpacing: Dimensions.paddingSizeDefault,
              childAspectRatio: 0.92,
            ),
            itemBuilder: (context, index) => _CategoryCard(category: categoryProvider.categoryList[index]),
          );
        },
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final CategoryModel category;
  const _CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    final String? imagePath = category.imageFullUrl?.path;
    final bool hasImage = imagePath != null && imagePath.isNotEmpty;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        RouterHelper.getBrandCategoryRoute(
          action: RouteAction.push,
          isBrand: false,
          id: category.id,
          name: category.name,
          categoryModel: category,
          isAllProduct: true,
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          fit: StackFit.expand,
          children: [
            hasImage
                ? CustomImageWidget(image: imagePath, fit: BoxFit.cover)
                : Container(
                    color: Theme.of(context).colorScheme.onTertiary,
                    child: Icon(Icons.eco_rounded, size: 42, color: Theme.of(context).primaryColor.withValues(alpha: 0.5)),
                  ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.4, 1],
                  colors: [Colors.transparent, Colors.black.withValues(alpha: 0.65)],
                ),
              ),
            ),
            Positioned(
              left: Dimensions.paddingSizeSmall,
              right: Dimensions.paddingSizeSmall,
              bottom: Dimensions.paddingSizeSmall,
              child: Text(
                category.name ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: textBold.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeLarge),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
