//Size of the map in tiles
int largeur = 48;
int longueur = 32;

MiniMap ma;

PImage player;

PImage boatSprite;
PImage playerSprite;

int playerX = 0;
int playerY = 0;

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

//key pressed
boolean[] keypressed = new boolean[6]; // [0]Z [1]Q [2]S [3]D [4]M [5]others

//The map of the entire section (island + ocean)
float[][] fullMap = new float[largeur][longueur];

void setup() {
  size(500, 500);

  player = loadImage("boat.png");
  player.resize(100, 100);
  
  boatSprite = player;
  
  playerSprite = loadImage("player.png");
  playerSprite.resize(100,100);

  water = loadImage("water.png");
  water.resize(50, 50);

  sand = loadImage("sand.png");
  sand.resize(50, 50);

  grass = loadImage("grass.png");
  grass.resize(50, 50);

  m = new Map(23, 23);

  frameRate(30);

  generateTroncon();
  
  ma = new MiniMap(fullMap);
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
  
  //get mouseX Tile : ceil(getNoIsoX(mouseX - width / 2 - playerX, mouseY - playerY))
  //get mouseY Tile : ceil(getNoIsoY(mouseX - width / 2 - playerX, mouseY - playerY))
  
  //get playerX Tile : ceil(getNoIsoX(-playerX, -playerY + height / 2))
  //get playerY Tile : ceil(getNoIsoY(-playerX, -playerY + height / 2))
  
  int playerXTile = ceil(getNoIsoX(-playerX, -playerY + height / 2));
  int playerYTile = ceil(getNoIsoY(-playerX, -playerY + height / 2));
  
  println(c[playerXTile][playerYTile].offsetY);
  if (c[playerXTile][playerYTile].water > 0) {
    player = boatSprite;
    imageMode(CENTER);
    image(player, width/2, height/2 + c[playerXTile][playerYTile].offsetWave / c[playerXTile][playerYTile].water);
  } else {
    player = playerSprite;
    imageMode(CENTER);
    image(player, width/2, height/2 + c[playerXTile][playerYTile].offsetHeight);
  }
  
  manageKey();
}

float getNoIsoX(int xPos, int yPos) {
    int xNoIso = 0;
    
    float det = determinant();
    
    xNoIso = ceil(((xPos * (det * (sand.height / 4))) + (yPos * (det * (sand.width / 2)))));
    
    return xNoIso;
  }
  
  float getNoIsoY(int xPos, int yPos) {
    int yNoIso = 0;
    
    float det = determinant();
    
    yNoIso = ceil(((xPos * (det * ((-sand.height) / 4))) + (yPos * (det * (sand.width / 2)))));
    
    return yNoIso;
  }
  
  float determinant () {
    float bottom = ((sand.width * sand.height) / 4);
    return (1 / bottom);
  }

void keyReleased () {
  switch(key) {
  case 'z':
    keypressed[0] = false;
    break;
  case 's':
    keypressed[1] = false;
    break;
  case 'q':
    keypressed[2] = false;
    break;
  case 'd':
    keypressed[3] = false;
    break;
  default:
    keypressed[5] = false;
    break;
  }
}

void keyPressed () {

  switch(key) {
  case 'z':
    keypressed[0] = true;
    break;
  case 's':
    keypressed[1] = true;
    break;
  case 'q':
    keypressed[2] = true;
    break;
  case 'd':
    keypressed[3] = true;
    break;
  case 'm':
    keypressed[4] = !keypressed[4];
    break;
  default:
    keypressed[5] = true;
    break;
  }
}

void manageKey () {
  if (keypressed[0]) {
    for (int i = 0; i < largeur; i++) {
      for (int j = 0; j < longueur; j++) {
        c[i][j].offsetY+=10; //Translation to create 2d isometric effect
      }
    }
    playerY+=10;
  }

  if (keypressed[1]) {
    for (int i = 0; i < largeur; i++) {
      for (int j = 0; j < longueur; j++) {
        c[i][j].offsetY-=10; //Translation to create 2d isometric effect
      }
    }
    playerY-=10;
  }

  if (keypressed[2]) {
    for (int i = 0; i < largeur; i++) {
      for (int j = 0; j < longueur; j++) {
        c[i][j].offsetX+=10; //Translation to create 2d isometric effect
      }
    }
    playerX+=10;
  }

  if (keypressed[3]) {
    for (int i = 0; i < largeur; i++) {
      for (int j = 0; j < longueur; j++) {
        c[i][j].offsetX-=10; //Translation to create 2d isometric effect
      }
    }
    playerX-=10;
  }
  
  if (keypressed[4]) {
    ma.display();
  }

  if (keypressed[5]) {
    decalageNoise = random(100000);
    generateTroncon();
    playerX = 0;
    playerY = 0;
    ma = new MiniMap(fullMap);
  }
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
        c[i][j] = new Cube (i, j, grass, 2);
      } else if (fullMap[i][j]*255 > 60) {
        c[i][j] = new Cube (i, j, sand, 1);
      } else {
        c[i][j] = new Cube (i, j, water, 0);
      }
    }
  }

  for (int i = 0; i < largeur; i++) {
    for (int j = 0; j < longueur; j++) {
      c[i][j].transpo(); //Translation to create 2d isometric effect

      //Translation to center the map after the application of 2d isometric matrix
      c[i][j].x += width / 2;
    }
  }

  //Creation of the noise for the wave
  for (int i = 0; i < largeur; i++) {
    for (int j = 0; j < longueur; j++) {
      float value = noise(i*inc, j*inc);
      
      if (fullMap[i][j]*255 <= 20) {
        c[i][j].offsetWave = (int)map(value, 0, 1, -range, range);
        c[i][j].water = 2;
      } else if (fullMap[i][j]*255 <= 40) {
        c[i][j].offsetWave = (int)map(value, 0, 1, -range, range);
        c[i][j].water = 4;
      } else if (fullMap[i][j]*255 <= 60) {
        c[i][j].offsetWave = (int)map(value, 0, 1, -range, range);
        c[i][j].water = 6;
      } else {
        c[i][j].offsetWave = (int)map(value, 0, 1, -range, range);
        c[i][j].water = 0;
      }
    }
  }
  
  c = generateRelief(c);
}

Cube[][] generateRelief(Cube [][] c) {
  for (int i = 0; i < largeur; i++) {
    for (int j = 0; j < longueur; j++) {
      if (c[i][j].cellType == 1) {
        c[i][j].offsetHeight -= 10;
      } else if (c[i][j].cellType == 2) {
        c[i][j].offsetHeight -= map(fullMap[i][j]*255, 90, 255, 10, 150);
      }
    } 
  }
  return c;
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
    temp[i-1].offsetWave = tab[i].offsetWave;
  }

  float value = noise(decalageNoise+j*inc, decalageNoise+((tab.length-1))*inc);

  temp[tab.length-1].offsetWave = (int)map(value, 0, 1, -range, range);
  return temp;
}
