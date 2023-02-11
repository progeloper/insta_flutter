import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_flutter/models/user.dart';
import 'package:insta_flutter/providers/user_provider.dart';
import 'package:insta_flutter/resources/firestore_methods.dart';
import 'package:insta_flutter/utils/colors.dart';
import 'package:insta_flutter/utils/utils.dart';
import 'package:insta_flutter/widgets/text_field_input.dart';
import 'package:provider/provider.dart';

import '../utils/global_variables.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  final TextEditingController _captionController = TextEditingController();
  bool _isLoading = false;

  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Select a post'),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Select from gallery'),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  clearImage() {
    _captionController.clear();
    setState(() {
      _file = null;
    });
  }

  void postImage(String uid, String username, String profilePhotoUrl) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FirestoreMethods().uploadPost(
          _captionController.text, uid, _file!, username, profilePhotoUrl);
      _captionController.clear();
      setState(() {
        _isLoading = false;
      });
      if (res == 'success') {
        showSnackBar(context, 'Posted successfully!');
        clearImage();
      } else {
        showSnackBar(context, res);
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _captionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;

    return (_file == null)
        ? Center(
            child: IconButton(
              onPressed: () {
                _selectImage(context);
              },
              icon: Icon(
                Icons.upload_file,
                color: primaryColor,
              ),
            ),
          )
        : Scaffold(
            appBar: MediaQuery.of(context).size.width > webScreenSize
                ? null
                : AppBar(
                    elevation: 3.0,
                    backgroundColor: mobileBackgroundColor,
                    centerTitle: false,
                    leading: IconButton(
                      onPressed: clearImage,
                      icon: const Icon(
                        Icons.arrow_back,
                        color: primaryColor,
                      ),
                    ),
                    title: const Text('Post to'),
                    actions: [
                      TextButton(
                        onPressed: () => postImage(
                            user!.uid, user.username, user.profilePhotoUrl),
                        child: const Text(
                          'Post',
                          style: TextStyle(
                            color: blueColor,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ],
                  ),
            backgroundColor: MediaQuery.of(context).size.width > webScreenSize
                ? webBackgroundColor
                : mobileBackgroundColor,
            body: Column(
              children: [
                _isLoading
                    ? LinearProgressIndicator()
                    : Padding(padding: EdgeInsets.only(top: 0)),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(user!.profilePhotoUrl),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: TextField(
                        controller: _captionController,
                        decoration: const InputDecoration(
                          hintText: 'Write a caption...',
                          hintStyle: TextStyle(
                            color: secondaryColor,
                          ),
                          border: InputBorder.none,
                        ),
                        maxLines: 8,
                      ),
                    ),
                    SizedBox(
                      height: 45,
                      width: 45,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: MemoryImage(
                                _file!,
                              ),
                              fit: BoxFit.fill,
                              alignment: FractionalOffset.topCenter,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Divider(),
                  ],
                ),
              ],
            ),
          );
  }
}
