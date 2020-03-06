// 卢之睿

// 新年「贺」卡？
// 刮

import java.util.*;

PImage frontImg;
PImage backgroundImg;
PGraphics frontPG;
PGraphics backgroundPG;
int[] transparancy;
int transparancyMax = 255;
int radius = 100;
int effectHeight, effectWidth;
int startX, startY;

int indexConvert(int x, int y) {
    return y * width + x;
}

void myPrint(Object... args) {
    for (Object o : args) {
        print(o);
        print(" ");
    }
    println();
}

boolean inBoundary(int x, int y){
    return (0<=x&& x <width) && (0<=y && y<height);
}

// 1 calc the new width, height
// 2 resize the image
// 3 calc the new starting point
// 4 remap

void calcNewDimension(int imgWidth, int imgHeight, int viewWidth, int viewHeight, int[] newDimensions){
    double widthRatio = 1.0*viewWidth / imgWidth;
    double heightRatio = 1.0*viewHeight / imgHeight;
    int newWidth = 0;
    int newHeight = 0;
    if(widthRatio==heightRatio){
        newWidth = viewWidth;
        newHeight = viewHeight;
    } else {
        if (widthRatio > heightRatio){
            newHeight = viewHeight;
            newWidth = (int) (imgWidth * heightRatio);
        } else {
            newWidth = viewWidth;
            newHeight = (int) (imgHeight * widthRatio);
        }
    }
    myPrint(widthRatio, heightRatio, newWidth, newHeight);
    newDimensions[0] = newWidth;
    newDimensions[1] = newHeight;
}

void calcNewStarting(int viewWidth, int viewHeight, int effectWidth, int effectHeight, int[] startPos){
    int startX, startY;
    if(viewWidth==effectWidth){
        int space = (viewHeight - effectHeight) / 2;
        startX=0;
        startY=space;
    } else {
        int space = (viewWidth - effectWidth) / 2;
        startY=0;
        startX=space;
    }
    startPos[0] = startX;
    startPos[1] = startY;
}

void setup(){

    frontImg = loadImage("2019.jpg");
    backgroundImg = loadImage("2020.jpg");

    size(700, 350); // fixed image size
    // fullScreen();

    int[] newDim = new int[2];
    calcNewDimension(frontImg.width, frontImg.height, width, height, newDim);
    printArray(newDim);

    effectWidth = newDim[0];
    effectHeight = newDim[1];

    frontImg.resize(effectWidth, effectHeight);
    backgroundImg.resize(effectWidth, effectHeight);

    int[] newStartPos = new int[2];
    calcNewStarting(width, height, effectWidth, effectHeight, newStartPos);
    printArray(newStartPos);
    
    startX = newStartPos[0];
    startY = newStartPos[1];

    frontPG = createGraphics(width, height);
    backgroundPG = createGraphics(width, height);

    frontPG.beginDraw();
    frontPG.image(frontImg, startX, startY);
    frontPG.endDraw();

    backgroundPG.beginDraw();
    backgroundPG.image(backgroundImg, startX, startY);
    backgroundPG.endDraw();

    transparancy = new int[width * height];
    

}

void draw(){
        if(mousePressed){
        myPrint("pressed mouse", mouseX, mouseY);

        for(int i=-radius;i<radius;i++){
            for(int j=-radius;j<radius;j++)
            if(inBoundary( mouseX+i, mouseY+j )){
                //myPrint(mouseX+i, mouseY+j);
                float d = dist(mouseX+i, mouseY+j,mouseX, mouseY);
                if(d<=radius){
                //myPrint(d);
                int dInt = (int) (radius - d);
                transparancy[indexConvert(mouseX+i, mouseY+j)] += dInt;
                if(transparancy[indexConvert(mouseX+i, mouseY+j)] >= transparancyMax){
                    transparancy[indexConvert(mouseX+i, mouseY+j)] = transparancyMax;
                }
                }
                
            }
        }

        //myPrint("current tr",transparancy[indexConvert(mouseX, mouseY)]);
        }
    loadPixels();
    for(int i=0;i<pixels.length;i++){
        color inter = lerpColor(backgroundPG.pixels[i], frontPG.pixels[i], 1 - transparancy[i]*1.0/transparancyMax);
        pixels[i]=inter;
    }
    updatePixels();
}


void mousePressed() {


}
