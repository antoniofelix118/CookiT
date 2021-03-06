import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookit_demo/AdminPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cookit_demo/UserScreen.dart';
import 'package:cookit_demo/RecipeDetails.dart';
import 'package:cookit_demo/RecipeSearch.dart';
import 'package:cookit_demo/ViewUser.dart';
import 'package:cookit_demo/model/PostModel.dart';
import 'package:cookit_demo/model/Recipe.dart';
import 'package:cookit_demo/service/AdminOperations.dart';
import 'package:cookit_demo/service/Authentication.dart';
import 'package:cookit_demo/service/UserOperations.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  Home({Key key, this.auth, this.userId, this.logoutCallback, this.role})
      : super(key: key);

  final BaseAuth auth;
  final String userId;
  final VoidCallback logoutCallback;
  final String role;

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  List<Post> postsFeed = [];
  FirebaseUser currentUser;
  DocumentReference userRef;
  var role;
  var userQuery;
  bool isAdmin = false;
  String username;
  String userId;
  String profilePic = " ";
  bool manage = false;
  String userImage, user_name;

  @override
  void initState() {
    super.initState();
    print(getPosts());
    getUserRef();
  }

  Future<void> getUserRef() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final Firestore _firestore = Firestore.instance;

    FirebaseUser user = await _auth.currentUser();

    setState(() {
      userRef = _firestore.collection('users').document(user.uid);
      userId = user.uid;
      userRef.get().then((data) {
        if (data.exists) {
          role = data.data['role'].toString();
          username = data.data['user_name'].toString();
          profilePic = data.data['profileImage'].toString();
          log("profilePic " + profilePic);
          print('Role: ' + role);
          if (role == 'admin') {
            isAdmin = true;
          }
        }
      });
    });
    return;
  }

  String getuserId() {
    return userId;
  }

  Future<List<String>> getPosts() async {
    List<String> temp = [];
    final QuerySnapshot result =
        await Firestore.instance.collection('posts').getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    //documents.forEach((data) => temp.add(data.documentID));
    for (var doc in documents) {
      temp.add(doc.toString());
    }
    return temp.reversed;
  }

  Widget showDelete(
      BuildContext context, String postId, String role, String url) {
    return IconButton(
        icon: Icon(
          Icons.remove_circle_outline,
          color: Colors.redAccent,
          size: 30.0,
        ),
        onPressed: () {
          showAlert(context, postId, role, url);
        });
  }

  Future<void> showAlert(BuildContext context, postId, role, url) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Are you sure you want to delete this post? '),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Text('Yes'),
                    onTap: () {
                      removeImage(url);
                      AdminOperations.deletePost(postId);
                      Navigator.pop(context);
                    },
                  ),
                  Padding(padding: EdgeInsets.all(8.0)),
                  GestureDetector(
                    child: Text('No'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  Padding(padding: EdgeInsets.all(8.0)),
                  GestureDetector(
                    child: Text('Cancel',
                        style: TextStyle(
                          color: Colors.redAccent,
                        )),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  Future<void> removeImage(String url) async {
    try {
      print(url);
      String path = url.replaceAll(new RegExp(r'%2F'), '---');
      String remove = path.split('---')[1].replaceAll('?alt', '---');
      String img = remove.split('---')[0];
      print(img);
      final StorageReference storageReference =
          FirebaseStorage.instance.ref().child("UserRecipes/" + img);
      storageReference.delete();
    } catch (e) {
      return null;
    }
  }

  Widget buildPostsAvatar(String profilePic) {
    return new GestureDetector(
        child: Container(
          width: (MediaQuery.of(context).size.width / 3),
          height: 180.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white30),
          ),
          margin: const EdgeInsets.only(top: 32.0, left: 16.0),
          padding: const EdgeInsets.all(3.0),
          child: ClipOval(
            child: (profilePic == null || profilePic.toString() == "")
                ? Image.network(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTbEs2FYUCNh9EJ1Hl_agLEB6oMYniTBhZqFBMoJN2yCC1Ix0Hi&s',
                  )
                : Image.network(
                    profilePic,
                    height: 300,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        onTap: () {});
  }

  List<Widget> displayPosts(AsyncSnapshot snapshot) {
    return snapshot.data.documents.map<Widget>((document) {
      //userImage = getUserInfo(document['userId'], 'profileImage').toString();
      //print(getUserInfo(document['userId'], 'profileImage').toString());
      //user_name = getUserInfo(document['userId'], 'username').toString();
      //print('getUserInfo userImage: ' + userImage);
      //print('getUserInfo user_name: ' + user_name);
      return Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 1),
          child: Container(
              width: MediaQuery.of(context).size.width,
              child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  //color: Colors.grey[200],
                  clipBehavior: Clip.antiAlias,
                  child: Column(children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0),
                      child: ListTile(
                        leading: SizedBox(
                          child: IconButton(
                            iconSize: 50,
                            //icon: userImage != null ? CircleAvatar(radius: 20.0, backgroundImage: NetworkImage(userImage)):
                            icon: document['profileImage'] != ""
                                ? CircleAvatar(
                                    radius: 20.0,
                                    backgroundImage:
                                        NetworkImage(document['profileImage']))
                                : CircleAvatar(
                                    radius: 20.0,
                                    backgroundImage: NetworkImage(
                                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTbEs2FYUCNh9EJ1Hl_agLEB6oMYniTBhZqFBMoJN2yCC1Ix0Hi&s')),
                            onPressed: () {
                              if (userId != document['userId']) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ViewUser(
                                          userId: userId.toString(),
                                          otherId:
                                              document['userId'].toString())),
                                );
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UserProfile(
                                              userId: widget.userId,
                                              auth: widget.auth,
                                            )));
                              }
                            },
                          ),
                        ),
                        contentPadding: EdgeInsets.all(7),
                        title: GestureDetector(
                          child: Text(
                            //getUsername(document['email']).toString() == null ? document['email'].toString() : getUsername(document['email']).toString(),
                            document['user_name'] == null
                                ? document['email']
                                : document['user_name'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onTap: () {
                            if (userId != document['userId']) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ViewUser(
                                        userId: userId.toString(),
                                        otherId:
                                            document['userId'].toString())),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UserProfile(
                                          userId: widget.userId,
                                          auth: widget.auth,
                                        )),
                              );
                            }
                          },
                        ),
                        trailing: Padding(
                          padding: EdgeInsets.fromLTRB(0.0, 0.0, 30.0, 5.0),
                          child: Text(
                            document['title'],
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: ClipRect(
                        child: Image.network(document['imageUrl'],
                            height: 300,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
                      child: ListTile(
                        title: Text(document['description'],
                            style: TextStyle(fontWeight: FontWeight.w500)),
                      ),
                    ),
                    ButtonBar(
                      alignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        FlatButton(
                          child: Text('Cook it'),
                          textColor: Colors.orange,
                          onPressed: () {
                            print("cooki it:::");
                            print(document['recipeId'].toString());
                            Firestore.instance
                                .collection('recipes')
                                .document(document['recipeId'].toString())
                                .get()
                                .then((data) {
                              //print(data.documentID);
                              Recipe postRecipe = Recipe.fromDoc(data);
                              print(postRecipe.id);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RecipeDetails(
                                      recipe: postRecipe,
                                      recid: postRecipe,
                                    ),
                                  ));
                            });
                          },
                        ),
                        FlatButton(
                          child: Text('Next time'),
                          textColor: Colors.lightBlue,
                          onPressed: () {
                            UserOperations.addToSave(userId,
                                Post.fromDoc(document).recipeId.toString());
                          },
                        ),
                        Visibility(
                          child: showDelete(
                              context,
                              Post.fromDoc(document).id.toString(),
                              role.toString(),
                              Post.fromDoc(document).imageUrl),
                          visible: manage,
                        ),
                        Visibility(
                          child: SizedBox(
                            width: 42,
                          ),
                          visible: !manage,
                        ),
                      ],
                    ),
                  ]))));
    }).toList();
  }

  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
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
            title: Text(
              "CookiT",
              style: TextStyle(color: Colors.lightGreen),
            ),
            centerTitle: true,
            leading: new IconButton(
              icon: profilePic != " "
                  ? CircleAvatar(
                      radius: 15.0,
                      backgroundImage: NetworkImage(profilePic),
                      backgroundColor: Colors.grey[300],
                    )
                  : Icon(Icons.account_circle,
                      color: Colors.grey[300], size: 30.0),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UserProfile(
                            userId: widget.userId,
                            auth: widget.auth,
                          )),
                );
              },
            ),
            actions: <Widget>[
              new FlatButton(
                  onPressed: signOut,
                  child: new Text('Logout',
                      style: new TextStyle(
                        fontSize: 17.0,
                        color: Colors.lightGreen,
                      ))),
            ],
          ),
          body: Container(
            child: StreamBuilder(
              stream: Firestore.instance
                  .collection('posts')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                  default:
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      children: displayPosts(snapshot),
                    );
                }
              },
            ),
          ),
          floatingActionButton: InkWell(
            splashColor: Colors.lightBlueAccent,
            onLongPress: () {
              isAdmin
                  ? setState(() {
                      manage = !manage;
                    })
                  : Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => new RecipeSearch()));
            },
            child: FloatingActionButton(
              backgroundColor: Colors.lightGreen,
              child: manage
                  ? Icon(
                      Icons.edit,
                      color: Colors.white,
                    )
                  : Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
              onPressed: () {
                manage
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => new AdminPage()))
                    : Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => new RecipeSearch()));
              },
            ),
          )),
    );
  }

  Widget getUserId() {
    return Container(
        child: FutureBuilder(
            future: FirebaseAuth.instance.currentUser(),
            builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data.uid);
              } else {
                return Text('Loading...');
              }
            }));
  }
}
