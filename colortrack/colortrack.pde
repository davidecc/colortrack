import processing.video.*;

Capture video; //instancia para la camara
color trackColor; //variable para el color
//arreglos para acumular puntos de color
float [] cirx = new float [1000];
float [] ciry = new float [1000];
int actual = 0; //numero actual del pixel
PImage imgs;

void setup (){
size (640,480);
//iniciamos
imgs = loadImage("ojo.png");
video = new Capture (this, width, height, 30);//30 frames por segundo
video.start();
//definimos el color a buscar
trackColor = color (255,255,255);
smooth ();//suavisamos escenario
}
// a continuacion escribimos el cicli iterativo de 
void draw(){
if(video.available()){
video.read();
}
video.loadPixels();
image(video,0,0);
float worldRecord = 500;
int closestX = 0;
int closestY = 0;
for (int x= 0; x< video.width; x++){
for (int y= 0; y< video.height; y++){
int loc= x+y*video.width;

color currentColor = video.pixels[loc];
float r1=red (currentColor);
float g1= green (currentColor);
float b1= blue (currentColor);

float r2=red (trackColor);
float g2= green (trackColor);
float b2= blue (trackColor);

float d = dist(r1, g1, b2, r2, g2, b2);

if (d < worldRecord){
worldRecord = d;
closestX = x;
closestY= y;
}
}
}

noStroke();
for(int i=0; i<actual; i++){
  image (imgs, cirx[i],ciry[i], 30,30);
}
if(worldRecord <10){
fill(trackColor);
strokeWeight(4.0);
stroke(0);


}
if (closestX != cirx[actual]&& closestY !=ciry[actual])
{
actual++;
cirx[actual] = closestX;
ciry[actual]= closestY;
pushMatrix();
translate(200,150);
textSize(22);
String s = "Da click dentro de la pantalla sobre el color que quieras rastrear en movimiento";
fill(0,102,153);
text(s, 10, 10, 300, 300);  
popMatrix();
}

}

void mousePressed(){
int loc= mouseX + mouseY*video.width;
trackColor = video.pixels[loc];
}