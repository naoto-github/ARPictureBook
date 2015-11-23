/**
 NyARToolkit for proce55ing/1.0.0
 (c)2008-2011 nyatla
 airmail(at)ebony.plala.or.jp
 
 最も短いARToolKitのコードです。
 Hiroマーカを用意してください。
 
 This sample program is most small sample as simpleLite.
 The marker is "patt.hiro".
 */

//ライブラリのインポート
import processing.video.*;
import jp.nyatla.nyar4psg.*;

//カメラ
Capture cam;

//マーカーの配列
MultiMarker markers[] = new MultiMarker[13];

//画像の配列
PImage imgs[] = new PImage[13];

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

  //カメラのスタート
  cam.start();
  

}

void draw()
{
  //カメラの利用可能の判定
  if (cam.available() !=true) {
    return;
  }

  //画像の読込
  loadImages();

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
     
      println("detect:" + i);
      
      
      //画像サイズ
      float img_width;
      float img_height;
      
      switch(i){
        case 0:
          img_width = 500;
          img_height = 500;
          break;
         case 1:
          img_width = 500;
          img_height = 500;
          break;
        case 2:
          img_width = 500;
          img_height = 500;
          break;
        case 3:
          img_width = 500;
          img_height = 500;
          break;
        case 4:
          img_width = 500;
          img_height = 500;
          break;
        case 5:
          img_width = 500;
          img_height = 500;
          break;
        case 6:
          img_width = 500;
          img_height = 500;
          break;
        case 7:
          img_width = 500;
          img_height = 500;
          break;
        case 8:
          img_width = 500;
          img_height = 500;
          break;
        case 9:
          img_width = 500;
          img_height = 500;
          break;
        case 10:
          img_width = 500;
          img_height = 500;
          break;
        case 11:
          img_width = 500;
          img_height = 500;
          break;
        case 12:
          img_width = 500;
          img_height = 500;
          break;
        case 13:
          img_width = 500;
          img_height = 500;
          break;
        default:
          img_width = 0;
          img_height = 0;
      }
      
      //テクスチャの描画
      markers[i].beginTransform(0);
      textureMode(IMAGE);
      textureWrap(REPEAT);
      beginShape();
      texture(imgs[i]);
      noStroke();
      vertex(-80, -80,  40, img_width, img_height);
      vertex( 80, -80,  40, 0,         img_height);
      vertex( 80,  80,  40, 0,         0);
      vertex(-80,  80,  40, img_width, 0);
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
    imgs[i] = loadImage("img/" + (i+1) + ".png");
  }
}

