import 'package:appsqflite/models/task.dart';
import 'package:appsqflite/pages/task/task_list.dart';
import 'package:appsqflite/services/database.dart';
import 'package:appsqflite/services/task_controller.dart';
import 'package:appsqflite/src/shared/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TaskScreen extends StatefulWidget {
  final int noteId;

  const TaskScreen({super.key, required this.noteId});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  int get _noteId => widget.noteId;

  // Fields
  final _titleFieldController = TextEditingController();
  final _descriptionFieldController = TextEditingController();
  final _dueDateController = TextEditingController();
  String _hour = "00";
  String _minute = "00";
  bool _taskChecked = false; // Salva automaticamente no db

  // Variable Widgets - Default: Criar
  Widget? _showLastAltered;
  String _appBarTitle = "Criar Nova Tarefa";
  double _appBarTitleWidth = 200;
  String _saveButtonTxt = "Criar Tarefa";
  double _saveButtonWidth = 140;
  Color _titleFieldOutline = ThemeColors.primaryDark;
  Color _dateFieldOutline = ThemeColors.primaryDark;

  bool _altered = false; // Se houve alteração
  late Task _task;

  @override
  void initState() {
    super.initState();

    // Carrega itens de Tempo
    _hourItems = _createDropDownHMTimeList("hours");
    _minuteItems = _createDropDownHMTimeList("minutes");

    // Altera Form para Editar
    if (_noteId != -1) {
      _appBarTitleWidth = 168;
      _saveButtonWidth = 184;
      _saveButtonTxt = "Salvar Alterações";
      loadTaskFromDb();
    }
  }

  // Puxa task do Db e carrega nos campos
  Future<void> loadTaskFromDb() async {
    _task = await DatabaseHelper.getTask(_noteId);
    setState(() {
      _appBarTitle = _task.title;
      _lastAltered(_task.lastAltered!);
      _taskChecked = _task.status;
      _titleFieldController.text = _task.title;
      _descriptionFieldController.text = _task.description!;
    });
    _dueDateController.text =
        TaskController.dateFormatFromSystem(_task.dueTime, false);
    _hour = TaskController.getHourFromSystem(_task.dueTime);
    _minute = TaskController.getMinuteFromSystem(_task.dueTime);
  }

  // Show Last Altered DateTime on Edit
  void _lastAltered(String dateTime) {
    String date =
        "${TaskController.dateFormatFromSystem(dateTime, false)} ${TaskController.getTimeFromSystem(dateTime)}";
    _showLastAltered = Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Text(
          'última alteração',
          style: GoogleFonts.roboto(
            color: ThemeColors.secondary,
            fontSize: 11,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.italic,
          ),
        ),
        Text(
          date,
          style: GoogleFonts.roboto(
            color: ThemeColors.secondary,
            fontSize: 9,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  // DatePicker Dialog
  Future<void> _datePicker() async {
    DateTime initialDate = DateTime.now();
    if (_dueDateController.text != "") {
      initialDate = DateTime(
          int.parse(_dueDateController.text.substring(6, 10)),
          int.parse(_dueDateController.text.substring(3, 5)),
          int.parse(_dueDateController.text.substring(0, 2)));
    }
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2100),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );
    if (date != null) {
      _dueDateController.text =
          TaskController.dateFormatFromSystem(date.toString(), false);
    }
  }

  // Time Options
  late List<PopupMenuEntry<String>> _hourItems;
  late List<PopupMenuEntry<String>> _minuteItems;
  // Converte lista de String de Tempo para lista de Objetos do Menu de Tempo
  List<PopupMenuEntry<String>> _createDropDownHMTimeList(String unTime) {
    List<String> list;
    List<String> hours = [
      '00',
      '01',
      '02',
      '03',
      '04',
      '05',
      '06',
      '07',
      '08',
      '09',
      '10',
      '11',
      '12',
      '13',
      '14',
      '15',
      '16',
      '17',
      '18',
      '19',
      '20',
      '21',
      '22',
      '23'
    ];
    List<String> minutes = [
      '00',
      '05',
      '10',
      '15',
      '20',
      '25',
      '30',
      '35',
      '40',
      '45',
      '50',
      '55'
    ];
    if (unTime == "hours") {
      list = hours;
    } else {
      list = minutes;
    }
    List<PopupMenuEntry<String>> temp = [];
    for (int i = 0; i < list.length; i++) {
      temp.add(
        PopupMenuItem<String>(
          value: list[i],
          child: Container(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.all(0),
            width: 60,
            height: 28,
            child: Text(
              list[i],
              style: GoogleFonts.roboto(
                fontSize: 16,
                color: ThemeColors.secondaryDark,
              ),
            ),
          ),
        ),
      );
    }
    return temp;
  }

  // Mensagem de !Validação
  bool _validated = false;
  String _validationMessage = "* Mensagem de validação";
  Widget validationErrorMessage() {
    if (!_validated) {
      return const SizedBox(height: 20); // Padding
    } else {
      return Column(
        children: <Widget>[
          const SizedBox(height: 8), // Padding
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              _validationMessage,
              style: GoogleFonts.roboto(
                color: Colors.red,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          const SizedBox(height: 6), // Padding
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: ThemeColors.background,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // Voltar - ArrowBack
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TaskListScreen(),
                  ),
                );
              },
              child: const Icon(Icons.arrow_back),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: SizedBox(
                width: 260,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    // AppBar Title
                    SizedBox(
                      width: _appBarTitleWidth,
                      child: Text(
                        _appBarTitle,
                        style: GoogleFonts.leagueSpartan(
                          color: ThemeColors.secondary,
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    // LastAltered Date on Edit
                    SizedBox(
                      child: _showLastAltered,
                    ),
                  ],
                ),
              ),
            ),
            Checkbox(
              value: _taskChecked,
              onChanged: (value) {
                setState(() {
                  _taskChecked = !_taskChecked;
                  if (_noteId != -1) {
                    DatabaseHelper.checkTask(
                        _noteId, _taskChecked); // Change in db
                  }
                });
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 2, bottom: 10, right: 10),
        scrollDirection: Axis.vertical,
        child: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: 340,
            height: 820,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Label: Título
                Text(
                  'Título',
                  style: GoogleFonts.leagueSpartan(
                    color: ThemeColors.secondarySubtle,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 3), // Padding
                // TextField: Título
                Container(
                  height: 36,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _titleFieldOutline,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextFormField(
                    textAlignVertical: const TextAlignVertical(y: 1),
                    controller: _titleFieldController,
                    maxLength: 25,
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      color: ThemeColors.secondaryLight,
                    ),
                    decoration: InputDecoration(
                      counterText: "",
                      hoverColor: ThemeColors.primarySubtle,
                      hintText: 'Insira seu título aqui...',
                      border: const OutlineInputBorder(
                        gapPadding: 0,
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) {
                      // Altera o estado de _altered para true
                      if (!_altered) {
                        setState(() {
                          _altered = true;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(height: 7), // Padding
                // Label: Prazo
                Text(
                  'Prazo',
                  style: GoogleFonts.leagueSpartan(
                    color: ThemeColors.secondarySubtle,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                // DatePickerField
                Row(
                  children: <Widget>[
                    Container(
                      width: 153.75,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _dateFieldOutline,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: TextField(
                        controller: _dueDateController,
                        style: GoogleFonts.roboto(
                          fontSize: 15,
                          color: ThemeColors.secondary,
                          height: 48,
                        ),
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.calendar_today,
                            size: 22,
                            color: ThemeColors.primaryExtraDark,
                          ),
                          border: InputBorder.none,
                        ),
                        readOnly: true,
                        onTap: _datePicker,
                        onChanged: (value) {
                          if (!_altered) {
                            // Altera o estado de _altered para true
                            setState(() {
                              _altered = true;
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 20), // Padding
                    // TimePicker Field
                    Container(
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: ThemeColors.primaryDark,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        children: <Widget>[
                          // TimePicker: Hora
                          SizedBox(
                            width: 33,
                            child: PopupMenuButton<String>(
                              itemBuilder: (BuildContext context) => _hourItems,
                              constraints:
                                  BoxConstraints.loose(const Size(52, 580)),
                              offset: const Offset(10, -108),
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.only(top: 4, left: 4),
                                width: 33,
                                height: 30,
                                child: Text(
                                  _hour,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.roboto(
                                    fontSize: 15,
                                    color: ThemeColors.secondary,
                                  ),
                                ),
                              ),
                              onSelected: (value) {
                                setState(() {
                                  _hour = value;
                                });
                                // Altera o estado de _altered para true
                                if (!_altered) {
                                  setState(() {
                                    _altered = true;
                                  });
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 2.125),
                            child: Text(
                              ":",
                              style: GoogleFonts.roboto(
                                fontSize: 15,
                                color: ThemeColors.secondary,
                              ),
                            ),
                          ),
                          // TimePicker: Minutos
                          SizedBox(
                            width: 33,
                            child: PopupMenuButton<String>(
                              itemBuilder: (BuildContext context) =>
                                  _minuteItems,
                              constraints:
                                  BoxConstraints.loose(const Size(52, 580)),
                              offset: const Offset(10, -108),
                              child: Container(
                                alignment: Alignment.center,
                                padding:
                                    const EdgeInsets.only(top: 4, right: 4),
                                width: 33,
                                height: 30,
                                child: Text(
                                  _minute,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.roboto(
                                    fontSize: 15,
                                    color: ThemeColors.secondary,
                                  ),
                                ),
                              ),
                              onSelected: (value) {
                                setState(() {
                                  _minute = value;
                                });
                                // Altera o estado de _altered para true
                                if (!_altered) {
                                  setState(() {
                                    _altered = true;
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 7), // Padding
                // Label: Descrição
                Text(
                  'Descrição',
                  style: GoogleFonts.leagueSpartan(
                    color: ThemeColors.secondarySubtle,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 3), // Padding
                // TextField: Descrição
                Container(
                  height: 376,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: ThemeColors.primaryDark,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextFormField(
                    controller: _descriptionFieldController,
                    scrollPadding: const EdgeInsets.symmetric(vertical: 20),
                    scrollPhysics: const AlwaysScrollableScrollPhysics(),
                    maxLines: 9999,
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      color: ThemeColors.secondaryLight,
                    ),
                    decoration: InputDecoration(
                      hoverColor: ThemeColors.primarySubtle,
                      hintText: 'Insira uma descrição aqui...',
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10.875),
                    ),
                    onChanged: (value) {
                      // Altera o estado de _altered para true
                      if (!_altered) {
                        setState(() {
                          _altered = true;
                        });
                      }
                    },
                  ),
                ),
                validationErrorMessage(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    // Button: Cancelar
                    ElevatedButton(
                      onPressed: () {
                        if (_altered) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Text(
                                  "As alterações feitas serão perdidas, tem certeza de que deseja sair?",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: ThemeColors.secondary),
                                ),
                                actions: <Widget>[
                                  // Opcão: Continuar
                                  TextButton(
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(
                                          ThemeColors.neutral),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      return;
                                    },
                                    child: const Text(
                                      "Continuar",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                  // Opção: Cancelar
                                  TextButton(
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(
                                          ThemeColors.cancel),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const TaskListScreen(),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      "Sair",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          // Se não houve nenhuma alteração não há necessidade do popup
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TaskListScreen(),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)),
                          minimumSize: const Size(108, 36.5),
                          maximumSize: const Size(108, 36.5),
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          backgroundColor: ThemeColors.secondarySubtle),
                      child: Text(
                        'Cancelar',
                        style: TextStyle(
                          color: ThemeColors.background,
                          fontSize: 19,
                        ),
                        softWrap: false,
                      ),
                    ),
                    const SizedBox(width: 28),
                    // Button: Salvar
                    ElevatedButton(
                      onPressed: () {
                        String title =
                            _titleFieldController.text.replaceAll(" ", "");
                        if (title == "") {
                          // Título Inválido
                          setState(() {
                            // Formato de titleField Inválido
                            _titleFieldOutline = Colors.red;
                            _validated = true;
                            _validationMessage = "* Título Inválido";
                          });
                          return;
                        }
                        setState(() {
                          // Formato de titleField Padrão
                          _titleFieldOutline = ThemeColors.primaryDark;
                          _validated = false;
                          _validationMessage = "";
                        });
                        if (_dueDateController.text == "") {
                          // Data não selecionada
                          setState(() {
                            // Formato de dateField Inválido
                            _dateFieldOutline = Colors.red;
                            _validated = true;
                            _validationMessage = "* Selecione uma data";
                          });
                          return;
                        }
                        setState(() {
                          // Formato de dateField Padrão
                          _dateFieldOutline = ThemeColors.primaryDark;
                          _validated = false;
                          _validationMessage = "";
                        });
                        String dueDate = TaskController.dateTimeFromView(
                            _dueDateController.text, _hour, _minute);
                        Task task = Task(
                          id: _noteId,
                          title: _titleFieldController.text,
                          dueTime: dueDate,
                          description: _descriptionFieldController.text,
                          status: _taskChecked,
                        );
                        if (_noteId == -1) {
                          DatabaseHelper.insertTask(task);
                        } else {
                          DatabaseHelper.updateTask(task);
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TaskListScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)),
                          minimumSize: Size(_saveButtonWidth, 36.5),
                          maximumSize: Size(_saveButtonWidth, 36.5),
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          backgroundColor: ThemeColors.primary),
                      child: Text(
                        _saveButtonTxt,
                        style: TextStyle(
                          color: ThemeColors.background,
                          fontSize: 19,
                        ),
                        softWrap: false,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
