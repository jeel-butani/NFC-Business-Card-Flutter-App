import 'package:flutter/material.dart';

class Connection extends StatefulWidget {
  const Connection({super.key});

  @override
  State<Connection> createState() => _ConnectionState();
}

class _ConnectionState extends State<Connection> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: Container()),
          const Text(
            'No Profile Found',
            style: TextStyle(
                fontFamily: ' ',
                color: Color.fromARGB(255, 255, 17, 0),
                fontSize: 30,
                fontWeight: FontWeight.bold),
          ),
          Expanded(child: Container()),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 22, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.07,
                  width: MediaQuery.of(context).size.width * 0.15,
                  decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(400)),
                  child: const Icon(
                    Icons.nfc,
                    size: 42,
                    color: Color.fromARGB(255, 251, 20, 3),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
