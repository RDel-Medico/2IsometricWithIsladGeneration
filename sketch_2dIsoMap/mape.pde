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
        
        if (fullMap[i][j]*255 > 90) {
          fill(0, m.map[i][j]*255, 0, 100);
        } else if (fullMap[i][j]*255 > 60) {
          fill(m.map[i][j]*255, m.map[i][j]*255, 0, 100);
        } else {
          fill(0, 0, m.map[i][j]*255, 100);
        }
      
        
        rect(i*10+(width - m.w*10) / 2 + 5, j*10+(height - m.h*10) / 2, 10, 10);
      }
    }
  }
}
