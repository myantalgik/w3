import 'coreObjects.dart';
import 'program.dart';

dynamic evalAssign(Exp exp){
  final String varname=exp.ents[0].alias;
  final dynamic val=Exp.eval(Exp(exp.ents.sublist(2)));
  Program.addVar(varname,val);
  //print("ASSIGN $varname to $val");
  return val;
}

dynamic evalAri(Exp exp){
  final List<Entity> ents=exp.ents;
  final bool hasString=ents.any((element)=>element.type==ET.str);
  /*print("calc_BEG");
  ents.forEach((element) {print(element.toString());});
  print("calc_END");*/
  dynamic res=0;
  for(int i=0;i<ents.length;i++){
    final Entity ent=ents[i];
    if(i%2!=0){
      if(ent.val=="*"){
        res=ents[i-1].val*ents[i+1].val;
        ents.replaceRange(i-1,i+1,[Entity.fromAlias(res.toString())]);
      }else if(ent.val=="/"){
        res=ents[i-1].val/ents[i+1].val;
        ents.replaceRange(i-1,i+1,[Entity.fromAlias(res.toString())]);
      }
    }
  }
  if(hasString){
    res="";
    for(int i=0;i<ents.length;i++){
      final Entity ent=ents[i];
      if(i%2!=0){
        if(i==1)res+=ents[i-1].val.toString();
        if(ent.val=="+"){
          res+=ents[i+1].val.toString();
        }else if(ent.val=="-"){
          res-=ents[i+1].val.toString();
        }
      }
    }
  }else{
    res=0;
    for(int i=0;i<ents.length;i++){
      final Entity ent=ents[i];
      if(i%2!=0){
        if(i==1)res+=ents[i-1].val;
        if(ent.val=="+"){
          res+=ents[i+1].val;
        }else if(ent.val=="-"){
          res-=ents[i+1].val;
        }
      }
    }
  }
  
  return res;
}

bool evalBool(Exp exp){
  final List<Entity> ents=exp.ents;
  int signsCount=0;
  ents.forEach((e){if(e.val==">"||e.val=="<"||e.val=="=="||e.val==">="||e.val=="<=")signsCount++;});//first signs(>,<,=)
  while(signsCount>0){
    for(int i=0;i<ents.length;i++){
      final Entity ent=ents[i];
      if(i%2!=0){
        bool res=true;
        dynamic a=ents[i-1].val;
        dynamic b=ents[i+1].val;
        if(ent.val==">"){
          res=a>b;
        }else if(ent.val=="<"){
          res=a<b;
        }else if(ent.val=="=="){
          res=a==b;
        }else if(ent.val==">="){
          res=a>=b;
        }else if(ent.val=="<="){
          res=a<=b;
        }
        ents.replaceRange(i-1,i+2,[Entity.fromAlias(res.toString())]);
        signsCount--;
      }
    }
  }
  ents.forEach((e){if(e.val=="&&"||e.val=="||")signsCount++;});//second signs(&&,||)
  while(signsCount>0){
    for(int i=0;i<ents.length;i++){
      final Entity ent=ents[i];
      if(i%2!=0){
        bool res=true;
        dynamic a=ents[i-1].val;
        dynamic b=ents[i+1].val;
        if(ent.val=="&&"){
          res=a&&b;
        }else if(ent.val=="||"){
          res=a||b;
        }
        ents.replaceRange(i-1,i+2,[Entity.fromAlias(res.toString())]);
        signsCount--;
      }
    }
  }
  return ents[0].val;
}