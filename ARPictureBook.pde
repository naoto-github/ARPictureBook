//ライブラリのインポート
import processing.video.*;
import jp.nyatla.nyar4psg.*;

//画像のパス
String IMG_PATH = "img/christmas/";

//カメラ
Capture cam;

//マーカーのサイズ
int marker_size = 19;

//マーカーの配列
MultiMarker markers[] = new MultiMarker[marker_size];

//画像のサイズ
int image_size = 16;

//画像の配列
PImage imgs[] = new PImage[image_size];

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

  //背景描画
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
 
      if(i < image_size){  
      
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
      else if(i == (image_size)){
        sunning();
      }
      else if(i == (image_size + 1)){
        raining();
      }
      else if(i == (image_size + 2)){
        snowing();
      }
    }
  }
  
  //雪の効果
  //snowing();
  
  //雨の効果
  //raining();
  
  //太陽の効果
  //sunning();
  
  //画像のキャプチャ
  if(shoot){
    PImage file = loadImage(filename);
    image(file,0,0);
  }
  
}

//保存ファイル名
String filename;

//撮影状態
boolean shoot = false;

//キャプチャ画像を保存
void mousePressed() {
  if(shoot == false){
    filename = "result/" + index + ".jpg";
    save(filename); 
    println("Save at " + filename);
    shoot = true;
    index++;
  }
  else{
    shoot = false;
  }
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

//***********************************
// 雪の効果
//***********************************
//雪のリスト
ArrayList<Snow> snows = new ArrayList<Snow>();

//雪の降る確率
float rate_snows = 0.05;

//雪の初期化
Snow makeSnow(){
  PImage img = loadImage("img/snow.png");
  float x = random(width);
  float y = 0;
  float speed = 1;
  Snow snow = new Snow(x, y, speed, img);
  return snow;
}

//雪の生成
void snowing(){
  //雪の生成
  if(random(1) < rate_snows){
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

//雪のクラス
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
//***********************************

//***********************************
// 雨の効果
//***********************************
//雨のリスト
ArrayList<Raindrop> raindrops = new ArrayList<Raindrop>();

//雨の降る確率
float rate_raindrops = 0.3;

//雨の初期化
Raindrop makeRaindrop(){
  PImage img = loadImage("img/raindrop.png");
  float x = random(width);
  float y = 0;
  float speed = 1;
  Raindrop raindrop = new Raindrop(x, y, speed, img);
  return raindrop;
}

//雨の生成
void raining(){
  //雨の生成
  if(random(1) < rate_raindrops){
    Raindrop raindrop = makeRaindrop();
    raindrops.add(raindrop);
  }
  
  //雨の処理
  for(int i=0; i<raindrops.size(); i++){
    Raindrop raindrop = raindrops.get(i);
    raindrop.draw();
    
    if(raindrop.visible == false){
      raindrops.remove(raindrop);
    }
  }
  
}

//雨のクラス
class Raindrop{
  float x;
  float y;
  float speed; 
  PImage img;
  boolean visible;
  
  Raindrop(float x, float y, float speed, PImage img){
    this.x = x;
    this.y = y;
    this.speed = speed;
    this.img = img;
    this.visible = true;
  }
  
  void draw(){
 
    y = y + speed;
    speed = speed * 1.2;
 
    if(y >= height){
      visible = false;
    }
    
    if(visible){
      image(img, x, y);
    }
  }
  
}
//***********************************

//***********************************
// 太陽の効果
//***********************************

//太陽
Sun sun;

//太陽の初期化
Sun makeSun(){
  PImage img = loadImage("img/sun.png");
  float x = (img.width / 2) - 10;
  float y = (img.height / 2) - 10;
  Sun sun = new Sun(x, y, img);
  return sun;
}

//太陽の生成
void sunning(){
  if(sun == null){
    sun = makeSun();
  }
  sun.draw();
}

//太陽のクラス
class Sun{
  float x;
  float y;
  PImage img;
  int time = 0;
  boolean flg = true;
  
  Sun(float x, float y, PImage img){
    this.x = x;
    this.y = y;
    this.img = img;
  }
  
  void draw(){
    time = time + 1;
    
    if(time % 10 == 0){
      flg = !flg;
    }
    
    if(flg){
      image(img, x, y);
    } 
     
  }
  
}
//***********************************
