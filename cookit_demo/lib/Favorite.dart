//Daichi Kanasugi
//favorite.dart
//This file allows people to search through their favorite.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookit_demo/RecipeInstructions.dart';
import 'package:cookit_demo/model/Recipe.dart';
import 'package:cookit_demo/service/UserOperations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

//Global Variable for List.

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SearchAppBarRecipe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Favorites(title: 'SearchAppBarRecipe'),
    );
  }
}

class Favorites extends StatefulWidget {
  Favorites({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _Favorites createState() => _Favorites();
}

class _Favorites extends State<Favorites> {
  _SearchAppBarDelegate _searchDelegate;
  FirebaseUser currentUser;

  bool loading = false;
  DocumentReference userRef;
  String profileImage;
  String userId;
  List<String> favorites;
  List<Recipe> recipes = [];
  List<String> favNames;
  List<String> favs = [];
  String searchText = "";
  bool isSearching;
  List recipeResults = new List();

  List<String> filterRecipes;
  TextEditingController editingController = TextEditingController();
  var items = List<String>();
  TextEditingController filterController = new TextEditingController();

  Widget appBarTitle = new Text(
    "Favorites",
    style: TextStyle(color: Colors.lightGreen),
  );
  Icon currIcon = Icon(Icons.search);

  Widget getAppTitle() {
    return appBarTitle;
  }

  @override
  void initState() {
    super.initState();
    //Initializing search delegate with sorted list of recipes
    isSearching = false;
    loadCurrentUser();
    getUserRef();
  }

  void getFavs() {
    print(favs);
  }

  void loadCurrentUser() {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      setState(() {
        this.currentUser = user;
      });
    });
  }

  Future<void> getUserRef() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final Firestore _firestore = Firestore.instance;

    FirebaseUser user = await _auth.currentUser();

    //_searchDelegate = _SearchAppBarDelegate(favorites);

    setState(() {
      userRef = _firestore.collection('users').document(user.uid);
      userId = user.uid;
      List<String> temp = [];
      userRef.get().then((data) {
        if (data.exists) {
          profileImage = data.data['profileImage'].toString();
          temp = List.from(data.data['favorites']);
          for (var i = 0; i < temp.length; i++) {
            favs.add(temp[i]);
            //print(temp[i].toString());
          }
        }
      });

      //print(user.displayName.toString());
    });
  }

  @override
  void dispose() {
    filterController.dispose();
    super.dispose();
  }

  Future<List<Recipe>> getRecipeDetails(List<String> temp) async {
    List<Recipe> recipeDetails = [];
    Recipe recipe;
    String rec_id, rec_name, rec_description, rec_imageURL;
    double rec_numCal;
    int rec_prepTime, rec_servings;
    List<String> rec_ingredients;
    List<String> rec_instructions;

    for (var i in temp) {
      DocumentSnapshot snapshot =
          await Firestore.instance.collection('recipes').document(i).get();
      if (snapshot.exists) {
        rec_id = snapshot.data['id'].toString();
        rec_name = snapshot.data['name'].toString();
        rec_description = snapshot.data['description'].toString();
        rec_imageURL = snapshot.data['imageURL'].toString();
        rec_numCal = snapshot.data['numCalories'];
        rec_prepTime = snapshot.data['prepTime'];
        rec_servings = snapshot.data['servings'];
        rec_ingredients = List<String>.from(snapshot.data['ingredients']);
        rec_instructions = List<String>.from(snapshot.data['instructions']);
        recipe = new Recipe(
            id: rec_id,
            name: rec_name,
            description: rec_description,
            imageURL: rec_imageURL,
            numCalories: rec_numCal,
            prepTime: rec_prepTime,
            servings: rec_servings,
            ingredients: rec_ingredients,
            instructions: rec_instructions);
        recipeDetails.add(recipe);
      }
    }

    return recipeDetails;
  }

  Future<List<Recipe>> getFavorites() async {
    List<Recipe> temp = [];
    List<Recipe> results = [];
    List<String> names = [];
    var snap =
        await Firestore.instance.collection('users').document(userId).get();

    temp = List.from(snap.data['favorites']);

    for (var i in temp) {
      DocumentSnapshot snapItem = await Firestore.instance
          .collection('recipes')
          .document(i.toString())
          .get();
      results.add(Recipe.fromDoc(snapItem));
    }
    return results;
  }

  List<Widget> displayFavorites(AsyncSnapshot snapshot) {
    return snapshot.data.documents.map<Widget>((document) {
      if (document['name'].toString() != "") {
        return Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 1),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Card(
                clipBehavior: Clip.antiAlias,
                // shape: shape,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 5.0),
                  child: Column(children: <Widget>[
                    Center(
                      child: ClipRect(
                        child: document['imageURL'].toString() != ""
                            ? Image.network(
                                document['imageURL'],
                                height: 200,
                                width: MediaQuery.of(context).size.width,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                padding: EdgeInsets.only(top: 0.0, bottom: 0.0),
                                margin:
                                    const EdgeInsets.only(top: 0, bottom: 0.0),
                                height: 200,
                                width: MediaQuery.of(context).size.width,
                                color: Colors.blueGrey[100],
                              ),
                      ),
                    ),
                    Divider(),
                    Divider(),
                    ListTile(
                      leading: Text(
                        document['name'].toString(),
                      ),
                    ),
                  ]),
                ),
              ),
            ));
      } else {
        return new Container();
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    void userQuery(String query) {
      setState(() {
        filterRecipes = favs
            .where(
                (string) => string.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }

    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.white,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.lightGreen,
                size: 24.0,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: appBarTitle,
          actions: <Widget>[
            IconButton(
              onPressed: () {
                //SizedBox(height: 10),
                setState(() {
                  if (this.currIcon.icon == Icons.search) {
                    this.currIcon = Icon(Icons.cancel);
                    this.appBarTitle = Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: filterController,
                        decoration:
                            InputDecoration(hintText: 'Search your favs...'),
                        onChanged: userQuery,
                      ),
                    );
                  } else {
                    this.currIcon = Icon(Icons.search);
                    this.appBarTitle = Text("Favorites",
                        style: TextStyle(color: Colors.lightGreen));
                  }
                });
              },
              icon: currIcon,
            )

            //Adding the search widget in AppBar
          ],
          centerTitle: true,
        ),
        body: Column(children: <Widget>[
          Expanded(
            child: StreamBuilder(
                stream: Firestore.instance
                    .collection('users')
                    .document(userId)
                    .snapshots(),
                builder: (context, snapshot) {
                  print(snapshot);
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Center(child: CircularProgressIndicator());
                    default:
                      List favsList = snapshot.data['favorites'];
                      if (!snapshot.hasData) {
                        return Container(
                          alignment: FractionalOffset.center,
                          padding: const EdgeInsets.only(top: 10.0),
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Container(
                            alignment: FractionalOffset.center,
                            padding: const EdgeInsets.only(top: 1.0),
                            child: Text(
                              'No Favorite Recipes!',
                              style: TextStyle(
                                color: Colors.lightGreen,
                                fontSize: 20,
                              ),
                            ));
                      } else if (snapshot.data['favorites'] == null ||
                          snapshot.data['favorites'].length == 0) {
                        return Container(
                            alignment: FractionalOffset.center,
                            padding: const EdgeInsets.only(top: 1.0),
                            child: Text(
                              'No Favorite Recipes!',
                              style: TextStyle(
                                color: Colors.lightGreen,
                                fontSize: 20,
                              ),
                            ));
                      } else {
                        return new ListView(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: List.generate(
                              snapshot.data['favorites'].length, (index) {
                            //print(snapshot.data['favorites'][index]);
                            List temp3 = [];

                            if (temp3 != null &&
                                !temp3.contains(snapshot.data['favorites']
                                        [index]
                                    .toString())) {
                              temp3.add(
                                  snapshot.data['favorites'][index].toString());
                            }
                            print(temp3);

                            return StreamBuilder(
                                stream: Firestore.instance
                                    .collection('recipes')
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  print(snapshot);
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.waiting:
                                      return Center(
                                          child: CircularProgressIndicator());
                                    default:
                                      // List videosList = snapshot.data;
                                      return ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemCount:
                                            snapshot.data.documents.length,
                                        itemBuilder: (context, recipeId) {
                                          DocumentSnapshot recipe =
                                              snapshot.data.documents[recipeId];
                                          if (filterRecipes != null &&
                                              filterRecipes.length != 0) {
                                            if (temp3
                                                .contains(recipe.documentID)) {
                                              //if(favs.contains(searchText)){
                                              if (filterRecipes.contains(
                                                  recipe.data["name"])) {
                                                return Container(
                                                  height: 250,
                                                  padding: EdgeInsets.only(
                                                      top: 0.0, bottom: 0.0),
                                                  child: Card(
                                                    clipBehavior:
                                                        Clip.antiAlias,
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              0.0,
                                                              0.0,
                                                              0.0,
                                                              0.0),
                                                      child: Column(
                                                          children: <Widget>[
                                                            Center(
                                                              child: Padding(
                                                                padding: EdgeInsets
                                                                    .fromLTRB(
                                                                        0.0,
                                                                        0.0,
                                                                        0.0,
                                                                        0.0),
                                                                child: ClipRect(
                                                                  child: recipe.data['imageURL']
                                                                              .toString() !=
                                                                          ""
                                                                      ? Image
                                                                          .network(
                                                                          recipe
                                                                              .data['imageURL'],
                                                                          height:
                                                                              132,
                                                                          width: MediaQuery.of(context)
                                                                              .size
                                                                              .width,
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        )
                                                                      : Container(
                                                                          padding: EdgeInsets.only(
                                                                              top: 0.0,
                                                                              bottom: 0.0),
                                                                          margin: const EdgeInsets.only(
                                                                              top: 0,
                                                                              bottom: 0.0),
                                                                          height:
                                                                              132,
                                                                          width: MediaQuery.of(context)
                                                                              .size
                                                                              .width,
                                                                          color:
                                                                              Colors.blueGrey[100],
                                                                        ),
                                                                ),
                                                              ),
                                                            ),
                                                            ListTile(
                                                              leading: Text(
                                                                recipe.data[
                                                                        'name']
                                                                    .toString(),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 0.0,
                                                                      bottom:
                                                                          0.0),
                                                              child: Row(
                                                                // align left
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .end,
                                                                textDirection:
                                                                    TextDirection
                                                                        .rtl,

                                                                children: <
                                                                    Widget>[
                                                                  IconButton(
                                                                    icon: Icon(
                                                                      Icons
                                                                          .remove_circle_outline,
                                                                      color: Colors
                                                                              .redAccent[
                                                                          200],
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      UserOperations.deleteFavorite(
                                                                          userId,
                                                                          recipe
                                                                              .documentID);
                                                                    },
                                                                  ),
                                                                  FlatButton(
                                                                    //color: Colors.lightBlueAccent,
                                                                    child: const Text(
                                                                        'Start'),
                                                                    //shape: new RoundedRectangleBorder(
                                                                    //borderRadius: new BorderRadius.circular(30.0)),
                                                                    textColor:
                                                                        Colors
                                                                            .blue,
                                                                    onPressed:
                                                                        () {
                                                                      Recipe
                                                                          selectRecipe =
                                                                          Recipe.fromDoc(
                                                                              recipe);
                                                                      Navigator
                                                                          .push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                RecipeInstructions(
                                                                                  recipe: selectRecipe,
                                                                                  rId: selectRecipe,
                                                                                )),
                                                                      );
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ]),
                                                    ),
                                                  ),
                                                );
                                              }
                                            }
                                          } else if (temp3
                                              .contains(recipe.documentID)) {
                                            // setState(() {
                                            if (!favs.contains(
                                                recipe.data["name"])) {
                                              favs.add(recipe.data["name"]);
                                            }
                                            // });

                                            return Container(
                                              height: 250,
                                              padding: EdgeInsets.only(
                                                  top: 0.0, bottom: 0.0),
                                              child: Card(
                                                clipBehavior: Clip.antiAlias,
                                                child: Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0.0, 0.0, 0.0, 0.0),
                                                  child:
                                                      Column(children: <Widget>[
                                                    Center(
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                0.0,
                                                                0.0,
                                                                0.0,
                                                                0.0),
                                                        child: ClipRect(
                                                          child: recipe.data[
                                                                          'imageURL']
                                                                      .toString() !=
                                                                  ""
                                                              ? Image.network(
                                                                  recipe.data[
                                                                      'imageURL'],
                                                                  height: 132,
                                                                  width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                )
                                                              : Container(
                                                                  padding: EdgeInsets.only(
                                                                      top: 0.0,
                                                                      bottom:
                                                                          0.0),
                                                                  margin: const EdgeInsets
                                                                          .only(
                                                                      top: 0,
                                                                      bottom:
                                                                          0.0),
                                                                  height: 132,
                                                                  width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                                  color: Colors
                                                                          .blueGrey[
                                                                      100],
                                                                ),
                                                        ),
                                                      ),
                                                    ),
                                                    ListTile(
                                                      leading: Text(
                                                        recipe.data['name']
                                                            .toString(),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 0.0,
                                                          bottom: 0.0),
                                                      child: Row(
                                                        // align left
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        textDirection:
                                                            TextDirection.rtl,

                                                        children: <Widget>[
                                                          IconButton(
                                                            icon: Icon(
                                                              Icons
                                                                  .remove_circle_outline,
                                                              color: Colors
                                                                      .redAccent[
                                                                  200],
                                                            ),
                                                            onPressed: () {
                                                              UserOperations
                                                                  .deleteFavorite(
                                                                      userId,
                                                                      recipe
                                                                          .documentID);
                                                            },
                                                          ),
                                                          FlatButton(
                                                            //color: Colors.lightBlueAccent,
                                                            child: const Text(
                                                                'Start'),
                                                            //shape: new RoundedRectangleBorder(
                                                            //borderRadius: new BorderRadius.circular(30.0)),
                                                            textColor:
                                                                Colors.blue,
                                                            onPressed: () {
                                                              Recipe
                                                                  selectRecipe =
                                                                  Recipe.fromDoc(
                                                                      recipe);
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            RecipeInstructions(
                                                                              recipe: selectRecipe,
                                                                              rId: selectRecipe,
                                                                            )),
                                                              );
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ]),
                                                ),
                                              ),
                                            );
                                          }
                                          return Container(
                                            padding: EdgeInsets.only(
                                                top: 0.0, bottom: 0.0),
                                          );
                                        },
                                      );
                                  }
                                });
                          }),
                        );
                      }
                  }
                }),
          ),
        ]),
      ),
    );
  }

  //Shows Search result
  void showSearchPage(
      BuildContext context, _SearchAppBarDelegate searchDelegate) async {
    final String selected = await showSearch<String>(
      context: context,
      delegate: searchDelegate,
    );

    if (selected != null) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Your Word Choice: $selected'),
        ),
      );
    }
  }
}

//Search delegate
class _SearchAppBarDelegate extends SearchDelegate<String> {
  final List<String> _words;
  final List<String> _history;

  _SearchAppBarDelegate(List<String> words)
      : _words = words,
        //pre-populated history of words
        _history = <String>['apple', 'orange', 'banana', 'watermelon'],
        super();

  // Setting leading icon for the search bar.
  //Clicking on back arrow will take control to main page
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        //Take control back to previous page
        this.close(context, null);
      },
    );
  }

  // Builds page to populate search results.
  @override
  Widget buildResults(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('===Your Word Choice==='),
            GestureDetector(
              onTap: () {
                //Define your action when clicking on result item.
                //In this example, it simply closes the page
                this.close(context, this.query);
              },
              child: Text(
                this.query,
                style: Theme.of(context)
                    .textTheme
                    .display2
                    .copyWith(fontWeight: FontWeight.normal),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Suggestions list while typing search query - this.query.
  @override
  Widget buildSuggestions(BuildContext context) {
    final Iterable<String> suggestions = this.query.isEmpty
        ? _history
        : _words.where((word) => word.startsWith(query));

    return _WordSuggestionList(
      query: this.query,
      suggestions: suggestions.toList(),
      onSelected: (String suggestion) {
        this.query = suggestion;
        this._history.insert(0, suggestion);
        showResults(context);
      },
    );
  }

  // Action buttons at the right of search bar.
  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      query.isNotEmpty
          ? IconButton(
              tooltip: 'Clear',
              icon: const Icon(Icons.clear),
              onPressed: () {
                query = '';
                showSuggestions(context);
              },
            )
          : IconButton(
              icon: const Icon(Icons.mic),
              tooltip: 'Voice input',
              onPressed: () {
                this.query = 'TBW: Get input from voice';
              },
            ),
    ];
  }
}

// Suggestions list widget displayed in the search page.
class _WordSuggestionList extends StatelessWidget {
  const _WordSuggestionList({this.suggestions, this.query, this.onSelected});

  final List<String> suggestions;
  final String query;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme.subhead;
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (BuildContext context, int i) {
        final String suggestion = suggestions[i];
        return ListTile(
          leading: query.isEmpty ? Icon(Icons.history) : Icon(null),
          // Highlight the substring that matched the query.
          title: RichText(
            text: TextSpan(
              text: suggestion.substring(0, query.length),
              style: textTheme.copyWith(fontWeight: FontWeight.bold),
              children: <TextSpan>[
                TextSpan(
                  text: suggestion.substring(query.length),
                  style: textTheme,
                ),
              ],
            ),
          ),
          onTap: () {
            onSelected(suggestion);
          },
        );
      },
    );
  }
}
