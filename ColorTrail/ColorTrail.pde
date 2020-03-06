// 卢之睿 19.09.29
// 按下鼠标 生成颜色轨迹

int mousePressCounter = 0;

void setup(){
  background(255);
  size(500,500);
  colorMode(HSB,255);
  noStroke();
}

void draw(){
  if(mousePressed){
   mousePressCounter++;
   fill(mouseX%255, mouseY%255, (mousePressCounter)*5);
   ellipse(mouseX, mouseY, mousePressCounter, mousePressCounter);
  } else {
    mousePressCounter=0;
  }
}
