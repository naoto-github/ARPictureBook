//ライブラリのインポート
import processing.video.*;
import jp.nyatla.nyar4psg.*;

//画像のパス
String IMG_PATH = "img/christmas/";

//カメラ
Capture cam;

//マーカーの配列
MultiMarker markers[] = new MultiMarker[16];

//画像の配列
PImage imgs[] = new PImage[16];

//画像番号
int index = 0;

/****PC用の設定*****/
//カメラナンバー
int number = 0;

//キャプチャサイズ
int width = 640;
int height = 480;
/********************/

/****Surface用の設定*****/
//カメラナンバー
//int number = 77;

//キャプチャサイズ
//int width = 1280;
//int height = 720;
/********************/

void setup() {
 
  //キャプチャサイズ
  size(width, height, P3D);

  //カラーモード
  colorMode(RGB, 100);

  //バージョンの表示
  println(MultiMarker.VERSION);

  //カメラの初期化
  String[] cameras = Capture.list();
  cam = new Capture(this, cameras[number]);
  
  //カメラの一覧の表示
  for(int i=0; i<cameras.length; i++){
    println(i + ":" + cameras[i]);
  }
  
  //マーカーの初期化
  for(int i=0; i<markers.length; i++){
    markers[i] = new MultiMarker(this, width, height, "camera_para.dat", NyAR4PsgConfig.CONFIG_PSG);
    markers[i].addNyIdMarker(i+1, 80);
  }

  //画像の初期化
  loadImages();
  
  //カメラのスタート
  cam.start();
  

}

void draw()
{
  //カメラの利用可能の判定
  if (cam.available() !=true) {
    return;
  }

  //カメラの読込
  cam.read();

  //frustumを考慮した背景描画
  background(0);
  for(int i=0; i<markers.length; i++){
    markers[i].drawBackground(cam);
  }

  //マーカーの検出
  for(int i=0; i<markers.length; i++){
    markers[i].detect(cam);
  }

  //マーカーの処理
  for(int i=0; i<markers.length; i++){
    if(markers[i].isExistMarker(0)){
     
      //println("Detect:" + i);
      
      
      //画像サイズ
      float img_width = 300;
      float img_height = 300;
      
      //テクスチャの描画
      int r = 50;
      markers[i].beginTransform(0);
      textureMode(IMAGE);
      textureWrap(REPEAT);
      beginShape();
      texture(imgs[i]);
      noStroke();
      vertex(-2 * r, -2 * r, r, img_width, img_height);
      vertex( 2 * r, -2 * r, r, 0,         img_height);
      vertex( 2 * r,  2 * r, r, 0,         0);
      vertex(-2 * r,  2 * r, r, img_width, 0);
      endShape();
      markers[i].endTransform();
    }
  }
  
  //雪の生成
  if(random(1) < rate){
    Snow snow = makeSnow();
    snows.add(snow);
  }
  
  //雪の処理
  for(int i=0; i<snows.size(); i++){
    Snow snow = snows.get(i);
    snow.draw();
    
    if(snow.visible == false){
      snows.remove(snow);
    }
  }
  
}

//キャプチャ画像を保存
void mousePressed() {
  String filename = "result/" + index + ".jpg";
  save(filename); 
  println("Save at " + filename);
  index++;
}

//画像の読込
void loadImages() {
  for(int i=0; i<imgs.length; i++){
    
    int number = i + 1;
    String filename = number + ".png";
   
    if(number < 10){
      filename = "00" + filename;
    }
    else if(number < 100){
      filename = "0" + filename;
    }
    
    imgs[i] = loadImage(IMG_PATH + filename);
    
    println("Load:" + filename);
  }
}

//雪のリスト
ArrayList<Snow> snows = new ArrayList<Snow>();

//雪の降る確率
float rate = 0.05;

//雪の初期化
Snow makeSnow(){
  PImage img = loadImage("img/snow.png");
  float x = random(width);
  float y = 0;
  float speed = 1;
  Snow snow = new Snow(x, y, speed, img);
  return snow;
}

class Snow{
  float x;
  float y;
  float speed; 
  PImage img;
  float time;
  boolean visible;
  
  Snow(float x, float y, float speed, PImage img){
    this.x = x;
    this.y = y;
    this.speed = speed;
    this.img = img;
    this.time = 0;
    this.visible = true;
  }
  
  void draw(){
 
    y = y + speed;
    time = ((time + 1) % 72);
 
    float d = sin(6.28 * (time * 1/72)) * 2;
    
    x = x + d;
    //println(d);
 
    if(y >= height){
      visible = false;
    }
    
    if(visible){
      image(img, x, y);
    }
  }
  
}

