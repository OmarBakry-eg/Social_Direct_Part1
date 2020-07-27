import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:socialdirect_app/models/user.dart';
import 'package:uuid/uuid.dart';
import 'package:image/image.dart' as Im;

class AddPost extends StatefulWidget {
  final User currentUser;
  AddPost({@required this.currentUser});
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final StorageReference storageRef = FirebaseStorage.instance.ref();
  TextEditingController captionController = TextEditingController();
  final CollectionReference postRef = Firestore.instance.collection('posts');
  File file;
  String postId = Uuid().v4();
  bool isUploading = false;
  DateTime timestamp = DateTime.now();

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

  Future<void> compressedImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image imageFile = Im.decodeImage(file.readAsBytesSync());
    final compressedImage = File('$path/post_img_$postId.jpg')
      ..writeAsBytesSync(
        Im.encodeJpg(imageFile, quality: 85),
      );
    setState(() {
      file = compressedImage;
    });
  }

  Future<String> uploadImage(File imageFile) async {
    StorageUploadTask uploadTask =
        storageRef.child('post_img/$postId.jpg').putFile(imageFile);
    StorageTaskSnapshot storageSnapshot = await uploadTask.onComplete;
    String downloadUrl = await storageSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  createUserInFireStore({String mediaUrl, String description}) {
    postRef
        .document(widget.currentUser.id)
        .collection('userPosts')
        .document(postId)
        .setData({
      'postId': postId,
      'ownerId': widget.currentUser.id,
      'username': widget.currentUser.username,
      'mediaUrl': mediaUrl,
      'description': description,
      'timestamp': Timestamp.now(),
      'likes': {},
    });
  }

  handelSubmit() async {
    setState(() {
      isUploading = true;
    });
    await compressedImage();
    String mediaUrl = await uploadImage(file);
    createUserInFireStore(
      mediaUrl: mediaUrl,
      description: captionController.text,
    );
    captionController.clear();
    setState(() {
      file = null;
      isUploading = false;
      postId = Uuid().v4();
    });
  }

  Widget buildSplashUpload() {
    return Center(
      child: RaisedButton(
        onPressed: () => selectImage(context),
        child: Text('Upload Post'),
      ),
    );
  }

  buildUploadForm() {
    return ListView(
      children: <Widget>[
        isUploading
            ? LinearProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.purple),
                backgroundColor: Colors.white,
              )
            : Text(''),
        formUpload(),
        SizedBox(
          height: 7,
        ),
        TextFormField(
          controller: captionController,
          validator: (value) {
            if (value.isEmpty) {
              return 'Cannot be empty ';
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
            hintText: 'Caption..',
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 50),
          child: RaisedButton(
            color: Colors.blueAccent,
            onPressed: file == null
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
    );
  }

  Widget formUpload() {
    return Column(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.7,
          height: 220,
          child: Center(
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: FileImage(file),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: file == null ? buildSplashUpload() : buildUploadForm(),
    );
  }
}
