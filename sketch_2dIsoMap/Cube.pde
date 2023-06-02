class Cube {
  float x;
  float y;
  
  PImage img;
  
  int water;
  
  float largeur;
  float longueur;
  
  int offset;
  
  
  Cube(float x, float y, PImage img) {
     this.x = x;
     this.y = y;
     this.img = img;
     this.largeur = img.width;
     this.longueur = img.height;
     
     this.water = 1;
     
     this.offset = 0;
  }
  
  
  
  
  void display () {
    if (water == 0) {
      image(img, x, y);
    } else {
      image(img, x, y + offset / water);
    }
     
  }
  
  void transpo() {
    this.x = this.x / 2 - this.y;
    this.y = this.x / 2 + this.y / 2;
  } 
}
