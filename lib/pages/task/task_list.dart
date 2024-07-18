import 'package:appsqflite/models/task.dart';
import 'package:appsqflite/pages/task/task_details.dart';
import 'package:appsqflite/pages/user/user_login.dart';
import 'package:appsqflite/services/database.dart';
import 'package:appsqflite/services/task_controller.dart';
import 'package:appsqflite/src/shared/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  // Armazena o usuário atual
  late int _userId;
  late String _user;

  // Categorias: TODAS - CHECKED = NOTCHECKED
  int _categSelectedIndex = 1;
  late Widget? _categSelected;
  String _title = "Todas as tarefas";

  List<Task> _tasksShown = [];

  @override
  void initState() {
    super.initState();

    getUser();
    changeSelection();
  }

  Future<void> getUser() async {
    _userId = await DatabaseHelper.getCurrentUserId();
    String username = await DatabaseHelper.selectUserById(_userId);
    setState(() {
      _user = username;
    });
  }

  // Alterna o estado da seleção entre as categorias ao clicar no checkbox no AppBar
  void changeSelection() {
    switch (_categSelectedIndex) {
      case -1:
        setState(() {
          _categSelectedIndex = 1;
          _title = "Tarefas concluídas";
          _categSelected = Image.asset(
            'assets/images/icons8-selecionado.png',
            height: 18,
            color: ThemeColors.secondary,
          );
        });
        break;
      case 0:
        setState(() {
          _categSelectedIndex = -1;
          _title = "Tarefas pendentes";
          _categSelected = null;
        });
        break;
      case 1:
        setState(() {
          _categSelectedIndex = 0;
          _title = "Todas as tarefas";
          _categSelected = Container(
            height: 18,
            width: 18,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3.0),
              color: ThemeColors.secondary,
            ),
          );
        });
        break;
    }
  }

  String noDataTextCompliment() {
    switch (_categSelectedIndex) {
      case -1:
        return "pendente";
      case 0:
        return "ainda";
      case 1:
        return "concluída";
    }
    return "";
  }

  // Layout constants
  static const double _contentWidth = 360;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: ThemeColors.primary,
        title: Center(
          child: SizedBox(
            width: _contentWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    children: <Widget>[
                      // Checkbox
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: GestureDetector(
                          onTap: changeSelection,
                          child: Container(
                            alignment: Alignment.center,
                            height: 22,
                            width: 22,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3.0),
                              color: ThemeColors.background,
                            ),
                            child: _categSelected,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12), // Padding
                      Text(
                        _title,
                        style: GoogleFonts.leagueSpartan(
                          color: ThemeColors.background,
                          fontSize: 28,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: SvgPicture.asset(
                    'assets/images/bxs-user-circle.svg',
                    height: 36,
                    color: ThemeColors.light,
                  ),
                  offset: const Offset(-10, 54),
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      enabled: false,
                      child: Text(
                        _user,
                        style: GoogleFonts.leagueSpartan(
                          color: ThemeColors.secondary,
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'sair',
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Sair',
                            style: GoogleFonts.leagueSpartan(
                              color: ThemeColors.secondary,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Icon(Icons.logout_outlined)
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    switch (value) {
                      case 'sair':
                        DatabaseHelper.changeLoginState(null);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const UserLogin()));
                        break;
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: _contentWidth,
          child: Padding(
            padding: const EdgeInsets.only(top: 13.75),
            child: FutureBuilder<List<Task>?>(
              future: DatabaseHelper.selectAllTasksFromCurrentUser(),
              builder: (context, AsyncSnapshot<List<Task>?> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: SizedBox(
                          height: 50,
                          width: 50,
                          child: CircularProgressIndicator(
                              color: ThemeColors.primary)));
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                } else if (snapshot.hasData) {
                  if (snapshot.data != null) {
                    if (_categSelectedIndex == 0) {
                      _tasksShown = snapshot.data!;
                    } else {
                      bool categStat;
                      if (_categSelectedIndex == 1) {
                        categStat = true;
                      } else {
                        categStat = false;
                      }
                      // categStat = _categSelectedIndex == 1 ? true : false;
                      _tasksShown = snapshot.data!
                          .where((index) => index.status == categStat)
                          .toList();
                    }
                    return ListView.builder(
                        itemCount: _tasksShown.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          String subtitle = "";
                          if (_tasksShown[index].description != null) {
                            subtitle = _tasksShown[index]
                                .description!
                                .replaceAll(" ", "");
                            if (subtitle != "") {
                              subtitle = _tasksShown[index].description!;
                              if (subtitle.length > 50) {
                                subtitle = subtitle.substring(0, 50);
                              }
                            }
                          }
                          return Container(
                            padding: const EdgeInsets.only(bottom: 13),
                            child: Dismissible(
                              key: Key(_tasksShown[index].id.toString()),
                              direction: DismissDirection.startToEnd,
                              background: Container(
                                color: Colors.red,
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(left: 48),
                                child: const Icon(Icons.delete_forever_rounded,
                                    color: Colors.white),
                              ),
                              confirmDismiss: (direction) => showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text(
                                      "Excluir Tarefa",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: ThemeColors.secondaryDark,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    content: Text(
                                      "Tem certeza de que deseja excluir esta tarefa?",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: ThemeColors.secondary,
                                      ),
                                    ),
                                    actions: <Widget>[
                                      // Opcão: Cancelar
                                      TextButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                                  ThemeColors.neutral),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          return;
                                        },
                                        child: const Text(
                                          "Cancelar",
                                          style: TextStyle(fontSize: 15),
                                        ),
                                      ),
                                      // Opção: Excluir
                                      TextButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                                  ThemeColors.cancel),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            DatabaseHelper.deleteTask(
                                                _tasksShown[index].id);
                                          });
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text(
                                          "Excluir",
                                          style: TextStyle(fontSize: 15),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                              child: ListTile(
                                key: Key(_tasksShown[index].id.toString()),
                                tileColor: ThemeColors.primary,
                                textColor: Colors.white,
                                contentPadding:
                                    const EdgeInsets.only(right: 20),
                                horizontalTitleGap: 0,
                                leadingAndTrailingTextStyle: const TextStyle(
                                  fontSize: 14,
                                ),
                                shape: const BeveledRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                ),
                                title: Padding(
                                    padding: const EdgeInsets.only(right: 28),
                                    child: Text(_tasksShown[index].title,
                                        softWrap: false)),
                                subtitle: Padding(
                                    padding: const EdgeInsets.only(right: 28),
                                    child: Text(subtitle, softWrap: false)),
                                leading: Checkbox(
                                    value: _tasksShown[index].status,
                                    onChanged: (value) async {
                                      setState(() {
                                        DatabaseHelper.checkTask(
                                            _tasksShown[index].id, value!);
                                      });
                                    }),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(TaskController.dateFormatFromSystem(
                                        _tasksShown[index].dueTime, true)),
                                    Text(TaskController.getTimeFromSystem(
                                        _tasksShown[index].dueTime)),
                                  ],
                                ),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TaskScreen(
                                        noteId: _tasksShown[index].id),
                                  ),
                                ),
                              ),
                            ),
                          );
                        });
                  }
                }
                return Text("Nenhuma tarefa ${noDataTextCompliment()}");
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const TaskScreen(noteId: -1),
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: const Icon(Icons.add),
      ),
    );
  }
}
