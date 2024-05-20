import 'package:flutter/material.dart';
import 'package:text_scan_ia/models/question.dart';
import 'package:text_scan_ia/services/geminie_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _image;
  List<Question> questions = [];
  TextEditingController questionController = TextEditingController();

  void addQuestion(Question question) {
    setState(() {
      questions.add(question);
    });
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        questions.add(Question("IA", "waiting for answer"));
      });
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0XFF424A59),
        centerTitle: true,
        title: const Text(
          "Gemini chat",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: MediaQuery.sizeOf(context).height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (BuildContext context, int index) {
                  return Align(
                    alignment: questions[index].author == "ME"
                        ? Alignment.topRight
                        : Alignment.topLeft,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (questions[index].author == "ME" && _image != null)
                          Container(
                            margin: const EdgeInsets.all(5),
                            width: MediaQuery.sizeOf(context).width * 0.4,
                            height: 200,
                            decoration: BoxDecoration(
                                image:
                                    DecorationImage(image: FileImage(_image!))),
                          ),
                        Container(
                          margin: const EdgeInsets.all(5),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: questions[index].author == "ME"
                                  ? Colors.white
                                  : const Color(0XFF424A59),
                              borderRadius: questions[index].author == "ME"
                                  ? const BorderRadius.only(
                                      topRight: Radius.circular(12),
                                      topLeft: Radius.circular(15),
                                      bottomLeft: Radius.circular(15))
                                  : const BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(15),
                                      bottomRight: Radius.circular(15))),
                          child: Text(
                            questions[index].text!,
                            style: TextStyle(
                                color: questions[index].author == "ME"
                                    ? Colors.black
                                    : Colors.white),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                // padding: const EdgeInsets.only(left: 20),
                width: MediaQuery.sizeOf(context).width * 0.95,
                // height: MediaQuery.sizeOf(context).height * 0.07,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: const Color(0XFF424A59)),
                child: Column(
                  children: [
                    if (_image != null)
                      Container(
                        margin: const EdgeInsets.all(10),
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                            image: DecorationImage(image: FileImage(_image!))),
                      ),
                    TextField(
                      controller: questionController,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: () async {
                                addQuestion(
                                    Question("ME", questionController.text));
                                // Question? response = await GeminieService()
                                //     .showResponse(
                                //         questionController.text, _image!.path);
                                // if (response != null) {
                                //   addQuestion(response);
                                // }
                                _image!.delete();
                                questionController.clear();
                                print(questions.length);
                              },
                              icon: const Icon(
                                Icons.send,
                                color: Color(0XFFAEB5BF),
                              )),
                          prefixIcon: IconButton(
                              onPressed: () {
                                _pickImage();
                              },
                              icon: const Icon(
                                Icons.photo,
                                color: Color(0xffAEB5BF),
                              )),
                          border: InputBorder.none,
                          hintText: 'Entrez la question...',
                          hintStyle: const TextStyle(color: Color(0xffAEB5BF))),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
