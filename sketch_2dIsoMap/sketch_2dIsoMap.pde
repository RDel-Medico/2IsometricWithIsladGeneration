//Size of the map in tiles
int largeur = 48;
int longueur = 32;

//Range of the wave
int range = 80;

//Increment for perin noise function
float inc = 0.05;

//Images for tiles
PImage water;
PImage sand;
PImage grass;

//2d array for the tile
Cube[][] c = new Cube[largeur][longueur];

//Starting point in the perin noise function
float decalageNoise = 0;

//The map of the island
Map m;

//The map of the entire section (island + ocean)
float[][] fullMap = new float[largeur][longueur];

void setup() {
  size(500, 500);

  water = loadImage("water.png");
  water.resize(50, 50);

  sand = loadImage("sand.png");
  sand.resize(50, 50);

  grass = loadImage("grass.png");
  grass.resize(50, 50);

  m = new Map(23, 23);

  frameRate(200);
  
  generateTroncon();
}


void draw() {
  background(255);


  for (int i = 0; i < largeur; i++) {
    for (int j = 0; j < longueur; j++) {
      c[i][j].display();
    }
  }
  
  for (int i = 0; i < largeur; i++) {
    c[i] = cicle(c[i], i);
  }
  decalageNoise+=inc;

  textSize(56);
  fill(0);
  text(frameRate, 50, 50);
}


void keyPressed () {
  decalageNoise = random(100000);

  generateTroncon();
}

void generateTroncon() {
  //Fill the map with water tile
  for (int i = 0; i < 48; i++) {
    for (int j = 0; j < 32; j++) {
      fullMap[i][j] = 0;
    }
  }

  //Generation of an island
  m.newMap();

  //Insertion of the island in the ocean
  fullMap = insertInBiggerTab(fullMap, m.map, (int)random(0, 25), (int)random(0, 9), 23, 23);

  //Creating the tile 2d array
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
      c[i][j].transpo(); //Translation to create 2d isometric effect

      //Translation to center the map after the application of 2d isometric matrix
      c[i][j].x += 300;
      c[i][j].y -= 100;
    }
  }

  //Creation of the noise for the wave
  for (int i = 0; i < largeur; i++) {
    for (int j = 0; j < longueur; j++) {
      float value = noise(i*inc, j*inc);
      if (fullMap[i][j]*255 <= 20) {
        c[i][j].offset = (int)map(value, 0, 1, -range, range);
        c[i][j].water = 2;
      } else if (fullMap[i][j]*255 <= 40) {
        c[i][j].offset = (int)map(value, 0, 1, -range, range);
        c[i][j].water = 4;
      } else if (fullMap[i][j]*255 <= 60) {
        c[i][j].offset = (int)map(value, 0, 1, -range, range);
        c[i][j].water = 6;
      } else {
        c[i][j].offset = (int)map(value, 0, 1, -range, range);
        c[i][j].water = 0;
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


Cube[] cicle (Cube[] tab, int j) {
  Cube[] temp = tab;
  for (int i = 1; i < tab.length; i++) {
    temp[i-1].offset = tab[i].offset;
  }

  float value = noise(decalageNoise+j*inc, decalageNoise+((tab.length-1))*inc);

  temp[tab.length-1].offset = (int)map(value, 0, 1, -range, range);
  return temp;
}
