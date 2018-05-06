/**
 * Splines.
 *
 * Here we use the interpolator.keyFrames() nodes
 * as control points to render different splines.
 *
 * Press ' ' to change the spline mode.
 * Press 'g' to toggle grid drawing.
 * Press 'c' to toggle the interpolator path drawing.
 */

import frames.input.*;
import frames.primitives.*;
import frames.core.*;
import frames.processing.*;
import java.lang.Math;
import java.util.ArrayList;

// global variables
// modes: 0 natural cubic spline; 1 Hermite;
// 2 (degree 7) Bezier; 3 Cubic Bezier
int mode;

Scene scene;
Interpolator interpolator;
OrbitNode eye;
boolean drawGrid = true, drawCtrl = true;

//Choose P3D for a 3D scene, or P2D or JAVA2D for a 2D scene
String renderer = P3D;

// variables
ArrayList<Method> splines = new ArrayList<Method>();
PVector [] empty = {};
boolean change = false;
int numberofcp = 8;
Frame [] control_points = new Frame[numberofcp];
boolean set = true;



void setup() {
  size(800, 800, renderer);
  scene = new Scene(this);
  eye = new OrbitNode(scene);
  eye.setDamping(0);
  scene.setEye(eye);
  scene.setFieldOfView(PI / 3);
  //interactivity defaults to the eye
  scene.setDefaultGrabber(eye);
  scene.setRadius(150);
  scene.fitBallInterpolation();
  interpolator = new Interpolator(scene, new Frame());
  
  splines.add(new Natural());
  splines.add(new Hermite());
  splines.add(new Bezier());
  Bezier mode2 = new Bezier();
  mode2.setName("Cubic Bezier");
  splines.add(mode2);
  getControlPoints();
  
}

void draw() {
  if (change){
    getControlPoints();
    change=false;
  }
  background(175);
  if (drawGrid) {
    stroke(255, 255, 0);
    scene.drawGrid(200, 50);
  }
  if (drawCtrl) {
    fill(255, 0, 0);
    stroke(255, 0, 255);
    for (Frame frame : interpolator.keyFrames()){
      scene.drawPickingTarget((Node)frame);
    }
  } else {
    fill(255, 0, 0);
    stroke(255, 0, 255);
    scene.drawPath(interpolator);
    for (Frame frame : interpolator.keyFrames()){
      scene.drawPickingTarget((Node)frame);
    }
    splines.get(mode).setPoints(control_points);
    splines.get(mode).Points();  
    titles( splines.get(mode).name(), numberofcp);
  }

}

void getControlPoints(){
  
  if(control_points.length != 0){
    control_points = new Frame[numberofcp]; 
    interpolator = new Interpolator(scene, new Frame());
  }  
  for (int i = 0; i < numberofcp; i++) {
    Node ctrlPoint = new OrbitNode(scene);
    ctrlPoint.randomize();
    interpolator.addKeyFrame(ctrlPoint);  
    control_points[i] =((Frame)ctrlPoint);
  }
  
}

void titles(String name, int numP){
  scene.beginScreenCoordinates();
  textSize(30);
  fill(65,105,225);
  text("Spline: " + name, 50, 35);
  fill(102,0,214);
  text("Points: "+ numP, 420, 35);
  scene.endScreenCoordinates();
}

void keyPressed() {
  if (key == ' '){
    mode = mode < 3 ? mode+1 : 0;
    change = true;
    switch(mode){
      case 0:
        numberofcp = 4;
        Natural temp = (Natural)splines.get(mode);
        temp.resizeMatrix();
        break;
      case 1:
        set = true;
        numberofcp = 8;
        break;
      case 2:
        numberofcp = 8;  
        break;
      case 3:
        numberofcp = 4;
        break;    
    }    
  } 
  
  if (key == 'g')
    drawGrid = !drawGrid;
  if (key == 'c')
    drawCtrl = !drawCtrl;
}