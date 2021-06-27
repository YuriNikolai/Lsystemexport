// Original JS by Daniel Shiffman from The Coding Train
// http://patreon.com/codingtrain
// Code for: https://youtu.be/E1B4UoSQMFw
// Ported to processing by Max (https://github.com/TheLastDestroyer)
// Alpha background, styling and save functionality by YuriNikolai

// angles to keep in mind: 10, 25, 35, 45, 60.
//25 breaks the image completely after the 6th. random between 10 and 30 seems to work better for a near identical result.

// variables: A B
// axiom: A
// rules: (A → AB), (B → A)

int ANGLEDEG = 10; //TODO change len reduction to be less if angle is higher, otherwise image gets cutoff at around angle 60 iteration 6
int STROKEWEIGHT = 1; //if changed to float, values less than 1 may break the preview window

float angle;
PGraphics pG;
String axiom = "F";
String sentence = axiom;
String output;
int len = 100;
Rule[] rules;


void setup(){
  size(1024,1024);
  noSmooth();
  rules = new Rule[1];
  rules[0] = new Rule('F', "FF+[+F-F-F]-[-F+F+F]");
  // rules[0] = new Rule('F', "FF+[+F-F-F]-[-F+F+F]"); //default rule
  
  angle = radians(ANGLEDEG);
  // PGraphics object allows rendering on a transparent background
  pG = createGraphics(width,height, JAVA2D);
  println(axiom);
  turtle();
}


void draw(){
  image(pG,0,0); //Allows us to see what's going on in the PGraphics
}


void keyPressed() { if (key == ' ') {
       output = "angle" + ANGLEDEG + "_" + counter + "_" + "stroke" + STROKEWEIGHT + ".png";
       pG.save(output);
       println("saved as " + output); 
  }
}
int counter = 0;


void mouseClicked() { if (counter < 6 && mouseButton == RIGHT) {
    counter++;
    println("click " + counter);
    generate();
  }
}


class Rule {
  char a;
  String b;
  Rule(char _a, String _b){
    a = _a;
    b = _b;
  }
}


void generate(){
  len *= 0.6;
  String next_sentence = "";
  for (int i = 0; i < sentence.length(); i++){
    char current = sentence.charAt(i);
    boolean found = false;
    for (int j = 0; j < rules.length; j++){
      if (current == rules[j].a){
        found = true;
        next_sentence += rules[j].b;
        break;
      }
    }
    if (!found){
      next_sentence += current;
    }
  }
  sentence = next_sentence;
  //println(sentence);
  turtle();
}


void turtle(){
  pG.beginDraw();
  pG.resetMatrix(); 
  pG.background(255,0); //transparent on save
  pG.translate(width/2, height);
  pG.strokeWeight(STROKEWEIGHT);
  pG.stroke(0, 200);
  for (int i = 0; i < sentence.length(); i++) {
    char current = sentence.charAt(i);

    if (current == 'F') {
      pG.line(0, 0, 0, -len);
      pG.translate(0, -len);
    } else if (current == '+') {
      pG.rotate(angle);
    } else if (current == '-') {
      pG.rotate(-angle);
    } else if (current == '[') {
      pG.pushMatrix();
    } else if (current == ']') {
      pG.popMatrix();
    }
  }
  pG.endDraw();
}
