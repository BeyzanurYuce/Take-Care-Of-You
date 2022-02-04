import 'package:flutter/material.dart';

import 'package:meditation_app/src/utils/secure_stroge.dart';
import 'package:meditation_app/src/widgets/secure_widget.dart';
class SecurePage extends StatefulWidget {
  @override
  _SecurePageState createState() => _SecurePageState();
}

class _SecurePageState extends State<SecurePage> {
  final formKey = GlobalKey<FormState>();
  final controllerName = TextEditingController();
  DateTime? birthday;
  List<String> pets = [];

  @override
  void initState() {
    super.initState();

    init();
  }

  Future init() async {
    final name = await UserSecureStorage.getUsername() ?? '';
    final birthday = await UserSecureStorage.getBirthday();
    final pets = await UserSecureStorage.getPets() ?? [];

    setState(() {
      this.controllerName.text = name;
      this.birthday = birthday;
      this.pets = pets;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: ListView(
        padding: EdgeInsets.all(16),
        children: [
          TitleWidget(icon: Icons.lock, text: 'Secure\nStorage'),
          const SizedBox(height: 12),
          buildName(),
          const SizedBox(height: 12),
          buildBirthday(),
          const SizedBox(height: 12),
          buildPets(),
          const SizedBox(height: 32),
          buildButton(),
        ],
      ),
    ),
  );

  Widget buildName() => buildTitle(
    title: 'Name',
    child: TextFormField(
      controller: controllerName,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Your Name',
      ),
    ),
  );

  Widget buildBirthday() => buildTitle(
    title: 'Birthday',
    child: BirthdayWidget(
      birthday: birthday,
      onChangedBirthday: (birthday) =>
          setState(() => this.birthday = birthday),
    ),
  );

  Widget buildPets() => buildTitle(
    title: 'Pets',
    child: PetsButtonsWidget(
      pets: pets,
      onSelectedPet: (pet) => setState(
              () => pets.contains(pet) ? pets.remove(pet) : pets.add(pet)),
    ),
  );

  Widget buildButton() => ButtonWidget(
      text: 'Save',
      onClicked: () async {
        await UserSecureStorage.setUsername(controllerName.text);
        await UserSecureStorage.setPets(pets);

        if (birthday != null) {
          await UserSecureStorage.setBirthday(birthday!);
        }
      });

  Widget buildTitle({
    required String title,
    required Widget child,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          child,
        ],
      );
}