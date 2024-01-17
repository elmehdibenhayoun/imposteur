import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tic_tac_toe/resource/socket_method.dart';
import 'package:tic_tac_toe/responsive/responsive.dart';
import 'package:tic_tac_toe/screens/geme_screen.dart';
import 'package:tic_tac_toe/util/dimension.dart';
import 'package:tic_tac_toe/widgets/custom_button.dart';
import 'package:tic_tac_toe/widgets/custom_text.dart';
import 'package:tic_tac_toe/widgets/custom_text_field.dart';

import '../widgets/TextField.dart';
import '../widgets/button.dart';

class CreateRoomScreen extends StatefulWidget {
  static const String routeName = '/create-room';

  const CreateRoomScreen({Key? key}) : super(key: key);

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GameController _gameController = Get.find<GameController>();

  @override
  void initState() {
    _gameController.createRoomSuccessListener(
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
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    _gameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Responsive(
        child: SafeArea(
          child: Padding(
            padding: paddingH20,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CustomText(
                    text: 'Create Room',
                    fontSize: shadowTextFontSize,
                    shadows: [
                      BoxShadow(
                        color: Colors.blue,
                        blurRadius: textBlurShadowColor,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.08,
                  ),
                  TextFieled(
                    hint: 'Enter your nickname',
                    controller: _nameController,
                  ),
                  SizedBox(
                    height: size.height * 0.045,
                  ),
                  TextFieled(
                    hint: 'Enter password room',
                    controller: _passwordController,
                  ),
                  SizedBox(
                    height: size.height * 0.145,
                  ),
                  Button(
                    label: 'create',
                    onPressed: () {
                      _gameController.createRoom(_nameController.text,_passwordController.text);
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
}
