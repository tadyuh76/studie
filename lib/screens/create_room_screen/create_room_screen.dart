import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studie/constants/banner_colors.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';
import 'package:studie/constants/tags_with_icons.dart';
import 'package:studie/models/room.dart';
import 'package:studie/providers/room_provider.dart';
import 'package:studie/screens/create_room_screen/widgets/checkbox_option.dart';
import 'package:studie/screens/room_screen/room_screen.dart';
import 'package:studie/services/db_methods.dart';
import 'package:studie/widgets/auth_text_button.dart';
import 'package:studie/widgets/form/form_title.dart';
import 'package:studie/widgets/form/number_input.dart';
import 'package:studie/widgets/form/pomodoro_setting.dart';
import 'package:studie/widgets/form/text_input.dart';

class CreateRoomScreen extends StatefulWidget {
  static const routeName = 'create';
  const CreateRoomScreen({super.key});

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  final _dbMethods = DBMethods();

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _maxParticipantsController = TextEditingController();
  bool micEnable = false;
  bool cameraEnable = false;
  bool chatEnable = true;
  String pomodoroType = 'pomodoro_50';
  List<String> selectedTags = [];
  String bannerColor = 'red';

  int _currentStep = 0;

  onTagSelect(String tagText) {
    if (selectedTags.contains(tagText)) {
      selectedTags.remove(tagText);
    } else if (selectedTags.length >= 3) {
      selectedTags.removeLast();
      selectedTags.add(tagText);
    } else {
      selectedTags.add(tagText);
    }
    setState(() {});
  }

  onCreateRoom(BuildContext context, WidgetRef ref) {
    final room = Room(
      name: _nameController.text,
      bannerColor: bannerColor,
      description: _descriptionController.text,
      tags: selectedTags,
      maxParticipants: int.parse(_maxParticipantsController.text),
      curParticipants: 0,
      type: 'public',
      hostPhotoUrl:
          'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80',
    );

    _dbMethods.createRoom(room).then((value) {
      _dbMethods.joinRoom(room.id);
      ref.read(roomProvider).changeRoom(room);

      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => RoomScreen(room: room),
      ));
    });
  }

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
          FocusManager.instance.primaryFocus?.unfocus();
        },
        onStepCancel: () {
          if (_currentStep > 0) setState(() => _currentStep--);
          FocusManager.instance.primaryFocus?.unfocus();
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
              if (_currentStep < 2)
                CustomTextButton(
                  text: 'Tiếp',
                  onTap: details.onStepContinue!,
                  primary: true,
                )
              else
                Consumer(
                  builder: (context, ref, child) => CustomTextButton(
                    text: 'Hoàn tất',
                    onTap: () => onCreateRoom(context, ref),
                    primary: true,
                  ),
                )
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
                NumberInput(
                  title: 'Số lượng người tham gia',
                  hintText: '',
                  controller: _maxParticipantsController,
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
            title: const Text('Chức năng'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const FormTitle(title: 'Cài đặt thiết bị'),
                const SizedBox(height: kMediumPadding),
                CheckBoxOption(
                  enabled: micEnable,
                  icon: Icons.mic_rounded,
                  text: 'Cho phép Mic',
                ),
                const SizedBox(height: kMediumPadding),
                CheckBoxOption(
                  text: 'Cho phép Camera',
                  icon: Icons.videocam_rounded,
                  enabled: cameraEnable,
                ),
                const SizedBox(height: kMediumPadding),
                CheckBoxOption(
                  text: 'Cho phép Chat',
                  icon: Icons.chat_rounded,
                  enabled: chatEnable,
                ),
                const SizedBox(height: kDefaultPadding),
                PomodoroSetting(pomodoroType: pomodoroType)
              ],
            ),
          ),
          Step(
            isActive: _currentStep == 2,
            title: const Text('Trang trí'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const FormTitle(title: 'Thẻ', optional: true),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        'Chọn tối đa 3 thẻ để miêu tả chủ đề phòng học của bạn tốt hơn.',
                        style: TextStyle(
                          color: kBlack,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: kDefaultPadding),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: selectedTags.length.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: kBlack,
                            ),
                          ),
                          const TextSpan(
                            text: '/3',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: kDarkGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Wrap(
                  children: tagsWithIcons.map(
                    (tag) {
                      final selected = selectedTags.contains(tag['text']);

                      return AnimatedContainer(
                        duration: const Duration(microseconds: 200),
                        child: GestureDetector(
                          onTap: () => onTagSelect(tag['text']!),
                          child: Container(
                            padding: const EdgeInsets.all(kMediumPadding),
                            margin: const EdgeInsets.only(
                              right: kMediumPadding,
                              top: kMediumPadding,
                            ),
                            decoration: BoxDecoration(
                              color: selected ? kPrimaryColor : kLightGrey,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Text(
                              tag['text']!,
                              style: TextStyle(
                                color: selected ? kWhite : kDarkGrey,
                                fontWeight: selected ? FontWeight.bold : null,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ).toList(),
                ),
                const SizedBox(height: kDefaultPadding),
                const FormTitle(title: 'Màu ảnh bìa'),
                const SizedBox(height: kMediumPadding),
                SizedBox(
                  height: 50,
                  child: Row(
                    children: bannerColors
                        .map((colorName, color) {
                          final selected = bannerColor == colorName;
                          return MapEntry(
                            colorName,
                            GestureDetector(
                              onTap: () =>
                                  setState(() => bannerColor = colorName),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  right: kMediumPadding,
                                ),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  height: selected ? 50 : 30,
                                  width: selected ? 50 : 30,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: color,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(50),
                                      ),
                                    ),
                                    child: selected
                                        ? const Icon(
                                            Icons.check_rounded,
                                            color: kWhite,
                                            size: 24,
                                          )
                                        : null,
                                  ),
                                ),
                              ),
                            ),
                          );
                        })
                        .values
                        .toList(),
                  ),
                ),
              ],
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
              onPressed: Navigator.of(context).pop,
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
