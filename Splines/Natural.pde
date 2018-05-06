
class Natural extends Method{
  Frame [] control_points;
  String methodName = "Natural Cubic";
  double[][] M ; // Base matrix to solve
  double[][] px;
  double[][] py;
  double[][] pz;
  double[][] X; // a,b,c,d coefficients in X
  double[][] Y; // a,b,c,d coefficients in Y
  double[][] Z; // a,b,c,d coefficients in Z
  
  
  public Natural(){
    initMatrix();
    setupMatrix();
  }
  
  
  @Override
  public String name(){
    return this.methodName;  
  }
  
 @Override
  public void setPoints(Frame[] cp){
     this.control_points = cp;
     int size= cp.length;
     px = new double[size][];
     py = new double[size][];
     pz = new double[size][];
     
     for (int i = 0; i< size; i++){
       px[i] = new double[1];
       px[i][0] = (double) this.control_points[i].position().x();
       py[i] = new double[1];
       py[i][0] = (double) this.control_points[i].position().y();
       pz[i] = new double[1];
       pz[i][0] = (double) this.control_points[i].position().z();
     }    
  }
  
 @Override
 public void Points(){
   int d = this.control_points.length;
   this.X = gather(px);
   this.Y = gather(py);
   this.Z = gather(pz);
   for(int n = 0; n < d-1; n++ ){
     for(float u = 0; u <= 1.0; u += 0.0002){
      stroke(230,230,250);
      strokeWeight(2);
      PVector w = NaturalFuncion(u,n);
      point(w.x, w.y, w.z);  
     }
   } 
 }
 
 
 public PVector NaturalFuncion(double u, int n){
   //PVector [] Q = new PVector [1];
  
     float x = (float) coordinate(u, X[n]);
     float y = (float)coordinate(u, Y[n]);
     float z = (float) coordinate(u, Z[n]);
     PVector Q = new PVector(x,y,z);
   return Q;
 }
 
 public double coordinate(double u, double[]coef){
   double result = coef[0] + coef[1]*u + (u*u)*coef[2] + (u*u*u)*coef[3];
   return result;
 }
 
 public double[][] gather(double[][] points){
   int segments = points.length -1 ;
   double [][] coef = new double[segments][];
   Matrix d = derivates(points);
   
   for(int i = 0; i< segments; i++){
     coef[i] = new double[4];
     coef[i] = coefficients(points,d,i);
   }
    
   return coef;
 }
  
// Returns coefficients a,b,c,d for each segment given the derivates in a coordinate
 public double[] coefficients(double[][] p, Matrix d, int index){
   double[] cardinal = new double[4];
     cardinal[0] = p[index][0]; // a
     cardinal[1] = d.data[index][0]; // b 
     cardinal[2] = 3.0*(p[index+1][0] - p[index][0])- 2.0*d.data[index][0] - d.data[index+1][0] ; // c
     cardinal[3] = 2.0*(p[index][0] - p[index+1][0]) + d.data[index][0] + d.data[index+1][0]; // d
   return cardinal;
 }
 
 
public Matrix derivates(double[][] cp){
  Matrix A = new Matrix(M);
  Matrix d = new Matrix(cp.length,1);
  d.data[0][0] = 3*(cp[1][0]-cp[0][0]);
  d.data[cp.length-1][0] = 3*(cp[cp.length-1][0]-cp[cp.length-2][0]);
  
  for (int i = 1; i < cp.length-1; i++)
    d.data[i][0] = 3*(cp[i+1][0] - cp[i-1][0]);
  
  Matrix der = A.solve(d);
  return der; 
 }
 
 
 public void initMatrix(){
    this.M = new double[numberofcp][];
    for (int i =0; i< numberofcp; i++){
      this.M[i] = new double[numberofcp];
      for (int j =0; j< numberofcp; j++)
            this.M[i][j] = 0;
    }
  }
  
  public void setupMatrix(){
    this.M[0][0] = 2;
    this.M[0][1] = 1;
    this.M[numberofcp-1][numberofcp-1] = 2;
    this.M[numberofcp-1][numberofcp-2] = 1;
    
    for (int i = 1; i <(numberofcp - 1); i++) {
      this.M[i][i-1] = 1;
      this.M[i][i] = 4;
      this.M[i][i+1] = 1; 
     }    
  }
  
  public void resizeMatrix(){
    if (M[0].length != numberofcp){
      initMatrix(); 
      setupMatrix();
    }
  }
 
 
}