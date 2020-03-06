// 卢之睿

// SquareDraw的副产物：Card
// 其实是Bug 不过似乎也不错？

int density = 10;
float squareRatio = 0.9; // 方块本身的缩放比例
float squareSize; // 方块最原始的大小
float roundCorner = 0;
float mouceScale = 0.1; // 鼠标移过来的时候 最小可以缩小到多少
float rotateAngle = 45; // 鼠标移过来的时候 方块移动的角度

PVector[][] squareCenters = new PVector[density][density];
// Color[][] colorOfSquares = new Color[density][density];

void setup(){
  int canvasSize = 800;

  size(800,800);
  background(255);

  squareSize = canvasSize * 1.0 / density;

  for (int i = 0; i < density; ++i) {
    for (int j = 0; j < density; ++j) {
      squareCenters[i][j] = new PVector(squareSize /2 + squareSize*j, squareSize /2 + squareSize*i);
    }
  }

  for (int i = 0; i < density; ++i) {
    for (int j = 0; j < density; ++j) {
      PVector squareCenter = squareCenters[i][j];
      drawSquare(squareCenter.x, squareCenter.y, squareSize, squareRatio);
    }
  }

}

void draw(){

  float maxDist = 50;
  float minDist = 10;

  for (int i = 0; i < density; ++i) {
    for (int j = 0; j < density; ++j) {
      PVector squareCenter = squareCenters[i][j];
      float distance = dist(squareCenter.x, squareCenter.y, mouseX, mouseY);
      float ratio = map(distance, minDist, maxDist, squareRatio, mouceScale);
      drawSquare(squareCenter.x, squareCenter.y, squareSize, ratio);
    }
  }
    
}

void drawSquare(float centerX,float  centerY,float  size,float  scale){
  float realSize = size * scale;
  rect(centerX - realSize / 2, centerY - realSize / 2, realSize, realSize);
}
