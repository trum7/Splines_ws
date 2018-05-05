 class Hermite extends Method{
    
  Frame [] control_points;
  String methodName = "Hermite";
 
  @Override
  public String name(){
    return this.methodName;  
  }
  
  @Override
  public void setPoints(Frame[] cp){
    if(set){
      this.control_points = new Frame[cp.length + 2];
      Node ctrlPoint = new OrbitNode(scene);
      ctrlPoint.randomize();
      this.control_points[0] =((Frame)ctrlPoint); 
      ctrlPoint.randomize();
      this.control_points[cp.length + 1] =((Frame)ctrlPoint);
      for(int i = 0; i < cp.length; i++ ){
        this.control_points[i+1] = cp[i];
      }
      set = false;
    }
  }
  
  @Override
 public void Points(){
   Frame[] ctrlP = this.control_points;
   
   PVector [] Q = new PVector [ctrlP.length];
    for (int i = 0; i < ctrlP.length; i++) {
      Q[i] = new PVector(ctrlP[i].position().x(),ctrlP[i].position().y(),ctrlP[i].position().z());
    }
  for(float u = 0; u <= 1.0; u += 0.0002){
    float col = 15;
    stroke(col,255,0);
    strokeWeight(2);
    PVector w[] = HermiteFunction(0.5,u,Q);
    for(int j = 0; j< w.length-2; j++)
      point(w[j].x, w[j].y, w[j].z);
   }
   
  }
  
  PVector[]  HermiteFunction(float t, float u, PVector [] P ){
   
    float s = (1 - t)/2.0;
    float [] cardinal = cardinals(s,u);
    int d = P.length-1;
    PVector [] Q = new PVector [d];
    if (d == 0) {
      return empty;
    }
     
   for (int n = 1; n < d-1; n++) {
     Q[n-1] = new PVector(
       P[n-1].x * cardinal[0] + P[n].x * cardinal[1] + P[n+1].x * cardinal[2] + P[n+2].x * cardinal[3], 
       P[n-1].y * cardinal[0] + P[n].y * cardinal[1] + P[n+1].y * cardinal[2] + P[n+2].y * cardinal[3],
       P[n-1].z * cardinal[0] + P[n].z * cardinal[1] + P[n+1].z * cardinal[2] + P[n+2].z * cardinal[3]
     );
   }
   
    return Q;
  }
  
  
  float [] cardinals(float s, float u){
    float factor[] = new float[4];
    factor[0] = -s*(float)Math.pow(u,3)+(2*s*(u*u)) -s*u;
    factor[1] = ((2-s)*(float)Math.pow(u,3)) + ((s-3)*(u*u))+ 1 ;
    factor[2] = ((s-2)*(float)Math.pow(u,3)) + ((3 -2*s)*(u*u))+ s*u;
    factor[3] = (s*(float)Math.pow(u,3)) -(s*(u*u));
  
    return factor;  
  }
  
  
 }
 
 