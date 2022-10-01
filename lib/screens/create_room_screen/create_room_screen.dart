import 'package:flutter/material.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';
import 'package:studie/screens/home_screen/home_screen.dart';

class CreateRoomScreen extends StatelessWidget {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _tagsController = TextEditingController();
  // final _nameController = TextEditingController();

  static const routeName = 'create';
  CreateRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: renderAppBar(context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: kMediumPadding),
            const Image(
              image: AssetImage('assets/images/placeholder.png'),
              fit: BoxFit.cover,
              width: double.infinity,
            ),
            const SizedBox(height: kDefaultPadding),
            CreateRoomField(
              title: 'TÊN PHÒNG HỌC',
              hintText: 'Chủ đề, môn học...',
              controller: _nameController,
            ),
            const SizedBox(height: kDefaultPadding),
            CreateRoomField(
              title: 'MÔ TẢ',
              hintText: 'Cùng học nào!',
              controller: _descriptionController,
            ),
            const SizedBox(height: kDefaultPadding),
            CreateRoomField(
              title: 'THẺ',
              hintText: 'Vật lý, Hóa học...',
              controller: _tagsController,
            ),
          ],
        ),
      ),
    );
  }

  AppBar renderAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      foregroundColor: kPrimaryColor,
      backgroundColor: kWhite,
      elevation: 0,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
        child: Row(
          children: [
            IconButton(
              splashRadius: 25,
              onPressed: () => Navigator.of(context)
                  .pushReplacementNamed(HomeScreen.routeName),
              icon: const Icon(Icons.arrow_back),
            ),
            const SizedBox(width: kDefaultPadding),
            const Text(
              'Tạo phòng học',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            IconButton(
              splashRadius: 25,
              onPressed: () {},
              icon: const Icon(Icons.done),
            ),
          ],
        ),
      ),
    );
  }
}

class CreateRoomField extends StatelessWidget {
  final String title;
  final String hintText;
  final TextEditingController controller;

  const CreateRoomField({
    Key? key,
    required this.title,
    required this.hintText,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: kDarkGrey,
            fontWeight: FontWeight.bold,
            fontSize: 12,
            letterSpacing: 1,
          ),
        ),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              color: kLightGrey,
              fontSize: 12,
              height: 1,
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: kPrimaryColor,
                width: 2,
                style: BorderStyle.solid,
              ),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: kPrimaryColor,
                width: 4,
                style: BorderStyle.solid,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
