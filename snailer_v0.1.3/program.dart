import 'core/program.dart';

void main(List<String> arguments){

  final String code="""
  write,'I AM TOO SLOW!';
  """;

  print("****DECODING SNAILER****");
  Program.decode(code);

  print("****EXECUTING SNAILER CODE****");
  Program.exec();

  /*print("***EXECUTING DART CODE*****");
  Duration startMillis=Duration(milliseconds:DateTime.now().millisecond);

  //dart here
  int i=0;
  while(i<10){
    print("${i+1}");
    i++;
  }

  Duration elapsed=Duration(milliseconds:DateTime.now().millisecond)-startMillis;
  print("DART TERMINATED WITHIN ${elapsed.inMilliseconds} ms");*/
}
