abstract class Poisson {
  int posX, posY, v, direction;
  color couleur;
  float taille;

  Poisson() {
    this.posX = int(random(0, width));
    this.posY = int(random((25*height/100)+50, height));
    this.couleur = color(int(random(0, 256)), int(random(0, 256)), int(random(0, 256)));
    this.v = 1;
    this.taille = random(0.5, 2.1);
    this.direction = int(random(0, 2));
    if (direction == 0) {
      direction = -1;
    }
  }
  Poisson(int x, int y, int t, int v) {
    this.posX = x;
    this.posY = y;
    this.taille = t;
    this.v = v;
    this.couleur = color(int(random(0, 256)), int(random(0, 256)), int(random(0, 256)));
    this.direction = int(random(0, 2));
    if (direction == 0) {
      direction = -1;
    }
  }
  Poisson(int x, int y, int t, int v, color couleur) {
    this.posX = x;
    this.posY = y;
    this.taille = t;
    this.v = v;
    this.couleur = couleur;
    this.direction = int(random(0, 2));
    if (direction == 0) {
      direction = -1;
    }
  }
  Poisson(color couleur) {
    this.posX = int(random(0, width));
    this.posY = int(random((25*height/100)+50, height));
    this.couleur = couleur;
    this.v = 1;
    this.taille = random(0.5, 2.1);
    this.direction = int(random(0, 2));
    if (direction == 0) {
      direction = -1;
    }
  }

  PVector getPosition() {
    return new PVector(posX, posY);
  }
  float getTaille() {
    return taille;
  }

  int getPoissonY() {
    return posY;
  }
  int getPoissonX() {
    return posX;
  }

  void setVitesse(int vitesseModif) {
    this.v=vitesseModif;
  }

  abstract void affichagePoisson();

  void affichePoisson() {
    //-----Dessine un poisson-----
    decor.initialisation();
    int hauteurCorps = 10;
    int largeurCorps = 30;
    int centreTete = 25;
    float circonferenceTete = dist(posX+largeurCorps/2*taille, posY, posX+largeurCorps/2*taille, posY-hauteurCorps*taille);
    int oeuilX = 33;
    int oeuilY = 5;
    int oeuilProportion = 2;
    fill(couleur);
    quad(posX, posY, posX, posY-hauteurCorps*taille, posX+largeurCorps*taille, posY, posX+largeurCorps*taille, posY-hauteurCorps*taille);
    arc(posX+largeurCorps*taille, (posY+posY-hauteurCorps*taille)/2, centreTete*taille, circonferenceTete, -PI/2, PI/2);
    fill(0);
    circle(posX+oeuilX*taille, posY-oeuilY*taille, oeuilProportion*taille);
  }

  void affichePoissonQuiFaitPeur() {
    decor.initialisation();

    int baseTailleX = 45;
    int baseTailleY = -10;
    image(poissonClement, posX, posY, baseTailleX*taille, baseTailleY*taille);
  }

  void mouvementPoisson() {
    posX+=direction*v;
    int respawnPoisson = 55;
    if (posX>=width) {
      posX=int(-respawnPoisson*this.taille);
    } else if (posX<=-respawnPoisson*this.taille) {
      posX=width;
    }
    posX=constrain(posX, int(-respawnPoisson*taille), width);
  }

  void apparitionPoisson() {
    //-----Fait reaparaitre un poisson-----
    posX=int(random(0, width));
    posY=int(random((25*height/100)+50, height));
    direction=int(random(0, 2));

    if (direction==0) {
      direction=-1;
    }

    taille=random(0.5, 2.1);
    couleur=color(int(random(0, 256)), int(random(0, 256)), int(random(0, 256)));
  }

  boolean hitBoxPoisson(int contactX, int contactY) {
    //-----Zone de collision du poisson avec l'hamecon-----
    decor.initialisation();
    float colliderX1 = this.posX+15*taille;
    float colliderX2 = this.posX+40*taille;
    float colliderY1 = this.posY-10*taille;
    float colliderY2 = this.posY;
    /*
    noFill();
     rectMode(CORNERS);
     // Affiche l'hit Box du poisson
     strokeWeight(10);
     point(this.posX, this.posY);
     strokeWeight(1);
     stroke(0);
     noFill();
     rect(this.posX+15*taille, this.posY-10*taille, this.posX+40*taille, this.posY);
     */
    return !decor.getPoissonPecher() && contactX>colliderX1 && contactY>colliderY1 && contactX<colliderX2 && contactY<colliderY2;
  }

  void pecher(int contactX, int contactY) {
    if (this.hitBoxPoisson(contactX, contactY) ) {
      if (poissons.size() == 1) {
        //-----Timer a la fin de la partie, lorsque le dernier poisson est peché-----
        temps.setStop();
      }
      //-----Le poisson est peché-----
      int profondeur = height/this.getPoissonY();
      bateau.addScore((3/taille)+2/constrain(profondeur, 1, profondeur));
      poissons.remove(this);
      bateau.setPosHamY(bateau.getBatY());
    }
  }
}


class Truite extends Poisson {
  void affichagePoisson() {
    this.affichePoisson();
  }
}

class Dorade extends Poisson {
  void affichagePoisson() {
    int baseTailleX = 25;
    int baseTailleY = -10;
    float decallage = 35*this.taille - baseTailleX*this.taille ;
    image(dorades, posX + decallage, this.posY, baseTailleX+decallage*taille, baseTailleY*taille);
  }
}

class PoissonQuiFaitPeur extends Poisson {
  void affichagePoisson() {
    int baseTailleX = 45;
    int baseTailleY = -10;
    image(poissonClement, posX, posY, baseTailleX*taille, baseTailleY*taille);
  }
}
