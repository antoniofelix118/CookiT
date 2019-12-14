# CookiT

This is the final project for CST 438: Software Engineering.

Developers:
Julia Werner,
Mireya Leon,
Antonio Felix,
Daichi Kanasugi

## Description 

Are you home and do not know what to cook or too lazy to go buy food? Do not sweat it! CookiT is here to help, CookiT allows you to enter a list of ingredients and give you a recipe or a list of recipes to make! Let's get started!

## Model User

A user is able to login or create an account. A user is able to enter a list of ingredients that are aviable to them. Using a third party API, Recipe - Food - Nutrition by Spponacular, to return recipes that can be created. Once a user is done cooking, they will have the option to upload a picture of their food. The post will then be shown to other users within the community. All post will have a button to 'CookiT' or 'Next Time'. Upon clicking on 'CookiT', the user will be linked into the recipe and they can start to cook! Users also have a user screen where they are able to see all their post and add another post, it they forgot to upload a picture; as well as, deleting post. Within the user screen, a user is able to locate their favorite list and start to cook any favorite recipes without having to look for it again.

All user data is stored in Firebase. Very basic rule to allow users to read and write into the delete database.

Application was developed in Flutter. Coding language: Dart.

## Screenshots of Application

Splash Screen              |  Welcome                  
:-------------------------:|:-------------------------:
<img src="https://github.com/antoniofelix118/CookiT/blob/master/Cookit_Screenshots/Screenshot_20191214-124354.jpg" alt="alt text" width="100" height="200">|<img src="https://github.com/antoniofelix118/CookiT/blob/master/Cookit_Screenshots/Screenshot_20191214-124407.jpg" alt="alt text" width="100" height="200">

Login Page                 | Login Page Error          | Sign Up Page              |  Sign Up Page Error
:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:
<img src="https://github.com/antoniofelix118/CookiT/blob/master/Cookit_Screenshots/Screenshot_20191214-124429.jpg" alt="alt text" width="100" height="200">|<img src="https://github.com/antoniofelix118/CookiT/blob/master/Cookit_Screenshots/Screenshot_20191214-125434.jpg" alt="alt text" width="100" height="200">|<img src="https://github.com/antoniofelix118/CookiT/blob/master/Cookit_Screenshots/Screenshot_20191214-130145.jpg" alt="alt text" width="100" height="200"> | <img src="https://github.com/antoniofelix118/CookiT/blob/master/Cookit_Screenshots/Screenshot_20191214-125440.jpg" alt="alt text" width="100" height="200">

Home Screen                |  User Screen              | Favorites                 |  Bookmarks
:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:
<img src="https://github.com/antoniofelix118/CookiT/blob/master/Cookit_Screenshots/Screenshot_20191214-124611.jpg" alt="alt text" width="100" height="200">  |  <img src="https://github.com/antoniofelix118/CookiT/blob/master/Cookit_Screenshots/Screenshot_20191214-125628.jpg" alt="alt text" width="100" height="200">|<img src="https://github.com/antoniofelix118/CookiT/blob/master/Cookit_Screenshots/Screenshot_20191214-124657.jpg" alt="alt text" width="100" height="200">|<img src="https://github.com/antoniofelix118/CookiT/blob/master/Cookit_Screenshots/Screenshot_20191214-124705.jpg" alt="alt text" width="100" height="200">

Search                     |  Results                  | Details                   | Instructions 
:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:
<img src="https://github.com/antoniofelix118/CookiT/blob/master/Cookit_Screenshots/Screenshot_20191214-124713.jpg" alt="alt text" width="100" height="200">  |  <img src="https://github.com/antoniofelix118/CookiT/blob/master/Cookit_Screenshots/Screenshot_20191214-124722.jpg" alt="alt text" width="100" height="200">|<img src="https://github.com/antoniofelix118/CookiT/blob/master/Cookit_Screenshots/Screenshot_20191214-124727.jpg" alt="alt text" width="100" height="200">|<img src="https://github.com/antoniofelix118/CookiT/blob/master/Cookit_Screenshots/Screenshot_20191214-124733.jpg" alt="alt text" width="100" height="200">

View User                  |  View Post                | Make a Post               | Preview                   | New Post
:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:
<img src="https://github.com/antoniofelix118/CookiT/blob/master/Cookit_Screenshots/Screenshot_20191214-125635.jpg" alt="alt text" width="100" height="200">  |  <img src="https://github.com/antoniofelix118/CookiT/blob/master/Cookit_Screenshots/Screenshot_20191214-125641.jpg" alt="alt text" width="100" height="200">|<img src="https://github.com/antoniofelix118/CookiT/blob/master/Cookit_Screenshots/Screenshot_20191214-124805.jpg" alt="alt text" width="100" height="200">|<img src="https://github.com/antoniofelix118/CookiT/blob/master/Cookit_Screenshots/Screenshot_20191214-124836.jpg" alt="alt text" width="100" height="200"> | <img src="https://github.com/antoniofelix118/CookiT/blob/master/Cookit_Screenshots/Screenshot_20191214-124851.jpg" alt="alt text" width="100" height="200">

Admin Features
>Looking at the home screen, there is a floating action button, upon long pressing that button. The user, if user is an admin, the page updates and is allowed to delete user's post. Once 'manage' setting is on, it can be turned off with another long press, but a single person. The admin is sent over to the admin page where they are able to see all user, post, and recipes that are stored in the database. Admin page is reachable through an admin's user screen, with a floation action button
>>Within that admin page, the admin is able to view and/or delete users or grant/remove admin roles to users. The admin is also able to delete post. While recipes, the admin is only able to see them. Recipes are stored in our database to lower calls that are made into the api. An admin is also able to delete or grant/remove admin role while visiting another user's profile.

Manage Mode                 |  View Post                | Make a Post               | Preview                   | New Post
:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:
<img src="https://github.com/antoniofelix118/CookiT/blob/master/Cookit_Screenshots/Screenshot_20191214-134938.jpg" alt="alt text" width="100" height="200">  |  <img src="https://github.com/antoniofelix118/CookiT/blob/master/Cookit_Screenshots/Screenshot_20191214-125641.jpg" alt="alt text" width="100" height="200">|<img src="https://github.com/antoniofelix118/CookiT/blob/master/Cookit_Screenshots/Screenshot_20191214-124805.jpg" alt="alt text" width="100" height="200">|<img src="https://github.com/antoniofelix118/CookiT/blob/master/Cookit_Screenshots/Screenshot_20191214-124836.jpg" alt="alt text" width="100" height="200"> | <img src="https://github.com/antoniofelix118/CookiT/blob/master/Cookit_Screenshots/Screenshot_20191214-124851.jpg" alt="alt text" width="100" height="200">


## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
