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
int range = 40;

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

int per[] = { 151,160,137,91,90,15,
           131,13,201,95,96,53,194,233,7,225,140,36,103,30,69,142,8,99,37,240,21,10,23,
           190, 6,148,247,120,234,75,0,26,197,62,94,252,219,203,117,35,11,32,57,177,33,
           88,237,149,56,87,174,20,125,136,171,168, 68,175,74,165,71,134,139,48,27,166,
           77,146,158,231,83,111,229,122,60,211,133,230,220,105,92,41,55,46,245,40,244,
           102,143,54, 65,25,63,161, 1,216,80,73,209,76,132,187,208, 89,18,169,200,196,
           135,130,116,188,159,86,164,100,109,198,173,186, 3,64,52,217,226,250,124,123,
           5,202,38,147,118,126,255,82,85,212,207,206,59,227,47,16,58,17,182,189,28,42,
           223,183,170,213,119,248,152, 2,44,154,163, 70,221,153,101,155,167, 43,172,9,
           129,22,39,253, 19,98,108,110,79,113,224,232,178,185, 112,104,218,246,97,228,
           251,34,242,193,238,210,144,12,191,179,162,241, 81,51,145,235,249,14,239,107,
           49,192,214, 31,181,199,106,157,184, 84,204,176,115,121,50,45,127, 4,150,254,
           138,236,205,93,222,114,67,29,24,72,243,141,128,195,78,66,215,61,156,180,151,
           160,137,91,90,15,131,13,201,95, 96,53,194,233,7,225,140,36, 103,30,69,142,8,
           99,37,240,21,10,23,190, 6,148,247,120,234,75,0,26,197,62,94,252,219,203,117,
           35,11,32,57,177,33,88,237,149,56,87,174,20,125,136,171,168,68,175,74,165,71,
           134,139,48,27,166,77,146,158, 231,83,111,229,122,60, 211,133,230,220,105,92,
           41,55,46,245,40,244,102,143,54,65,25,63,161,1, 216,80,73,209,76,132,187,208,
           89,18,169,200,196,135,130, 116,188,159, 86,164,100,109,198,173,186, 3,64,52,
           217,226,250,124,123,5,202,38,147,118,126,255,82,85,212,207,206,59,227,47,16,
           58,17,182,189,28,42,223,183,170,213,119,248,152,2,44,154,163,70,221,153,101,
           155,167,43,172, 9,129,22, 39,253, 19,98,108, 110,79,113,224,232,178,185,112,
           104,218,246,97,228,251,34,242,193,238,210,144,12,191,179,162,241, 81,51,145,
           235,249,14,239,107,49,192, 214, 31,181,199, 106,157,184, 84,204,176,115,121,
           50,45,127, 4,150,254,138,236,205,93,222,114, 67,29,24,72,243,141,128,195,78,
           66,215,61,156,180};

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
        c[i][j].offsetY+=5; //Translation to create 2d isometric effect
        c[i][j].offsetX-=5; //Translation to create 2d isometric effect
      }
    }
    playerY+=5;
    playerX-=5;
  }

  if (keypressed[1]) {
    for (int i = 0; i < largeur; i++) {
      for (int j = 0; j < longueur; j++) {
        c[i][j].offsetY-=5; //Translation to create 2d isometric effect
        c[i][j].offsetX+=5; //Translation to create 2d isometric effect
      }
    }
    playerY-=5;
    playerX+=5;
  }

  if (keypressed[2]) {
    for (int i = 0; i < largeur; i++) {
      for (int j = 0; j < longueur; j++) {
        c[i][j].offsetX+=5; //Translation to create 2d isometric effect
        c[i][j].offsetY+=5; //Translation to create 2d isometric effect
      }
    }
    playerX+=5;
    playerY+=5;
  }

  if (keypressed[3]) {
    for (int i = 0; i < largeur; i++) {
      for (int j = 0; j < longueur; j++) {
        c[i][j].offsetX-=5; //Translation to create 2d isometric effect
        c[i][j].offsetY-=5; //Translation to create 2d isometric effect
      }
    }
    playerX-=5;
    playerY-=5;
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
      float value = perinNoise(i*inc, j*inc);
      
      if (fullMap[i][j]*255 <= 20) {
        c[i][j].offsetWave = (int)map(value, 0, 1, -range, range);
        c[i][j].water = 2;
      } else if (fullMap[i][j]*255 <= 50) {
        c[i][j].offsetWave = (int)map(value, 0, 1, -range, range);
        c[i][j].water = 3;
      } else if (fullMap[i][j]*255 <= 60) {
        c[i][j].offsetWave = (int)map(value, 0, 1, -range, range);
        c[i][j].water = 4;
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
        c[i][j].offsetHeight -= 20;
      } else if (c[i][j].cellType == 2) {
        c[i][j].offsetHeight -= map(fullMap[i][j]*255, 90, 255, 20, 150);
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

//https://gist.github.com/Fataho/5b422037a6fdcb21c9134ef34d2fa79a
  float perinNoise(float x, float y){
      int xi = (int)floor(x) & 255;
      int yi = (int)floor(y) & 255;
      
      int g1 = per[per[xi] + yi];
      int g2 = per[per[xi + 1] + yi];
      int g3 = per[per[xi] + yi + 1];
      int g4 = per[per[xi + 1] + yi + 1];
      
      float xf = x - floor(x);
      float yf = y - floor(y);
      
      float d1 = grad(g1, xf, yf);
      
      float d2 = grad(g2, xf - 1, yf);
      float d3 = grad(g3, xf, yf - 1);
      float d4 = grad(g4, xf - 1, yf - 1);
      
      float u = fade(xf);
      float v = fade(yf);
      
      float x1Inter = interpretationPolaire(u, d1, d2);
      float x2Inter = interpretationPolaire(u, d3, d4);
      float yInter = interpretationPolaire(v, x1Inter, x2Inter);
      
      return yInter;
    }
    
    float fade(float t) { 
      return t * t * t * (t * (t * 6 - 15) + 10); 
    }
    
    float grad(int hash, float x, float y){
      switch(hash & 3){
      case 0: return x + y;
      case 1: return -x + y;
      case 2: return x - y;
      case 3: return -x - y;
      default: return 0;
      }
    }
    
    float interpretationPolaire(float amount, float left, float right) {
      return ((1 - amount) * left + amount * right); 
    }


Cube[] cicle (Cube[] tab, int j) {
  Cube[] temp = tab;
  for (int i = 1; i < tab.length; i++) {
    temp[i-1].offsetWave = tab[i].offsetWave;
  }

  float value = perinNoise(decalageNoise+j*inc, decalageNoise+((tab.length-1))*inc);

  temp[tab.length-1].offsetWave = (int)map(value, 0, 1, -range, range);
  return temp;
}
