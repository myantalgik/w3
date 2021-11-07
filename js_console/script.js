//components
//console component
class Console{
    version="0.1.0";
    welcome_message="JS Console v0.1.0";
    comps=[];
    input_received=false;
    user_input="";
    blocking_interval=null;
    text_color="whitesmoke";
    error_color="red";
    success_color="teal";
    warning_color="yellow";
    constructor(root){
        this.elem=document.createElement("div");
        this.elem.className="console";
        this.elem.addEventListener('click',()=>{
            if(this.lastComp.elem.className=="input"){
                this.lastComp.elem.focus();
            }
        });
        root.appendChild(this.elem);
        this.writeWarning(this.welcome_message);
        this.lineBreak();
    }
    appendComponent(comp){
        this.comps.push(comp);
        this.elem.appendChild(comp.elem);
    }
    execute(func){
        func();
    }
    writeLine(txt){
        let text=new Text(txt,this.text_color);
        this.appendComponent(text);
    }
    writeError(txt){
        let text=new Text(txt,this.error_color);
        this.appendComponent(text);
    }
    writeWarning(txt){
        let text=new Text(txt,this.warning_color);
        this.appendComponent(text);
    }
    writeSuccess(txt){
        let text=new Text(txt,this.success_color);
        this.appendComponent(text);
    }
    async readLine(txt){
        if(txt)this.writeLine(txt);
        let input=new Input(this.text_color);
        this.appendComponent(input);
        input.elem.focus();
        return new Promise(resolve=>{
            this.blocking_interval=setInterval(()=>{
                if(this.input_received){
                    this.input_received=false;
                    clearInterval(this.blocking_interval);
                    resolve(this.user_input);
                }
            },500);
        })
    }
    async readChoice(choices,txt=null,bgcolor="darkgrey",color="black"){
        if(txt)this.writeLine(txt);
        let choice=new Choice(choices,bgcolor,color);
        this.appendComponent(choice);
        return new Promise(resolve=>{
            this.blocking_interval=setInterval(()=>{
                if(this.input_received){
                    this.input_received=false;
                    clearInterval(this.blocking_interval);
                    resolve(this.user_input);
                }
            },500);
        })
    }
    displayButton(text,callback,bgcolor="darkgrey",color="black"){
        let button=new Button(text,callback,bgcolor,color);
        this.appendComponent(button);
    }
    async waitFor(millis){
        return new Promise(resolve=>{
            setTimeout(()=>this.input_received=true,millis);
            this.blocking_interval=setInterval(()=>{
                if(this.input_received){
                    this.input_received=false;
                    clearInterval(this.blocking_interval);
                    resolve(true);
                }
            },500);
        })
    }
    lineBreak(){
        let text=new Text("<br>",this.text_color);
        this.appendComponent(text);
    }
    clear(){
        for(let i=0;i<this.comps.length;i++){
            this.comps[i].elem.parentNode.removeChild(this.comps[i].elem);
        }
        this.comps.length=0;
        this.writeWarning(this.welcome_message);
        this.lineBreak();
    }
    setBGColor(color){
        this.elem.style.backgroundColor=color;
    }
    resetBGColor(){
        this.elem.style.backgroundColor="black";
    }
    setTextColor(color){
        this.text_color=color;
    }
    resetTextColor(){
        this.text_color="whitesmoke";
    }
    //helpers
    get lastComp(){return this.comps[this.comps.length-1]};
}
//text component
class Text{
    constructor(txt,color){
        this.elem=document.createElement("p");
        this.elem.className="text";
        this.elem.style.color=color;
        this.elem.innerHTML=txt;
    }
}
//input component
class Input{
    constructor(color){
        this.elem=document.createElement("p");
        this.elem.className="input";
        this.elem.style.color=color;
        this.elem.contentEditable=true;
        this.elem.addEventListener('keydown',function(e){
            let key=e.key;
            if(key=="Enter"){
                e.preventDefault();
                cmd.user_input=cmd.lastComp.elem.innerText;
                cmd.input_received=true;
                cmd.lastComp.elem.contentEditable=false;
                cmd.lastComp.elem.style.borderWidth="0px";
            }
        });
    }
}
//button component
class Button{
    constructor(txt,callback,bgcolor,color){
        this.elem=document.createElement("span");
        this.elem.className="button";
        this.elem.style.backgroundColor=bgcolor;
        this.elem.style.color=color;
        this.elem.innerText=txt;
        this.elem.addEventListener('click',(e)=>{callback(e);});
    }
}
//choice component
class Choice{
    constructor(choices,bgcolor,color){
        this.elem=document.createElement("div");
        this.elem.className="choice_container";
        choices.forEach(element=>{
            let button_comp=new Button(element,()=>{
                cmd.user_input=element;
                cmd.input_received=true;
            },bgcolor,color);
            this.elem.appendChild(button_comp.elem);
        });
    }
}
