import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:studie/constants/agora.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';
import 'package:studie/models/agora_user.dart';
import 'package:studie/models/room.dart';
import 'package:studie/models/user.dart';
import 'package:studie/providers/room_provider.dart';
import 'package:studie/providers/room_settings_provider.dart';
import 'package:studie/providers/user_provider.dart';
import 'package:studie/screens/loading_screen/loading_screen.dart';
import 'package:studie/utils/show_snack_bar.dart';
import 'package:studie/widgets/auth/auth_text_button.dart';

const channelName = "tadyuh";

class CameraViewPage extends ConsumerStatefulWidget {
  const CameraViewPage({Key? key}) : super(key: key);

  @override
  ConsumerState<CameraViewPage> createState() => _State();
}

class _State extends ConsumerState<CameraViewPage>
    with AutomaticKeepAliveClientMixin {
  final RtcEngine _engine = createAgoraRtcEngine();
  late final UserModel _user;
  late final Room _room;

  bool _isReadyPreview = false, _permissionsGranted = true;
  bool isJoined = false, switchCamera = true, switchRender = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _user = ref.read(userProvider).user;
    _room = ref.read(roomProvider).room!;

    _requestPermissions();
    _initEngine();
  }

  @override
  void dispose() {
    super.dispose();
    _dispose();
  }

  Future<void> _dispose() async {
    await _engine.leaveChannel();
    await _engine.release();
    await FirebaseFirestore.instance
        .collection("rooms")
        .doc(_room.id)
        .collection("agoraUsers")
        .doc(_user.uid)
        .delete();
  }

  Future<void> _initEngine() async {
    await _engine.initialize(const RtcEngineContext(appId: appId));
    await _engine.leaveChannel();
    await _engine
        .setChannelProfile(ChannelProfileType.channelProfileCommunication);
    _registerEventHandlers();

    await _engine.setVideoEncoderConfiguration(
      const VideoEncoderConfiguration(
        dimensions: VideoDimensions(width: 360, height: 360),
        frameRate: 15,
        bitrate: 0,
      ),
    );
    await _engine.enableAudio();
    await _engine.enableVideo();
    await _engine.muteLocalAudioStream(true);
    await _engine.muteLocalVideoStream(true);
    await _settingsCall();

    await _engine.startPreview();
    setState(() => _isReadyPreview = true);
    await _joinChannel();
  }

  Future<void> _joinChannel() async {
    await _engine.joinChannel(
      token: _room.rtcToken,
      channelId: _room.hostUid,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  Future<void> onSwitchCameraTap() async {
    await _engine.switchCamera();
    ref.read(roomSettingsProvider).updateSwitchCamera();
  }

  Future<void> onCameraTap() async {
    final cameraEnabled = ref.read(roomSettingsProvider).cameraEnabled;
    if (cameraEnabled) {
      await _engine.muteLocalVideoStream(true);
    } else {
      await _engine.muteLocalVideoStream(false);
    }
    ref.read(roomSettingsProvider).updateCamera();
  }

  Future<void> onMicTap() async {
    final micEnabled = ref.read(roomSettingsProvider).micEnabled;
    if (micEnabled) {
      await _engine.muteLocalAudioStream(true);
    } else {
      await _engine.muteLocalAudioStream(false);
    }
    ref.read(roomSettingsProvider).updateMic();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (!_permissionsGranted) _buildRequestPermissions();
    if (!_isReadyPreview) return const LoadingScreen();

    final roomSettings = ref.watch(roomSettingsProvider);
    final size = MediaQuery.of(context).size;
    final videoWidth = size.width - kDefaultPadding;
    final videoHeight = videoWidth * 9 / 16;

    return Container(
      color: kBlack,
      padding: const EdgeInsets.all(kMediumPadding),
      child: Stack(
        children: [
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("rooms")
                  .doc(_room.id)
                  .collection("agoraUsers")
                  .snapshots(),
              builder: (context, snapshots) {
                if (snapshots.hasData) {
                  final agoraUsers =
                      List<AgoraUser>.from(snapshots.data!.docs.map(
                    (e) => AgoraUser.fromJson(e.data()),
                  ));

                  if (isJoined) {
                    return ListView.builder(
                      itemCount: agoraUsers.length,
                      shrinkWrap: true,
                      itemBuilder: (context, i) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: kMediumPadding),
                          decoration: const BoxDecoration(
                            color: kWhite,
                            image: DecorationImage(
                              image: AssetImage("assets/logo.png"),
                            ),
                          ),
                          width: videoWidth,
                          height: videoHeight,
                          child: Stack(
                            children: [
                              if (!(agoraUsers[i].name == _user.username &&
                                  !roomSettings.cameraEnabled))
                                AgoraVideoView(
                                  controller: VideoViewController.remote(
                                    rtcEngine: _engine,
                                    canvas: VideoCanvas(
                                      uid: agoraUsers[i].name == _user.username
                                          ? 0
                                          : agoraUsers[i].localUid,
                                    ),
                                    connection: RtcConnection(
                                      channelId: _room.hostUid,
                                    ),
                                  ),
                                ),
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: Container(
                                  padding: const EdgeInsets.all(kSmallPadding),
                                  decoration: BoxDecoration(
                                    color: kBlack.withOpacity(0.8),
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(5),
                                    ),
                                  ),
                                  child: Text(
                                    agoraUsers[i].name,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: kWhite,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                }
                return const LoadingScreen();
              }),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: kDefaultPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _CallButton(
                    onTap: onCameraTap,
                    disabledIcon: Icons.videocam_off_rounded,
                    enabledIcon: Icons.videocam_rounded,
                    enabled: roomSettings.cameraEnabled,
                  ),
                  const SizedBox(width: kDefaultPadding),
                  _CallButton(
                    onTap: onMicTap,
                    disabledIcon: Icons.mic_off_rounded,
                    enabledIcon: Icons.mic_rounded,
                    enabled: roomSettings.micEnabled,
                  ),
                  const SizedBox(width: kDefaultPadding),
                  _CallButton(
                    onTap: onSwitchCameraTap,
                    disabledIcon: Icons.switch_camera,
                    enabledIcon: Icons.switch_camera,
                    enabled: true,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRequestPermissions() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: SizedBox(
                width: double.infinity,
                child: SvgPicture.asset("assets/svgs/warning.svg"),
              ),
            ),
            const Text(
              "Không thể truy cập quyền...",
              textAlign: TextAlign.center,
              style: TextStyle(color: kBlack, fontSize: 16),
            ),
            const SizedBox(height: kDefaultPadding),
            CustomTextButton(
              text: "Thử lại",
              onTap: _initEngine,
              primary: true,
            ),
          ],
        ),
      ),
    );
  }

  //methods
  Future<void> _requestPermissions() async {
    final status = await [Permission.camera, Permission.microphone].request();
    status.forEach((key, value) {
      if (value != PermissionStatus.granted) {
        showSnackBar(
          context,
          "Không thể tham gia cuộc gọi khi ứng dụng không có quyền truy cập.",
        );
        _permissionsGranted = false;
        return setState(() {});
      }
    });
  }

  Future<void> _settingsCall() async {
    final roomSettings = ref.read(roomSettingsProvider);
    if (roomSettings.cameraEnabled) await _engine.muteLocalAudioStream(false);
    if (roomSettings.micEnabled) await _engine.muteLocalAudioStream(false);
    if (roomSettings.switchCamera) await _engine.switchCamera();
  }

  Future<void> updateUserList(RtcConnection connection) async {
    try {
      final newUser = AgoraUser(
        name: _user.username,
        localUid: connection.localUid!,
        photoUrl: _user.photoURL,
        cameraEnable: false,
        micEnable: false,
      );
      final room = FirebaseFirestore.instance.collection("rooms").doc(_room.id);
      final agoraUsers = room.collection("agoraUsers");
      await agoraUsers.doc(_user.uid).set(newUser.toJson());
    } catch (e) {
      print("error test: $e");
    }
  }

  void _registerEventHandlers() async {
    _engine.registerEventHandler(RtcEngineEventHandler(
      onError: (ErrorCodeType err, String msg) {
        debugPrint('[onError] err: $err, msg: $msg');
      },
      onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        debugPrint(
            '[onJoinChannelSuccess] connection: ${connection.toJson()} elapsed: $elapsed');
        updateUserList(connection);
        setState(() => isJoined = true);
      },
      onUserJoined: (RtcConnection connection, int rUid, int elapsed) {
        debugPrint(
            '[onUserJoined] connection: ${connection.toJson()} remoteUid: $rUid elapsed: $elapsed');
        setState(() {});
      },
      onUserOffline:
          (RtcConnection connection, int rUid, UserOfflineReasonType reason) {
        debugPrint(
            '[onUserOffline] connection: ${connection.toJson()}  rUid: $rUid reason: $reason');
      },
      onLeaveChannel: (RtcConnection connection, RtcStats stats) {
        debugPrint(
            '[onLeaveChannel] connection: ${connection.toJson()} stats: ${stats.toJson()}');
        setState(() => isJoined = true);
      },
    ));
  }
}

class _CallButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData disabledIcon;
  final IconData enabledIcon;
  final bool enabled;
  const _CallButton({
    Key? key,
    required this.disabledIcon,
    required this.onTap,
    required this.enabled,
    required this.enabledIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.hardEdge,
      borderRadius: const BorderRadius.all(Radius.circular(50)),
      color: enabled ? kPrimaryColor : kWhite,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(kMediumPadding),
          child: Icon(
            enabled ? enabledIcon : disabledIcon,
            color: enabled ? kWhite : kBlack,
            size: kIconSize,
          ),
        ),
      ),
    );
  }
}
