


class Cube {
  float x;
  float y;
  
  PImage img;
  
  float largeur;
  float longueur;
  
  int offset;
  
  
  Cube(float x, float y, PImage img) {
     this.x = x;
     this.y = y;
     this.img = img;
     this.largeur = img.width;
     this.longueur = img.height;
     
     this.offset = 0;
  }
  
  
  
  
  void display () {
     image(img, x, y + offset);
  }
  
  void transpo() {
    this.x = this.x / 2 - this.y;
    this.y = this.x / 2 + this.y / 2;
  } 
}