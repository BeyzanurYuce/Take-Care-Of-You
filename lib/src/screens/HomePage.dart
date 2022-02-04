import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meditation_app/src/screens/NotesPage.dart';
import 'package:meditation_app/src/screens/sideBar.dart';
import 'package:meditation_app/src/screens/track_categories.dart';




class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final user=FirebaseAuth.instance.currentUser;

    CollectionReference userRef= FirebaseFirestore.instance.collection('User Data');
    Map<String, dynamic> userData={'Name': user?.displayName,'Email': user?.email,'photoURL': user?.photoURL};
    userRef.doc(user?.email).set(userData);
    String name= user?.displayName ?? "User";
    var currentUser=FirebaseFirestore.instance.collection('Data').doc(user?.email);
    return Scaffold(
      drawer: sideBar(),

      appBar: AppBar(
        centerTitle: true,
        title: Text('Take Care Of You '),
        backgroundColor: Colors.cyan,

      ),
      body:Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.jpg'),
            fit: BoxFit.fill,
          ),
        ),
        child: Center(
          child: Column(

              children:<Widget>[
                Expanded(
                  flex: 2,
                  child: Image(
                      width: 100.0,
                      height: 100.0,
                      image: AssetImage('assets/images/cute cartoon meditation_6223223.png')),
                ),
                StreamBuilder(stream: currentUser.snapshots(),builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if(snapshot.hasData){
                  return Text("Welcome ${snapshot.data.data()['Name']}! Let's get started. ",style: TextStyle(color: Colors.indigo,fontSize: 24),); }
                  else{
                    return CircularProgressIndicator();
                  }
                }),


                SizedBox(
                  width: 50.0,
                  height:50.0,
                ),


                Expanded(
                  flex: 3,
                  child: SizedBox(
                    width:500.0,
                    height: 200.0,

                    child: TextButton.icon(
                      style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all(Colors.cyan),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              )
                          )
                      ),

                      onPressed: () {
                        Navigator.push(context,MaterialPageRoute(builder:(context)=>TrackCategories()));
                      },
                      icon: Image.asset('assets/images/space.jpg'),
                      label: Text(
                        'Start medtation',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.indigo,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40.0,
                  width: 50.0,
                ),
                Expanded(
                  flex: 3,
                  child: SizedBox(
                    width:500.0,
                    height: 200.0,

                    child: TextButton.icon(

                      style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all(Colors.cyan),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              )
                          )
                      ),
                      onPressed: () {
                        Navigator.push(context,MaterialPageRoute(builder:(context)=>NotesPage()));
                      },
                      icon: Image.asset('assets/images/journaling.jpeg'),

                      label: Text(
                        'Start journaling',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.indigo,
                          fontWeight: FontWeight.bold,
                        ),

                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                  width: 50.0,
                ),
              ]

          ),
        ),
      ),
    );
  }
}