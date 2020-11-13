import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:video_call/core/permission.dart';
import 'package:video_call/server/signaling.dart';

class VideoCaller extends StatefulWidget {
  final String appname;
  final String serverIp;
  final bool isDebugTagVisible;

  VideoCaller({
    Key key,
    @required this.appname,
    @required this.serverIp,
    @required this.isDebugTagVisible,
  }) : super(key: key);

  @override
  _VideoCallerState createState() {
    return _VideoCallerState();
  }
}

class _VideoCallerState extends State<VideoCaller> {
  // & Variable Declaration
  bool _isCalling = false;
  Signaling signaling;
  MediaStream mediaStream;
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  var _selfId;
  var _peers;

  String mediaType = 'video';

  // & Logic Component

  @override
  void initState() {
    _requestUserPerssion();
    _connect();
    super.initState();
  }

  @override
  void deactivate() {
    super.deactivate();

    if (signaling != null) {
      signaling?.close();
    }
    _localRenderer.dispose();
    _remoteRenderer.dispose();
  }

  Future<void> initRenderer() async {
    await _localRenderer?.initialize();
    await _remoteRenderer?.initialize();
  }

  void _requestUserPerssion() {
    int android = 0;
    int ios = 1;

    if (Platform.isAndroid) {
      // * Android Camera
      UserPermission().getPlatformPermission(android, 0);
      // * Android Record Audio
      UserPermission().getPlatformPermission(android, 8);
    } else if (Platform.isIOS) {
      // * IOS Camera
      UserPermission().getPlatformPermission(ios, 0);
      // * IOS Record Auido
      UserPermission().getPlatformPermission(ios, 7);
    } else {
      throw ('Not Supported');
    }
  }

  // * Connect Call
  Future<void> _connect() async {
    if (signaling == null) {
      signaling = Signaling(widget?.serverIp)..connect();

      signaling.onStateChange = (SignalingState state) {
        switch (state) {
          case SignalingState.CallStateNew:
            this.setState(() {
              _isCalling = true;
            });
            break;

          case SignalingState.CallStateBye:
            this.setState(() {
              _localRenderer.srcObject = null;
              _remoteRenderer.srcObject = null;
              _isCalling = false;
            });
            break;

          case SignalingState.CallStateRinging:
            print('Ringing.....');
            break;

          case SignalingState.CallStateInvite:
            break;

          case SignalingState.CallStateConnected:
            print('Connected');
            break;

          case SignalingState.ConnectionOpen:
            print('ConnectionOpen');
            break;

          case SignalingState.ConnectionClosed:
            print('ConnectionClosed');
            break;

          case SignalingState.ConnectionError:
            print('ConnectionError');
            break;
        }
      };

      signaling.onPeersUpdate = ((dynamic event) {
        this.setState(() {
          _selfId = event['self'];
          _peers = event['peers'];
        });
      });

      signaling.onLocalStream = ((MediaStream stream) {
        _localRenderer.srcObject = stream;
      });

      signaling.onAddRemoteStream = ((MediaStream stream) {
        _remoteRenderer.srcObject = stream;
      });
    }
  }

  // * Invite Peer
  Future<void> _invitePeer(
    dynamic context,
    dynamic peerId,
    dynamic useScreen,
  ) async {
    signaling.invite(peerId, mediaType, useScreen);
  }

  // * End Call
  Future<void> _hangUp() async {
    if (signaling != null) {
      signaling.bye();
    }
  }

  // * Switch USer Camera
  Future<void> _switchCamera() async {
    signaling?.switchCamera();
  }

  // * Mute User Microphone
  Future<void> _muteMic() async {
    if (mediaStream != null) {
      mediaStream.getAudioTracks()[0]?.enabled = false;
      mediaStream.getAudioTracks()[0]?.setMicrophoneMute(true);
    } else {
      mediaStream.getAudioTracks()[0]?.enabled = true;
      mediaStream.getAudioTracks()[0]?.setMicrophoneMute(true);
    }
  }

  // & User Interface Component

  buildRow(context, peer) {
    bool self = (peer['id'] == _selfId);

    IconButton videoCall = IconButton(
      icon: const Icon(Icons.videocam),
      onPressed: () {
        return _invitePeer(context, peer['id'], false);
      },
      tooltip: 'Video calling',
    );

    IconButton screenShare = IconButton(
      icon: const Icon(Icons.screen_share),
      onPressed: () {
        return _invitePeer(context, peer['id'], true);
      },
      tooltip: 'Screen sharing',
    );

    SizedBox body = SizedBox(
      width: 100.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          videoCall,
          screenShare,
        ],
      ),
    );

    ListTile listTile = ListTile(
      title: Text((() {
        if (self) {
          return peer['name'] + '[Your self]';
        } else {
          return peer['name'] + 'Not You';
        }
      }())),
      onTap: null,
      trailing: body,
      subtitle: Text('id: ' + peer['id']),
    );

    Divider divider = Divider(
      color: Colors.black,
      thickness: 3.0,
    );

    return ListBody(
      children: <Widget>[
        listTile,
        divider,
      ],
    );
  }

  AppBar appBar() {
    Text applicationName = Text('${widget.appname}');

    AppBar _appBar = AppBar(
      centerTitle: true,
      title: applicationName,
    );

    return _appBar;
  }

  Scaffold scaffold() {
    FloatingActionButton switchCameraBtn = FloatingActionButton(
      child: const Icon(Icons.switch_camera),
      onPressed: _switchCamera,
    );

    FloatingActionButton hangUpBtn = FloatingActionButton(
      onPressed: _hangUp,
      tooltip: 'Hangup',
      child: Icon(Icons.call_end),
      backgroundColor: Colors.pink,
    );

    FloatingActionButton muteMicBtn = FloatingActionButton(
      child: const Icon(Icons.mic_off),
      onPressed: _muteMic,
    );

    SizedBox showFloatButton = SizedBox(
      width: 200.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          switchCameraBtn,
          muteMicBtn,
          hangUpBtn,
        ],
      ),
    );

    Container appBody = Container(
      child: (() {
        if (_isCalling) {
          OrientationBuilder(
              builder: (BuildContext context, Orientation orientation) {
            return Container(
                child: Stack(
              children: <Widget>[
                ///
                Positioned(
                  left: 0.0,
                  right: 0.0,
                  top: 0.0,
                  bottom: 0.0,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: RTCVideoView(_remoteRenderer),
                    decoration: BoxDecoration(color: Colors.black54),
                  ),
                ),

                ///
                Positioned(
                  left: 20.0,
                  top: 20.0,
                  child: Container(
                    width: orientation == Orientation.portrait ? 90.0 : 120.0,
                    height: orientation == Orientation.portrait ? 120.0 : 90.0,
                    child: RTCVideoView(_localRenderer),
                    decoration: BoxDecoration(color: Colors.black54),
                  ),
                ),
              ],
            ));
          });
        } else {
          return ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(0.0),
            itemCount: (_peers != null ? _peers.length : 0),
            itemBuilder: (context, i) {
              return buildRow(context, _peers[i]);
            },
          );
        }
      }()),
    );

    Scaffold _scaffold = Scaffold(
      appBar: appBar(),
      body: appBody,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: (() {
        if (_isCalling) {
          return showFloatButton;
        } else {
          return null;
        }
      }()),
    );

    return _scaffold;
  }

  @override
  Widget build(BuildContext context) {
    MaterialApp _main = MaterialApp(
      home: scaffold(),
      debugShowCheckedModeBanner: widget.isDebugTagVisible,
    );
    return _main;
  }
}
