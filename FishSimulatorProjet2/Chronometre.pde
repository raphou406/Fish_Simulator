class Chronometre {
  int start, stop, pause;

  Chronometre() {
    this.pause = 0;
    this.start = -1;
    this.stop = -1;
  }

  Chronometre(int arret) {
    this.start = -1;
    this.stop = -1;
    this.stop = arret;
  }

  int getStart() {
    return this.start;
  }
  int getStop() {
    return this.stop;
  }
  int getPause() {
    return this.pause;
  }

  void setStart() {
    start = millis();
  }

  void setStop() {
    if (stop < 0) {
      stop = millis();
    }
  }

  void iterPause() {
    if (start != millis() ) {
      this.pause = millis() - start;
    }
    else{
      pause = 0;
    }
  }
  float afficheTempsSecondes() {
    return (getStop() - getStart() ) / 1000.0;
  }
}
