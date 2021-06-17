// Original JS by Daniel Shiffman from The Coding Train
// http://patreon.com/codingtrain
// Code for: https://youtu.be/E1B4UoSQMFw
// Ported to processing by Max (https://github.com/TheLastDestroyer)
// Alpha background, styling and save functionality by YuriNikolai

// usually breaks on 6th click. Maybe the n of clicks supported can be improved?
// angles to keep in mind: 10, 25, 45. 45 and 10 can render a 6th click after a long time,
//25 breaks the image completely after the 6th. random between 10 and 30 seems to work better

// variables: A B
// axiom: A
// rules: (A → AB), (B → A)

int savenumber;
float angle;
int anglenumber;
PGraphics alphaG;
String axiom = "F";
String sentence = axiom;
String output;
int len = 100;
Rule[] rules;


void setup(){
  size(1024,1024);
  noSmooth();
  savenumber = 0;
  rules = new Rule[1];
  rules[0] = new Rule('F', "FF+[+F-F-F]-[-F+F+F]");
  // rules[0] = new Rule('F', "FF+[+F-F-F]-[-F+F+F]");
  anglenumber = 10;
  angle = radians(random(anglenumber, anglenumber + 20));
  // PGraphics object allows rendering on a transparent background
  alphaG = createGraphics(width,height, JAVA2D);
  println(axiom);
  turtle();
}

void draw(){
  image(alphaG,0,0); //Allows us to see what's going on in the PGraphics
}

void keyPressed() { if (key == ' ') {
       savenumber++;
       output = "alpha" + anglenumber + "_" + savenumber + ".png";
       alphaG.save(output);
       println("saved as alpha" + anglenumber + "_"  + savenumber + ".png"); 
  }
}

void mouseClicked() { if (mouseButton == RIGHT) {
    println("click");
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
  println(sentence);
  turtle();
}


void turtle(){
  alphaG.beginDraw();
  alphaG.resetMatrix(); 
  alphaG.background(255,0); //transparent on save
  alphaG.translate(width/2, height);
  alphaG.stroke(0, 200);
  for (int i = 0; i < sentence.length(); i++) {
    char current = sentence.charAt(i);

    if (current == 'F') {
      alphaG.line(0, 0, 0, -len);
      alphaG.translate(0, -len);
    } else if (current == '+') {
      alphaG.rotate(angle);
    } else if (current == '-') {
      alphaG.rotate(-angle);
    } else if (current == '[') {
      alphaG.pushMatrix();
    } else if (current == ']') {
      alphaG.popMatrix();
    }
  }
  alphaG.endDraw();
}
