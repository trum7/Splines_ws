class Bezier extends Method{

  Frame [] control_points;
  String methodName = "Bezier";
  float R = 0;
  float G = 255;
  float B = 255;
  @Override
  public String name(){
    return this.methodName;
  }

 public void setName(String name){
   this.methodName = name;
   this.R = 102;
   this.G = 128;
   this.B = 221;
 }
  @Override
  public void setPoints(Frame[] cp){
    this.control_points = cp;
  }
  
 @Override
 public void Points(){
  Frame[] ctrlP = this.control_points;
  for(float u = 0; u <= 1.0; u += 0.0002){
    PVector [] Q = new PVector [ctrlP.length];
    for (int i = 0; i < ctrlP.length; i++) {
      Q[i] = new PVector(ctrlP[i].position().x(),ctrlP[i].position().y(),ctrlP[i].position().z());
    }
    // now recurse though control points (col is color) 
    // with one fewer control points for each step
    while (Q.length > 0) {
      stroke(R,G,B);
      strokeWeight(2);
      // this adds a point to the memorised bezier up to the current u value:
      if (Q.length == 1) {
        //strokeWeight(1);
        point(Q[0].x,Q[0].y,Q[0].z);
      }
      // this recurses through de Casteljau's algorithm to calculate the points at degree d + 1:
      Q = Casteljaus(u,Q);
      // color for next set of points: 
    }
   }
 }
  
     // de Casteljau's algorithm
  PVector [] Casteljaus(float u, PVector [] P){
    int d = P.length - 1;
    if (d == 0) {
      return empty;
    }
    // otherwise recursive calculation:
    PVector [] Q = new PVector [d];
    for (int n = 0; n < d; n++) {
      Q[n] = new PVector( 
        (1-u) * P[n].x + u * P[n+1].x,
        (1-u) * P[n].y + u * P[n+1].y,
        (1-u) * P[n].z + u * P[n+1].z
      );
    }
    return Q;
  }
  

  
}