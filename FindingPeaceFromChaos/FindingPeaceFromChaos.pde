// 卢之睿

// 闹中取静
// 为袁老师的「离线自习室」而作
// 无需操作，稍等约30s即可
// 按下 [空格] 暂停动画
// 按下 [s] 保存为 PNG 图片

import java.util.*;
import processing.pdf.*;
import java.util.Calendar;

PImage wordBackground;
PImage wordRevBackground;
PGraphics pg;
PGraphics pg2;
PFont font;

boolean[] maskArray;
color[] resizedWordBackgroundPixels;
List<MovingPoint> pointList;
int pointCount = 300;
double speedValue = 5;
int refreshOpacity = 10;
int cnt = 0;
int maxCnt = 1_000_000;

boolean savePDF = false;
boolean running = true;

int indexConvert(int x, int y) {
    return y * width + x;
}

// allow Python style print
void myPrint(Object... args) {
    for (Object o : args) {
        print(o);
        print(" ");
    }
    println();
}

String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}

void setup() {

    font = createFont("微软雅黑", 32, true);
    textFont(font);

    wordBackground = loadImage("squared.png");
    wordRevBackground = loadImage("squared_rev.png");
    println(wordBackground.width);

    pg = createGraphics(800, 1000);
    pg2 = createGraphics(800, 1000);
    pg.beginDraw();
    pg.tint(0, 200, 255, 10);
    pg.image(wordRevBackground,0,0,800,800);
    pg.endDraw();

    size(800, 1000);

    image(wordBackground, 0, 0, 800, 800);
    loadPixels();

    resizedWordBackgroundPixels = Arrays.copyOf(pixels, pixels.length);
    background(255);
    maskArray = new boolean[resizedWordBackgroundPixels.length];

    // create mask
    for (int i = 0; i < maskArray.length; i++) {
        color c = resizedWordBackgroundPixels[i];
        double grey = red(c) * 0.299 + green(c) * 0.587 + blue(c) * 0.114;
        maskArray[i] = (grey < 128) ? true : false; // if mask=True, then this part is black....
    }

    noStroke();

    // init point list
    pointList = new ArrayList<MovingPoint>(pointCount);
    for (int i = 0; i < pointCount; i++) {
        MovingPoint mp = new MovingPoint(random(width), random(height), speedValue,
                random(360) / 360.0 * 2 * Math.PI);
        pointList.add(mp);
    }
    // println(pointList);

    // String[] fontList = PFont.list();
    // printArray(fontList);

}

void draw() {

    if (savePDF) beginRecord(PDF, timestamp()+".pdf");

    //image(pg2,0,0);
  
    // leave trace

    if(running){

    fill(255, 255, 255, refreshOpacity);
    rect(0,0,width,height);
    color c = color(0,0,0);
    fill(c);

    // for each moving point
    for(int i=0;i<pointCount;i++){
        MovingPoint mp = pointList.get(i);

        int xpos = (int)mp.xpos;
        int ypos = (int)mp.ypos;

        if(! ( (0<xpos && xpos<width) && (0<ypos && ypos <height) ) ){
            // out of boundary
            mp = new MovingPoint(random(width), random(height), speedValue, random(360) / 360.0 * 2 * Math.PI);
            pointList.set(i,mp);
            continue;
        }

        if(!maskArray[indexConvert(xpos, ypos)]){
            set(xpos, ypos, c);
        } else {
            cnt++;
        }

        mp.move();
    }

    //tint(255, (int)(cnt * 4.0 * 255 / maxCnt ));
    //image(pg,0,0);

    // words
    // pg2.beginDraw();
    textAlign(CENTER);
    //tint(127,255);
    //pg2.tint(255,(int)(cnt * 1.0 * 255 / maxCnt ) );

    fill(0, 0, 0, 10);
    text("离 线 自 习 室",width/2,810);
    text("袁 长 庚", width/2, 860); 
    // pg2.endDraw();
    
    //tint(255,(int)(cnt * 10.0 * 255 / maxCnt ) );
    //image(pg2,0,0);

    }

    if (savePDF) {
    savePDF = false;
    endRecord();
  }
}

void keyReleased(){
  if (key=='s' || key=='S') saveFrame(timestamp()+"_##.png");
  if (key=='p' || key=='P') savePDF = true;
  if (key==' ') running = !running;
}
