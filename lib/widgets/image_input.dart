import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;

class ImageInput extends StatefulWidget {
  final Function onSelectImage;
  ImageInput(this.onSelectImage);

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File _storageImage;

  _takePicture() async {
    final ImagePicker _picker = ImagePicker();
    PickedFile imageFile = await _picker.getImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );

    if (imageFile == null) {
      return;
    }

    setState(() {
      _storageImage = File(imageFile.path);
    });

    //Pega o caminho da pasta que será salvo a imagem
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    //Pega o caminho da imagem que foi tirada
    String fileName = path.basename(_storageImage.path);
    //Copia a imagem para a pasta do aplicativo

    final savedImage = await _storageImage.copy('${appDir.path}/$fileName');
    widget.onSelectImage(savedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 180,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          alignment: Alignment.center,
          child: _storageImage != null
              ? Image.file(
                  _storageImage,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
              : Text('Nenhuma Imagem'),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: FlatButton.icon(
            icon: Icon(Icons.camera),
            label: Text('Tirar foto'),
            textColor: Theme.of(context).primaryColor,
            onPressed: _takePicture,
          ),
        )
      ],
    );
  }
}
