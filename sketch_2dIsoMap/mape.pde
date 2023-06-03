class mape{
  Map m;
  mape(float[][] m){
    this.m = new Map(48, 32);
    for (int i=0; i<this.m.w; i++){
      for (int j=0; j<this.m.h; j++){
        this.m.map[i][j] =  int(255 - floor(m[i][j]*255));
      }
    }
  }
  void display(){
    rectMode(CENTER);
    noStroke();
    for (int j=0; j<m.h; j++){
      for (int i=0; i<m.w; i++){
        fill(m.map[i][j], m.map[i][j], m.map[i][j], 200);
        rect(i*10+(width - m.w*10) / 2 + 5, j*10+(height - m.h*10) / 2, 10, 10);
      }
    }
  }
}
