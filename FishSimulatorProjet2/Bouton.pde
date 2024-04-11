class Bouton {
  int posX, posY, largeur, longueur,
    posTextX, posTextY;
  String text;
  color couleur;

  Bouton() {
    this.posX = 0;
    this.posY = 0;
    this.largeur = 25;
    this.longueur = 15;
    this.couleur = color(175);
    this.posTextX = (this.posX + this.largeur)/2;
    this.posTextY = (this.posY + this.longueur)/2;
    this.text = "";
  }

  Bouton(int x, int y, int decalX, int decalY, String text) {
    this.posX = x;
    this.posY = y;
    this. largeur = decalX;
    this.longueur = decalY;
    this.text = text;
    this.posTextX = (x + decalX)/2;
    this.posTextY = (y + decalY)/2;
    this.couleur = color(175);
  }

  Bouton(int x, int y, int decalX, int decalY, String text, color couleur) {
    this.posX = x;
    this.posY = y;
    this. largeur = decalX;
    this.longueur = decalY;
    this.text = text;
    this.posTextX = (x + decalX)/2;
    this.posTextY = (y + decalY)/2;
    this.couleur = couleur;
  }

  void afficheBouton() {
    rectMode(CORNERS);
    stroke(0);
    fill(this.couleur);
    rect(this.posX, this.posY, this.largeur, this.longueur);
    textAlign(CENTER);
    fill(0);
    text(this.text, this.posTextX, this.posTextY);
  }

  boolean mouseOver() {
    return mouseX>this.posX && mouseY>this.posY && mouseX<this.largeur && mouseY<this.longueur ;
  }
}
