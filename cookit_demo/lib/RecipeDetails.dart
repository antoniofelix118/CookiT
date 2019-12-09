import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookit_demo/RecipeInstructions.dart';
import 'package:cookit_demo/model/Recipe.dart';
import 'package:cookit_demo/model/recipeId.dart';
import 'package:cookit_demo/service/UserOperations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(MaterialApp(
    title: 'CookiT Recipe Results',
    //home: RecipeDetails(recipe:632660),
    home:RecipeDetails(recipe:null),
  ));
}

Widget buildError(BuildContext context, FlutterErrorDetails error) {
   return Scaffold(
     body: Center(
       child: Text(
         "Error appeared.",
         style: Theme.of(context).textTheme.title,
       ),
     )
   );
 }

class RecipeDetails extends StatefulWidget {
  final Recipe recipe;
  final RecipeId recipeId;
  RecipeDetails({Key key,@required this.recipe,@required this.recipeId}):super(key:key);


  @override
  _RecipeDetails createState() => _RecipeDetails();
}
class _RecipeDetails extends State<RecipeDetails>{
  Recipe recipe;
  FirebaseUser currentUser;
  String username;
  DocumentReference userRef;
  String currEmail;
  String userId;
  bool saved = false;
  bool favorite = false;


  @override
  void initState(){
    super.initState();
    recipe = widget.recipe;
    getUserRef();
  }

  Future<List<String>> getFavorites() async {
    DocumentSnapshot querySnapshot = await Firestore.instance
        .collection('users')
        .document(userId)
        .get();
    if (querySnapshot.exists &&
        querySnapshot.data.containsKey('favorites') &&
        querySnapshot.data['favorites'] is List) {
      // Create a new List<String> from List<dynamic>
      return List<String>.from(querySnapshot.data['favorites']);
    }
    return [];
  }


  Future<void> getUserRef() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final Firestore _firestore = Firestore.instance;

    FirebaseUser user = await _auth.currentUser();
    List<String> favorites = await getFavorites();

    setState((){
      userRef = _firestore.collection('users').document(user.uid);
      userId = user.uid;

      String recipeId = widget.recipeId.rid.toString();
      //log(recipeId);

      for(var i = 0; i < favorites.length; i++){
        log(favorites[i]);
      }

      /*userRef.get().then((data) {
        if (data.exists) {
          profileImage = data.data['profileImage'].toString();



        }
      });*/


      //print(user.displayName.toString());
    });
  }


  @override
  Widget build(BuildContext context){
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          builder: (BuildContext context, Widget widget) {
          ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
            return buildError(context, errorDetails);
          };
          return widget;
        },
          home: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.lightGreen,
              automaticallyImplyLeading: true,
              title: Text('CookiT'),
              leading: IconButton(icon:Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context, false),
              ),
              actions: <Widget>[

              ],
            ),
            backgroundColor: Colors.white,
            body: Center(
              child: /*FutureBuilder<Recipe>(
              future: recipe,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return */
                   Container(
                    child: Padding(
                      padding: const EdgeInsets.all(36.0),
                      child: ListView(
                        children: <Widget>[
                          SizedBox(height: 5.0,),
                          new Container(
                            height:150.0,
                            width:600.0,
                            child:Image.network(
                              recipe.imageURL,
                              fit: BoxFit.fill,),
                          ),
                          new Container(
                            height: 120.0,
                            child:ListView(
                              scrollDirection: Axis.horizontal,
                              children: <Widget>[
                                Container(
                                  width:160.0,
                                  child:ListView(
                                    children: <Widget>[
                                          new Text(
                                            recipe.name,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20.0,
                                              color: Colors.black,)
                                          ),
                                          new Text(
                                            recipe.description,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15.0,
                                              color: Colors.grey,)
                                          ),
                                        ]
                                  ),
                                ),
                                Container(
                                  width:160.0,
                                  child:Padding(
                                    padding:EdgeInsets.fromLTRB(30.0, 40.0, 35.0, 45.0),
                                    child:Material(
                                      elevation: 5.0,
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Colors.lightGreen,
                                      child:MaterialButton(
                                        minWidth: MediaQuery.of(context).size.width,
                                        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                                        onPressed: (){
                                          UserOperations.addToSave(userId, widget.recipeId.rid.toString());
                                        },
                                        child: Text("Save",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ]
                            ),
                          ),
                          new Container(
                            height: 80.0,
                            child:ListView(
                              scrollDirection: Axis.horizontal,
                              children: <Widget>[
                                  Container(
                                  width:120.0,
                                  child:ListView(
                                        children: <Widget>[
                                          new Text(
                                            recipe.ingredients.length.toString(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20.0,
                                              color: Colors.black,)
                                          ),
                                          new Text(
                                            "Ingredients",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20.0,
                                              color: Colors.black,)
                                          ),
                                        ]
                                      ),
                                  ),
                                  Container(
                                  width:80.0,
                                  child:ListView(
                                        children: <Widget>[
                                          new Text(
                                            recipe.prepTime.toString(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20.0,
                                              color: Colors.black,)
                                          ),
                                          new Text(
                                            "Minutes",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20.0,
                                              color: Colors.black,)
                                          ),
                                        ]
                                      ),
                                  ),
                                  Container(
                                  width:100.0,
                                  child:ListView(
                                        children: <Widget>[
                                          new Text(
                                            recipe.numCalories.toString(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20.0,
                                              color: Colors.black,)
                                          ),
                                          new Text(
                                            "Calories",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20.0,
                                              color: Colors.black,)
                                          ),
                                        ]
                                      ),
                                ),
                              ]
                            ),
                          ),
                          new Container(
                            height: 40.0,
                            child:Padding(
                              padding:EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                              child:Material(
                                elevation: 5.0,
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.lightGreen,
                                child:MaterialButton(
                                  minWidth: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                                  onPressed: (){
                                   Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => RecipeInstructions(recipe:recipe))
                                    );
                                  },
                                  child: Text("Start Recipe",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
               /* } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                // By default, show a loading spinner.
                return CircularProgressIndicator();
              },
              ),*/
            ),
            ),
          );
  }

  Widget showStar(){
    if(favorite){
      return IconButton(
        icon: Icon(Icons.favorite_border,
        color: Colors.red,
        size: 40),
        onPressed: (){
          UserOperations.addToFavorites(userId, widget.recipeId.rid.toString());
        },
      );
    } else{
      return IconButton(
        icon: Icon(Icons.favorite,
            color: Colors.red,
            size: 40),
        onPressed: (){
          UserOperations.deleteFavorite(userId, widget.recipeId.rid.toString());
        },
      );
    }
  }

}