//Test
let root=document.getElementById("root");
let cmd=new Console(root);

//rgb to hex conversion
cmd.execute(async ()=>{

    while(true){
        cmd.writeLine("__MENU__");
        cmd.lineBreak();
        let choice=await cmd.readChoice(["RGB To Hex",'Hex To RGB']);
        cmd.clear();
        if(choice=="RGB To Hex"){
            cmd.writeLine(choice);
            let input=await cmd.readLine("Enter RGB color: (expected format 'r,g,b')");
            let color_values=input.split(",");
            color_values=color_values.map((val)=>parseInt(val).toString(16));
            let res="#"+color_values.join("");
            cmd.writeSuccess("Result: "+res);
        }else if(choice=="Hex To RGB"){
            cmd.writeLine(choice);
            let input=await cmd.readLine("Enter Hex color (expected format '#xxxxxx')");
            let r=parseInt(input.substr(1,2),16);
            let g=parseInt(input.substr(3,2),16);
            let b=parseInt(input.substr(5,2),16);
            let res=r+','+g+','+b;
            cmd.writeSuccess("Result: "+res);
        }
        cmd.lineBreak();
        let choice2=await cmd.readChoice(["Back To Menu","End"]);
        cmd.clear();
        if(choice2=="Back To Menu"){
            //loop
        }else if(choice2=="End"){
            cmd.writeSuccess("Terminated!");
            break;
        }
    }

});