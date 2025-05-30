import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newsfinal/models/article_model.dart';
import 'package:newsfinal/models/slider_model.dart';
import 'package:newsfinal/services/data.dart';
import 'package:newsfinal/services/news.dart';
import 'package:newsfinal/services/slider_data.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../models/category_model.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategoryModel> categories = [];
  List<sliderModel> sliders = [];
  List<ArticleModel> articles = [];
  bool _loading = true;

  int activeIndex = 0;
  @override
  void initState() {
    categories = getCategories();
    sliders = getSliders();
    getNews();
    super.initState();
  }

  getNews()async {
    News newsClass = News();
    await newsClass.getNews();
    articles = newsClass.news;
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Flutter"),
            Text(
              "News",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            )
          ],
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 30.0,
                  ), // Above the Breaking news Text
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Breaking News",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0),
                        ),
                        Text(
                          "View All",
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ), //Below Breaking news horizontal slider
                  CarouselSlider.builder(
                      itemCount: sliders.length,
                      itemBuilder: (context, index, realIndex) {
                        String? res = sliders[index].image;
                        String? res1 = sliders[index].name;
                        return buildImage(res!, index, res1!);
                      },
                      options: CarouselOptions(
                          height: 250,
                          enlargeCenterPage: true,
                          enlargeStrategy: CenterPageEnlargeStrategy.height,
                          onPageChanged: (index, reason) {
                            setState(() {
                              activeIndex = index;
                            });
                          })),
                  SizedBox(
                    height: 15.0,
                  ), //for slider button effect
                  Center(child: buildIndicator()),

                  Container(
                    margin: EdgeInsets.only(left: 10.0, top: 10.0),
                    height: 70,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          return CategoryTile(
                            image: categories[index].image,
                            categoryName: categories[index].categoryName,
                          );
                        }),
                  ),

                  SizedBox(
                    height: 30.0,
                  ), // below Category
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Trending News",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0),
                        ),
                        Text(
                          "View All",
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ), // Below trending news and View All text
                  Container(
                    child: ListView.builder(
                      shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: articles.length,
                        itemBuilder: (context, index) {
                          return BlogTile(
                              desc: articles[index].description!,
                              imageUrl: articles[index].urlToImage!,
                              title: articles[index].title!);
                        }),
                  )
                ],
              ),
            ),
    );
  }

  Widget buildImage(String image, int index, String name) => Container(
        margin: EdgeInsets.symmetric(horizontal: 10.0),
        child: Stack(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              image,
              height: 250,
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
            ),
          ),
          Container(
            height: 250,
            padding: EdgeInsets.only(left: 10.0),
            margin: EdgeInsets.only(top: 170.0),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10))),
            child: Text(
              name,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
          )
        ]),
      );

  Widget buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: sliders.length,
        effect: SlideEffect(
            dotWidth: 10, dotHeight: 10, activeDotColor: Colors.blue),
      );
}

class CategoryTile extends StatelessWidget {
  final image, categoryName;
  CategoryTile({this.categoryName, this.image});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 16),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.asset(
              image,
              width: 120,
              height: 70,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            width: 120,
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.black38,
            ),
            child: Center(
                child: Text(categoryName,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold))),
          )
        ],
      ),
    );
  }
}

class BlogTile extends StatelessWidget {
  String imageUrl, title, desc;
  BlogTile({required this.desc, required this.imageUrl, required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(bottom: 10.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Material(
            elevation: 3.0,
            borderRadius: BorderRadius.circular(10.0),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: CachedNetworkImage(
                            imageUrl: imageUrl,
                            height: 150,
                            width: 150,
                            fit: BoxFit.cover,
                          ))),
                  SizedBox(
                    width: 8.0,
                  ), // btw trending news image and text card
                  Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 2,
                        child: Text(
                          title,
                          maxLines: 2,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 17.0),
                        ),
                      ),
                      SizedBox(
                        width: 7.0,
                      ), // btw both text in trending news Section
                      Container(
                        width: MediaQuery.of(context).size.width / 2,
                        child: Text(
                          desc,
                          maxLines: 3,
                          style: TextStyle(
                              color: Colors.black26,
                              fontWeight: FontWeight.w500,
                              fontSize: 15.0),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
