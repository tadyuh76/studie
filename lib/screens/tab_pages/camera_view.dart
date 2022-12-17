import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:studie/constants/agora.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';
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
  List<int> remoteUids = [];
  Map<int, String> participantNames = {};

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
  }

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
    if (roomSettings.cameraEnabled) await _engine.enableVideo();
    if (roomSettings.micEnabled) await _engine.enableAudio();
    if (roomSettings.switchCamera) await _engine.switchCamera();
  }

  void _registerEventHandlers() {
    _engine.registerEventHandler(RtcEngineEventHandler(
      onError: (ErrorCodeType err, String msg) {
        debugPrint('[onError] err: $err, msg: $msg');
      },
      onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        debugPrint("joined successfully, id: ${connection.localUid}");
        debugPrint(
            '[onJoinChannelSuccess] connection: ${connection.toJson()} elapsed: $elapsed');
        setState(() {
          participantNames[connection.localUid!] = _user.username;
          isJoined = true;
        });
      },
      onUserJoined: (RtcConnection connection, int rUid, int elapsed) {
        debugPrint(
            '[onUserJoined] connection: ${connection.toJson()} remoteUid: $rUid elapsed: $elapsed');
        setState(() {
          remoteUids.add(rUid);
        });
      },
      onUserOffline:
          (RtcConnection connection, int rUid, UserOfflineReasonType reason) {
        debugPrint(
            '[onUserOffline] connection: ${connection.toJson()}  rUid: $rUid reason: $reason');
        setState(() {
          remoteUids.removeWhere((element) => element == rUid);
        });
      },
      onLeaveChannel: (RtcConnection connection, RtcStats stats) {
        debugPrint(
            '[onLeaveChannel] connection: ${connection.toJson()} stats: ${stats.toJson()}');
        setState(() {
          isJoined = false;
          remoteUids.clear();
        });
      },
    ));
  }

  Future<void> _initEngine() async {
    await _engine.initialize(const RtcEngineContext(appId: appId));
    await _engine.leaveChannel();
    _registerEventHandlers();

    await _engine.setVideoEncoderConfiguration(
      const VideoEncoderConfiguration(
        dimensions: VideoDimensions(width: 640, height: 360),
        frameRate: 15,
        bitrate: 0,
      ),
    );
    // await _engine.disableAudio();
    // await _engine.disableVideo();
    await _engine.enableAudio();
    await _engine.enableVideo();
    await _engine.startPreview();
    setState(() => _isReadyPreview = true);

    await _settingsCall();
    await _joinChannel();
  }

  Future<void> _joinChannel() async {
    print("remote uid: $remoteUids");
    await _engine.joinChannel(
      token: tempToken,
      channelId: channelName,
      uid: _room.curParticipants,
      options: ChannelMediaOptions(
        clientRoleType: remoteUids.isEmpty
            ? ClientRoleType.clientRoleBroadcaster
            : ClientRoleType.clientRoleAudience,
      ),
    );
  }

  Future<void> onSwitchCameraTap() async {
    await _engine.switchCamera();
    ref.read(roomSettingsProvider).updateSwitchCamera();
  }

  Future<void> onCameraTap() async {
    final cameraEnabled = ref.read(roomSettingsProvider).cameraEnabled;
    // await _engine.muteLocalVideoStream(cameraEnabled);
    ref.read(roomSettingsProvider).updateCamera();
  }

  Future<void> onMicTap() async {
    final micEnabled = ref.read(roomSettingsProvider).micEnabled;
    // await _engine.muteLocalAudioStream(micEnabled);
    ref.read(roomSettingsProvider).updateMic();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final roomSettings = ref.watch(roomSettingsProvider);

    if (!_permissionsGranted) {
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

    final size = MediaQuery.of(context).size;
    final videoWidth = size.width - kDefaultPadding;
    final videoHeight = videoWidth * 9 / 16;

    if (!_isReadyPreview) return const LoadingScreen();
    return Container(
      color: kBlack,
      padding: const EdgeInsets.all(kMediumPadding),
      child: Stack(
        children: [
          Column(
            children: [
              if (isJoined)
                SizedBox(
                  height: videoHeight,
                  width: videoWidth,
                  child: Stack(
                    children: [
                      AgoraVideoView(
                        controller: VideoViewController(
                          rtcEngine: _engine,
                          canvas: const VideoCanvas(uid: 0),
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
                            _user.username,
                            style: const TextStyle(fontSize: 12, color: kWhite),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              Align(
                alignment: Alignment.topLeft,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.of(remoteUids.map(
                      (e) => Padding(
                        padding: const EdgeInsets.only(top: kMediumPadding),
                        child: SizedBox(
                          width: videoWidth,
                          height: videoHeight,
                          child: Stack(
                            children: [
                              AgoraVideoView(
                                controller: VideoViewController.remote(
                                  rtcEngine: _engine,
                                  canvas: VideoCanvas(uid: e),
                                  connection: const RtcConnection(
                                    channelId: channelName,
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
                                    participantNames[e]!,
                                    style: const TextStyle(
                                        fontSize: 12, color: kWhite),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )),
                  ),
                ),
              ),
            ],
          ),
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
