import 'dart:isolate';

class IsolateUtils {
  Isolate? _isolate;
  late SendPort _sendPort;
  late ReceivePort _receivePort;

  SendPort get sendPort => _sendPort;

  Future<void> initIsolate() async {
    _receivePort = ReceivePort();
    print("Initializing Isolate...");
    _isolate = await Isolate.spawn<SendPort>(
      _entryPoint,
      _receivePort.sendPort,
    );

    _sendPort = await _receivePort.first;
    print("Isolate initialized with sendPort: $_sendPort");
  }

  static void _entryPoint(SendPort mainSendPort) async {
    print("Im entry point!!!!!----------------------------------");
    final childReceivePort = ReceivePort();
    print("Child Isolate entry point called");
    mainSendPort.send(childReceivePort.sendPort);
    print("Child ReceivePort sent to main Isolate");

    await for (final _IsolateData? isolateData in childReceivePort) {
      if (isolateData != null) {
        print("Received data in child Isolate: $isolateData");
        print("Isolate handler: ${isolateData.handler}");
        final results = await isolateData.handler(isolateData.params);
        print("Handler executed with results: $results");
        isolateData.responsePort.send(results);
        print("Results sent back to main Isolate");
      }
    }
  }

  void sendMessage({
    required Function handler,
    required Map<String, dynamic> params,
    required SendPort sendPort,
    required ReceivePort responsePort,
  }) {
    final isolateData = _IsolateData(
      handler: handler,
      params: params,
      responsePort: responsePort.sendPort,
    );

    print("Sending message to child Isolate: $isolateData");
    sendPort.send(isolateData);
  }

  void dispose() {
    _receivePort.close();
    _isolate?.kill(priority: Isolate.immediate);
    _isolate = null;
  }
}

class _IsolateData {
  Function handler;
  Map<String, dynamic> params;
  SendPort responsePort;

  _IsolateData({
    required this.handler,
    required this.params,
    required this.responsePort,
  });
}
