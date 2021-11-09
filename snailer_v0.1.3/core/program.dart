import 'dart:convert';
import 'dart:io';

import 'coreObjects.dart';
import 'decoder.dart';

class Program{
  static int idcount=0;
  static final List<String> CMDS=<String>["var","write","read","if","else","elif","endif","while","endwhile"];
  static final List<String> DELS=<String>[" ","'",",",";","(",")","{","}","&","|","+","-","*","/","%","=",">","<"];//delemiters
  static final List<String> DOUBLE_DELS=<String>["&&","||","==",">=","<="];//delemiters
  static Map<String,dynamic> vars=Map<String,dynamic>();
  static Map<String,String> blocs=Map<String,String>();
  static List<String> strs=<String>[];
  static List<Inst> insts=<Inst>[];
  static bool inCond=false;
  static bool lastCondRes=false;
  static bool lastCondResolved=false;
  static bool inLoop=false;
  static int loopIdx=-1;
  static List<int> loopsStartIdx=<int>[];
  static List<bool> loopsRes=<bool>[];
  static Exp loopCondExp=Exp([]);
  static int cc=0;

  Program();

  static bool decode(String code){
    Duration startMillis=Duration(milliseconds:DateTime.now().millisecond);
    code=code.trim();
    code=code.replaceAll("\n","");
    Decoder.decodeEntities(code);
    Duration elapsed=Duration(milliseconds:DateTime.now().millisecond)-startMillis;
    print("DECODED WITHIN ${elapsed.inMilliseconds} ms");
    return true;
  }

  static Future<bool> exec()async{
    Duration startMillis=Duration(milliseconds:DateTime.now().millisecond);
    for(int i=0;i<insts.length;i++){
      final Inst inst=insts[i];
      final List<List<Entity>> args=inst.args;
      //print("In Inst $i");
      //args.forEach((element) { Entity.logList(element);});
      final Entity head=args[0][0];
      final String cmd=head.alias;
      //print("CMD $cmd");
      final List<List<Entity>> cmd_args=args.sublist(1);
      //for conditions
      //bool proceed=true;
      if(inLoop){
        if(cmd=="endwhile"){
          //final dynamic res=Exp.eval(loopCondExp);
          //loopsRes[loopIdx]=res;
          if(loopsRes[loopIdx]){
            i=loopsStartIdx[loopIdx];
            //print("STARTING AT IDX $i");
            continue;
          }else{
            loopIdx--;
            loopsStartIdx.clear();
            loopsRes.clear();
            inLoop=loopIdx>=0;
            //print("inloop $inLoop");
          }
        }else{
          if(!loopsRes[loopIdx])continue;
        }
        cc++;
        if(cc>100){
          print("BREAK PROGRAM LOOP");
          return false;
        }
      }
      if(inCond){
        if(cmd=="endif"){
          inCond=false;
          lastCondRes=false;
          lastCondResolved=false;
        }else{
          if(!lastCondRes&&cmd!="else"&&cmd!="elif")continue;
        }
        //proceed=lastCondRes;
      }
      //print("canproceed $proceed");
      //one arg inst
      if(args.length==1&&args[0].length>1){//instructions with one argument but with more than one entity
        //if(!proceed)continue;
        final Exp exp=Exp(args[0]);
        final dynamic res=Exp.eval(exp);
      }else{
        switch(cmd){
          case "write":
          //if(!proceed)break;
          final Exp exp=Exp(cmd_args[0]);
          final dynamic res=Exp.eval(exp);
          print(res);
          break;
          case "read":
          //if(!proceed)break;
          final input=stdin.readLineSync(encoding:utf8);
          addVar(cmd_args[0][0].alias,input);
          break;
          case "if":
          final Exp exp=Exp(cmd_args[0]);
          final dynamic res=Exp.eval(exp);
          inCond=true;
          lastCondRes=res;
          lastCondResolved=res;
          break;
          case "elif":
          if(lastCondResolved){
            lastCondRes=false;
            break;
          }
          final Exp exp=Exp(cmd_args[0]);
          final dynamic res=Exp.eval(exp);
          lastCondRes=res;
          lastCondResolved=res;
          break;
          case "else":
          lastCondRes=lastCondResolved?false:true;
          print("last cond res $lastCondRes");
          break;
          case "while":
          loopCondExp=Exp(cmd_args[0]);
          final Exp exp=loopCondExp;
          final dynamic res=Exp.eval(exp);
          //print("LOOP RES $res");
          loopIdx++;
          loopsStartIdx.add(i-1);
          loopsRes.add(res);
          inLoop=true;
          break;
          default:
          break;
        }
      }
    }
    Duration elapsed=Duration(milliseconds:DateTime.now().millisecond)-startMillis;
    print("PROGRAM TERMINATED WITHIN ${elapsed.inMilliseconds} ms");
    return true;
  }

  static Entity addEntity(int instIdx,int argIdx,String alias){
    //print("adding $alias");
    if(alias=='')return Entity.fromAlias("und");
    //print("adding ent $alias to inst $instIdx argidx $argIdx");
    final Entity ent=Entity.fromAlias(alias);
    Program.insts[instIdx].addEntity(argIdx,ent);
    idcount++;
    return ent;
  }

  static void addVar(String name,dynamic val){
    Program.vars[name]=val;
  }

}