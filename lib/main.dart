import 'package:energy_control_desktop/pages/files.dart';
import 'package:energy_control_desktop/pages/login.dart';
import 'package:energy_control_desktop/pages/logs.dart';
import 'package:energy_control_desktop/pages/upload.dart';
import 'package:energy_control_desktop/utils/auth.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

const String apiUrl = "http://neodim.fun";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  windowManager.setTitle('ЭнергоКонтрольАдмин');
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void update() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ЭнергоКонтроль Админ',
      theme: ThemeData.dark(useMaterial3: true),
      home: FutureBuilder<bool>(
        future: userExists(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && snapshot.data!) {
              return HomePage(
                update: update,
              );
            } else {
              return LoginPage(
                update: update,
              );
            }
          } else {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({super.key, required this.update});

  Function update;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static List<Widget> _pages = <Widget>[
    UploadPage(),
    AllFilesPage(),
    LogsPage(),
  ];

  void _onItemTapped(int index) {
    if (index == 3) {
      setState(() {
        removeUser();
        widget.update();
      });
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onItemTapped,
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.upload_file),
                selectedIcon: Icon(Icons.upload_file),
                label: Text('Загрузить'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.folder),
                selectedIcon: Icon(Icons.folder),
                label: Text('Документы'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.receipt),
                selectedIcon: Icon(Icons.receipt),
                label: Text('Логи'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.logout),
                selectedIcon: Icon(Icons.logout),
                label: Text('Выход'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: _pages[_selectedIndex],
          ),
        ],
      ),
    );
  }
}





