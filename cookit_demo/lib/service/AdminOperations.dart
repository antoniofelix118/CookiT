import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookit_demo/model/PostModel.dart';
import 'package:cookit_demo/model/User.dart';
import 'package:cookit_demo/service/Authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart';

class AdminOperations {
  static String deletePost(String PostId) {
    // delete the specified post
    String filepath;
    String url;
      Firestore.instance.collection('posts')
          .document(PostId)
          .get().then((data) {
        if (data.exists) {
          url = data['imageUrl'];
          print(url);
          filepath = url.replaceAll(new RegExp(r'%2F'), '/');
         // filepath = filepath.replaceAll(new RegExp(r'(\?alt).*'), '');
          //StorageReference storageReference = FirebaseStorage.instance.ref();
          print(filepath);
          //StorageReference photoRef = FirebaseStorage.instance.getReferenceFromUrl(url);

          //storageReference.child("UserRecipes/").delete().then((_) => print('Successfully deleted $filepath storage item' ));
          print(filepath);
          data.reference.delete();
        }
      });
    return url;
  }

  static void grantAdmin(String userId) {
    Firestore.instance.collection('users')
        .document(userId)
        .get().then((data) {
      if (data.exists) {

        if(data.data["role"] == "user") {
          data.reference.updateData({
            'role': 'admin',
          });
          }
      }
    });
  }

  static void unGrantAdmin(String userId){
    Firestore.instance.collection('users')
        .document(userId)
        .get().then((data) {
      if (data.exists) {
        if(data.data["role"] == "admin") {
          data.reference.updateData({
            'role': 'user',
          });
        }
      }
    });
  }

  static bool checkUser(String userId) {
    bool exists = true;
    Firestore.instance.collection('users')
        .document(userId)
        .get().then((data) {
      if (data.exists) {
        exists = false;
      }
    });
    return exists;
  }


  static void deleteUser(String userId) {

    Firestore.instance
        .collection('posts')
        .where("userId", isEqualTo: userId)
        .getDocuments().then((data) {
      for (var doc in data.documents) {
        print(doc.documentID.toString());
        deletePost(doc.documentID.toString());
        //print(doc['user_name']);
      }

    });








    Firestore.instance.collection('users')
        .document(userId)
        .get().then((data) {
      if (data.exists) {



          //adminRemovePic(data['profileImage']);
          data.reference.delete();
          print(data.data["user_name"].toString());

      }
    });



  }



}