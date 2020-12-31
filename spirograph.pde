import controlP5.*;


class Hypocycloid {
  
  // Attrbutes for the hypocycloid.
  private float x;
  private float y;
  private float radius;
  private Hypocycloid child;
  private Hypocycloid parent;
  private int depth;
  
  public Hypocycloid(float x, float y, float radius) {
    this.x = x;
    this.y = y;
    this.radius = radius;
    this.child = null;
    this.parent = null;
    this.depth = 1;
  }
  
  public float getRadius() {
    // Return the Hypocycloid's radius.
    return this.radius;
  }
  
  public void addChild(Hypocycloid child) {
    // Add a hypocycloid within the hypocycloid. Add this object as a parent to the child and update it's depth.
    this.child = child;
    child.setParent(this);
    child.setDepth(this.depth + 1);
  }
  
  public void setParent(Hypocycloid parent) {
    // Set the hypocycloid's parent- the hypocycloid that updates its position.
    this.parent = parent;
  }
  
  public Hypocycloid getParent() {
    // Return the parent of the hypocycloid.
    return this.parent;
  }
  
  public void setPosition(float x, float y) {
    // Set the updated position of the hypocycloid.
    this.x = x;
    this.y = y;
  }
  
  public void setDepth(int depth) {
    // Set the depth for the hypocycloid, which is a measure of how nested the hypocycloid is.
    this.depth = depth;
  }
  
  public void setRadius(float radius) {
    // Set the hypocycloid's radius.
    this.radius = radius;
  }
  
  public void draw() {
    // Draw function for the hypocycloid- drawing it to the screen.
    stroke(color(0, 0, 0));
    noFill();
    strokeWeight(1);
    circle(this.x, this.y, this.radius * 2);
  }
  
  public void drawPoint(boolean flip) {
    // Update the position of children hypocycloid OR draw points with the pen if no child.
    float x = this.x;
    float y = this.y;
    
    if (this.child == null && this.parent != null) {
      // Execute this code if the hypocycloid has no children, so it must be drawing the pen point.
      
      // Flip the sin and cos functions for each nested layer to reverse the direction of movement.
      if (flip) {
        x += (offset) * sin(((this.parent.getRadius() - this.radius) / this.radius) * radians(t));
        y += (offset) * cos(((this.parent.getRadius() - this.radius) / this.radius) * radians(t));
      }else {
        x += (offset) * cos(((this.parent.getRadius() - this.radius) / this.radius) * radians(t));
        y += (offset) * sin(((this.parent.getRadius() - this.radius) / this.radius) * radians(t));
      }
       
      // Draw the pen point.
      fill(color(R, G, B));
      circle(x, y, 10);
      
      // Don't increment time if paused.
      if (!playing) return;
      t ++;
      
      // Add x to linex and y to liney to draw the new points on the curve.
      // Loop around back to 0 at the end of the array to avoid an IndexOutOfBounds Exception.
      // This writes over previous points on the curve to save memory.
      if (index == linex.length - 1) {
        index = 0;
      } else {
        linex[index] = x;
        liney[index] = y;
        // Write zeroes after the newest point to stop drawing a line between the first and last points on the curve.
        linex[index + 1] = 0.0;
        liney[index + 1] = 0.0;
      }
      index ++;
      
    } else if (this.child != null) {
      // Execute this code if the hypocycloid has a child- therefore it must update that child's position.
      x = this.x;
      y = this.y;
      
      if (flip) {
        // Flip the sin and cos functions for each nested layer to reverse the direction of movement.
        x += ((this.radius - this.child.getRadius()) * cos(radians(t)));
        y += ((this.radius - this.child.getRadius()) * sin(radians(t)));
      } else {
        x += ((this.radius - this.child.getRadius()) * sin(radians(t)));
        y += ((this.radius - this.child.getRadius()) * cos(radians(t)));
      }
      
      // Draw a point in the centre of the child.
      fill(0);
      circle(x, y, 10);
      this.child.setPosition(x, y);
      
      // Call drawPoint in child.
      this.child.drawPoint(flip); 
    }
  }
  
}


// Declare controller object.
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
int multiplier = 1;

// Environment
int t;
boolean playing;
ArrayList<Hypocycloid> hcs;
float[] linex;
float[] liney;
int index;


void setup() {
  // Set the window size to 800x800 px.
  size(800, 800);
  
  // Instantiate controller object and arrays.
  controller = new ControlP5(this);
  hcs = new ArrayList<Hypocycloid>();
  linex = new float[10000];
  liney = new float[10000];
  index = 0;
  reset();
  
  // Hypocycloid setup.
  hcs.clear();
  hcs.add(new Hypocycloid(400, 500, 200));
  hcs.add(new Hypocycloid(400, 400, 80));
  hcs.get(0).addChild(hcs.get(1));
  
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
            
  controller.addSlider("Pen Offset")
            .setPosition(300, 25)
            .setSize(25, 150)
            .setColorBackground(color(100, 100, 100))
            .setColorCaptionLabel(0)
            .setColorValueLabel(0);  
            
  controller.addSlider("Outer Radius")
            .setPosition(375, 25)
            .setSize(25, 150)
            .setColorBackground(color(100, 100, 100))
            .setColorCaptionLabel(0)
            .setColorValueLabel(0)
            .setRange(1, 200); 
            
  controller.addSlider("Inner Radius")
            .setPosition(450, 25)
            .setSize(25, 150)
            .setColorBackground(color(100, 100, 100))
            .setColorCaptionLabel(0)
            .setColorValueLabel(0)
            .setRange(1, 200); 
  
  
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
  // Use the values of the colour sliders.
  R = (int) controller.getController("R").getValue();
  G = (int) controller.getController("G").getValue();
  B = (int) controller.getController("B").getValue();
  background(color(200, 200, 200));
   
  // Change some of the attributes of other controllers.
  controller.getController("Pen Offset").setColorForeground(color(R, G, B));
  controller.getController("Pen Offset").setColorActive(color(R, G, B));
  controller.getController("Outer Radius").setColorForeground(color(R, G, B));
  controller.getController("Outer Radius").setColorActive(color(R, G, B));
  controller.getController("Inner Radius").setColorForeground(color(R, G, B));
  controller.getController("Inner Radius").setColorActive(color(R, G, B));
  
  // Set the range of the pen offset slider using the radius of the inner circle.
  ((Slider) controller.getController("Pen Offset")).setRange(-hcs.get(hcs.size() - 1).getRadius(), hcs.get(hcs.size() - 1).getRadius());
  offset = controller.getController("Pen Offset").getValue();
  if (offset >= 0) {
    offset = min(offset, hcs.get(hcs.size() - 1).getRadius());
  } else {
    offset = max(-hcs.get(hcs.size() - 1).getRadius(), offset);
  }
  hcs.get(0).setRadius(controller.getController("Outer Radius").getValue());
  hcs.get(1).setRadius(min(controller.getController("Inner Radius").getValue(), hcs.get(0).getRadius()));
  
  // Draw dividing line.
  stroke(color(0, 0, 0));
  strokeWeight(3);
  line(0, 200, 800, 200);
  
  // Call drawPoint and then draw in each hypocycloid.
  hcs.get(0).drawPoint(true);
  for (Hypocycloid h : hcs) h.draw();
  
  // Draw the curve between points stored in linex and liney ignoring any 0.0 values.
  stroke(color(R, G, B));
  strokeWeight(3);
  for (int i = 0; i < linex.length - 1; i ++) {
    if ((linex[i] == 0.0 && liney[i] == 0.0) || (linex[i + 1] == 0 && liney[i + 1] == 0)) continue;
    line(linex[i], liney[i], linex[i + 1], liney[i + 1]);
  }
  
  // Increment time counter by 2 (twice as fast).
  if (playing) t += 2;
  
}

void controlEvent(ControlEvent event) {
  // Look for button press events and effect appropriate changes.
  if (event.isController()) {
    if (event.getController().getName() == "Play") playing = true;
    if (event.getController().getName() == "Pause") playing = false;
    if (event.getController().getName() == "Reset") reset();
  }
}

void reset() {
  // Reset variables. Called when reset button is pressed.
  playing = false;
  t = 0;
  for (int i = 0; i < linex.length; i++) linex[i] = 0;
  for (int i = 0; i < liney.length; i++) liney[i] = 0;
  
}
