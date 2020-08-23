import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rshb/models/product_model.dart';
import 'package:rshb/screens/product_view.dart';
import 'package:rshb/services/services.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List products = [];
  List farmers = [];
  List jsonData = [];
  List secondData = [];
  bool sort = false;
  String sortCategory = ' ';
  var doc;

  //загрузка листа в кеш
  getSPData(doc) async {
    doc = json.decode(doc);
    products = doc['products'];
    farmers = doc['farmers'];

    JsonData.farmers = farmers;
//сортируем лист в зависимости от нужной категории
    List tempDoc = new List();
    if(sortCategory == 'Мясо'){
      for (var i = 0; i < products.length; i++){
        try{
          if(products[i]['characteristics'][1]['value'].toString().isNotEmpty ){
            if(products[i]['characteristics'][1]['value'] == 'Мясо'){
              tempDoc.add(products[i]);
            }
          }
        }catch(e){
          // print(e);
        }
      }
      products = tempDoc;
    } else if(sortCategory == 'Молоко и яйца'){
      for (var i = 0; i < products.length; i++){
        try{
          if(products[i]['characteristics'][1]['value'].toString().isNotEmpty ){
            if(products[i]['characteristics'][1]['value'] == 'Молоко и яйца'){
              tempDoc.add(products[i]);
            }
          }
        }catch(e){
          // print(e);
        }
      }
      products = tempDoc;
    } else{
      sortCategory = ' ';
    }

//сортируем лист в зависимости от рейтинга(от бол. к менш.) и стоимости(от менш. к бол.)
    if(!sort){
      products.sort((a, b) {
        return b['totalRating'].compareTo(a['totalRating']);
      });

    }else{
      products.sort((a, b) {
        return a['price'].compareTo(b['price']);
      });

    }

    return doc;
  }

  //Эмуляция загрузки из сети
  getDataWeb() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await Timer(Duration(milliseconds: 500), () {
      print('.....');
    });

    //Разбираем локальный Json
    String jsonFile = await DefaultAssetBundle.of(context)
        .loadString("assets/data/data.json");
    var document = json.decode(jsonFile);

    prefs.setString('doc', json.encode(document));

    products = document['products'];
    farmers = document['farmers'];

    JsonData.farmers = farmers;
//сортируем лист в зависимости от нужной категории
    List tempDoc = new List();
    if(sortCategory == 'Мясо'){
      for (var i = 0; i < products.length; i++){
        try{
          if(products[i]['characteristics'][1]['value'].toString().isNotEmpty ){
            if(products[i]['characteristics'][1]['value'] == 'Мясо'){
              tempDoc.add(products[i]);
            }
          }
        }catch(e){
          // print(e);
        }
      }
      products = tempDoc;
    } else if(sortCategory == 'Молоко и яйца'){
      for (var i = 0; i < products.length; i++){
        try{
          if(products[i]['characteristics'][1]['value'].toString().isNotEmpty ){
            if(products[i]['characteristics'][1]['value'] == 'Молоко и яйца'){
              tempDoc.add(products[i]);
            }
          }
        }catch(e){
          // print(e);
        }
      }
      products = tempDoc;
    } else{
      sortCategory = ' ';
    }

//сортируем лист в зависимости от рейтинга(от бол. к менш.) и стоимости(от менш. к бол.)
    if(!sort){
      products.sort((a, b) {
        return b['totalRating'].compareTo(a['totalRating']);
      });

    }else{
      products.sort((a, b) {
        return a['price'].compareTo(b['price']);
      });

    }

    return document;
  }

  getData() async {
    //загружем лист закладок из памяти телфона, если он пустой, то суем в него какую-нидь дату, иначе все сломается :D
    SharedPreferences prefs = await SharedPreferences.getInstance();

    JsonData.favList = (prefs.getStringList('fav'));
    if(JsonData.favList == null) {
      JsonData.favList = ['', ' '];
    }

    print(  "0000" + JsonData.doc.toString());

    JsonData.doc = (prefs.getString('doc'));

    if (JsonData.doc == null) {
      print('loading from web');
      getDataWeb();
    } else {
      print(   JsonData.doc.toString());
      print('loading from local');
      getSPData(JsonData.doc);
    }
  }

  @override
  Widget build(BuildContext context) {

      return Scaffold(
        backgroundColor: Colors.white,
      body: SingleChildScrollView(
          child: Container(
        //margin: EdgeInsets.symmetric(horizontal: 10.0)
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 35.0),
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.0),
                      child: Column(
                        children: [
                          OutlineButton(
                            onPressed: () {
                              // Проверяем статус переменной сортировки для покраски конпки сортировки в зеленый
                              setState(() {
                                if(sort == true){
                                  setState(() {
                                    sort = false;
                                  });

                                }else{
                                  setState(() {
                                    sort = true;
                                  });

                                }
                              });
                            },
                            color: Colors.green,
                            textColor: Colors.grey[600],
                            child: SvgPicture.asset('assets/icons/categories/Sort.svg', height: 25, color: sort ? Colors.green : Colors.black,),
                            padding: EdgeInsets.all(16),
                            borderSide: BorderSide(
                              color:sort ? Colors.green : Colors.grey[400],
                              width: 1,
                            ),
                            shape: CircleBorder(),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Сортировать',
                            style: TextStyle(
                                color: Colors.grey[500],
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      )),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      child: Column(
                        children: [
                          OutlineButton(
                            onPressed: () {
                              // тоже самое, что и с сортировкой

                              if(sortCategory == 'Мясо'){

                                setState(() {
                                  sortCategory = ' ';

                                });
                                print('Категория :' + sortCategory);


                              } else {

                                setState(() {
                                  sortCategory = 'Мясо';

                                });
                                print('Категория :' + sortCategory);

                              }

                            },
                            color: sortCategory == 'Мясо' ? Colors.green : Colors.grey[400],
                            textColor: Colors.grey[600],
                            child: SvgPicture.asset('assets/icons/categories/Pig.svg', height: 25, color: sortCategory == 'Мясо' ? Colors.green : Colors.black,),

                            padding: EdgeInsets.all(16),
                            borderSide: BorderSide(
                              color: sortCategory == 'Мясо' ? Colors.green : Colors.grey[400],
                              width: 1,
                            ),
                            shape: CircleBorder(),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                           'Мясо',
                            style: TextStyle(
                                color: Colors.grey[500],
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      )),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      child: Column(
                        children: [
                          OutlineButton(
                            onPressed: () {
                              if(sortCategory == 'Молоко и яйца'){

                                setState(() {
                                  sortCategory = ' ';
                                });
                                print('Категория :' + sortCategory);

                              } else {

                                setState(() {

                                  sortCategory = 'Молоко и яйца';

                                });
                                print('Категория :' + sortCategory);

                              }

                            },
                            color: sortCategory == 'Молоко и яйца' ? Colors.green : Colors.grey[400],
                            textColor: Colors.grey[600],
                            child: SvgPicture.asset('assets/icons/categories/Milk.svg', height: 25, color: sortCategory == 'Молоко и яйца' ? Colors.green : Colors.black,),

                            padding: EdgeInsets.all(16),
                            borderSide: BorderSide(
                              color: sortCategory == 'Молоко и яйца' ? Colors.green : Colors.grey[400],
                              width: 1,
                            ),
                            shape: CircleBorder(),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                       '''Молоко 
и яйца''',
                            style: TextStyle(
                                color: Colors.grey[500],
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      )),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      child: Column(
                        children: [
                          OutlineButton(
                            onPressed: () {},
                            color: Colors.blue,
                            textColor: Colors.grey[600],
                            child: Icon(
                              Icons.star,
                              size: 20,
                            ),
                            padding: EdgeInsets.all(16),
                            borderSide: BorderSide(
                              color: Colors.grey[400],
                              width: 1,
                            ),
                            shape: CircleBorder(),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            '''    Хлеб 
и пыпечка''',
                            style: TextStyle(
                                color: Colors.grey[500],
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      )),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      child: Column(
                        children: [
                          OutlineButton(
                            onPressed: () {},
                            color: Colors.blue,
                            textColor: Colors.grey[600],
                            child: Icon(
                              Icons.star,
                              size: 20,
                            ),
                            padding: EdgeInsets.all(16),
                            borderSide: BorderSide(
                              color: Colors.grey[400],
                              width: 1,
                            ),
                            shape: CircleBorder(),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Мясо',
                            style: TextStyle(
                                color: Colors.grey[500],
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      )),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      child: Column(
                        children: [
                          OutlineButton(
                            onPressed: () {},
                            color: Colors.blue,
                            textColor: Colors.grey[600],
                            child: Icon(
                              Icons.star,
                              size: 20,
                            ),
                            padding: EdgeInsets.all(16),
                            borderSide: BorderSide(
                              color: Colors.grey[400],
                              width: 1,
                            ),
                            shape: CircleBorder(),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Сыры',
                            style: TextStyle(
                                color: Colors.grey[500],
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      )),
                ],
              ),
            ),
            Container(
                child: FutureBuilder(
              future: getData(),
              builder: (context, snapshot) {
                // snapshot.hasError напишет нам, если во время загруки данных произошла ошибка

                if (snapshot.hasError)
                  return new Text('Error: ${snapshot.error}');
            //ждем подключения к интенету
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return new Center(child: CircularProgressIndicator(),);

                  default:
                    return new RefreshIndicator(
                        onRefresh: () {
                          setState(() {});
                        },
                        child: products.isNotEmpty
                            ? GridView.count(


                          shrinkWrap: true,
                                crossAxisCount: 2,
                          childAspectRatio: 0.53,

                          physics: ScrollPhysics(),
                                children:
                                    List.generate(products.length, (index) {
                                  return CustomCard(product: products[index]);
                                }),
                              )
                            : new Center(child: CircularProgressIndicator()));
                }
              },
            ))
          ],
        ),
      )),
    );
  }
}

class CustomCard extends StatefulWidget {
  var product;

  CustomCard({@required this.product});

  @override
  _CustomCardState createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  @override
  Widget build(BuildContext context) {
    String ratingCountTextNum = widget.product['ratingCount'].toString();
    String ratingTotalTextGreen = widget.product['totalRating'].toString();
    Color rating = Colors.orange;
    String ratingCount = 'оценка';
    Color favColor = Colors.white;

    //Проверяем чему равен райтиг и в зависимости от данных выставляем нужный цвет для бекграудна рейтинга
    if (widget.product['totalRating'] >= 4.0) {
      rating = Colors.green;
    } else if (widget.product['totalRating'] <= 3.8) {
      rating = Colors.grey;
    }
    //Проверяем чему равно кол-во оценок и в зависимости от данных выставляем нужный текст  для вывода корректого текста для текста оценок

    if ((widget.product['ratingCount'] <= 4) && (widget.product['ratingCount'] != 0 && (widget.product['ratingCount'] != 1))) {
      ratingCount = "оценки";
    } else if ((widget.product['ratingCount'] > 4) &&
        (widget.product['ratingCount'] != 0)) {
      ratingCount = "оценок";
    } else if (widget.product['ratingCount'] == 0) {
      ratingCount = "Нет оценок";
      ratingTotalTextGreen = "_";
      ratingCountTextNum = "";
    }
    //Проходися по листу закладок чтобы потом покрасить выбранные закладки в зеленый цвет

    if(JsonData.favList.contains(widget.product['id'].toString())){
      favColor = Colors.green;
    } else {
      favColor = Colors.black;

    }

      return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: Card(
          shape: RoundedRectangleBorder(
              side: new BorderSide(color: Colors.grey[300], width: 1.0),
              borderRadius: BorderRadius.circular(4.0)),
          child: InkWell(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ProductView(product: widget.product))),
              child: Column(
                children: <Widget>[
                  Stack(children: <Widget>[
                    Center(child:         Hero(
                      tag: 'image_${widget.product['id'].toString()}',
                      child: Image.asset(widget.product['image'],
                        height: 125,
                      ),
                    ) ,),

                    Container(
                        padding: EdgeInsets.fromLTRB(0, 10, 10, 0),
                        alignment: Alignment.topRight,
                        child: Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.grey[400], width: 1),
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),

                          child: Center(
                            child: InkWell(
                              onTap: () async {
                                //Если элмент содержится в списке закладок, то удаляем его и апдейт листа в памяти. Если его там нет, то добовляем его и кладем новый список в память Устр.

                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                if(JsonData.favList.toString() != null){
                                  if(JsonData.favList.contains(widget.product['id'].toString())){
                                    JsonData.favList.removeWhere((item) => item == widget.product['id'].toString());
                                    await prefs.setStringList('fav', JsonData.favList);
                                    print('FavList Remove: ' +JsonData.favList.toString());


                                    setState(() {
                                      favColor = Colors.black;

                                    });

                                  }else{
                                    JsonData.favList.add(widget.product['id'].toString());
                                    print('FavList: add ' +JsonData.favList.toString());

                                    await prefs.setStringList('fav', JsonData.favList);
                                    setState(() {
                                      favColor = Colors.green;

                                    });

                                  }
                                } else{
                                  print('FavList create: ' +JsonData.favList.toString());

                                  JsonData.favList = ['test','test2'];
                                }




                              },
                              child: Icon(favColor == Colors.green ? Icons.bookmark : Icons.bookmark_border, color: favColor,),
                            ),
                          ),
//
                        )),
                  ]),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Expanded(
                                            child: Container(
                                                child: RichText(
                                              text: TextSpan(children: [
                                                TextSpan(
                                                  text: widget.product['title'],
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16.0,
                                                      color: Colors.black),
                                                ),
                                                TextSpan(
                                                  text:
                                                      ' / ${widget.product['unit']}',
                                                  style: TextStyle(
                                                      fontSize: 12.0,
                                                      color: Colors.grey),
                                                ),
                                              ]),
                                              overflow: TextOverflow.ellipsis,
                                            )),
                                            flex: 10,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: rating,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                      8.0) //                 <--- border radius here
                                                  ),
                                            ),
                                            child: Text(
                                              ratingTotalTextGreen.toString(),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14),
                                            ),
                                          ),
                                          Container(
                                            child: Text(
                                              ' ${ratingCountTextNum.toString()} ${ratingCount.toString()}',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Container(
                                        alignment:
                                            AlignmentDirectional.centerStart,
                                        child: Text(
                                          widget.product['shortDescription'],
                                          textAlign: TextAlign.start,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                          alignment:
                                              AlignmentDirectional.centerStart,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 4.0),
                                            child: Text(
                                              JsonData.farmers[widget.product['farmerId']]['title'],
                                              style: TextStyle(fontSize: 12.0),
                                            ),
                                          )),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                          alignment:
                                              AlignmentDirectional.centerStart,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 4.0),
                                            child: Text(
                                              widget.product['price']
                                                      .toString()
                                                      .substring(
                                                          0,
                                                          widget
                                                              .product['price']
                                                              .toString()
                                                              .indexOf('.')) +
                                                  " ₽",
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          )),
                                    ],
                                  )),

                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ))),
    );
  }
}
