int largeur = 48;

int longueur = 32;

int range = 80;

float inc = 0.05;

PImage water;
PImage sand;
PImage grass;

Cube[][] c = new Cube[largeur][longueur];

Tile[][] offset = new Tile[largeur][longueur];

float decalageNoise = 0;

Map m;

float[][] fullMap = new float[largeur][longueur];

void setup() {
  size(500, 500);
  
  m = new Map(23, 23);
  
  for (int i = 0; i < 48; i++) {
    for (int j = 0; j < 32; j++) {
      fullMap[i][j] = 0;
    }
  }
  
  water = loadImage("water.png");
  water.resize(50,50);
  
  sand = loadImage("sand.png");
  sand.resize(50,50);
  
  grass = loadImage("grass.png");
  grass.resize(50,50);
  
  
  m.newMap();
  for (int i = 0; i < 48; i++) {
    for (int j = 0; j < 32; j++) {
      fullMap[i][j] = 0;
    }
  }
  fullMap = insertInBiggerTab(fullMap, m.map, (int)random(0, 25), (int)random(0,9), 23, 23);
  
  
  
  for (int i = 0; i < largeur; i++) {
    for (int j = 0; j < longueur; j++) {
      
      if (fullMap[i][j]*255 > 90) {
        c[i][j] = new Cube (grass.width*i, grass.height*j, grass);
      } else if (fullMap[i][j]*255 > 60) {
        c[i][j] = new Cube (sand.width*i, sand.height*j, sand);
      } else {
        c[i][j] = new Cube (water.width*i, water.height*j, water);
      }
      
    }
  }
  
  for (int i = 0; i < largeur; i++) {
    for (int j = 0; j < longueur; j++) {
      c[i][j].transpo();
    }
  }
  
  for (int i = 0; i < largeur; i++) {
    for (int j = 0; j < longueur; j++) {
      c[i][j].x += 300;
      c[i][j].y -= 100;
    }
  }
  
  for (int i = 0; i < largeur; i++) {
    for (int j = 0; j < longueur; j++) {
      float value = noise(i*inc, j*inc);
      
      if (fullMap[i][j]*255 <= 20) {
        offset[i][j] = new Tile((int)map(value, 0, 1, -range, range), 2);
      } else if (fullMap[i][j]*255 <= 40) {
        offset[i][j] = new Tile((int)map(value, 0, 1, -range, range), 4);
      } else if (fullMap[i][j]*255 <= 60) {
        offset[i][j] = new Tile((int)map(value, 0, 1, -range, range), 6);
      } else {
        offset[i][j] = new Tile((int)map(value, 0, 1, -range, range), 0);
      }
     
  }
  }
  
  frameRate(200);
}


void draw() {
  background(255);
  
  
  for (int i = 0; i < largeur; i++) {
    for (int j = 0; j < longueur; j++) {
      if (offset[i][j].water >= 1 ) {
        if (offset[i][j].water >= 1) {
       c[i][j].offset = (offset[i][j].offset / offset[i][j].water);
        }
      } else {
        c[i][j].offset = 0; 
      }
      c[i][j].display();
    }
  }
  for (int i = 0; i < largeur; i++) {
    offset[i] = cicle(offset[i], i);
  }
  decalageNoise+=inc;
  
  textSize(56);
  fill(0);
  text(frameRate, 50, 50);
  
}


void keyPressed () {
  decalageNoise = random(100000);
  
  
  m.newMap();
  for (int i = 0; i < 48; i++) {
    for (int j = 0; j < 32; j++) {
      fullMap[i][j] = 0;
    }
  }
  fullMap = insertInBiggerTab(fullMap, m.map, (int)random(0, 25), (int)random(0,9), 23, 23);
  
  
  for (int i = 0; i < largeur; i++) {
    for (int j = 0; j < longueur; j++) {
      
      if (fullMap[i][j]*255 > 90) {
        c[i][j] = new Cube (grass.width*i, grass.height*j, grass);
      } else if (fullMap[i][j]*255 > 60) {
        c[i][j] = new Cube (sand.width*i, sand.height*j, sand);
      } else {
        c[i][j] = new Cube (water.width*i, water.height*j, water);
      }
      
    }
  }
  
  for (int i = 0; i < largeur; i++) {
    for (int j = 0; j < longueur; j++) {
      c[i][j].transpo();
    }
  }
  
  for (int i = 0; i < largeur; i++) {
    for (int j = 0; j < longueur; j++) {
      c[i][j].x += 300;
      c[i][j].y -= 100;
    }
  }
  
  for (int i = 0; i < largeur; i++) {
    for (int j = 0; j < longueur; j++) {
      float value = noise(decalageNoise+i*inc, decalageNoise+j*inc);
       if (fullMap[i][j]*255 <= 20) {
        offset[i][j] = new Tile((int)map(value, 0, 1, -range, range), 2);
      } else if (fullMap[i][j]*255 <= 40) {
        offset[i][j] = new Tile((int)map(value, 0, 1, -range, range), 4);
      } else if (fullMap[i][j]*255 <= 60) {
        offset[i][j] = new Tile((int)map(value, 0, 1, -range, range), 6);
      } else {
        offset[i][j] = new Tile((int)map(value, 0, 1, -range, range), 0);
      }
    }
  }
}


float[][] insertInBiggerTab(float [][] biggerTab, float[][] tab, int x, int y, int largeur, int longueur) {
  float[][] temp = biggerTab;
  
  for (int i = x; i < x + largeur; i++) {
    for (int j = y; j < y + longueur; j++) {
      temp[i][j] = tab[i-x][j-y];
    }
  }
  
  return temp;
}


Tile[] cicle (Tile[] tab, int j) {
  Tile[] temp = tab;
  for (int i = 1; i < tab.length; i++) {
    temp[i-1].offset = tab[i].offset;
  }
  
  float value = noise(decalageNoise+j*inc, decalageNoise+((tab.length-1))*inc);
      
  temp[tab.length-1].offset = (int)map(value, 0, 1, -range, range);
  return temp;
}
