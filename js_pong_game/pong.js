var Pong=function(){
    var _=this;
    this.paddleWidth=10;
    this.paddleHeight=100;
    this.ballRadius=10;
    this.ballSpeed=6;
    this.ballXDir=this.ballYDir=1;
    this.paddleSpeed=4;
    this.paddle1={x:10,y:ch/2-_.paddleHeight/2,w:_.paddleWidth,h:_.paddleHeight};
    this.paddle2={x:cw-_.paddleWidth-10,y:ch/2-_.paddleHeight/2,w:_.paddleWidth,h:_.paddleHeight};
    this.ball={x:cw/2,y:ch/2,r:_.ballRadius};
    this.p1score=this.p2score=0;
    this.pause=true;

    this.init=function(){
    }

    this.draw=function(cc){
        drawRect(cc,_.paddle1.x,_.paddle1.y,_.paddle1.w,_.paddle1.h,paddleColor);
        drawRect(cc,_.paddle2.x,_.paddle2.y,_.paddle2.w,_.paddle2.h,paddleColor);
        drawCircle(cc,_.ball.x,_.ball.y,_.ball.r,ballColor);
    }

    this.update=function(cc){
        _.draw(cc);
        if(_.pause)return;
        _.updatePlayerPaddleMovement();
        _.updateFoePaddleMovement();
        _.updateBallMovement();
    }

    this.updatePlayerPaddleMovement=function(){
        if(upKey){
            _.paddle1.y+=_.paddleSpeed*-1;
        }
        if(downKey){
            _.paddle1.y+=_.paddleSpeed*1;
        }
    }

    this.updateFoePaddleMovement=function(){
        if(_.ballYDir<0){
            _.paddle2.y-=_.paddleSpeed;
        }else{
            _.paddle2.y+=_.paddleSpeed;
        }
    }

    this.updateBallMovement=function(){
        _.ball.x+=_.ballSpeed*_.ballXDir;
        _.ball.y+=_.ballSpeed*_.ballYDir;
        let boundColl=outBound(_.ball.x,_.ball.y,_.ball.r,_.ball.r,0,0,cw,ch);
        if(boundColl){
            if(boundColl=="x"){
                _.ballXDir*=-1;
                if(_.ballXDir<0){
                    _.p1score++;
                }else{
                    _.p2score++;
                }
                score_board.innerText=_.p1score+" | "+_.p2score;
            }else{
                _.ballYDir*=-1;
            }
        }
        if(_.ball.y>_.paddle1.y && _.ball.y<_.paddle1.y+_.paddleHeight && _.ball.x-_.ballRadius<_.paddle1.x+_.paddleWidth){
            _.ballXDir=1;
        }
        if(_.ball.y>_.paddle2.y && _.ball.y<_.paddle2.y+_.paddleHeight && _.ball.x+_.ballRadius>_.paddle2.x){
            _.ballXDir=-1;
        }
    }

    
};