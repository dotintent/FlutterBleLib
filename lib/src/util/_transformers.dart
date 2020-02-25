import 'dart:async';

class CancelOnErrorStreamTransformer<T> extends StreamTransformerBase<T, T> {
  @override
  Stream<T> bind(Stream<T> stream) =>
      stream.transform(StreamTransformer<T, T>.fromHandlers(
        handleError: (error, stacktrace, sink) {
          sink.addError(error, stacktrace);
          sink.close();
        },
      ));
}
