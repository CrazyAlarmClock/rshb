import 'package:flutter/material.dart';
import 'package:rshb/models/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductView extends StatefulWidget {
  var product;

  ProductView({@required this.product});

  @override
  _ProductViewState createState() => _ProductViewState();
}


class _ProductViewState extends State<ProductView> {

  Color rating = Colors.orange;
  String ratingCount = 'оценка';
  bool showMore = false;
  String statsText = 'Все характеристики';
  IconData statsIcon = Icons.keyboard_arrow_right;
  Color favColor = Colors.black;

  @override
  Widget build(BuildContext context) {

    String ratingCountTextNum = widget.product['ratingCount'].toString();
    String ratingTotalTextGreen = widget.product['totalRating'].toString();

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
    } else{
      favColor = Colors.black;

    }

    //Проверяем дату на null, чтобы не сломался ui у тех элементов, где хар-ка пустая
    List checkData = widget.product['characteristics'];

    bool showInfo = false;

    if(checkData.isEmpty){
       showInfo = true;
    }


    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(child: Column(
        children: <Widget>[
          Stack(children: <Widget>[
            Center(
              child: Hero(
              tag: 'image_${widget.product['id'].toString()}',
              child: Image.asset(widget.product['image'],
                height: 300,
              ),
            ) ,),

            Container(
                padding: EdgeInsets.fromLTRB(0, 60, 10, 0),
                alignment: Alignment.topRight,
                child: Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[400], width: 2),
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
                )),
            Hero(
                tag: 'fav_${widget.product['id'].toString()}',
                child: Container(
                    padding: EdgeInsets.fromLTRB(10, 60, 0, 0),
                    alignment: Alignment.topLeft,
                    child: Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[400], width: 1),
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Icon(Icons.arrow_back),
                        ),
                      ),
                    ))),
          ]),
          Container(
            child:    Padding(
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
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20.0,
                                                    color: Colors.black),
                                              ),
                                              TextSpan(
                                                text: ' / ${widget.product['unit']}',
                                                style: TextStyle(
                                                    fontSize: 16.0,
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
                                  height: 15,
                                ),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: rating,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)
                                        ),
                                      ),
                                      child: Text(
                                        ratingTotalTextGreen.toString(),
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 14),
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        ' ${ratingCountTextNum.toString()} ${ratingCount.toString()}',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 12),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 15),

                                Container(
                                    alignment: AlignmentDirectional.centerStart,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4.0),
                                      child: Text(
                                        widget.product['price']
                                            .toString()
                                            .substring(
                                            0,
                                            widget.product['price']
                                                .toString()
                                                .indexOf('.')) +
                                            " ₽",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 24.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )),
                                SizedBox(height: 30),

                                Container(
                                  alignment: AlignmentDirectional.centerStart,
                                  child: Text(
                                    widget.product['description'],
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                !showInfo ?  Row(children: [
                                  Flexible(
                                    child: Text(
                                      widget.product['characteristics'][0]['title'].toString() ?? 'нет данных' + ' .................................................',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      softWrap: false,

                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                  Container(
                                    alignment: AlignmentDirectional.centerEnd,
                                    child: Text(
                                      widget.product['characteristics'][0]['value'].toString() ,
                                      //overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),

                                ]
                                ):Container(),
                                SizedBox(height: 15),

                                !showInfo ?  Row(children: [
                                  Flexible(
                                    child: Text(
                                      widget.product['characteristics'][1]['title'].toString()  + ' .................................................',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      softWrap: false,

                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                  Container(
                                    alignment: AlignmentDirectional.centerEnd,
                                    child: Text(
                                      widget.product['characteristics'][1]['value'].toString() ,
                                      //overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),

                                ],):Container(),

                                SizedBox(height: 15),

                                 showMore ? Row(children: [
                                    Flexible(
                                      child: Text(
                                        widget.product['characteristics'][2]['title'].toString()  + ' .................................................',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        softWrap: false,

                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                    Container(
                                      alignment: AlignmentDirectional.centerEnd,
                                      child: Text(
                                        widget.product['characteristics'][2]['value'].toString() ,
                                        //overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),


                                  ],): Container(),
                                SizedBox(height: 15),

                                showMore ? Row(children: [
                                  Flexible(
                                    child: Text(
                                      widget.product['characteristics'][3]['title'].toString()  + ' ............................',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      softWrap: false,

                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                  Container(
                                    alignment: AlignmentDirectional.centerEnd,
                                    child: Text(
                                      widget.product['characteristics'][3]['value'].toString() ,
                                      //overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),


                                ],): Container(),


                                SizedBox(height: 15),
                                InkWell(
                                  onTap: (){
                                    // Меняем хар-ки и их текст в зависмоисти от SnowMore
                                    print(showMore.toString());

                                    setState(() {
                                      if(showMore == false){
                                        showMore = true;
                                        statsIcon = Icons.keyboard_arrow_up;
                                        statsText = "Скрыть характиристики";

                                      } else {
                                        showMore = false;
                                        statsIcon = Icons.keyboard_arrow_right;
                                        statsText = "Все характиристики";

                                      }

                                    });

                                  },
                                  child:
                                  !showInfo ? Row(children: [ Container(
                                  alignment: AlignmentDirectional.centerStart,
                                  child: Text(
                                    statsText ,
                                    //overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.green[600],
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                  Container(child:
                                    Icon(statsIcon, color: Colors.green[600],),)
                                ],) : Container()

                                )

                              ],
                            )),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )

        ],
      ),)
    );
  }
}
