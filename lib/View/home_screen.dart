import 'dart:developer';
import 'package:atodo_app/DataBase/Shared_Preferences.dart';
import 'package:atodo_app/DataBase/database.dart';
import 'package:atodo_app/Model/TodoModel.dart';
import 'package:atodo_app/View/Login_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:msh_checkbox/msh_checkbox.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePageUi extends StatefulWidget {
  const HomePageUi({super.key});

  @override
  State<HomePageUi> createState() => _HomePageUiState();
}

class _HomePageUiState extends State<HomePageUi> {
  List<Todomodel> tasklist = [];
  bool iscompletedcheck = false;
  String username = "";

  int id = -1;
  TextEditingController titletextEditingController = TextEditingController();
  TextEditingController descriptiontextEditingController =
      TextEditingController();
  TextEditingController datetextEditingController = TextEditingController();

  void clearcontroller() {
    titletextEditingController.clear();
    descriptiontextEditingController.clear();
    datetextEditingController.clear();
  }

  @override
  void initState() {
    super.initState();
    getdata();
    getsharedData();
  }

  void getsharedData() async {
    await UserController().getSharedpreferenced();
    log("data is the : ${UserController().getSharedpreferenced()}");
    UserController userController = UserController();
    await userController.getSharedpreferenced();
    log(userController.username);
    username = userController.username;
    setState(() {});
  }

  void getdata() async {
    List<Map> todotask = await HelperDatabase().gettododata();
    for (int i = 0; i < todotask.length; i++) {
      var element = todotask[i];
      tasklist.add(
        Todomodel(
          id: element['id'],
          date: element['date'] ?? "",
          description: element['description'] ?? "",
          title: element['title'] ?? "",
          iscompletedcheck: element['iscompletedcheck'] == 1,
        ),
      );
      log("todotask : $todotask");
      setState(() {});
    }
  }

  Widget floatingactionbotton() {
    return FloatingActionButton.extended(
      backgroundColor: Color.fromARGB(255, 64, 44, 167),
      onPressed: () {
        showbottomsheetBar(false);
      },
      label: Text(
        'Add To-Do',
        style: GoogleFonts.quicksand(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
      icon: Icon(Icons.add, color: Colors.white),
    );
  }

  void submitButton(bool doEdit, [Todomodel? obj]) {
    if (titletextEditingController.text.trim().isNotEmpty &&
        descriptiontextEditingController.text.trim().isNotEmpty &&
        datetextEditingController.text.trim().isNotEmpty) {
      if (doEdit) {
        obj!.title = titletextEditingController.text;
        obj.description = descriptiontextEditingController.text;
        obj.date = datetextEditingController.text;
        HelperDatabase().updatetododata(obj.updatetoMap());
        setState(() {});
      } else {
        Todomodel todo = Todomodel(
          date: datetextEditingController.text,
          description: descriptiontextEditingController.text,
          title: titletextEditingController.text,
          iscompletedcheck: iscompletedcheck,
        );
        HelperDatabase().insertdata(todo.inserttoMap());
        tasklist.add(todo);
      }
      setState(() {});
      clearcontroller();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          dismissDirection: DismissDirection.down,
          duration: Duration(seconds: 2),
          backgroundColor: Color.fromARGB(255, 64, 44, 167),
          content: Text(
            "Data Added Succesfully",
            style: GoogleFonts.quicksand(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    } else {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          dismissDirection: DismissDirection.down,
          duration: Duration(seconds: 2),
          backgroundColor: Color.fromARGB(255, 64, 44, 167),
          content: Text(
            "Please Enter The Data",
            style: GoogleFonts.quicksand(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }
  }

  void showbottomsheetBar(bool doEdit, [Todomodel? obj]) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 5,
                width: 55,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black38,
                ),
              ),
              SizedBox(height: 12),
              Text(
                "Create To-Do ",
                style: GoogleFonts.quicksand(
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                ),
              ),
              SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  children: [
                    Text(
                      "Title",
                      style: GoogleFonts.quicksand(
                        color: Color.fromARGB(255, 80, 55, 207),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              SizedBox(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 5),
                  child: TextField(
                    controller: titletextEditingController,
                    maxLength: 50,
                    decoration: InputDecoration(
                      hintText: "Enter The Title",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  children: [
                    Text(
                      "Description",
                      style: GoogleFonts.quicksand(
                        color: Color.fromARGB(255, 80, 55, 207),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              SizedBox(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 5),
                  child: TextField(
                    controller: descriptiontextEditingController,
                    maxLength: 1000,
                    decoration: InputDecoration(
                      hintText: "Enter The Description",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  children: [
                    Text(
                      "Date",
                      style: GoogleFonts.quicksand(
                        color: Color.fromARGB(255, 80, 55, 207),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              SizedBox(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 5),
                  child: TextField(
                    controller: datetextEditingController,
                    onTap: () async {
                      DateTime? pickdate = await showDatePicker(
                        context: context,
                        firstDate: DateTime(1950),
                        lastDate: DateTime(2050),
                      );
                      datetextEditingController.text = DateFormat.yMMMd()
                          .format(pickdate!);
                    },
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.calendar_month_outlined),
                      hintText: "Enter The Date",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    if (doEdit) {
                      submitButton(true, obj);
                    } else {
                      submitButton(false);
                    }
                    setState(() {});
                  },
                  child: Container(
                    height: 50,
                    width: 300,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 215, 212, 212),
                          blurRadius: 5,
                          spreadRadius: 1,
                          blurStyle: BlurStyle.outer,
                        ),
                      ],
                      color: Color.fromARGB(255, 64, 44, 167),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "Submit",
                      style: GoogleFonts.quicksand(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 25),
            ],
          ),
        );
      },
    ).whenComplete(() {
      clearcontroller();
    });
  }

  Future showdialogbox(int showdialogindex) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Confirm To Deleted To-Do ?",
            style: GoogleFonts.quicksand(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            "Are you sure you want to delete this To do Task ?",
            style: GoogleFonts.quicksand(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            ElevatedButton(
              style: ButtonStyle(
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    side: BorderSide(color: Colors.black12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "No",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 5),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                  Color.fromARGB(255, 64, 44, 167),
                ),
              ),
              onPressed: () {
                id = tasklist[showdialogindex].id;
                tasklist.removeAt(showdialogindex);
                HelperDatabase().deletetdata(id);
                Navigator.of(context).pop();
                setState(() {});
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    dismissDirection: DismissDirection.down,
                    duration: Duration(seconds: 2),
                    backgroundColor: Color.fromARGB(255, 64, 44, 167),
                    content: Text(
                      "Data Deleted Succefully",
                      style: GoogleFonts.quicksand(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              },
              child: const Text(
                "Yes",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0x806F51FF),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 35, top: 10, right: 35),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Logout",
                        style: GoogleFonts.quicksand(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(width: 8),
                      GestureDetector(
                        onTap: () async {
                          SharedPreferences sharedPreferencesobj =
                              await SharedPreferences.getInstance();
                          sharedPreferencesobj.clear();
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) {
                                return LoginScreen();
                              },
                            ),
                            (route) => false,
                          );
                        },
                        child: Icon(Icons.logout, color: Colors.white),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "WellCome Back,",
                            style: GoogleFonts.quicksand(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 22,
                            ),
                          ),
                          Text(
                            username,
                            style: GoogleFonts.quicksand(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 30,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/im.png"),
                                fit: BoxFit.cover,
                              ),
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 222, 219, 219),
                      blurRadius: 2,
                    ),
                  ],
                  color: const Color.fromARGB(255, 231, 226, 226),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Text(
                      "CREATE TO DO LIST",
                      style: GoogleFonts.quicksand(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 222, 219, 219),
                              blurRadius: 3,
                              blurStyle: BlurStyle.outer,
                            ),
                          ],
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                          ),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 17,
                            right: 17,
                            top: 30,
                          ),
                          child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: tasklist.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color.fromARGB(
                                          255,
                                          192,
                                          187,
                                          187,
                                        ),
                                        blurRadius: 3,
                                        blurStyle: BlurStyle.outer,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 10,
                                              top: 10,
                                              right: 8,
                                            ),
                                            child: SizedBox(
                                              child: Container(
                                                height: 52,
                                                width: 52,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: AssetImage(
                                                      "assets/imag.png",
                                                    ),
                                                  ),
                                                  color: Color(0xFFD9D9D9),
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 12),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                8.0,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    tasklist[index].title,
                                                    style: GoogleFonts.inter(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  SizedBox(height: 8),
                                                  Text(
                                                    tasklist[index].description,
                                                    style: GoogleFonts.inter(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  SizedBox(height: 10),
                                                  Text(
                                                    tasklist[index].date,
                                                    style: GoogleFonts.inter(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 14,
                                          right: 14,
                                          top: 8,
                                          bottom: 12,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              tasklist[index].iscompletedcheck
                                                  ? "Completed"
                                                  : "Pending",
                                              style: GoogleFonts.inter(
                                                color:
                                                    tasklist[index]
                                                            .iscompletedcheck
                                                        ? Colors.green
                                                        : Colors.red,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 13,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                MSHCheckbox(
                                                  size: 19,
                                                  checkedColor: Colors.green,
                                                  value:
                                                      tasklist[index]
                                                          .iscompletedcheck,
                                                  onChanged: (selected) {
                                                    tasklist[index]
                                                            .iscompletedcheck =
                                                        selected;

                                                    HelperDatabase()
                                                        .updatetododata(
                                                          tasklist[index]
                                                              .updatetoMap(),
                                                        );
                                                    log(
                                                      "update map : ${tasklist[index]}",
                                                    );
                                                    setState(() {});
                                                  },
                                                ),
                                                SizedBox(width: 10),
                                                GestureDetector(
                                                  onTap: () {
                                                    titletextEditingController
                                                            .text =
                                                        tasklist[index].title;
                                                    descriptiontextEditingController
                                                        .text = tasklist[index]
                                                            .description;
                                                    datetextEditingController
                                                            .text =
                                                        tasklist[index].date;
                                                    showbottomsheetBar(
                                                      true,
                                                      tasklist[index],
                                                    );
                                                    setState(() {});
                                                  },
                                                  child: Icon(
                                                    Icons.edit,
                                                    size: 18,
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                GestureDetector(
                                                  onTap: () {
                                                    showdialogbox(index);
                                                    setState(() {});
                                                  },
                                                  child: Icon(
                                                    Icons
                                                        .delete_outline_outlined,
                                                    size: 18,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: floatingactionbotton(),
    );
  }
}
