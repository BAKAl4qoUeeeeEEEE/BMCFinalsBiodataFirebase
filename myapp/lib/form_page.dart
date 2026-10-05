import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  // Controllers
  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final fatherController = TextEditingController();
  final religionController = TextEditingController();
  final languageController = TextEditingController();
  final qualificationController = TextEditingController();
  final experienceController = TextEditingController();
  final addressController = TextEditingController();

  String gender = "Male";
  String maritalStatus = "Single";
  String dateOfBirth = "";

  bool isLoading = false;

  // Date Picker
  Future<void> selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      initialDate: DateTime(2005),
    );

    if (pickedDate != null) {
      setState(() {
        dateOfBirth =
            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  // SAVE TO FIREBASE
  Future<void> saveBiodata() async {
    if (nameController.text.isEmpty ||
        mobileController.text.isEmpty ||
        emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill in Name, Mobile and Email."),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseFirestore.instance.collection("biodata").add({
        "name": nameController.text,
        "mobile": mobileController.text,
        "email": emailController.text,
        "fatherName": fatherController.text,
        "gender": gender,
        "dateOfBirth": dateOfBirth,
        "maritalStatus": maritalStatus,
        "religion": religionController.text,
        "languagesKnown": languageController.text,
        "qualification": qualificationController.text,
        "experience": experienceController.text,
        "address": addressController.text,
        "createdAt": FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Biodata saved successfully!"),
          backgroundColor: Colors.green,
        ),
      );

      // Clear form
      nameController.clear();
      mobileController.clear();
      emailController.clear();
      fatherController.clear();
      religionController.clear();
      languageController.clear();
      qualificationController.clear();
      experienceController.clear();
      addressController.clear();

      setState(() {
        gender = "Male";
        maritalStatus = "Single";
        dateOfBirth = "";
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  // INPUT DESIGN
  Widget inputField(
    String label,
    TextEditingController controller,
    IconData icon,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        title: const Text(
          "Biodata Form",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 6, 81, 83),
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            // ICON
            const Icon(
              Icons.person,
              size: 80,
              color: Color.fromARGB(255, 6, 81, 83),
            ),

            const SizedBox(height: 10),

            const Text(
              "Personal Information",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 6, 81, 83),
              ),
            ),

            const SizedBox(height: 25),

            // NAME
            inputField(
              "Name",
              nameController,
              Icons.person,
            ),

            const SizedBox(height: 15),

            // MOBILE
            inputField(
              "Mobile",
              mobileController,
              Icons.phone,
            ),

            const SizedBox(height: 15),

            // EMAIL
            inputField(
              "Email ID",
              emailController,
              Icons.email,
            ),

            const SizedBox(height: 15),

            // FATHER'S NAME
            inputField(
              "Father's Name",
              fatherController,
              Icons.person_outline,
            ),

            const SizedBox(height: 15),

            // GENDER
            DropdownButtonFormField<String>(
              value: gender,
              decoration: const InputDecoration(
                labelText: "Gender",
                prefixIcon: Icon(Icons.wc),
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: "Male",
                  child: Text("Male"),
                ),
                DropdownMenuItem(
                  value: "Female",
                  child: Text("Female"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  gender = value!;
                });
              },
            ),

            const SizedBox(height: 15),

            // DATE OF BIRTH
            TextField(
              readOnly: true,
              onTap: selectDate,
              controller: TextEditingController(
                text: dateOfBirth,
              ),
              decoration: const InputDecoration(
                labelText: "Date of Birth",
                prefixIcon: Icon(Icons.calendar_month),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            // MARITAL STATUS
            DropdownButtonFormField<String>(
              value: maritalStatus,
              decoration: const InputDecoration(
                labelText: "Marital Status",
                prefixIcon: Icon(Icons.favorite),
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: "Single",
                  child: Text("Single"),
                ),
                DropdownMenuItem(
                  value: "Married",
                  child: Text("Married"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  maritalStatus = value!;
                });
              },
            ),

            const SizedBox(height: 15),

            // RELIGION
            inputField(
              "Religion",
              religionController,
              Icons.church,
            ),

            const SizedBox(height: 15),

            // LANGUAGES
            inputField(
              "Languages Known",
              languageController,
              Icons.language,
            ),

            const SizedBox(height: 15),

            // QUALIFICATION
            inputField(
              "Qualification",
              qualificationController,
              Icons.school,
            ),

            const SizedBox(height: 15),

            // EXPERIENCE
            inputField(
              "Experience",
              experienceController,
              Icons.work,
            ),

            const SizedBox(height: 15),

            // ADDRESS
            TextField(
              controller: addressController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Address",
                prefixIcon: Icon(Icons.home),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 25),

            // SAVE BUTTON
            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton(
                onPressed: isLoading ? null : saveBiodata,

                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color.fromARGB(255, 6, 81, 83),
                  foregroundColor: Colors.white,
                ),

                child: isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text(
                        "SAVE BIODATA",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}