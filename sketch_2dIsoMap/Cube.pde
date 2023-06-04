class Cube {
  float x;
  float y;
  
  int cellX;
  int cellY;
  
  PImage img;
  
  int water;
  
  int cellType;
  
  float largeur;
  float longueur;
  
  int offsetWave;
  int offsetY;
  int offsetX;
  int offsetHeight;
  
  
  Cube(int x, int y, PImage img, int type) {
     this.cellX = x;
     this.cellY = y;
     
     this.cellType = type;
     
     this.img = img;
     this.largeur = img.width;
     this.longueur = img.height;
     
     this.x = this.cellX * this.largeur;
     this.y = this.cellY * this.longueur;
     
     this.water = 1;
     
     this.offsetY = 0;
     this.offsetX = 0;
  }
  
  
  
  
  void display () {
    if (water == 0) {
      image(img, x + offsetX, y + offsetY + offsetHeight);
    } else {
      image(img, x + offsetX, y + offsetY + offsetWave / water);
    }
  }
  
  void transpo() {
    this.x = (this.cellX * (this.largeur / 2)) + ((-this.cellY) * (this.largeur / 2));
    this.y = (this.cellX * (this.longueur / 4)) + (this.cellY * (this.longueur / 4));
  }
}
