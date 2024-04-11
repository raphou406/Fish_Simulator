class Bateau {

  int posBatX, posBatY, posHamX, posHamY, score;
  int vitesse = 2;
  color couleur;
  boolean deplacementSouris = false;
  boolean deplacementAutomatique = false;//---False par default, ne peux pas etre modifié durant l'execution du code---


  Bateau() {
    this.posBatX = 25*height/100;
    this.posBatY = 25*height/100;
    this.posHamY = posBatY - 25;
    this.couleur = color(255, 255, 0);
    this.score = 0;
  }
  Bateau(int x) {
    this.posBatX = x;
    this.posBatY = 25*height/100;
    this.posHamY = posBatY - 25;
    this.couleur = color(255, 255, 0);
    this.score = 0;
  }

  void setPosHamY(int x) {
    posHamY=x;
  }
  void setMouvementSouris(boolean modif) {
    deplacementSouris = modif;
  }
  void addScore(float ajout) {
    score += ajout;
  }

  boolean getDeplacementSouris() {
    return deplacementSouris;
  }
  boolean getDeplacementAutomatique() {
    return deplacementAutomatique;
  }
  int getHamY() {
    return posHamY;
  }
  int getHamX() {
    return posBatX + 80;
  }
  int getBatX() {
    return posBatX;
  }
  int getBatY() {
    return posBatY;
  }
  int getScore() {
    return score;
  }

  //-----Dessine le pecheur, le bateau et la canne a peche-----
  int Xcoin2 = 65;
  int Xcoin3 = 15;
  void afficheBateau() {
    decor.initialisation();
    barque();
    pecheur();
    hamecon();
    int maxHauteurHamecon = posBatY - 25;
    posBatX=constrain(posBatX, Xcoin3, width-Xcoin2);
    posHamY=constrain(posHamY, maxHauteurHamecon, height);
  assert posBatY == 25*height/100 :
    "La Largeur de la fenêtre ne doit pas être modifié pendand l'execution du code";
  }
  void barque() {
    fill(156, 66, 29);
    int decalageY = 15;
    int Xcoin1 = 50;
    quad(posBatX, posBatY, posBatX + Xcoin1, posBatY, posBatX + Xcoin2, posBatY-decalageY, posBatX - Xcoin3, posBatY-decalageY);
  }
  int rayonTete = 10;
  int decalageTete = 35;
  void pecheur() {
    fill(255);
    int debutPecheurX = posBatX + 35;
    int debutPecheurY = posBatY - 15;
    int fincanneY = posBatY - 30;
    int finPecheurY = posBatY - 30;
    int finCanneX = posBatX + 80;
    circle(posBatX+decalageTete, posBatY-decalageTete, rayonTete);
    line(debutPecheurX, debutPecheurY, debutPecheurX, finPecheurY);
    line(debutPecheurX, debutPecheurY, finCanneX, fincanneY);
  }
  void hamecon() {
    stroke(couleur);
    int OrigineHameconY = posBatY - 30;
    posHamX = posBatX + 80;
    line(posHamX, OrigineHameconY, posHamX, posHamY);
  }

  void deplacements() {
    //-----Choisis le mode de deplacement du bateau-----
    if (!decor.getPause()) {
      if (!this.deplacementAutomatique) {
        mouvementClavier();
        mouvementSouris();
      } else {
        mouvementAutomatique();
      }
    }
  }

  void mouvementClavier() {
    //-----Mouvement du bateau avec les touches directionnelles du clavier-----
    if (!this.deplacementSouris) {
      if (keys[UP]) {
        bateau.posHamY-=bateau.vitesse;
      } else if (keys[DOWN]) {
        bateau.posHamY+=vitesse;
      }
      if (keys[LEFT]) {
        bateau.posBatX-=vitesse;
      } else if (keys[RIGHT]) {
        bateau.posBatX+=vitesse;
      }
    }
  }

  void mouvementSouris() {
    if (this.deplacementSouris) {
      if (mouseX>posHamX) {
        posBatX+=vitesse;
        // posBatX=constrain(posHamX, 0, mouseX);
      } else if (mouseX<posHamX) {
        posBatX-=vitesse;
        // posBatX=constrain(posHamX, mouseX, width);
      }

      if (mouseY>posHamY) {
        posHamY+=vitesse;
        posHamY=constrain(posHamY, 0, mouseY);
      } else if (mouseY<posHamY) {
        posHamY-=vitesse;
        posHamY=constrain(posHamY, mouseY, width);
      }
    }
  }

  void mouvementAutomatique() {
    if (poissons.size()!=0) {
      Poisson poissonProche = decor.getIndicePoissonProche();
      float taille = poissonProche.getTaille();
      float hitBoxPoissonX = (poissonProche.getPoissonX() + 15 * taille + poissonProche.getPoissonX() + 40 * taille)/2;
      float hitBoxPoissonY = (poissonProche.getPoissonY() - 10 * taille);

      if (hitBoxPoissonX>posHamX) {
        posBatX+=vitesse;
      } else if (hitBoxPoissonX<posHamX) {
        posBatX-=vitesse;
      }
      //this.posX+15*taille, this.posY-10*taille, this.posX+40*taille, this.posY
      if (hitBoxPoissonY>posHamY) {
        posHamY+=vitesse;
      } else if (hitBoxPoissonY<posHamY) {
        posHamY-=vitesse;
      }
    }
  }

  boolean difficile() {
    return dist(mouseX, mouseY, posBatX + decalageTete, posBatY - decalageTete) <= rayonTete;
  }
}
