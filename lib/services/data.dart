
import 'package:newsfinal/models/category_model.dart';

List<CategoryModel> getCategories(){
  List<CategoryModel> category=[];
  CategoryModel categoryModel= CategoryModel();

  categoryModel.categoryName="Business";
  categoryModel.image='images/pic.jpg';
  category.add(categoryModel);
  categoryModel= CategoryModel();

  categoryModel.categoryName="Sports";
  categoryModel.image='images/pic.jpg';
  category.add(categoryModel);
  categoryModel= CategoryModel();

  categoryModel.categoryName="Bollywood";
  categoryModel.image='images/pic.jpg';
  category.add(categoryModel);
  categoryModel= CategoryModel();

  categoryModel.categoryName="International";
  categoryModel.image='images/pic.jpg';
  category.add(categoryModel);
  categoryModel= CategoryModel();

return category;

}