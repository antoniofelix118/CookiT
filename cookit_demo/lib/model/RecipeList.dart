import 'dart:convert';
import 'dart:io';
import 'package:cookit_demo/model/recipeId.dart';

import 'package:http/http.dart' as http;

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
      await http.get('https://api.spoonacular.com/recipes/findByIngredients?ingredients='+url+'&number=2&apiKey=ae9713972653426aa7db8cdf12f00d85');

      if (response.statusCode == 200) {
        // If the call to the server was successful, parse the JSON.
        return RecipeList.fromJSON(json.decode(response.body));
          } else {
            // If that call was not successful, throw an error.
            throw Exception('Failed to load post');
          }
  }
}



