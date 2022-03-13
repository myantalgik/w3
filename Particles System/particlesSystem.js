const colors=["#F06292","#BA68C8","#90CAF9"];
class ParticlesSystem{
    particles;
    nextSpawnTime;
    spawnTimer;

    constructor(initialParticlesCount,orgPos,minSpawnDelay,maxSpawnDelay,minAngle,maxAngle){
        this.initialParticlesCount=initialParticlesCount;
        this.orgPos=orgPos;
        this.minSpawnDelay=minSpawnDelay;
        this.maxSpawnDelay=maxSpawnDelay;
        this.minAngle=minAngle;
        this.maxAngle=maxAngle;
        this.particles=[];
        this.init();
    }

    init(){
        for(let i=0;i<this.initialParticlesCount;i++){
            this.spawnParticle();
        }
        this.nextSpawnTime=this.rndBetween(this.minSpawnDelay,this.maxSpawnDelay);
        this.spawnTimer=0;
    }

    draw(cc,dt){
        this.spawnTimer+=dt;
        if(this.spawnTimer>this.nextSpawnTime){
            this.spawnParticle();
            this.spawnTimer=0;
            this.nextSpawnTime=this.rndBetween(this.minSpawnDelay,this.maxSpawnDelay);
        }
        for(let i=this.particles.length-1;i>=0;i--){
            let particle=this.particles[i];
            particle.draw(cc,dt);
            if(particle.life<0){
                this.particles.splice(i,1);
                console.log("particle deleted");
            }
        }
    }

    spawnParticle(){
        let particleLife=this.rndBetween(3,10);
        let particlePos={x:this.orgPos.x,y:this.orgPos.y};
        let particleAngle=this.rndBetween(this.minAngle,this.maxAngle);
        let particleColor=colors[this.rndBetween(0,colors.length)];
        let particleSize=this.rndBetween(5,10);
        let particleSpeed=this.rndBetween(1,3);
        let particle=new Particle(particleLife,particlePos,particleAngle,particleColor,particleSize,particleSpeed);
        this.particles.push(particle);
    }

    rndBetween(min,max){
        return Math.floor(Math.random()*(max-min)+min);
    }

}