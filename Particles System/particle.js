class Particle{
    life;
    dir;

    constructor(orgLife,pos,angle,color,size,speed){
        this.orgLife=this.life=orgLife;
        this.pos=pos;
        this.angle=angle;
        this.color=color;
        this.size=size;
        this.speed=speed;
        this.dir={x:Math.cos(angle*Math.PI/180)*-1,y:Math.sin(angle*Math.PI/180)*-1};
    }

    draw(cc,dt){//cc is the canvas context
        //updating
        this.life-=dt;
        this.pos.x+=this.speed*this.dir.x;
        this.pos.y+=this.speed*this.dir.y;
        //rendering
        cc.fillStyle=this.color;
        cc.beginPath();
        cc.arc(this.pos.x,this.pos.y,this.size,0,Math.PI*2);
        cc.fill();
        cc.closePath();
    }

}