import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:socialdirect_app/models/normalUser.dart';
import 'package:socialdirect_app/testing_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as Im;

class CreateNormalUser extends StatefulWidget {
  final String email;
  CreateNormalUser({this.email});
  @override
  _CreateNormalUserState createState() => _CreateNormalUserState();
}

class _CreateNormalUserState extends State<CreateNormalUser> {
  var _fromKey = GlobalKey<FormState>();
  final DateTime timestamp = DateTime.now();
  final CollectionReference usersRef = Firestore.instance.collection('users');
  final StorageReference storageRef = FirebaseStorage.instance.ref();
  String id = Uuid().v4();
  TextEditingController username = TextEditingController();
  TextEditingController displayName = TextEditingController();
  TextEditingController bio = TextEditingController();
  File file;
  bool isUploading = false;
  NormalUser normalCurrentUser;
  clearImage() {
    setState(() {
      file = null;
    });
  }

  handelCameraPhoto() async {
    Navigator.pop(context);
    File file = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 675, maxWidth: 960);
    setState(() {
      this.file = file;
    });
  }

  handelGalleryPhoto() async {
    Navigator.pop(context);
    File file = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 675, maxWidth: 960);
    setState(() {
      this.file = file;
    });
  }

  selectImage(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('Choose from sources'),
        children: <Widget>[
          SimpleDialogOption(
            child: FlatButton(
              onPressed: handelCameraPhoto,
              child: Text('Import from camera'),
            ),
          ),
          SimpleDialogOption(
            onPressed: handelGalleryPhoto,
            child: Text('Choose from gallery'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Future<void> compressedImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image imageFile = Im.decodeImage(file.readAsBytesSync());
    final compressedImage = File('$path/img_$id.jpg')
      ..writeAsBytesSync(
        Im.encodeJpg(imageFile, quality: 85),
      );
    setState(() {
      file = compressedImage;
    });
  }

  Future<String> uploadImage(File imageFile) async {
    StorageUploadTask uploadTask =
        storageRef.child('img/$id.jpg').putFile(imageFile);
    StorageTaskSnapshot storageSnapshot = await uploadTask.onComplete;
    String downloadUrl = await storageSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  createUserInFireStore({
    @required String photoUrl,
    @required String username,
    @required String displayName,
    @required String bio,
  }) async {
    DocumentSnapshot doc = await usersRef.document(id).get();
    if (!doc.exists) {
      usersRef.document(id).setData({
        'id': id,
        'username': username,
        'bio': bio,
        'displayName': displayName,
        'email': widget.email,
        'photoUrl': photoUrl,
        'timestamp': timestamp,
      });
      doc = await usersRef.document(id).get();
    }
    setState(() {
      normalCurrentUser = NormalUser.fromDocument(doc);
    });
  }

  handelSubmit() async {
    setState(() {
      isUploading = true;
    });
    await compressedImage();
    String mediaUrl = await uploadImage(file);
    await createUserInFireStore(
        photoUrl: mediaUrl,
        bio: bio.text,
        username: username.text,
        displayName: displayName.text);
    bio.clear();
    username.clear();
    displayName.clear();
    setState(() {
      file = null;
      isUploading = false;
      id = Uuid().v4();
    });
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TestingAuth(
            username: normalCurrentUser.username,
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Form(
          key: _fromKey,
          child: ListView(
            children: <Widget>[
              isUploading
                  ? LinearProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.purple),
                      backgroundColor: Colors.white,
                    )
                  : Text(''),
              file == null ? splashUpload() : formUpload(),
              SizedBox(
                height: 7,
              ),
              TextFormField(
                controller: username,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Can not be empty ';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(
                      width: 1.0,
                      color: Colors.blue,
                    ),
                  ),
                  hintText: 'username',
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: displayName,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Can not be empty';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(
                      width: 1.0,
                      color: Colors.blue,
                    ),
                  ),
                  hintText: 'Display Name',
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: bio,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Can not be empty ';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(
                      width: 1.0,
                      color: Colors.blue,
                    ),
                  ),
                  hintText: 'Bio',
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 50),
                child: RaisedButton(
                  color: Colors.blueAccent,
                  onPressed: isUploading
                      ? null
                      : () async {
                          await handelSubmit();
                        },
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget splashUpload() {
    return GestureDetector(
      onTap: () => selectImage(context),
      child: CircleAvatar(
        backgroundColor: Colors.black54,
        radius: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.add),
            Text('Click to add photo'),
          ],
        ),
      ),
    );
  }

  Widget formUpload() {
    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 100,
          backgroundImage: FileImage(file),
        ),
        SizedBox(
          height: 7,
        ),
        FlatButton(
          onPressed: clearImage,
          child: Text(
            'Clear Image',
            style: TextStyle(fontSize: 20, color: Colors.blueAccent),
          ),
        ),
      ],
    );
  }
}
