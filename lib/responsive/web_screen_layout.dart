import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insta_flutter/utils/colors.dart';
import 'package:insta_flutter/utils/global_variables.dart';

class WebScreenLayout extends StatefulWidget {
  const WebScreenLayout({Key? key}) : super(key: key);

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {
  int _page = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void navigationTapped(int page) {
    _pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: webBackgroundColor,
        centerTitle: false,
        title: SvgPicture.asset(
          'assets/ic_instagram.svg',
          color: primaryColor,
          height: 32,
        ),
        actions: [
          IconButton(
            onPressed: ()=> navigationTapped(0),
            icon: (_page == 0) ? const Icon(
              Icons.home_filled,
              color: primaryColor,
            )
            :const Icon(
              Icons.home_outlined,
              color: secondaryColor,
            ),
          ),
          IconButton(
            onPressed: ()=> navigationTapped(1),
            icon: (_page == 0) ?const Icon(Icons.search, color: primaryColor)
            : const Icon(Icons.search, color: secondaryColor),
          ),
          IconButton(
            onPressed: ()=> navigationTapped(2),
            icon: (_page == 2)? const Icon(Icons.add_box, color: primaryColor)
            : const Icon(Icons.add_box_outlined, color: secondaryColor),
          ),
          IconButton(
            onPressed: ()=> navigationTapped(3),
            icon: (_page == 2)? const Icon(Icons.favorite, color: primaryColor)
            : const Icon(Icons.favorite, color: secondaryColor),
          ),
          IconButton(
            onPressed: ()=> navigationTapped(4),
            icon: (_page == 4)? const Icon(Icons.person, color: primaryColor)
            :const Icon(Icons.person_outline, color: secondaryColor),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.mail_outline, color: primaryColor),
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: onPageChanged,
        children: navBarItems,
        physics: const NeverScrollableScrollPhysics(),
      ),
    );
  }
}
