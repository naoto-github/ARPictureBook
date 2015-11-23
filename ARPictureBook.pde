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

//カメラナンバー
int number = 0;

//キャプチャサイズ
int width = 640;
int height = 480;

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

  //**********マーカー１***********
  for(int i=0; i<markers.length; i++){
    if(markers[i].isExistMarker(0)){
     
      println("Detect:" + i);
      
      
      //画像サイズ
      float img_width = 300;
      float img_height = 300;
      
      //テクスチャの描画
      markers[i].beginTransform(0);
      textureMode(IMAGE);
      textureWrap(REPEAT);
      beginShape();
      texture(imgs[i]);
      noStroke();
      vertex(-60, -60,  30, img_width, img_height);
      vertex( 60, -60,  30, 0,         img_height);
      vertex( 60,  60,  30, 0,         0);
      vertex(-60,  60,  30, img_width, 0);
      endShape();
      markers[i].endTransform();
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

