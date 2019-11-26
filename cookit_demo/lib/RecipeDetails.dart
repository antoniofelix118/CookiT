import 'package:cookit_demo/RecipeInstructions.dart';
import 'package:cookit_demo/model/Recipe.dart';
import 'package:cookit_demo/model/recipeId.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(MaterialApp(
    title: 'CookiT Recipe Results',
    home: RecipeDetails(recipeId:632660),
  ));
}

class RecipeDetails extends StatefulWidget {
  final int recipeId;
  RecipeDetails({Key key,@required this.recipeId}):super(key:key);

  @override
  _RecipeDetails createState() => _RecipeDetails();
}
class _RecipeDetails extends State<RecipeDetails>{
  Future<Recipe> recipe;

  @override
  void initState(){
    super.initState();
    recipe = Recipe.fetchRecipe(widget.recipeId);
  }

  @override
  Widget build(BuildContext context){
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.lightGreen,
              automaticallyImplyLeading: true,
              title: Text('CookiT'),
              leading: IconButton(icon:Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context, false),
              ),
            ),
            backgroundColor: Colors.white,
            body: Center(
              child: FutureBuilder<Recipe>(
              future: recipe,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return 
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
                              snapshot.data.imageURL,
                              fit: BoxFit.fill,),
                          ),
                          new Container(
                            height: 80.0,
                            child:ListView(
                              scrollDirection: Axis.horizontal,
                              children: <Widget>[
                                Container(
                                  width:160.0,
                                  child:ListView(
                                    children: <Widget>[
                                          new Text(
                                            snapshot.data.name,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20.0,
                                              color: Colors.black,)
                                          ),
                                          new Text(
                                            snapshot.data.description,
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
                                    padding:EdgeInsets.fromLTRB(30.0, 20.0, 35.0, 25.0),
                                    child:Material(
                                      elevation: 5.0,
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Colors.lightGreen,
                                      child:MaterialButton(
                                        minWidth: MediaQuery.of(context).size.width,
                                        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                                        onPressed: (){},
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
                                            snapshot.data.ingredients.length.toString(),
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
                                            snapshot.data.prepTime.toString(),
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
                                            snapshot.data.numCalories.toString(),
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
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                // By default, show a loading spinner.
                return CircularProgressIndicator();
              },
              ),
            ),
            ),
          );
  }

}