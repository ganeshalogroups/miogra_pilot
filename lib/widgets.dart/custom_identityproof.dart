// ignore_for_file: depend_on_referenced_packages

import 'package:miogra_service/Const.dart/const_colors.dart';
import 'package:miogra_service/Controller.dart/AuthController.dart/fileuploadcontroller.dart';
import 'package:miogra_service/Controller.dart/AuthController.dart/registercontroller.dart';
import 'package:miogra_service/widgets.dart/custom_container.dart';
import 'package:miogra_service/widgets.dart/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:get/get.dart';

class IdentityProof extends StatefulWidget {
  final String label;
  final void Function(File) onFileChosen;
  final TextStyle? style;
  final File? initialFile;

  const IdentityProof({
    super.key,
    required this.label,
    required this.onFileChosen,
    this.style,
    this.initialFile,
  });

  @override
  // ignore: library_private_types_in_public_api
  _IdentityProofState createState() => _IdentityProofState();
}

class _IdentityProofState extends State<IdentityProof> {
  File? _imageFile;
  ImageUploader imageUploader = Get.put(ImageUploader());

  @override
  void initState() {
    super.initState();
    _imageFile = widget.initialFile;
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null && pickedImage.path.isNotEmpty) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
      // Check the file extension
      File file = File(_imageFile!.path);
      String extension = file.path.split('.').last.toLowerCase();
      if (['jpg', 'jpeg', 'png', 'gif', 'svg'].contains(extension)) {
        widget.onFileChosen(_imageFile!);

        final registerController = Get.put(RegisterController());

        if (widget.label == 'Aadhar Front') {
          registerController.updateAadharFrontUrl(_imageFile!.path);
        } else if (widget.label == 'Aadhar Back') {
          registerController.updateAadharBackUrl(_imageFile!.path);
        } else if (widget.label == 'License Front') {
          registerController.updateLicenseFrontUrl(_imageFile!.path);
        } else if (widget.label == 'License Back') {
          registerController.updateLicenseBackUrl(_imageFile!.path);
        } else if (widget.label == 'RC Front') {
          registerController.updateRcUrl(_imageFile!.path);
        } else if (widget.label == 'RC Back') {
          registerController.updateInsuranceUrl(_imageFile!.path);
        }
      } else {
        Get.snackbar("Invalid File", "Please select a valid image file.");
      }
    } else {
      Get.snackbar("Error", "No image selected.");
    }
  }

  String getFileName() {
    if (_imageFile != null && _imageFile!.existsSync()) {
      return _imageFile!.path.split('/').last;
    } else {
      return 'No File Chosen';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: Row(
        children: [
          CustomContainer(
            height: 65,
            borderRadius: BorderRadius.circular(8),
            width: MediaQuery.of(context).size.width / 6,
            backgroundColor: Colors.grey.shade300,
            child: _imageFile != null && _imageFile!.existsSync()
                ? Image.file(
                    _imageFile!,
                    fit: BoxFit.cover,
                    width: 65,
                    height: 65,
                  )
                : Icon(
                    MdiIcons.imageSizeSelectActual,
                    color: Colors.grey.shade400,
                  ),
          ),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.label, style: widget.style),
              SizedBox(height: 10),
              CustomContainer(
              borderRadius: BorderRadius.circular(8),
                backgroundColor: Customcolors.decorationGreen,
                width: MediaQuery.of(context).size.width / 1.6,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      CustomContainer(
                        height: 25,
                        width: MediaQuery.of(context).size.width / 4,
                        border: Border.all(color: Colors.green),
                        child: Center(
                          child: CustomText(
                            text: 'Choose File',
                            color: Colors.green,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 4,
                        child: CustomText(
                          text: getFileName(),
                          overflow: TextOverflow.clip,
                          fontSize: getFileName() == 'No File Chosen' ? 10 : 6,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
