import 'package:flutter/material.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';
import 'package:studie/screens/create_room_screen/widgets/create_room_input.dart';
import 'package:studie/screens/home_screen/home_screen.dart';
import 'package:studie/widgets/custom_text_button.dart';

class CreateRoomScreen extends StatefulWidget {
  static const routeName = 'create';
  const CreateRoomScreen({super.key});

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _numParticipantsController = TextEditingController();

  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: renderAppBar(context),
      body: Stepper(
        currentStep: _currentStep,
        elevation: 0,
        margin: const EdgeInsets.all(0),
        type: StepperType.horizontal,
        onStepContinue: () {
          if (_currentStep < 2) setState(() => _currentStep++);
        },
        onStepCancel: () {
          if (_currentStep > 0) setState(() => _currentStep--);
        },
        controlsBuilder: (context, details) => Padding(
          padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
          child: Row(
            children: [
              if (_currentStep > 0)
                CustomTextButton(
                  text: 'Trở lại',
                  onTap: details.onStepCancel!,
                  primary: false,
                ),
              const Spacer(),
              CustomTextButton(
                text: 'Tiếp',
                onTap: details.onStepContinue!,
                primary: true,
              ),
            ],
          ),
        ),
        steps: [
          Step(
            isActive: _currentStep >= 0,
            title: const Text('Cơ bản'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CreateRoomInput(
                  title: 'TÊN PHÒNG HỌC',
                  hintText: 'Chủ đề, môn học...',
                  controller: _nameController,
                ),
                const SizedBox(height: kDefaultPadding),
                CreateRoomInput(
                  title: 'Số lượng người tham gia',
                  hintText: '',
                  controller: _numParticipantsController,
                  type: 'number',
                ),
                const SizedBox(height: kDefaultPadding),
                CreateRoomInput(
                  title: 'MÔ TẢ',
                  hintText: 'Cùng học nào!',
                  controller: _descriptionController,
                ),
              ],
            ),
          ),
          Step(
            isActive: _currentStep >= 1,
            title: Text('Giao tiếp'),
            content: Container(
              height: 50,
              width: 50,
              color: kPrimaryColor,
            ),
          ),
          Step(
            isActive: _currentStep == 2,
            title: Text('Trang trí'),
            content: Container(
              height: 50,
              width: 50,
              color: kPrimaryColor,
            ),
          ),
        ],
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
              icon: const Icon(
                Icons.arrow_back,
                color: kBlack,
              ),
            ),
            const SizedBox(width: kDefaultPadding),
            const Text(
              'Tạo phòng học',
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: kBlack),
            ),
            const Spacer(),
            IconButton(
              splashRadius: 25,
              onPressed: () {},
              icon: const Icon(Icons.done, color: kPrimaryColor),
            ),
          ],
        ),
      ),
    );
  }
}
