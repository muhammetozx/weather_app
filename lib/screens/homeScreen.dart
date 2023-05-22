import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({ Key? key }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Future<Weather> fecthWeather() async{
    final resp = await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/weather?lat=38.4200&lon=27.1400&appid=5b3ed0fe61b704ca6987e682333f58e8'));
    if(resp.statusCode == 200){
      Map<String,dynamic> json = jsonDecode(resp.body);
      return Weather.fromJson(json);
    }else{
      throw Exception('Veriler Yüklenmedi...!');
    }
  }

  Future<Weather>? myWeather;

  @override
  void initState() {
    // TODO: implement initState
    myWeather = fecthWeather();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF676BD0),
      body: Padding(
        padding: EdgeInsets.only(left:15.0, right: 15.0, top: 30.0),
        child: Stack(
          children: [
            SafeArea(
              top: true,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.menu, color: Colors.white,),
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage('assets/images/person.jpg'),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  FutureBuilder(
                    future: myWeather,
                    builder: (context, snapshot) {
                      if(snapshot.hasData){
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(snapshot.data!.name, style:TextStyle(color: Colors.white, fontSize: 35, fontWeight: FontWeight.bold)),
                            SizedBox(height: 20),
                            Text(snapshot.data!.weather[0]['main'].toString(), style:TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                            SizedBox(height: 20),
                            Text('22 Mayıs 2023', style:TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                            SizedBox(height: 20),
                            Container(
                              height: 250,
                              width: 250,
                              decoration: BoxDecoration(
                                image: DecorationImage(image: AssetImage('assets/images/cloudy.png'))
                              ),
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                 Column(
                                  children: [
                                    Text('Sıcaklık', style:  TextStyle(color: Colors.white,fontSize: 21,fontWeight: FontWeight.w700)),
                                    SizedBox(height: 10),
                                    Text('${((snapshot.data!.main['temp'] - 32 * 5) / 9).toStringAsFixed(2)}', style:  TextStyle(color: Colors.white,fontSize: 21,fontWeight: FontWeight.w700)),
                                  ],
                                ), 
                                SizedBox(width: 50),
                                Column(
                                  children: [
                                    Text('Rüzgar',style:  TextStyle(color: Colors.white,fontSize: 21,fontWeight: FontWeight.w700)),
                                    SizedBox(height: 10),
                                    Text('${snapshot.data!.wind['speed']} km/h',style:  TextStyle(color: Colors.white,fontSize: 21,fontWeight: FontWeight.w700)),
                                  ],
                                ), 
                                const SizedBox(width: 50,),
                                 Column(
                                  children: [
                                     Text('Nem',style:  TextStyle(color: Colors.white,fontSize: 21,fontWeight: FontWeight.w700)),
                                     SizedBox(height: 10),
                                    Text('${snapshot.data!.main['humidity']}%',style:  TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.w700)),
                                  ],
                               ), 
                          ],
                        ),
                      ],
                    );
                  

                      }else if(snapshot.hasError){
                        return Text('Veriler Yüklenemedi...!');
                      }else{
                        return CircularProgressIndicator(color: Colors.white);
                      }
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}