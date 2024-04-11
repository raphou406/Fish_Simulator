//-----Déclaration des images-----
PImage poissonClement, dorades;
PImage coraille;

//-----Déclaration des objets et Tableaux-----
Bateau bateau;
Environnement decor;
Chronometre temps;
ArrayList<Poisson> poissons = new ArrayList();
boolean [] keys = new boolean[63];
Bouton[] boutons = new Bouton[7];
Bouton boutonSettings;



void setup() {
  // Ce code n'est pas concu pour se voir changer sa taille de fenêtre pendant l'execution
  size(1000, 600);

  //-----Initialisation des poissons-----
  int nombrePoisson = 25;
  poissonClement =loadImage("poissonClement.png");
  dorades = loadImage("dorade4k.png");
  for (int i = 0; i < nombrePoisson; i++) {
    float poisson = random(0, 1);
    if (poisson > .5) {
      poissons.add(new Truite());
    } else {
      poissons.add(new Dorade());
    }
  }
  //-----Initialisation du décor et du bateau de peche et du chrono-----
  coraille = loadImage("coraille.png");
  bateau = new Bateau();
  decor = new Environnement();
  temps = new Chronometre();

  //-----Initialisation des boutons-----
  boutonSettings = new Bouton(90*width/100, 0, width, 5*height/100, "Paramètres", 175);
  boutons[0] = new Bouton(25*width/100, 15*height/100, 40*width/100, 20*height/100, "Mode Nuit");
  boutons[1] = new Bouton(50*width/100, 15*height/100, 65*width/100, 20*height/100, "Mode Jour");
  boutons[2] = new Bouton(25*width/100, 25*height/100, 30*width/100, 30*height/100, "Rouge", color(255, 0, 0));
  boutons[3] = new Bouton(33*width/100, 25*height/100, 38*width/100, 30*height/100, "Vert", color(0, 255, 0));
  boutons[4] = new Bouton(41*width/100, 25*height/100, 46*width/100, 30*height/100, "jaune", color(255, 255, 0));
  boutons[5] = new Bouton(25*width/100, 35*height/100, 40*width/100, 40*height/100, "Jouer avec la souris");
  boutons[6] = new Bouton(50*width/100, 35*height/100, 65*width/100, 40*height/100, "Jouer avec le clavier");
}

void draw() {

  //-----Dessin de l'arrière plan-----
  background(250);
  decor.initialisation();
  decor.eau();
  colorMode(RGB, 255);
  noStroke();
  decor.arrierePlan();

  //-----Affichage et mouvement  des poissons-----
  for (int i=0; i<poissons.size(); i++) {
    Poisson dorade = poissons.get(i);
    if (decor.getJour()) {
      dorade.affichagePoisson();
    } else {
      dorade.affichePoissonQuiFaitPeur();
    }
    if (!decor.getPause()) {
      dorade.mouvementPoisson();
      dorade.pecher(bateau.getHamX(), bateau.getHamY());
    }
  }

  //-----Ecran de fin-----
  decor.endGame();

  //-----Affichage et mouvement du bateau-----
  bateau.deplacements();
  bateau.afficheBateau();

  //-----Ecran de pause-----
  if (decor.getPause()) {
    decor.jeuPause();
  }

  //-----Affiche les boutons tant que le menu est ouvert-----
  decor.menu();
  boutonSettings.afficheBouton();
  for ( Bouton bouton : boutons) {
    if (decor.getMenuSettings()) {
      bouton.afficheBouton();
    }
  }
  
  //-----Affiche le score du joueur-----
  textAlign(LEFT);
  textSize(12);
  fill(255);
  int posTextX = 5;
  int posTextY = 19;
  text("score : "+bateau.getScore(), posTextX, posTextY);
}

void keyPressed() {
  //----- Renvoie le boolean de la touche codé du clavier-----
  keys[keyCode] = true;  
  
  //-----Met le jeu en pause quand espace est pressé-----
  if (key == 32 && !decor.getMenuSettings()) {
    decor.pause=!decor.pause;
    decor.setTutoriel(false);
    //-----Relance une partie-----
    if (poissons.size() == 0) {
      setup();
    }
  }
}
void keyReleased(){
  keys[keyCode] = false;
}

void mousePressed() {
  //-----Permet d'interagir avec touts les boutons-----
  if (boutonSettings.mouseOver()) {
    decor.menuSettings=!decor.menuSettings;
  }
  if (decor.getMenuSettings() ) {
    if (boutons[0].mouseOver() ) {
      decor.setJour(false);
    } else if (boutons[1].mouseOver() ) {
      decor.setJour(true);
    } else if (boutons[2].mouseOver() ) {
      bateau.couleur=boutons[2].couleur;
    } else if (boutons[3].mouseOver() ) {
      bateau.couleur=boutons[3].couleur;
    } else if (boutons[4].mouseOver() ) {
      bateau.couleur=boutons[4].couleur;
    } else if (boutons[5].mouseOver() ) {
      bateau.setMouvementSouris(true);
    } else if (boutons[6].mouseOver() ) {
      bateau.setMouvementSouris(false);
    }
  }

  //-----Active le mode hard si on click sur la tete du pecheur-----
  if (bateau.difficile()) {
    decor.setSecret(true);
    for (Poisson dorade : poissons) {
      dorade.setVitesse(2);
    }
  }
}
