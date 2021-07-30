import 'package:dog_breed_recognition/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:web_scraper/web_scraper.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key? key}) : super(key: key);

  // created as a variable because it will be used in search bar
  _SearchScreenState state = _SearchScreenState();

  @override
  _SearchScreenState createState() => _SearchScreenState();
}


  class _SearchScreenState extends State<SearchScreen> {

  //bool searched = false;
  //String search = '';
    late WebScraper webScraper;
    bool loaded = false;
    String image = "";
    String title = "";
    String price = "";
    String location = "";
    String url = "";

    // to initialize all the variables, we first override initState and call an async method
    @override
    void initState() {
      super.initState();
      _getData();
    }

    _getData() async {
      webScraper = WebScraper('https://reklama5.mk/');
      if (await webScraper.loadWebPage('/Search?city=&cat=1039&q=Snaucer')) {
        List<Map<String, dynamic>> images = webScraper.getElement('div.ad-image', ['innerHtml']);
        List<Map<String, dynamic>> titles = webScraper.getElement('a.SearchAdTitle', ['title']);
        List<Map<String, dynamic>> prices = webScraper.getElement('span.search-ad-price', ['title']);
        List<Map<String, dynamic>> locations = webScraper.getElement('span.city-span', ['title']);
        List<Map<String, dynamic>> urls = webScraper.getElement('', ['href']);


        setState(() {
          loaded = true;
          image = images[0]['innerHtml'];
          price = prices[0]['title'];
          title = titles[0]['title'];
          location = locations[0]['title'];
          url = urls[0]['href'];
        });
      }
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            (loaded)?Text(price): CircularProgressIndicator(),
            (loaded)?Text(title):CircularProgressIndicator(),
            (loaded)?Text(location):CircularProgressIndicator(),
            (loaded)?Text('this is the url: ${url}'):CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}