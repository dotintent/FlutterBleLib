#Proto files generation:
1. Install newest protoc. It can be done via brew 
``` brew install protobuf```
2. If you don't have dart sdk on your computer please install it.
```brew isntall dart```
3. Get the latest dart-protoc-plugin from https://github.com/dart-lang/dart-protoc-plugin
4. Go to dart-protoc-plugin-<<version>> folder and call
```pub install```
5. Add plugin path to PATH
5. Make sure protoc + protoc-gen-dart + dart bins are all in the same path
6. Run the following command from the protos folder
```protoc --dart_out=../lib/generated ./bledata.proto```
   * if folder ../lib/generated does not exist please create it.