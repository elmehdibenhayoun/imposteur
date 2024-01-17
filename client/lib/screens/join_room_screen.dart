import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tic_tac_toe/resource/socket_method.dart';
import 'package:tic_tac_toe/responsive/responsive.dart';
import 'package:tic_tac_toe/screens/geme_screen.dart';
import 'package:tic_tac_toe/util/dimension.dart';
import 'package:tic_tac_toe/widgets/button.dart';
import 'package:tic_tac_toe/widgets/custom_text.dart';
import 'package:tic_tac_toe/widgets/custom_text_field.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../widgets/TextField.dart';

class JoinRoomScreen extends StatefulWidget {
  static const String routeName = '/join-room';

  const JoinRoomScreen({Key? key}) : super(key: key);

  @override
  State<JoinRoomScreen> createState() => _JoinRoomScreenState();
}

class _JoinRoomScreenState extends State<JoinRoomScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _roomIdController = TextEditingController();
  final GameController _gameController = Get.find<GameController>();

  late QRViewController _qrController;
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  bool _isScanning = false;
  

  @override
  void initState() {
    _gameController.joinRoomSuccessListener(
      (data) {
        _gameController.updateRoomData(data);
        Navigator.of(context).pushNamed(GameScreen.routeName);
      },
    );
    _gameController.errorOccurredListener(
      (data) => {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(data.toString())))
      },
    );
    _gameController.updatePlayerListener((players) {
      _gameController.updatePlayersList(players);
    });
    super.initState();
  }
  

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Responsive(
          child: Padding(
            padding: paddingH20,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CustomText(
                    text: 'Join Room',
                    fontSize: shadowTextFontSize,
                    shadows: [
                      BoxShadow(
                        color: Colors.blue,
                        blurRadius: textBlurShadowColor,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.07,
                  ),
                  TextFieled(
                    hint: 'Enter your nickname',
                    controller: _nameController,
                  ),
                  SizedBox(
                    height: size.height * 0.07,
                  ),
                  Column(
                    children: [
                      TextFieled(
                        hint: 'Enter Game ID',
                        controller: _roomIdController,
                      ),
                      SizedBox(
                        height: size.height * 0.07,
                      ),
                      Button(
                        label: _isScanning ? 'Stop Scanning' : 'Start Scanning',
                        onPressed: () {
                          setState(() {
                            _isScanning = !_isScanning;
                          });

                          if (_isScanning) {
                            _qrController.resumeCamera();
                          } else {
                            _qrController.pauseCamera();
                          }
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.08,
                  ),
                  if (_isScanning) ...[
                    Container(
                      width: size.width,
                      height: _isScanning
                          ? size.height
                          : 0, // Utilisez cette ligne pour ajuster la hauteur
                      child: QRView(
                        key: _qrKey,
                        onQRViewCreated: _onQRViewCreated,
                      ),
                    ),
                  ],
                  Button(
                    label: 'Join',
                    onPressed: () {
                      _gameController.joinRoom(
                        _nameController.text,
                        _roomIdController.text,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      _qrController = controller;
    });

    controller.scannedDataStream.listen((scanData) {
      _qrController.pauseCamera();
      _gameController.joinRoom(_nameController.text, scanData.code);
      setState(() {
        _isScanning = false;
      });
    });
  }
  @override
  void dispose() {
    _nameController.dispose();
    _roomIdController.dispose();
    _gameController.dispose();
    super.dispose();
  }
}
