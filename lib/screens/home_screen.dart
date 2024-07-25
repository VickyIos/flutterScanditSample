import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_module_sam/screens/multi_scan_screen.dart';
import 'package:flutter_module_sam/screens/screen_one.dart';
import 'package:flutter_module_sam/screens/screen_three.dart';
import 'package:flutter_svg/svg.dart';
import '../helper/methodchannel_login_helper.dart';
import '../utils/image_constants.dart';

const String licenseKey = 'AXND9QRuIs+sKkzhm/hXJ+E98UimK3EyWlV9n9VSY/jGE0bjsn/ooVNFJGA5GsIe0GQ4uI5pV+ISUwVtBER/Igxqf54fexibNgXo3MkgtMMcHfQ4I0MpshZ46SOiT5OR2SAJE8kymZs6BQt7vCrcWWvsZ5E68QU8ZYrdyrRUjJ09fpmINZqjsANtMwZ03IRKl9lliLRRRa6v4KQWqkpWmrg8k+T0OvP0VFkBWAUYjkOmKnL+W67RagYbSCIlL3GvB1+qfoP6zj0IFkCnBToxh2SycbryPtkGsf9BaoAw8r2+9Fc0r6z9q6R9N/IDlEm5O7JgaicwIfbo86bhahs1zOcluft8Sc2bcMYJCIl9M2px0MuExoVW4YYfM3zAV6vKpQtncMnEmIcrwZ+j0O2rJ0CgJNDKvdVFGLlZztTAPVyUj2IQj4c7vdTNqgqqPymFTJm0YT7pusLEFKZkW9JI07WquQO8ZHf+yJ43XXQSEnNvpvVbknskLY9JoGvks26SSN2+SkojFn8aK70hSbG+6E33R1r6TyzUthZSlrg0rlq2XMuzoFgswSGQmVXJQirdKnwOBlaCkjIugKjx2kTw8vI20rn+gpD18ylM2BhgG0ibzahvA8x3PKvSOqk4Hh7vpQ/ScrQKiyfxAYTo0/NLu/v2YhX/KcNvdfu9DaZKOSa0OsgwupCOJIwq1f1mPRFy/yP93vnRHLL6VaxsYZXhxaZBXwByTEP+DQM7PVI3mXt/AGFZvWJkktRJDZrbVhrDImPCv4wfo7FILhFkRvMkFcBJ/BIbUPbc0ycztsVSk3IZKDLC9mpJXR4hwMSIYQ5O';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {

  final MethodChannelService _methodChannelService = MethodChannelService();
  late String instance;
  late String username;
  late TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _methodChannelService.setHomeCallBack = handleMethodChannelLoginMessage;
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Image.asset('assets/images/rfxcel_logo_new.png', height: 30,),
          ),
          leading: Builder(
            builder: (BuildContext context) {
              return GestureDetector(
                onTap: () {
                    debugPrint("Back button Pressed");
                    backToNative();
                },
                child: Container(
                    margin: const EdgeInsets.only(left: 16, top: 16),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: Color(0xFFE6E6E6),
                          width: 1.0),
                    ),
                    child: SizedBox(
                        width: 20,
                        height: 20,
                        child: SvgPicture.asset(ImageConstants.appBarBack))),
              );
            },
          ),
          bottom: PreferredSize(
      preferredSize: const Size.fromHeight(80.0),
      child: TabBar(
        isScrollable: false,
        controller: _tabController,
        indicatorColor: Color(0xFFC63663),
        padding: const EdgeInsets.only(
          bottom: 20,
        ),
        tabs: [
          Tab(
            text: 'Screen 1',
          ),
          Tab(
            text: 'Screen 2',
          ),
          Tab(
            text: 'Screen 3',
          ),
        ],
      ),
    )
      ),
        body: TabBarView(
          controller: _tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: const <Widget>[
            ScreenOne(),
            MultiScanScreen(licenseKey),
            ScreenThree()
          ],
        ) // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void handleMethodChannelLoginMessage(String inputData) async {
    debugPrint("Method channel call : $inputData");
    Map<String, dynamic> loginData = json.decode(inputData);
    instance = loginData["instance"];
    username = loginData["user"];
    setState(() {
    });
  }

  void backToNative() async {
    SystemNavigator.pop();
  }
}