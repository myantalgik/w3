import 'mathUtils.dart';
import 'program.dart';

enum ET{und,cmd,vr,str,num,bool,del}//undefined,cmd,var,str,num,del,exp
enum EXT{und,assign,ari,bool}

class Entity{
  static final RegExp num_regex=RegExp(r"^-?[0-9]+");
  //
  String alias;
  late int id;
  late ET type;
  late dynamic val;

  Entity(this.id,this.alias,this.type,this.val);

  factory Entity.fromAlias(String alias)=>Entity(Program.idcount,alias.trim(),Entity.getEntityType(alias),Entity.getEntityVal(alias,Entity.getEntityType(alias)));

  factory Entity.clone(Entity ent)=>Entity(ent.id,ent.alias,ent.type,ent.val);
  static List<Entity> cloneList(List<Entity> ents)=>ents.map((Entity ent)=>Entity.clone(ent)).toList();

  static ET getEntityType(String alias){
    if(Program.DELS.contains(alias)||Program.DOUBLE_DELS.contains(alias)){
      return ET.del;
    }else if(Program.CMDS.contains(alias)){
      return ET.cmd;
    }else if(alias.startsWith("_")){
      return ET.vr;
    }else if(alias.startsWith("#STR_")){
      return ET.str;
    }else if(Entity.num_regex.hasMatch(alias)){
      return ET.num;
    }else if(alias=="true"||alias=="false"){
      return ET.bool;
    }
    return ET.und;
  }
  static dynamic getEntityVal(String alias,ET type){
    switch(type){
      case ET.und:
      return "und";
      case ET.cmd:
      return alias;
      case ET.vr:
      return Program.vars[alias];
      case ET.str:
      final int strIdx=int.parse(alias.substring(5));
      return Program.strs[strIdx];
      case ET.num:
      return double.parse(alias);
      case ET.bool:
      return alias=="true";
      case ET.del:
      return alias;
      default:
      return "und";
    }
  }

  void log(){
    print(id.toString()+" "+alias+" "+type.toString()+" "+val.toString());
  }
  static void logList(List<Entity> ents){
    print("Logging list of entities");
    ents.forEach((element){element.log();});
    print("_____");
  }

}

class Inst{

  List<List<Entity>> args=<List<Entity>>[];

  Inst(){
  }

  void addArg(){
    args.add(<Entity>[]);
  }
  void addEntity(int argIdx,Entity ent){
    args[argIdx].add(ent);
  }

}

class Exp{
  List<Entity> ents=[];

  Exp(List<Entity> data){
    this.ents=Entity.cloneList(data);
  }

  static dynamic eval(Exp exp){
    final List<Entity> ents=exp.ents;
    int closesCount=0;
    ents.forEach((Entity ent){if(ent.val==")")closesCount++;});
    int lastOpenIdx=0;
    int cc=0;//avoid infinite loop just in case
    while(closesCount>0&&cc<10){
      for(int i=0;i<ents.length;i++){
        final Entity ent=ents[i];
        final dynamic val=ent.val;
        if(val=="("){
          lastOpenIdx=i;
        }
        if(val==")"){
          final int sidx=lastOpenIdx;
          final Exp toeval=Exp(ents.sublist(sidx+1,i));//removing ()
          //print("to eval: ${sidx+1} $i");
          //toeval.log();
          final dynamic sres=Exp.eval(toeval);
          //print(sres);
          //final dynamic sres="und";
          ents.replaceRange(sidx,i+1,[Entity.fromAlias(sres.toString())]);
          closesCount--;
          break;
        }
      }
      cc++;
    }
    ents.forEach((Entity e){//update vars
      if(e.type==ET.vr){
        e.val=Program.vars[e.alias];
      }
    });
    if(ents.length==1)return ents[0].val;
    //print("hh");
    //Entity.logList(ents);
    final EXT ext=Exp.getType(ents[1].val);
    switch(ext){
      case EXT.assign:
      return evalAssign(exp);
      case EXT.ari:
      return evalAri(exp);
      case EXT.bool:
      return evalBool(exp);
      default:
      return null;
    }
  }

  static EXT getType(String val){
    if(val=="="){
      return EXT.assign;
    }else if(["+","-","*","/"].contains(val)){
      return EXT.ari;
    }else if([">","<",">=","<=","==","&&","||"].contains(val)){
      return EXT.bool;
    }
    return EXT.und;
  }

  void log(){
    Entity.logList(ents);
  }

}