import 'package:dog_breed_recognition/dog_searcher.dart';
import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  TextEditingController controller = TextEditingController();
  late final SearchScreen searchScreen;

  SearchBar({Key? key, required this.searchScreen}) : super(key : key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue[800]!.withOpacity(0.9),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Container(
                width: 250,
                child: TextFormField(
                  controller: controller,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.black12,
                    hintText: 'Search..',
                    hintStyle: TextStyle(
                      color: Colors.white38
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
              ),
          ),
          MaterialButton(
            child: Text('Search', style: TextStyle(color: Colors.white),),
            onPressed: (){
                //searchScreen.state.setState(() {
                //searchScreen.state.searched = true;
                //searchScreen.state.search = controller.text;
              //});
            },

          )
        ],
      ),
    );
  }

}