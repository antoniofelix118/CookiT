import 'dart:convert';
import 'dart:io';
import 'package:cookit_demo/model/recipeId.dart';
import 'package:cookit_demo/model/globals.dart';

import 'package:http/http.dart' as http;

//final List<String> apiKeys=['1e3d8937a2294ffd9e5730315989629f'];

String getUrlString(List<String> ingredients){
    String request='';
    for(int i=0;i<ingredients.length;i++){
      if(i==(ingredients.length-1)){
        request+=ingredients[i];
      }
      else{
        request+=(ingredients[i]+',+');
      }
    }
    return request;
  }

class RecipeList{
  final List<RecipeId> recipes;
  RecipeList({this.recipes});

  factory RecipeList.fromJSON(List<dynamic> json){
    return RecipeList(recipes:json.map((p) => RecipeId.fromJSON(p)).toList());
  }


  static Future<RecipeList> fetchRecipes(List<String> ingredients) async {
    String url=getUrlString(ingredients);
    final response =
      await http.get('https://api.spoonacular.com/recipes/findByIngredients?ingredients='+url+'&ranking=2&number=8&ignorePantry=true&apiKey='+Globals.getKey());

      if (response.statusCode == 200) {
        // If the call to the server was successful, parse the JSON.
        return RecipeList.fromJSON(json.decode(response.body));
          } else {
            // If that call was not successful, throw an error.
            throw Exception('Failed to load post');
          }
  }
}


