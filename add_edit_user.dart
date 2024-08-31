import 'package:flutter/material.dart';
import '../../models/users.dart';


class AddEditUser extends StatefulWidget {
  final Users? user;

  const AddEditUser({this.user, Key? key}) : super(key: key);

  @override
  State<AddEditUser> createState() => _AddEditUserState();
}

class _AddEditUserState extends State<AddEditUser> {
  final _formKey = GlobalKey<FormState>();
  late Users _user;

  @override
  void initState() {
    super.initState();
    _user = widget.user ?? Users();
  }

  Widget buildInputField(String label, String? initialValue, Function(String?) onSave, IconData icon) {
    return Focus(
      child: Builder(
        builder: (context) {
          final isFocused = Focus.of(context).hasFocus;
          return TextFormField(
            initialValue: initialValue,
            obscureText: label == 'Password' ? true : false, // ซ่อน password โดยไม่มีไอคอน
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(color: isFocused ? Colors.cyan : Colors.grey),
              prefixIcon: Icon(icon, color: isFocused ? Colors.cyan : Colors.grey),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.cyan),
              ),
            ),
            onSaved: onSave,
          );
        },
      ),
    );
  }

  Widget buildGenderField() {
    return DropdownButtonFormField<String>(
      value: _user.gender,
      decoration: InputDecoration(
        labelText: 'Gender',
        prefixIcon: Icon(Icons.person, color: Colors.grey),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.cyan),
        ),
      ),
      items: ['None', 'Male', 'Female']
          .map((label) => DropdownMenuItem(
                child: Text(label),
                value: label,
              ))
          .toList(),
      onChanged: (value) => setState(() {
        _user.gender = value;
      }),
    );
  }

  Future<void> saveUser() async {
    _formKey.currentState?.save();
    Navigator.pop(context, _user); // ส่งข้อมูลผู้ใช้กลับไปยังหน้าหลัก
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User Form',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.cyan,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildInputField('Full Name', _user.fullname, (value) => _user.fullname = value, Icons.person),
              buildInputField('Email', _user.email, (value) => _user.email = value, Icons.email),
              buildInputField('Password', _user.password, (value) => _user.password = value, Icons.lock),
              buildGenderField(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan,
                ),
                child: const Text('Save', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
