import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:use_indexeddb_as_filestorage/idb_file.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Indexed DB Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Indexed DB Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String _directoryPath = '/AAA/BBB/CCC/';
  String _fileNameBase = 'File-';
  int _fileNo = 0;

  String _lastFilePath = '';
  String _lastFileType = '';
  int _lastFileLength = 0;

  Future<void> addTextFile() async {
    String contents = await rootBundle.loadString('sample.txt');
    String filePath = '$_directoryPath$_fileNameBase${_fileNo.toString()}';

    IdbFile idbFile = IdbFile(filePath);
    idbFile.writeAsString(contents);

    _lastFileType = 'String';
    _lastFilePath = filePath;

    int readLength = -1;
    if( await idbFile.exists() ){
      String readContents = await idbFile.readAsString();
      readLength = readContents.length;
    }
    else{
      // Something wrong...
    }
    _lastFileLength = readLength;
    _fileNo++;

    setState(() {

    });

  }

  Future<void> addBinaryFile() async {
    ByteData contents = await rootBundle.load('icon.png');
    String filePath = '$_directoryPath$_fileNameBase${_fileNo.toString()}';

    IdbFile idbFile = IdbFile(filePath);
    idbFile.writeAsBytes(contents.buffer.asUint8List());

    _lastFileType = 'Binary';
    _lastFilePath = filePath;

    int readLength = -1;
    if( await idbFile.exists() ){
      List<int> readContents = await idbFile.readAsBytes();
      readLength = readContents.length;
    }
    else{
      // Something wrong...
    }
    _lastFileLength = readLength;
    _fileNo++;

    setState(() {

    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: addTextFile,
                  child: const Text('Add Text File'),
                ),
                const SizedBox(width: 4),
                ElevatedButton(
                  onPressed: addBinaryFile,
                  child: const Text('Add Binary File'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Added file',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'type: $_lastFileType',
            ),
            Text(
              'path: $_lastFilePath',
            ),
            Text(
              'length: $_lastFileLength',
            ),
          ],
        ),
      ),
    );
  }
}
