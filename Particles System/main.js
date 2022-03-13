var can=document.getElementById("can");
var cc=can.getContext("2d");
var canWidth=can.width;var canHeight=can.height;

var dt=0;//deltatime
var lastTime=new Date();

var particleSystem=new ParticlesSystem(100,{x:canWidth*0.5,y:canHeight*0.85},0.2,0.5,0,180);

function draw(){
    //updating dt
    dt=(new Date()-lastTime)/1000;
    lastTime=new Date();
    //updating and rendering
    cc.clearRect(0,0,can.width,can.height);
    particleSystem.draw(cc,dt);
    requestAnimationFrame(draw);
}

draw();