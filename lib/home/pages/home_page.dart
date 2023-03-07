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
  /// Stores the data from the user API
  List<UserModel>? _userModel = [];

  /// Stores the filtered data
  // ignore: prefer_final_fields
  List<UserModel>? _searchList = [];

  /// Object of SharedPreferences to save the favourite robot
  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  /// This function gets the users from the API.
  /// It also fetches the existing stored favourite from SharedPreference.
  /// It also initializes [_searchList] with [_userModel]
  void _getData() async {
    _prefs = await SharedPreferences.getInstance();
    _userModel = await ApiService.getUsers();
    for (int i = 0; i < _userModel!.length; i++) {
      _userModel![i].isSaved = _prefs!.getBool(_userModel![i].id.toString()) ?? false;
    }
    _searchList!.addAll(_userModel!);
    setState(() {});
  }

  /// This function performs the search functionality.
  /// It takes [value] as a parameter which is the search string
  /// typed by the user for searching the robots.
  void _search(String value) {
    _searchList!.clear();
    if (value.isEmpty) {
      _searchList!.addAll(_userModel!);
    } else {
      for (int i = 0; i < _userModel!.length; i++) {
        if (_userModel![i].name.toLowerCase().contains(
              value.toLowerCase(),
            )) {
          _searchList!.add(_userModel![i]);
        }
      }
    }
    setState(() {});
  }

  /// This function saves the favourite robot.
  /// It saves the robot of particular [index]
  /// on which the user tap favourite.
  /// It is stored in SharedPreferences with user id as the key.
  void storeFavourite(int index) async {
    var prefs = await SharedPreferences.getInstance();

    setState(() {
      _userModel![index].isSaved = !_userModel![index].isSaved;
      _searchList![index].isSaved = _userModel![index].isSaved;
    });
    prefs.setBool(
      _searchList![index].id.toString(),
      _searchList![index].isSaved,
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
                          _search(value);
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
                                  itemCount: _searchList!.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Stack(
                                      children: [
                                        RobotCard(model: _searchList![index]),
                                        Positioned(
                                          right: -3,
                                          top: -4,
                                          child: IconButton(
                                            onPressed: () {
                                              storeFavourite(index);
                                            },
                                            icon: Icon(
                                              _searchList![index].isSaved ? Icons.favorite : Icons.favorite_border,
                                              color: _searchList![index].isSaved ? Colors.red : Colors.black,
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
