//Project Description: Music Visuals You Can Control
//This project is a digital art experience that mixes music and images. 
//When you play a song, the program listens to the music and shows different 
//images on the screen that react to the sound, especially the bass. 
//For example, when the beat is strong, you’ll see bursts of fire appear.

//You can also use your keyboard to control what’s shown:
//Press S to cover the screen with a big, colorful snake.
//Press W to splash water shapes with bright, random colors and different sizes.
//Press A to make smoke clouds appear in random places.
//Press D to switch the background from black to white.
//The images and effects change each time, so every run looks unique. 
//The idea is to let you play with the connection between sound, color, 
//and movement, creating your own live visuals as the music plays. )


import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioPlayer song;
FFT fft;

PImage fire;   // Graves (reacciona a la música)
PImage water;  // Muestra/cambia al presionar W
PImage smoke;  // Muestra/cambia al presionar A
PImage snake;  // Muestra/cambia al presionar S

boolean showSnake = false;
boolean showWater = false;
boolean showSmoke = false;

color snakeTint;
color waterTint;
float waterW, waterH;

color bgColor; // Color de fondo
boolean isBgWhite = false; // Controla si el fondo es blanco

void setup() {
 // size(1000, 800);
 fullScreen();
 noCursor();
  imageMode(CENTER);

  fire = loadImage("Fire.png");
  water = loadImage("water.png");
  smoke = loadImage("smoke.png");
  snake = loadImage("snake.jpg");

  minim = new Minim(this);
  song = minim.loadFile("SHOOK.mp3");
  if (song == null) {
    println("⚠️ ERROR: No se encontró SHOOK.mp3 en data/");
    noLoop(); 
    return;
  }
  song.loop();

  fft = new FFT(song.bufferSize(), song.sampleRate());

  snakeTint = color(255); 
  waterTint = color(255); 
  waterW = 100;
  waterH = 100;
  bgColor = color(0); 
}

void draw() {
  background(bgColor);
  fft.forward(song.mix);

  if (getEnergy(20, 150) > 50) {
    image(fire, random(width), random(height), random(80, 150), random(80, 150));
  }

  if (showSnake) {
    tint(snakeTint);
    imageMode(CORNER); 
    image(snake, 0, 0, width, height);
    imageMode(CENTER);
    noTint();
    return;
  }

  if (showWater) {
    tint(waterTint);
    image(water, random(width), random(height), waterW, waterH);
    noTint();
  }

  if (showSmoke) {
    image(smoke, random(width), random(height), random(100, 150), random(100, 150));
  }
}

float getEnergy(int freqStart, int freqEnd) {
  int start = fft.freqToIndex(freqStart);
  int end = fft.freqToIndex(freqEnd);
  float sum = 0;
  for (int i = start; i <= end; i++) {
    sum += fft.getBand(i);
  }
  return sum / (end - start + 1);
}

void keyPressed() {
  if (key == 's' || key == 'S') {
    showSnake = !showSnake;
    snakeTint = color(random(255), random(255), random(255));
  }
  if (key == 'w' || key == 'W') {
    showWater = !showWater;
    waterTint = color(
      random(180, 255), 
      random(180, 255), 
      random(180, 255)
    );
    waterW = random(80, 200);
    waterH = random(80, 200);
  }
  if (key == 'a' || key == 'A') {
    showSmoke = !showSmoke;
  }
  if (key == 'd' || key == 'D') {
    isBgWhite = !isBgWhite;
    bgColor = isBgWhite ? color(255) : color(0);
  }
}

void stop() {
  song.close();
  minim.stop();
  super.stop();
}
