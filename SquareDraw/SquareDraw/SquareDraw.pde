// 卢之睿

// SquareDraw
// 为空白的世界绘上颜色吧！
// 按下鼠标随机涂色
// 颜色在一定时间后会消散

// 本来想做混色的 但是似乎实现起来有点奇怪的问题...
// 可能增加：混色、颜色随距离减淡浓度......

int density = 20; // 每行列方块数
float squareDefaultRatio = 0.5; // 方块本身的缩放比例
float squareMaxRatio = 2; // 鼠标移过来的时候方块的缩放比例
float squareSize; // 方块最原始的大小
float roundCorner = 0; // 圆角大小
float mouseAffectRangeRatio = 0.1; // 鼠标作用范围
int colorFadeFrames = 120; // 颜色完全消失用的总帧数


color toBeFilledColor; 
PVector[][] squareCenters = new PVector[density][density];
color[][] squareColors = new color[density][density];
int[][] lastTouchFrameNum = new int[density][density];

void setup(){

  size(800,800);
  background(255);

  toBeFilledColor = color(255,255,255);

  squareSize = width * 1.0 / density;

  for (int i = 0; i < density; ++i) {
    for (int j = 0; j < density; ++j) {
      squareCenters[i][j] = new PVector(squareSize /2 + squareSize*j, squareSize /2 + squareSize*i);
      squareColors[i][j] = color(255,255,255);
    }
  }

  for (int i = 0; i < density; ++i) {
    for (int j = 0; j < density; ++j) {
      PVector squareCenter = squareCenters[i][j];
      drawSquare(squareCenter.x, squareCenter.y, squareSize, squareDefaultRatio);
    }
  }
  
}

void draw(){

  background(255); 

  float maxDist = width * (float) Math.sqrt(2) * mouseAffectRangeRatio;
  float minDist = 1;

  for (int i = 0; i < density; ++i) {
    for (int j = 0; j < density; ++j) {
      PVector squareCenter = squareCenters[i][j];
      float distance = dist(squareCenter.x, squareCenter.y, mouseX, mouseY);
      boolean touched = true;
      if(distance > maxDist){
        distance = maxDist;
        touched = false;
      } else if (distance < minDist){
        distance = minDist;
      }

      if(touched & mousePressed){
        lastTouchFrameNum[i][j] = frameCount;
        squareColors[i][j] = color(toBeFilledColor);
      }
      float ratio = map(distance, minDist, maxDist, squareMaxRatio, squareDefaultRatio);
      drawSquare(squareCenter.x, squareCenter.y, squareSize, ratio, squareColors[i][j], calcOpcacityAndUpdateColor(i,j));
    }
  }
  
  if(!mousePressed){
      println(toBeFilledColor);
      toBeFilledColor = color(random(255), random(255), random(255));
  }
}

void drawSquare(float centerX,float centerY,float size,float scale){
  color defaultColor = color(255,255,255);
  float defaultOpcaity = 255;
  drawSquare(centerX, centerY, size, scale, defaultColor, defaultOpcaity);
}

void drawSquare(float centerX,float centerY,float size,float scale, color c, float opacity){
  float realSize = size * scale;
  fill(c, opacity);
  rect(centerX - realSize / 2, centerY - realSize / 2, realSize, realSize, roundCorner);
}

float calcOpcacityAndUpdateColor(int i, int j){
  int frameDiff = frameCount - lastTouchFrameNum[i][j];
  if(frameDiff > colorFadeFrames){
    frameDiff = colorFadeFrames;
    squareColors[i][j] = color(255,255,255);
  }
  float opacity = map(frameDiff, 0, colorFadeFrames, 0, 255);
  return 255- opacity;
}
