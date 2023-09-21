/*import fisica.*;
Blob miBlob = new Blob();

class Canon {
  FBox cannonBody;
  PVector position;
  float width;
  float height;
  float angle; // Ángulo del cañón
  PImage manga;

  Canon(float x, float y, float w, float h) {
    position = new PVector(x, y);
    manga = loadImage("manga.png");
    width = w;
    height = h;
    cannonBody = new FBox(width, height);
    cannonBody.setPosition(x, y);
    cannonBody.setStatic(true); // El cañón no se moverá por la gravedad
    cannonBody.setRestitution(0.6); // Coeficiente de restitución
    cannonBody.setDensity(1); // Densidad del cañón
  }

  void display() {
    // Calcula el ángulo basado en la posición del mouse
    
   angle = atan2(miBlob.centroidY - position.y, miBlob.centroidX - position.x);

    pushMatrix();
    translate(position.x, position.y);
    rotate(angle); // Aplica la rotación según el ángulo calculado
    fill(0);
    rectMode(CENTER);
    imageMode(CENTER);
    //rect(0, 0, 60, 30);
    image(manga, 0, 0, 60, 60);
    popMatrix();
  }
}*/


import fisica.*;

Blob miBlob; // Debes asegurarte de inicializar miBlob en algún lugar antes de usarlo

class Canon {
  FBox cannonBody;
  PVector position;
  float width;
  float height;
  PImage manga;

  Canon(float x, float y, float w, float h) {
    position = new PVector(x, y);
    manga = loadImage("manga.png");
    width = w;
    height = h;
    cannonBody = new FBox(width, height);
    cannonBody.setPosition(x, y);
    cannonBody.setStatic(true); // El cañón no se moverá por la gravedad
    cannonBody.setRestitution(0.6); // Coeficiente de restitución
    cannonBody.setDensity(1); // Densidad del cañón
  }

  void display() {
    // Calcula el ángulo basado en la posición de miBlob
    float angle = atan2(miBlob.centroidY - position.y, miBlob.centroidX - position.x);

    pushMatrix();
    translate(position.x, position.y);
    rotate(angle); // Aplica la rotación según el ángulo calculado
    fill(0);
    rectMode(CENTER);
    imageMode(CENTER);
    image(manga, 0, 0, 60, 60);
    popMatrix();
  }
}
