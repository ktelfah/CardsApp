import 'dart:io';

import 'package:cards_app/bloc/cards_bloc.dart';
import 'package:cards_app/bloc/cards_event.dart';
import 'package:cards_app/bloc/cards_state.dart';
import 'package:cards_app/helper/custom_text_form_field.dart';
import 'package:cards_app/main.dart';
import 'package:cards_app/screens/add_admin_customer_cards.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class AddVendor extends StatefulWidget {
  final adminIdget;

  const AddVendor({Key key, this.adminIdget}) : super(key: key);

  @override
  _AddVendorState createState() => _AddVendorState(adminIdget);
}

class _AddVendorState extends State<AddVendor> {
  final adminIdget;
  final formKey = GlobalKey<FormState>();
  final nameNode = FocusNode();
  final iconNode = FocusNode();
  final addressNode1 = FocusNode();
  final addressNode2 = FocusNode();
  final zipcodeNode = FocusNode();
  final countyNode = FocusNode();
  String name = "",
      icon = "",
      address1 = "",
      address2 = "",
      zipcode = "",
      county = "";
  XFile _image;
  XFile selectedImage;
  String downloadUrl;

  _AddVendorState(this.adminIdget);

  Future uploadImage() async {
    final _firebaseStorage = FirebaseStorage.instance;
    var file = File(selectedImage.path);
    //Upload to Firebase
    var snapshot = await _firebaseStorage
        .ref()
        .child('icons/imageName/${DateTime.now()}/')
        .putFile(file);
    downloadUrl = await snapshot.ref.getDownloadURL();
  }

  _imgFromGallery() async {
    selectedImage = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (selectedImage != null) {
      setState(() {
        _image = selectedImage;
      });
    } else {
      print("image not selected");
    }
  }

  @override
  void initState() {
    BlocProvider.of<FirebaseBloc>(context).add(ResetAddVendor());
    super.initState();
  }

  String type = "Prepaid";
  @override
  var val = 1;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop();
        BlocProvider.of<FirebaseBloc>(context).add(ResetFetchCustomer());
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFFF2562),
          title: Text("Add Vendor"),
        ),
        //body: body(context)
        body: BlocBuilder<FirebaseBloc, FirebaseState>(
          builder: (context, state) {
            print("STATE:$state");
            if (state is AddVendorEmpty) {
              return Container(
                child: body(context),
              );
            }

            if (state is AddVendorError) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                    "Invalid Data",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        height: 3.0,
                        fontSize: 20),
                  ),
                  backgroundColor: Colors.red,
                ));
              });
              return Container(
                child: body(context),
              );
            }

            if (state is AddVendorLoaded) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  behavior: SnackBarBehavior.floating,
                  content: Text(
                    "Vendor Added Successfully",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor: Colors.black,
                ));

                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                        value: BlocProvider.of<FirebaseBloc>(context),
                        child: AddAdminCustomerCards())));
              });
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  Widget body(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: Column(
            children: [
              const SizedBox(height: 40.0),
              Text(
                "Add Vendor",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20.0),
              form(context),
              const SizedBox(
                height: 10.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Form form(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(children: [
        selectImage(),
        SizedBox(
          height: 20,
        ),
        CustomTextFormField(
          obscureText: false,
          textEditingController: TextEditingController(text: name),
          hintText: 'Name',
          icon: Icons.person,
          onFieldSubmitted: (String value) {},
          cursorColor: Color(0xFFFF2562),
          onChanged: (String value) {
            name = value;
          },
          keyboardType: TextInputType.name,
          focusNode: nameNode,
          nextNode: addressNode1,
          textInputAction: TextInputAction.next,
          validator: (String value) {
            if (value.isEmpty) {
              return 'Please Enter your Vendor name';
            }
          },
        ),
        SizedBox(
          height: 15,
        ),
        CustomTextFormField(
          obscureText: false,
          textEditingController: TextEditingController(text: address1),
          hintText: 'Address 1',
          icon: Icons.location_city,
          onFieldSubmitted: (String value) {},
          cursorColor: Color(0xFFFF2562),
          onChanged: (String value) {
            address1 = value;
          },
          keyboardType: TextInputType.text,
          focusNode: addressNode1,
          nextNode: addressNode2,
          textInputAction: TextInputAction.done,
          validator: (String value) {
            if (value.isEmpty) {
              return 'Please Enter your Vendor Address 1';
            }
          },
        ),
        SizedBox(
          height: 15,
        ),
        CustomTextFormField(
          obscureText: false,
          textEditingController: TextEditingController(text: address2),
          hintText: 'Address 2',
          icon: Icons.location_city,
          onFieldSubmitted: (String value) {},
          cursorColor: Color(0xFFFF2562),
          onChanged: (String value) {
            address2 = value;
          },
          keyboardType: TextInputType.text,
          focusNode: addressNode2,
          nextNode: zipcodeNode,
          textInputAction: TextInputAction.done,
          validator: (String value) {
            if (value.isEmpty) {
              return 'Please Enter your Vendor Address 2';
            }
          },
        ),
        SizedBox(
          height: 15,
        ),
        CustomTextFormField(
          obscureText: false,
          textEditingController: TextEditingController(text: zipcode),
          hintText: 'Zip Code',
          icon: Icons.location_city,
          onFieldSubmitted: (String value) {},
          cursorColor: Color(0xFFFF2562),
          onChanged: (String value) {
            zipcode = value;
          },
          keyboardType: TextInputType.text,
          focusNode: zipcodeNode,
          nextNode: countyNode,
          textInputAction: TextInputAction.done,
          validator: (String value) {
            if (value.isEmpty) {
              return 'Please Enter your Vendor Zipcode.';
            }
          },
        ),
        SizedBox(
          height: 15,
        ),
        CustomTextFormField(
          obscureText: false,
          textEditingController: TextEditingController(text: county),
          hintText: 'County',
          icon: Icons.location_city,
          onFieldSubmitted: (String value) {},
          cursorColor: Color(0xFFFF2562),
          onChanged: (String value) {
            county = value;
          },
          keyboardType: TextInputType.text,
          focusNode: countyNode,
          nextNode: iconNode,
          textInputAction: TextInputAction.done,
          validator: (String value) {
            if (value.isEmpty) {
              return 'Please Enter your Vendor County.';
            }
          },
        ),
        SizedBox(
          height: 15,
        ),
        radioButton(context),
        SizedBox(
          height: 20,
        ),
        addVendorButton(context),
        SizedBox(
          height: 20,
        ),
      ]),
    );
  }

  Widget radioButton(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ListTile(
          title: Text("Prepaid"),
          leading: Radio(
            value: 1,
            groupValue: val,
            onChanged: (value) {
              setState(() {
                type = "Prepaid";
                val = value;
                print(val);
                print(type);
              });
            },
            activeColor: Color(0xFFFF2562),
          ),
        ),
        ListTile(
          title: Text("Direct"),
          leading: Radio(
            value: 2,
            groupValue: val,
            onChanged: (value) {
              setState(() {
                type = "Direct";
                val = value;
                print(val);
                print(type);
              });
            },
            activeColor: Color(0xFFFF2562),
          ),
        ),
      ],
    );
  }

  Widget addVendorButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (formKey.currentState.validate()) {
          formKey.currentState.save();
          if (_image != null) {
            uploadImage().whenComplete(() {
              print("downloadUrl: $downloadUrl");
              BlocProvider.of<FirebaseBloc>(context).add(FetchAddVendor(
                '',
                getAdminIdUser,
                name,
                downloadUrl,
                address1,
                address2,
                zipcode,
                county,
                type,
              ));
            });
          } else {
            Scaffold.of(context)
                .showSnackBar(SnackBar(content: Text("Please Select Icon")));
          }
        }
      },
      child: Container(
        height: 50,
        decoration: BoxDecoration(
            color: Color(0xFFFF2562),
            borderRadius: BorderRadius.all(Radius.circular(4))),
        child: Center(
          child: Text(
            'ADD VENDOR',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15),
          ),
        ),
      ),
    );
  }

  Widget selectImage() {
    return GestureDetector(
      onTap: () {
        _showPicker(context);
      },
      child: CircleAvatar(
        radius: 55,
        backgroundColor: Color(0xFFFF2562),
        child: _image != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.file(
                  File(_image.path),
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              )
            : Container(
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(50)),
                width: 100,
                height: 100,
                child: Icon(
                  Icons.image,
                  color: Colors.grey[800],
                ),
              ),
      ),
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                ],
              ),
            ),
          );
        });
  }
}
