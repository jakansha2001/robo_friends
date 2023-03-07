import 'package:flutter/material.dart';
import 'package:robo_friends/home/widgets/widgets.dart';
import 'package:robo_friends/model/user_model.dart';
import 'package:robo_friends/service/api_service.dart';
import 'package:robo_friends/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<UserModel>? _userModel = [];
  List<UserModel>? searchList = [];
  SharedPreferences? prefs;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    prefs = await SharedPreferences.getInstance();
    _userModel = (await ApiService().getUsers())!;
    for (int i = 0; i < _userModel!.length; i++) {
      _userModel![i].isSaved = prefs!.getBool(_userModel![i].id.toString()) ?? false;
    }
    searchList!.addAll(_userModel!);
    setState(() {});
  }

  void search(String value) {
    searchList!.clear();
    if (value.isEmpty) {
      searchList!.addAll(_userModel!);
    } else {
      for (int i = 0; i < _userModel!.length; i++) {
        if (_userModel![i].name.toLowerCase().contains(
              value.toLowerCase(),
            )) {
          searchList!.add(_userModel![i]);
        }
      }
    }
    setState(() {});
  }

  void storeFavourite(int index) async {
    var prefs = await SharedPreferences.getInstance();

    setState(() {
      _userModel![index].isSaved = !_userModel![index].isSaved;
      searchList![index].isSaved = _userModel![index].isSaved;
    });
    prefs.setBool(
      searchList![index].id.toString(),
      searchList![index].isSaved,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            const BackgroundGradient(),
            Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(
                        top: 15.0,
                      ),
                      child: Text(
                        'ROBOFRIENDS',
                        style: TextStyle(
                          fontFamily: 'Monoton',
                          fontSize: 35,
                          color: Color.fromRGBO(
                            121,
                            196,
                            194,
                            1,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 30,
                        left: 50,
                        right: 50,
                      ),
                      child: TextField(
                        onChanged: (value) {
                          search(value);
                        },
                        decoration: ThemeConstants.searchFieldDecoration,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    _userModel == null || _userModel!.isEmpty
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GridView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                  ),
                                  itemCount: searchList!.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Stack(
                                      children: [
                                        RobotCard(model: searchList![index]),
                                        Positioned(
                                          right: -3,
                                          top: -4,
                                          child: IconButton(
                                            onPressed: () {
                                              storeFavourite(index);
                                            },
                                            icon: Icon(
                                              searchList![index].isSaved ? Icons.favorite : Icons.favorite_border,
                                              color: searchList![index].isSaved ? Colors.red : Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
