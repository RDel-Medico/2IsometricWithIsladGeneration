int p[] = { 151, 160, 137, 91, 90, 15,
  131, 13, 201, 95, 96, 53, 194, 233, 7, 225, 140, 36, 103, 30, 69, 142, 8, 99, 37, 240, 21, 10, 23,
  190, 6, 148, 247, 120, 234, 75, 0, 26, 197, 62, 94, 252, 219, 203, 117, 35, 11, 32, 57, 177, 33,
  88, 237, 149, 56, 87, 174, 20, 125, 136, 171, 168, 68, 175, 74, 165, 71, 134, 139, 48, 27, 166,
  77, 146, 158, 231, 83, 111, 229, 122, 60, 211, 133, 230, 220, 105, 92, 41, 55, 46, 245, 40, 244,
  102, 143, 54, 65, 25, 63, 161, 1, 216, 80, 73, 209, 76, 132, 187, 208, 89, 18, 169, 200, 196,
  135, 130, 116, 188, 159, 86, 164, 100, 109, 198, 173, 186, 3, 64, 52, 217, 226, 250, 124, 123,
  5, 202, 38, 147, 118, 126, 255, 82, 85, 212, 207, 206, 59, 227, 47, 16, 58, 17, 182, 189, 28, 42,
  223, 183, 170, 213, 119, 248, 152, 2, 44, 154, 163, 70, 221, 153, 101, 155, 167, 43, 172, 9,
  129, 22, 39, 253, 19, 98, 108, 110, 79, 113, 224, 232, 178, 185, 112, 104, 218, 246, 97, 228,
  251, 34, 242, 193, 238, 210, 144, 12, 191, 179, 162, 241, 81, 51, 145, 235, 249, 14, 239, 107,
  49, 192, 214, 31, 181, 199, 106, 157, 184, 84, 204, 176, 115, 121, 50, 45, 127, 4, 150, 254,
  138, 236, 205, 93, 222, 114, 67, 29, 24, 72, 243, 141, 128, 195, 78, 66, 215, 61, 156, 180, 151,
  160, 137, 91, 90, 15, 131, 13, 201, 95, 96, 53, 194, 233, 7, 225, 140, 36, 103, 30, 69, 142, 8,
  99, 37, 240, 21, 10, 23, 190, 6, 148, 247, 120, 234, 75, 0, 26, 197, 62, 94, 252, 219, 203, 117,
  35, 11, 32, 57, 177, 33, 88, 237, 149, 56, 87, 174, 20, 125, 136, 171, 168, 68, 175, 74, 165, 71,
  134, 139, 48, 27, 166, 77, 146, 158, 231, 83, 111, 229, 122, 60, 211, 133, 230, 220, 105, 92,
  41, 55, 46, 245, 40, 244, 102, 143, 54, 65, 25, 63, 161, 1, 216, 80, 73, 209, 76, 132, 187, 208,
  89, 18, 169, 200, 196, 135, 130, 116, 188, 159, 86, 164, 100, 109, 198, 173, 186, 3, 64, 52,
  217, 226, 250, 124, 123, 5, 202, 38, 147, 118, 126, 255, 82, 85, 212, 207, 206, 59, 227, 47, 16,
  58, 17, 182, 189, 28, 42, 223, 183, 170, 213, 119, 248, 152, 2, 44, 154, 163, 70, 221, 153, 101,
  155, 167, 43, 172, 9, 129, 22, 39, 253, 19, 98, 108, 110, 79, 113, 224, 232, 178, 185, 112,
  104, 218, 246, 97, 228, 251, 34, 242, 193, 238, 210, 144, 12, 191, 179, 162, 241, 81, 51, 145,
  235, 249, 14, 239, 107, 49, 192, 214, 31, 181, 199, 106, 157, 184, 84, 204, 176, 115, 121,
  50, 45, 127, 4, 150, 254, 138, 236, 205, 93, 222, 114, 67, 29, 24, 72, 243, 141, 128, 195, 78,
  66, 215, 61, 156, 180};

class Map {
  int w;
  int h;

  float [][] map;

  Map (int w, int h) {
    this.w =w;
    this.h = h;

    map = new float[w][h];

    //By default there is only water
    for (int x = 0; x < w; x++) {
      for (int y = 0; y < h; y++) {
        map[x][y] = 0;
      }
    }
  }

  void newMap() {
    generatePerlinNoise();
    generateIslandGradient();

    //While the island is too small (<40 grass tile), we generate a new one
    int nbGrassTile = 0;
    for (int i = 0; i < w && nbGrassTile < 220; i++) {
      for (int j = 0; j < h && nbGrassTile < 220; j++) {
        if (map[i][j]*255 > 70) {
          nbGrassTile++;
        }
      }
    }

    if (nbGrassTile < 220) {
      newMap();
    }
  }

  //Generation of an even perin noise on the whole map
  void generatePerlinNoise() {
    float start = random(10000);
    float yoff = start;
    for (int x = 0; x < w; x++) {
      float xoff = start;
      for (int y = 0; y < h; y++) {
        xoff+=0.05;

        map[x][y] = perinNoise(xoff, yoff);
      }
      yoff+=0.05;
    }
  }

  //https://gist.github.com/Fataho/5b422037a6fdcb21c9134ef34d2fa79a
  float perinNoise(float x, float y) {
    int xi = (int)floor(x) & 255;
    int yi = (int)floor(y) & 255;

    int g1 = p[p[xi] + yi];
    int g2 = p[p[xi + 1] + yi];
    int g3 = p[p[xi] + yi + 1];
    int g4 = p[p[xi + 1] + yi + 1];

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

  float grad(int hash, float x, float y) {
    switch(hash & 3) {
    case 0:
      return x + y;
    case 1:
      return -x + y;
    case 2:
      return x - y;
    case 3:
      return -x - y;
    default:
      return 0;
    }
  }

  float interpretationPolaire(float amount, float left, float right) {
    return ((1 - amount) * left + amount * right);
  }

  //A noise in a circle shape that we substract to the perin noise to create an island shape
  void generateIslandGradient () {
    float maxValue = sqrt(sq(w/2)+sq(h/2));
    for (int x = 0; x < w; x++) {
      for (int y = 0; y < h; y++) {
        float value = sqrt(sq(max(x, w/2) - min(x, w/2))+sq(max(y, h/2) - min(y, h/2)));
        map[x][y] -= map(value, 0, maxValue, 0, 1);
      }
    }
  }

  void display() {
    for (int i = 0; i < w; i++) {
      for (int j = 0; j < h; j++) {
        noStroke();
        if (map[i][j] * 255 > 70) {
         fill(#6CAA02);
         } else if (map[i][j] * 255 > 50) {
         fill(#DDDE09);
         } else if (map[i][j] * 255 > 30) {
         fill(#A5F1FF);
         } else if (map[i][j] * 255 > 180) {
         fill(#B2B2B2);
         } else {
         fill(#09BCDE);
         }
        //fill(map[i][j]*255);
        rect(20*i, 20*j, 20, 20);
      }
    }
  }
}
