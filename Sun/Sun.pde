// 卢之睿
// 日
// 上下方向键：增加/减少辐条数量
// 左右方向键：调整不同的发散模式

import tracer.*;
import tracer.paths.*;
import tracer.easings.*;

int n = 20; // 辐条数量
int r1 = 100; // 内径
int r2 = 300; // 外径
float trace = 0.3f; // 尾迹
float speed = 0.01f; // 速度

Path[] paths;
Tracer[] tracers;
Easing[] easings;
Easing easing;
Point center;
int easingSelection = 7; // 默认设定

void setup(){
  size(600, 600, P2D);
  
  easings = new Easing[]{
    Easings.getLinear(), 

    Easings.getQuadEaseIn(), 
    Easings.getQuadEaseOut(), 
    Easings.getQuadEaseInOut(), 

    Easings.getCubicEaseIn(), 
    Easings.getCubicEaseOut(), 
    Easings.getCubicEaseInOut(), 

    Easings.getCircEaseIn(), 
    Easings.getCircEaseOut(), 
    Easings.getCircEaseInOut()
  };
  easing = easings[easingSelection];
  
  center = new Point(width/2, height/2);
  initPathsAndTracers(n, center);
  
}

void initPathsAndTracers(int n, Point center){
  paths = new Path[n];
  tracers = new Tracer[n];
  float xoff = 0.0;
  for(int i=0;i<n;i++){
    double currentDegree = 2 * Math.PI / n * i;
    double x1 = center.x + Math.cos(currentDegree) * r1;
    double y1 = center.y + Math.sin(currentDegree) * r1;
    double x2 = center.x + Math.cos(currentDegree) * r2;
    double y2 = center.y + Math.sin(currentDegree) * r2;
    paths[i] = new Line((float)x1, (float)y1, (float)x2, (float)y2);
    xoff = 1.0f/n * i;
    tracers[i] = new Tracer(paths[i], xoff, speed); 

  }
}

void draw(){
  //background(255);
  for(Tracer t: tracers){
    t.step();
  }
 
    strokeWeight(2);
  stroke(0);
  fill(0);
  ellipseMode(CENTER);
  background(255);
  
  for(int i=0;i<n;i++){
    //paths[i].draw(g);
    float currentPos = easing.val(tracers[i].getInput1D());
    float start = Path.remainder(currentPos - trace, 1);
    float end = currentPos;
    strokeWeight(1);
    paths[i].draw(g, start, end);
  }
  
  strokeWeight(0);
  fill(color(241,141,0));
  circle(width/2, height/2, r1*1.5f);
  
}

void keyPressed() {
  if(key==CODED){
    
    switch(keyCode){
       case UP:
       n++;
       break;
       case DOWN:
       n--;
       break;
       case LEFT:
       easingSelection++;
       break;
       case RIGHT:
       easingSelection--;
       break;
      
    }
  }    
    easingSelection += easings.length;
    easingSelection %= easings.length;
    easing = easings[easingSelection];
    println("当前easing："+ easing);
    initPathsAndTracers(n, center);

}
