import controlP5.*;
import java.util.ArrayList;


class Hypocycloid {
  
  // Attrbutes for the hypocycloid.
  private float x;
  private float y;
  private float radius;
  private ArrayList<Hypocycloid> children;
  private Hypocycloid parent;
  
  public Hypocycloid(float x, float y, float radius) {
    this.x = x;
    this.y = y;
    this.radius = radius;
    this.children = new ArrayList<Hypocycloid>();
    this.parent = null;
  }
  
  public float getRadius() {
    return this.radius;
  }
  
  public void addChild(Hypocycloid child) {
    this.children.add(child);
    child.addParent(this);
  }
  
  public void addParent(Hypocycloid parent) {
    this.parent = parent;
  }
  
  public Hypocycloid getParent() {
    return this.parent;
  }
  
  public void setPosition(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  public void draw() {
    stroke(color(0, 0, 0));
    noFill();
    strokeWeight(1);
    circle(this.x, this.y, this.radius * 2);
  }
  
  public void drawPoint(int t) {
    // Tidy this the heck up bro.
    float x = this.x;
    float y = this.y;
    
    if (this.children.size() == 0 && this.parent != null) {
      x += (this.radius - offset) * sin(((this.parent.getRadius() - this.radius) / this.radius) * radians(t));
      y += (this.radius - offset) * cos(((this.parent.getRadius() - this.radius) / this.radius) * radians(t));
      
      fill(color(R, G, B));
      circle(x, y, 10);
      if (!(linex.contains(x) && liney.contains(y))) {
        linex.add(x);
        liney.add(y);
      }
      return;
    }
    
    for (Hypocycloid h : this.children) {
      x = this.x;
      y = this.y;
      x += ((this.radius - h.getRadius()) * cos(radians(t)));
      y += ((this.radius - h.getRadius()) * sin(radians(t)));
      fill(0);
      circle(x, y, 10);
      h.setPosition(x, y);
      h.drawPoint(t); 
    }
  }
  
}


ControlP5 controller;

// Pen colours.
int R = 0;
int G = 0;
int B = 0;

// Hypocycloid parameters.
float radius;
float x;
float y;
float offset = 50;

// Environment
int t;
boolean playing;
boolean clicked;
ArrayList<Hypocycloid> hcs;
float circlex;
float circley;
float circler;
ArrayList<Float> linex;
ArrayList<Float> liney;


void setup() {
  size(800, 800);
  controller = new ControlP5(this);
  hcs = new ArrayList<Hypocycloid>();
  linex = new ArrayList<Float>();
  liney = new ArrayList<Float>();
  reset();
  
  // Slider Creation
  controller.addSlider("R")
            .setPosition(50, 25)
            .setSize(25, 150)
            .setRange(0, 255)
            .setValue(128)
            .setColorBackground(color(100, 0, 0))
            .setColorForeground(color(200, 0, 0))
            .setColorActive(color(255, 0, 0))
            .setColorCaptionLabel(0)
            .setColorValueLabel(0);
  
  controller.addSlider("G")
            .setPosition(100, 25)
            .setSize(25, 150)
            .setRange(0, 255)
            .setValue(128)
            .setColorBackground(color(0, 100, 0))
            .setColorForeground(color(0, 200, 0))
            .setColorActive(color(0, 255, 0))
            .setColorCaptionLabel(0)
            .setColorValueLabel(0);
  
  controller.addSlider("B")
            .setPosition(150, 25)
            .setSize(25, 150)
            .setRange(0, 255)
            .setValue(128)
            .setColorBackground(color(0, 0, 100))
            .setColorForeground(color(0, 0, 200))
            .setColorActive(color(0, 0, 255))
            .setColorCaptionLabel(0)
            .setColorValueLabel(0);
  
  // Button Creation
  controller.addButton("Play")
            .setPosition(600, 25)
            .setSize(100, 40)
            .setColorBackground(color(0, 100, 0))
            .setColorForeground(color(0, 200, 0))
            .setColorActive(color(0, 255, 0));
            
  controller.addButton("Pause")
            .setPosition(600, 75)
            .setSize(100, 40)
            .setColorBackground(color(100, 0, 0))
            .setColorForeground(color(200, 0, 0))
            .setColorActive(color(255, 0, 0));
  
  controller.addButton("Reset")
            .setPosition(600, 125)
            .setSize(100, 40)
            .setColorBackground(color(100, 100, 100))
            .setColorForeground(color(150, 150, 150))
            .setColorActive(color(200, 200, 200));
  
}

void draw() {
  R = (int) controller.getController("R").getValue();
  G = (int) controller.getController("G").getValue();
  B = (int) controller.getController("B").getValue();
  background(color(200, 200, 200));
  
  stroke(color(0, 0, 0));
  strokeWeight(3);
  line(0, 200, 800, 200);
  
  hcs.get(0).drawPoint(t);
  for (Hypocycloid h : hcs) h.draw();
  
  for (int i = 0; i < linex.size() - 1; i ++) {
    stroke(color(R, G, B));
    strokeWeight(3);
    line(linex.get(i), liney.get(i), linex.get(i + 1), liney.get(i + 1));
  }
  
  if (clicked) {
    circler = (float) Math.sqrt(Math.pow(mouseX - circlex, 2) + Math.pow(mouseY - circley, 2));
    noFill();
    circle(circlex, circley, circler * 2);
  }
  
  // Increment time.
  if (playing) t += 1;
  
}

void controlEvent(ControlEvent event) {
  if (event.isController()) {
    if (event.getController().getName() == "Play") playing = true;
    if (event.getController().getName() == "Pause") playing = false;
    if (event.getController().getName() == "Reset") reset();
  }
}

void mouseClicked() {
  if (mouseY > 200 && !playing) {
    clicked = !clicked;
    if (clicked) {
      circlex = mouseX;
      circley = mouseY;
    } else { 
      circlex = 0;
      circley = 0;
    }
  }
}

void reset() {
  playing = false;
  clicked = false;
  t = 0;
  linex.clear();
  liney.clear();
  
  // Hypocycloid setup.
  hcs.clear();
  hcs.add(new Hypocycloid(400, 500, 200));
  hcs.add(new Hypocycloid(400, 400, 80));
  hcs.get(0).addChild(hcs.get(1));
}
