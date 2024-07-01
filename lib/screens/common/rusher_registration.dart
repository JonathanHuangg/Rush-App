import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rush_app/Firebase/firestore_service.dart';
import 'package:rush_app/screens/common/MainScreen.dart';
import 'package:rush_app/widgets/common/rusher_registration_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Referenced from https://www.syncfusion.com/blogs/post/dynamic-forms-in-flutter

// Declare as mutable state
class DynamicFormPage extends StatefulWidget {
  const DynamicFormPage({super.key});

  @override
  DynamicFormPageState createState() => DynamicFormPageState();
}

// State class is where all of the logic is created with the build method
class DynamicFormPageState extends State<DynamicFormPage> {
  
  final AuthService _authService = AuthService();
  final Map<String, TextEditingController> controllers = {}; 
  final _formKey = GlobalKey<FormState>();
  String? _uid;
  User? _currentUser;


  List<DynamicModel> formsList = [];

  List<ItemModel> schools = [
    ItemModel(0, "Georgia Tech"),
    ItemModel(1, "LocalSchoolTest1"),
    ItemModel(2, "LocalSchoolTest2")
  ];

  List<ItemModel> frats = [
    ItemModel(0, "Delta Sigma Phi"),
    ItemModel(1, "LocalFratTest1"),
    ItemModel(2, "LocalTestFrat2")
  ];

  @override 
  void initState() {
    super.initState();
    _signInUser();
    setUpForms();
  }

  /* DEPRECIATED. DEVICE ID DOESN'T WORK ON EMULATORS
  // User Auth stuff
  Future<void> _initializeDeviceId() async {
    String? deviceId = await _authService.getDeviceId();
    setState(() {
      _deviceId = deviceId;
    });
  }
  */

  Future<void> _signInUser() async { 
    try { 
      UserCredential userCredential = await FirebaseAuth.instance.signInAnonymously();
      
      if (userCredential.user != null) {
        setState(() { 
        _currentUser = userCredential.user;
        _uid = _currentUser?.uid;
        });
      } else {
        _show("Sign-in failed: userCredential.user is null");
      }
      
    } catch(e) {
      _show("Sign-in failed with error: $e");
      _showSignInFailedDialogue("auth");
    }
  }

  Future<void> _handleSignIn() async {
    
    if (_uid != null && _currentUser != null) {
      String name = controllers["Name"]?.text ?? '';
      
      String phrase = controllers["Phrase"]?.text ?? '';
      
      String fraternity = formsList[0].selectedItem?.name ?? '';
      bool isRushChair = false;
      if (controllers["Rush Chair Code"]?.text == "test") {
        isRushChair = true;
      } else if (controllers["Rush Chair Code"]?.text != "")  { 
        _showSignInFailedDialogue("rush");
        return;
      }

      try {
        // create user 
        await _authService.createUser(_uid!, name, fraternity, phrase, isRushChair);

        // Fetch user data to show in the popup
        /*
        DocumentSnapshot userDoc = await _authService.getUser(_uid!);
        
        if (userDoc.exists) {
          var data = userDoc.data() as Map<String, dynamic>;
          _showUserInfo(
            data['name'],
            data['fraternity'],
            data['createdAt'],
            data['phrase'],
            data['isRushChair'],
            data['authorized'],
          );
        } else {
          _showSignInFailedDialogue("panic");
        }
        */
      } catch(e) { 
        _show("Error: ${e.toString()}");
      } 
    } else {
      _showSignInFailedDialogue("uid");
    }
  }

  void _show(String info) { 
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog( 
        title: const Text("'Show' invoked"),
        content: Text(info),  // Use the 'info' parameter here
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
  }

  void _showSignInFailedDialogue(String problem) {
    showDialog(context: context, builder: (BuildContext context) {

      if (problem == "uid") {
        return AlertDialog( 
          title: const Text("Sign in Failed"),
          content: const Text("uid not recognized"),
          actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
        );
      } else if (problem == "rush") {
        return AlertDialog( 
          title: const Text("Incorrect Rush Chair Code"),
          content: const Text("If not the rush chair, please keep this field blank"),
          actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
        );
      } else {
        return AlertDialog( 
          title: const Text("Undefined issue"),
          content: const Text("panic, we're cooked. Idk"),
          actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
        );
      }
      
    });
  }

  
  void setUpForms() {
    formsList.add(DynamicModel("Greek Affiliation", FormType.dropdown, items: frats));

    DynamicModel dynamicModel = DynamicModel("Name", FormType.text, isRequired: true);
    dynamicModel.validators = [];
    dynamicModel.validators.add(DynamicFormValidator(ValidatorType.notEmpty, "Please provide a name"));
    dynamicModel.validators.add(DynamicFormValidator(ValidatorType.textLength, "Please keep the name under 50 characters", textLength: 50));
    formsList.add(dynamicModel);
    controllers[dynamicModel.controlName] = TextEditingController();

    dynamicModel = DynamicModel("Phrase", FormType.text, isRequired: true);
    dynamicModel.validators = [];
    dynamicModel.validators.add(DynamicFormValidator(ValidatorType.notEmpty, "Please provide the phrase given by the rush chair"));
    formsList.add(dynamicModel);
    controllers[dynamicModel.controlName] = TextEditingController();

    dynamicModel = DynamicModel("Rush Chair Code", FormType.text, isRequired: false);
    dynamicModel.validators = [];
    formsList.add(dynamicModel);
    controllers[dynamicModel.controlName] = TextEditingController();
  }


  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Title
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Center(
              child: Text(
                'Registration',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // form fields
          Expanded(
            child: Form(key: _formKey, 
              child: ListView.builder(
              itemCount: formsList.length,
              itemBuilder: (context, index) {
                switch (formsList[index].formType) {
                  case FormType.dropdown:
                    return getDropDown(index, formsList[index].items, formsList, frats, this);
                  case FormType.text:
                    return getTextWidget(index, formsList, controllers);
                  default:
                    return Container();
                }
              },
            ),
            ) 
          ),

          // Arrow Button
          const SizedBox(height: 20.0),
          AnimatedOpacity(
            opacity: 1, 
            duration: const Duration(seconds: 1),
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  _handleSignIn();

                  Navigator.pushReplacement(context, 
                  MaterialPageRoute(
                    builder: (context) => const MainScreen(), 
                  ));
                }
              },
              child: const Text('Confirm Registration')
            )
          )
        ],
      ),
    );
  }

  /*
  This is for debugging purposes
  */
  void _showUserInfo(String name, String fraternity, Timestamp createdAt, String phrase, bool isRushChair, bool authorized) { 
    showDialog( 
      context: context,
      builder: (BuildContext context) {
        return AlertDialog( 
          title: const Text("User Information"), 
          content: Column( 
            crossAxisAlignment: CrossAxisAlignment.start, 
            mainAxisSize: MainAxisSize.min, 
            children: [ 
              Text("Name: $name"),
              Text("Fraternity: $fraternity"),
              Text("Created At: ${createdAt.toDate()}"),
              Text("Phrase: $phrase"),
              Text("Is Rush Chair: ${isRushChair ? 'Yes' : 'No'}"),
              Text("Authorized: ${authorized ? 'Yes' : 'No'}"),
            ],
          ),

          actions: <Widget>[ 
            TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
        )],
        );
      }
    );
  }
}

