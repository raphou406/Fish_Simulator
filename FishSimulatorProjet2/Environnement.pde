class Environnement {

  boolean jour = true;
  boolean tutoriel = true;
  boolean secret = false;
  boolean pause = true;
  boolean menuSettings = false;
  boolean poissonPecher = false;
  int debutPeche;
  int finPeche;
  float tempsPause = 0;

  Environnement() {
  }

  void setSecret(boolean modif) {
    secret = modif;
  }
  void setJour(boolean modif) {
    jour = modif;
  }
  void setTutoriel(boolean modif) {
    tutoriel = modif;
  }

  boolean getJour() {
    return jour;
  }
  boolean getTutoriel() {
    return tutoriel;
  }
  boolean getSecret() {
    return secret;
  }
  boolean getPause() {
    return pause;
  }
  boolean getMenuSettings() {
    return menuSettings;
  }
  boolean getPoissonPecher() {
    return poissonPecher;
  }


  void initialisation() {
    //-----Pose une base pour preparer un dessin (evite les bugs lié au mod de dessin)-----
    stroke(0);
    fill(255);
    strokeWeight(1);
    colorMode(RGB, 255);
    rectMode(CORNER);
    textSize(12);
  }

  void arrierePlan() {
    initialisation();
    if (this.jour) {
      jour();
    } else {
      nuit();
    }
    if (this.secret) {
      initialisation();
      bloodMoon();
    }
  }

  void jeuPause() {
    tuto();
    textSize(26);
    textAlign(CENTER);
    text("Jeu en pause..", width/2, height/2);
    temps.iterPause();
    // tempsPause = millis() - debutPeche;
  }
  void jour() {
    //-----Degradé blanc et bleu du ciel-----
    int blue=200;
    int alpha=255;
    rect(0, 0, width, 25*height/100);
    for ( int ciel = 0; ciel<25*height/100; ciel++) {
      fill(0, 0, blue, alpha);
      noStroke();
      rect(0, ciel, width, 1);
      alpha=blue--;
    }
  }

  void nuit() {
    //-----Degradé blanc et noir du ciel-----
    colorMode(25*height/100);
    int gris=0;
    for ( int ciel = 0; ciel<25*height/100; ciel++) {
      fill(gris);
      noStroke();
      rect(0, ciel, width, 1);
      gris++;
    }
  }

  void bloodMoon() {
    //-----Degradé blanc et rouge du ciel-----
    int rouge=255;
    int alpha=255;
    rect(0, 0, width, 25*height/100);
    for ( int ciel = 0; ciel<25*height/100; ciel++) {
      fill(rouge, 0, 0, alpha);
      noStroke();
      rect(0, ciel, width, 1);
      alpha--;
    }
  }

  void eau() {
    //-----Degradé bleu et noir de l'eau-----
    colorMode(RGB, 25*height/100);
    int blue=height;
    int alpha=height/2;
    for ( int i = 0; i<height; i++) {
      fill(0, 0, blue, alpha);
      noStroke();
      rect(0, i, width, 1);
      blue--;
      alpha++;
    }
    int nombreCoraux = 15;
    int tailleCoraux = 34;
    for (int i = 0; i<nombreCoraux; i++) {
      float corailX = i;
      corailX = map(corailX, 0, nombreCoraux, 0, width);
      image(coraille, corailX, height - tailleCoraux, tailleCoraux, tailleCoraux);
    }
  }

  void endGame() {
    //-----Affiche le temps passé a pecher tout les poissons-----
    if (poissons.size() == 0) {
      float tps = temps.afficheTempsSecondes();
      textSize(28);
      textAlign(CENTER);
      fill(255);
      text("Felicitations vous avez attrapé tout les poissons en "+tps+" secondes !!", width/2, height/3);
      text("Appuez sur espace pour recommencer", width/2, height/2);
    }
  }

  void tuto() {
    //-----Explique au joueur comment jouer-----
    initialisation();
    if (tutoriel) {
      textSize(32);
      textAlign(CENTER);
      text("Utilise les flèches pour te déplacer et Espace pour retirer/mettre en pause", width/2, height/3);
      temps.setStart();
    }
  }

  int getHauteurMenu() {
    //-----Parcours la liste d'objets boutons afin de connaitre le boutons avec la hauteur la plus haute-----
    int max=0;
    for (Bouton bouton : boutons) {
      if (bouton.largeur > max) {
        max = bouton.longueur;
      }
    }
    return max;
  }

  void menu() {
    //Les valeurs sont en pourcentage de l'écran
    initialisation();
    if (menuSettings) {
      //-----Affiche le panneau des parametres du jeu-----
      int maxH = getHauteurMenu();
      int decallage = 50;
      int x1 = 20*width/100;
      int y1 = 10*height/100;
      int x2 = 80*width/100;
      rectMode(CORNERS);
      rect(x1, y1, x2, maxH + decallage);
      fill(0);
      textAlign(LEFT);
      text("changer la couleur du fils :", 25*width/100, 23*height/100);
      pause = true;
    }
  }

  float fibo(int n) {
    //-----Fonction qui renvoie l'entier n de la suite de fibonaccie dans le seul et unique but de remplir les critere de tableau-----
    int[] fibo = new int[n];
    fibo[0]=0;
    fibo[1]=1;
    
    for (int i = 0; i<fibo.length-2; i++) {
      fibo[i+2]=fibo[i]+fibo[i+1];
    }

    return fibo[fibo.length - 1];
  }

  Poisson getIndicePoissonProche() {
    //--Permet de connaitre le poisson le plus Proche de l'hamecon
    Poisson indice = poissons.get(0);
    float distance = width * height;
    for (int i = 0; i<poissons.size(); i++) {
      Poisson poisson = poissons.get(i);
      float zoneMorteX = 15 + 80 - poisson.getPoissonX() - 38 * poisson.taille;
      //valeur de la pointe gauche du bateau ajouté a la position X de l'hamecon dans le cas ou le bateau est collé contre le mur de gauche soustrait a la poite droite de la zone de collision du poisson
      float hitBoxPoissonX = (poisson.getPoissonX() + 15 * poisson.taille + poisson.getPoissonX() + 40 * poisson.taille)/2;
      float hitBoxPoissonY = (poisson.getPoissonY() - 10 * poisson.taille);
      if ( dist(hitBoxPoissonX, hitBoxPoissonY, bateau.getHamX(), bateau.getHamY()) < distance && zoneMorteX < hitBoxPoissonX) {
        distance =  dist(hitBoxPoissonX, hitBoxPoissonY, bateau.getHamX(), bateau.getHamY());
        indice = poissons.get(i);
      }
    }
    return indice;
  }
  /*
  PossedePosition getIndiceObjetProche(ArrayList<PossedePosition> objets) {
   //--Permet de connaitre le poisson le plus Proche de l'hamecon
   PossedePosition indice = objets.get(0);
   float distance = width * height;
   for (int i = 0; i<objets.size(); i++) {
   PVector pos = objets.get(i).getPosition();
   float taille = objets.get(i).getTaille();
   float hitBoxPoissonX = (pos.x + 15 * taille + pos.y + 40 * taille)/2;
   float hitBoxPoissonY = (pos.y - 10 * taille);
   if ( dist(hitBoxPoissonX, hitBoxPoissonY, bateau.getHamX(), bateau.getHamY()) < distance) {
   distance =  dist(hitBoxPoissonX, hitBoxPoissonY, bateau.getHamX(), bateau.getHamY());
   indice = poissons.get(i);
   }
   }
   return indice;
   }
   */
}
