// import 'package:agora_uikit/agora_uikit.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:studie/constants/agora.dart';
// import 'package:studie/models/user.dart';
// import 'package:studie/providers/user_provider.dart';
// import 'package:studie/screens/loading_screen/loading_screen.dart';
// import 'package:studie/utils/show_snack_bar.dart';

// class CameraViewPage extends ConsumerStatefulWidget {
//   const CameraViewPage({super.key});

//   @override
//   ConsumerState<CameraViewPage> createState() => _CameraViewPageState();
// }

// class _CameraViewPageState extends ConsumerState<CameraViewPage> {
//   bool loading = true;
//   late UserModel _user;
//   late AgoraClient client;

//   @override
//   void initState() {
//     super.initState();
//     _user = ref.read(userProvider).user;
//     client = AgoraClient(
//       agoraConnectionData: AgoraConnectionData(
//         appId: appId,
//         tempToken: tempToken,
//         channelName: channelName,
//         username: _user.username,
//       ),
//     );
//     initAgora();
//   }

//   initAgora() async {
//     try {
//       await client.initialize();
//     } catch (e) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         showSnackBar(context, "error initializing snackbar: $e");
//       });
//     }
//   }

//   @override
//   void dispose() {
//     disposeAgora();
//     super.dispose();
//   }

//   disposeAgora() async {
//     try {
//       await client.engine.leaveChannel();
//       print("left channel");
//     } catch (e) {
//       debugPrint("error leaving channel: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return loading
//         ? LoadingScreen()
//         : Stack(
//             children: [
//               AgoraVideoViewer(
//                 client: client,
//                 layoutType: Layout.grid,
//               ),
//               AgoraVideoButtons(
//                 client: client,
//                 enabledButtons: const [
//                   BuiltInButtons.switchCamera,
//                   BuiltInButtons.toggleCamera,
//                   BuiltInButtons.toggleMic,
//                 ],
//               ),
//             ],
//           );
//     // return Container();
//   }
// }

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  bool _isReadyPreview = false;

  bool isJoined = false, switchCamera = true, switchRender = true;
  Set<int> remoteUid = {};

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _user = ref.read(userProvider).user;
    _room = ref.read(roomProvider).room!;

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

  void _settingsCall() {
    final roomSettings = ref.read(roomSettingsProvider);
    if (roomSettings.cameraEnabled) _engine.enableVideo();
    if (roomSettings.micEnabled) _engine.enableAudio();
    if (roomSettings.switchCamera) _engine.switchCamera();
  }

  Future<void> _initEngine() async {
    await [Permission.camera, Permission.microphone].request();

    await _engine.initialize(const RtcEngineContext(appId: appId));
    await _engine.leaveChannel();

    _engine.registerEventHandler(RtcEngineEventHandler(
      onError: (ErrorCodeType err, String msg) {
        debugPrint('[onError] err: $err, msg: $msg');
      },
      onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        debugPrint(
            '[onJoinChannelSuccess] connection: ${connection.toJson()} elapsed: $elapsed');
        setState(() {
          isJoined = true;
        });
      },
      onUserJoined: (RtcConnection connection, int rUid, int elapsed) {
        debugPrint(
            '[onUserJoined] connection: ${connection.toJson()} remoteUid: $rUid elapsed: $elapsed');
        setState(() {
          remoteUid.add(rUid);
        });
      },
      onUserOffline:
          (RtcConnection connection, int rUid, UserOfflineReasonType reason) {
        debugPrint(
            '[onUserOffline] connection: ${connection.toJson()}  rUid: $rUid reason: $reason');
        setState(() {
          remoteUid.removeWhere((element) => element == rUid);
        });
      },
      onLeaveChannel: (RtcConnection connection, RtcStats stats) {
        debugPrint(
            '[onLeaveChannel] connection: ${connection.toJson()} stats: ${stats.toJson()}');
        setState(() {
          isJoined = false;
          remoteUid.clear();
        });
      },
    ));

    await _engine.setVideoEncoderConfiguration(
      const VideoEncoderConfiguration(
        dimensions: VideoDimensions(width: 640, height: 360),
        frameRate: 15,
        bitrate: 0,
      ),
    );
    await _engine.startPreview();
    setState(() {
      _isReadyPreview = true;
    });

    _settingsCall();
    await _joinChannel();
  }

  Future<void> _joinChannel() async {
    await _engine.joinChannel(
      token: tempToken,
      channelId: channelName,
      uid: 0,
      options: ChannelMediaOptions(
        channelProfile: ChannelProfileType.channelProfileCommunication,
        clientRoleType: _room.hostUid == _user.uid
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
    if (cameraEnabled) {
      await _engine.disableVideo();
    } else {
      await _engine.enableVideo();
    }

    ref.read(roomSettingsProvider).updateCamera();
  }

  Future<void> onMicTap() async {
    final micEnabled = ref.read(roomSettingsProvider).micEnabled;

    if (micEnabled) {
      await _engine.disableAudio();
    } else {
      await _engine.enableAudio();
    }

    ref.read(roomSettingsProvider).updateMic();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final roomSettings = ref.watch(roomSettingsProvider);

    return !_isReadyPreview
        ? const LoadingScreen()
        : Container(
            color: kBlack,
            child: Stack(
              children: [
                if (roomSettings.cameraEnabled)
                  AgoraVideoView(
                    controller: VideoViewController(
                      rtcEngine: _engine,
                      canvas: const VideoCanvas(uid: 0),
                    ),
                  ),
                if (roomSettings.cameraEnabled)
                  Align(
                    alignment: Alignment.topLeft,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.of(remoteUid.map(
                          (e) => SizedBox(
                            width: 120,
                            height: 120,
                            child: AgoraVideoView(
                              controller: VideoViewController.remote(
                                rtcEngine: _engine,
                                canvas: VideoCanvas(uid: e),
                                connection:
                                    const RtcConnection(channelId: channelName),
                              ),
                            ),
                          ),
                        )),
                      ),
                    ),
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
