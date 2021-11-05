const clearColor="#061030";
const paddleColor="#EEEEEE";
const ballColor="#d63031";
const can=document.getElementById("can");
const cw=can.width;const ch=can.height;
var upKey=false;var downKey=false;
const score_board=document.getElementById("score_board");
var cc,pong;

function init(){
    window.addEventListener("keyup",onKeyUp);
    window.addEventListener("keydown",onKeyDown);
    cc=can.getContext("2d");
    pong=new Pong();
    pong.init();
}

function update(){
    clearCanvas(cc);
    pong.update(cc);
    requestAnimationFrame(update);
}

function onKeyDown(e){
    let keycode=e.keyCode;
    //up
    if(keycode==38){
        upKey=true;
    }
    //down
    if(keycode==40){
        downKey=true;
    }
    //space
    if(keycode==32){
        pong.pause=!pong.pause;
        score_board.innerText=(pong.pause)?"Space To Resume":pong.p1score+" | "+pong.p2score;
    }
}

function onKeyUp(e){
    let keycode=e.keyCode;
    //up
    if(keycode==38){
        upKey=false;
    }
    //down
    if(keycode==40){
        downKey=false;
    }
}  



init();
update();