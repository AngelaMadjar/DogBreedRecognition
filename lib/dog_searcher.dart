import 'package:dog_breed_recognition/models/searched_item.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:dog_breed_recognition/models/searched_item.dart';


// NOTE: This class creates a search bar and provides its functionality:
//       displaying data obtained with web scraping, corresponding to the current search.

// TODO: It is recommended to refactor the code in this widget in a way that it will be split and organized in more widgets so that loose coupling is achieved



List list = ['item 1', 'item 2', 'item 3', 'item 4']; // Creating a global list that can be accessed from everywhere (it is initialized for testing purposes)

class SearchScreen extends StatefulWidget {
  SearchScreen({Key? key}) : super(key: key);

  _SearchScreenState state = _SearchScreenState();

  @override
  _SearchScreenState createState() => _SearchScreenState();
}


class _SearchScreenState extends State<SearchScreen> {

    // The controller is responsible for the text in the TextField
    final _controller = TextEditingController();

    // In the beginning, the search is an empty string
    String search = "";

    // A flag that indicates whether the search button is clicked or not
    bool isClicked = false;

    // A flag that indicates if the Web Scraper still awaits
    bool isLoading = false;

    // The lists in which the web scraped data is stored
    var titles;
    var hrefs;
    var prices;
    var locations;
    var dates;
    var images;

    // The result list that will be displayed in a List View
    var response;


    @override
    Widget build(BuildContext context) {
      return Scaffold(
          drawer: Drawer(),
          body: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 75, bottom: 10),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        // Creating the Search bar
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                          child: Container(
                            width: 280,
                            child: TextFormField(
                              controller: _controller,
                              decoration: InputDecoration(
                                // border: OutlineInputBorder(
                                //   borderRadius: BorderRadius.circular(27.0),
                                //   borderSide: BorderSide(
                                //     width: 0,
                                //     style: BorderStyle.none,
                                //   ),
                                // ),
                                //filled: true,
                                // fillColor: Colors.black12,
                                hintText: '    Search..',
                                hintStyle: TextStyle(
                                    color: Colors.black38
                                ),
                              ),
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),

                        // Creating the Search button which invokes the functionality of the search bar
                        MaterialButton(
                          child: Icon(Icons.search, color: Colors.grey),
                          onPressed: () async {
                            setState(() {
                              isLoading = true; // Changing the state
                              search = _controller.text; // Getting the current text in the search bar
                            });

                            // Awaiting for the web scraping function to return list of strings
                            response = await extractData(search);
                            //print(response);

                            setState(() {
                              isLoading = false; // Changing the state to default
                              //_controller.clear(); // Erasing the text in the search bar after clicking the button
                              search = ""; // Reinitializing the variable search to an empty string
                            });
                          },
                        )
                      ],
                    ),
                  ),
                ),

                // Creating a List View with custom Cards
                Expanded(
                    child:  (isClicked) // If the search button is clicked, then the list of items should be displayed
                        ? ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (BuildContext ctx, int index){
                        return GestureDetector(
                          onTap: () {
                            _launchUrl(Uri.encodeFull(response[index].href));
                          },
                          child: Container(
                            margin: EdgeInsets.all(12),
                            height: 150,
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  // Setting the Card's background to be an image
                                  // If the provided url isn't functional, an image from the assets is displayed
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: (!response[index].image.contains('noImage'))
                                        ? Image.network(response[index].image,
                                        fit: BoxFit.cover)
                                        : Image.asset('assets/dogs_alternative.jpg',
                                        fit: BoxFit.cover
                                    )
                                  ),
                                ),

                                // Making the Card's edges circular and adding some gradient
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    height: 150,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(20),
                                          bottomRight: Radius.circular(20),
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                        ),
                                        gradient: LinearGradient(
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                            colors: [
                                              Colors.black.withOpacity(0.9),
                                              Colors.black.withOpacity(0.5)
                                            ]
                                        )
                                    ),
                                  ),
                                ),

                                // Displaying the title : making it fit the card
                                // Making the first letter capital and the other small
                                Positioned(
                                    bottom: 102,
                                    left: 32,
                                    child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Row(
                                            children: [(response[index].title.length < 30)
                                                ? Text("${response[index].title[0].toUpperCase()}${response[index].title.substring(1,response[index].title.length).toLowerCase()}", //max length 36 + ...
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontFamily: 'SourceSansPro',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                                : Text("${response[index].title[0].toUpperCase()}${response[index].title.substring(1,25).toLowerCase()}...",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),)
                                            ]
                                        )
                                    )
                                ),

                                // Displaying the price
                                Positioned(
                                  bottom: 65,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      children: [
                                        ClipOval(
                                          child: Container(
                                            color: Colors.blue[800],
                                            padding: EdgeInsets.all(4),
                                            child: Icon(
                                              Icons.attach_money_rounded,
                                              color: Colors.white,
                                              size: 14,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Text(response[index].price,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15
                                          ),)
                                      ],
                                    ),
                                  ),
                                ),

                                // Displaying the date
                                Positioned(
                                  bottom: 35,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      children: [
                                        ClipOval(
                                          child: Container(
                                            color: Colors.orange,
                                            padding: EdgeInsets.all(4),
                                            child: Icon(
                                              Icons.calendar_today_rounded,
                                              color: Colors.white,
                                              size: 14,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Text(response[index].date,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15
                                          ),)
                                      ],
                                    ),
                                  ),
                                ),

                                // Displaying the location
                                Positioned(
                                  bottom: 5,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      children: [
                                        ClipOval(
                                          child: Container(
                                            color: Colors.green,
                                            padding: EdgeInsets.all(4),
                                            child: Icon(
                                              Icons.location_pin,
                                              color: Colors.white,
                                              size: 14,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Text(response[index].location,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15
                                          ),)
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    )

                    // Otherwise, display a message
                        : Text(response != null ? response[0].toString() : "",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w300,
                      ),),
                )
              ],
            ),
          )
      );
    }


  // A function that extracts data from www.reklama5.mk and gives functionality to the search bar
     Future<List> extractData(String search) async {

      list = []; // Creating an empty list of generic type
      print(search); // Checking if the current search is successfully accessed

       if (search.isNotEmpty) {
         // Waiting for http response in case the search is not empty
         final response = await http.Client().get(Uri.parse( // browse the current search
             'https://reklama5.mk/Search?city=&cat=1039&q=${search}&subcat=&sell=0&sell=1&buy=0&trade=0&includeOld=0&includeNew=0&private=0&company=0&page=1&SortByPrice=0&zz=1&pageView='));

         // If the site is accessed successfully, get the html body
         if (response.statusCode == 200) {
           var document = parser.parse(response.body);

           // Scrape the necessary data if there are any results
           try {
             // Scraping the titles of the ads and mapping them to String type
             titles = document
                 .getElementsByClassName('SearchAdTitle')
                 .map((e) => e.text.trim())
                 .toList();
             print(titles);
             print(titles.length);

             // Scraping the links of the ads and filtering only the relevant ones
             hrefs = document
                 .getElementsByTagName('a')
                 .where((e) => e.attributes.containsKey('href'))
                 .map((e) => e.attributes['href'].toString())
                 .where((e) => e.startsWith('/Ad'))
                 .map((e) => 'http://reklama5.mk' + e)
                 .toList();
             print(hrefs);

             // Scraping the prices and arranging the strings to be appropriate
             prices = document
                 .getElementsByClassName('search-ad-price')
                 .map((e) => e.text.replaceAll('\n', '').trim())
                 .toList();
             print(prices);

             // Scraping the locations
             locations = document
                 .getElementsByClassName('city-span')
                 .map((e) => e.text.trim())
                 .toList();
             print(locations);

             // Scraping the dates and arranging the strings to be appropriate
             dates = document
                 .getElementsByClassName('ad-date-div-1 col-lg-2 text-right')
                 .map((e) =>
                 e.text
                     .replaceAll('\n', '')
                     .replaceAll(" ", "")
                     .substring(0, 5)
                     .trim())
                 .map((e) =>
             (e.startsWith(RegExp(r'[0-9]'))) ? e.substring(0, 2) + " " +
                 e.substring(2, 5) : e)
                 .toList();
             print(dates);

             // Scraping the links of the images
             images = document
                 .getElementsByClassName('ad-image')
                 .map((e) => e.attributes['style'].toString())
                 .map((e) => e.substring(36, e.length-1))
                 .map((e) => 'http://' + e)
                 .toList();
             print(images);

             // Populate the list with objects of type Item - resembling an ad on reklama5
             var n = titles.length;
             var i = 0;
             while(n>0){
               list.add(new Item(
                   titles[i].toString(),
                   hrefs[i].toString(),
                   prices[i].toString(),
                   locations[i].toString(),
                   dates[i].toString(),
                   images[i].toString()
               ));
               i+=1;
               n-=1;
             }

             if (titles.length    != 0 &&
                 hrefs.length     != 0 &&
                 prices.length    != 0 &&
                 locations.length != 0 &&
                 dates.length     != 0 &&
                 images.length    != 0) {
               isClicked = true;
             }
             // In case there aren't any results for the current search,
             // the list is consisted of a single string providing a message
             else {
               isClicked = false;
               list.add("No results found");
             }

           }
           catch (e) {
             // In case the web scraping was unsuccessful,
             // the list is consisted of a single string providing a message
             isClicked = false;
             print('Unsuccessful web scraping');
             list.add("No results found");
           }
         }
         return list;
       }
       else {
         // If the search is empty, the function returns a list consisted of a single string providing info
         print("Empty search");
         list.add("Empty search");
         isClicked = false;
         return list;
       }
     }

     // A function that opens the provided url in web browser
     _launchUrl(String url) async {
      if (await canLaunch(url)) {
        await launch(url);
      }
      else {
        throw 'Could not launch $url';
      }
     }

}