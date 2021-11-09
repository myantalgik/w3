import 'coreObjects.dart';
import 'program.dart';

class Decoder{

  static void decodeEntities(String code){
    String word="";
    String inDel="";
    String prevChar="";
    bool appendChar=true;
    int instIdx=0;
    int argIdx=0;
    Program.insts.add(Inst());
    Program.insts[instIdx].addArg();
    for(int i=0;i<code.length;i++){
      final String char=code[i];
      appendChar=true;
      //check dels
      if(Program.DELS.contains(char)){
        appendChar=false;
        //check strings
        if(char=="'"){
          if(inDel=="'"){
            //found string
            Program.strs.add(word);
            Program.addEntity(instIdx,argIdx,"#STR_${Program.strs.length-1}");
            inDel="";
            word="";
          }else{
            //just found string
            inDel="'";
            Program.addEntity(instIdx,argIdx,word);
            word="";
          }
        }else{//any other del
          if(inDel=="'"){word+=char;continue;}//skip if in string delimiter
          //check for other types
          final Entity ent=Program.addEntity(instIdx,argIdx,word);
          if(char!=","&&char!=" "&&char!=";"){//not added as they define new arguments/instruction
            final String doubleChar=prevChar+char;
            if(["&&","||","==",">=","<="].contains(doubleChar)){//check double char delemiters (&&,||,==)
              Program.insts[instIdx].args[argIdx].removeLast();
              Program.addEntity(instIdx,argIdx,doubleChar);
            }
            else Program.addEntity(instIdx,argIdx,char);
          }else{
            if(char==";"){
              instIdx++;
              argIdx=0;
              //print("ARGSID IS NOW $argIdx");
              Program.insts.add(Inst());
              Program.insts[instIdx].addArg();
            }else if(char==","){
              argIdx++;
              //print("ARGSID++ IS NOW $argIdx char $char");
              Program.insts[instIdx].addArg();
            }
          }
          word="";
        }
      }
      prevChar=char;
      if(appendChar){word+=char;}
    }
    //remove last instruction(empty)
    Program.insts.removeLast();
  }

}