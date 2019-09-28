import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mudi_grocery_app/ui/login_page.dart';
import 'package:mudi_grocery_app/item_view.dart';

void main() => runApp(
  new MaterialApp(
    title: 'Mudi',
    theme: new ThemeData(
      primaryColor: Colors.blue,
    ),
    home: _handelWindowDisplay(),
  )
);



Widget _handelWindowDisplay(){
  return StreamBuilder(
    stream: FirebaseAuth.instance.onAuthStateChanged,
    builder: (BuildContext contex, snapshot){
      if(snapshot.connectionState == ConnectionState.waiting){
        return Center(child: Text("Loading"),
        );
      }

      else{
        if(snapshot.hasData){
          return new ListPage(title: "Catalogue",);
        }

        else{
          return new LoginPage();
        }
      }
    },
  );
}