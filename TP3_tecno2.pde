import processing.sound.*;
import fisica.*;

FWorld world;
Canon cannon;
Torta torta;

int milisegundos = 0;
int segundos = 120;
PVector cannonPos;
int puntos=0;
boolean suma = false;
int counter;
float cannonWidth = 40;
float cannonHeight = 20;
ArrayList<Bola> targets = new ArrayList<Bola>();
float bolaRadio = 10; // Radio de la bola
PImage fondo;
PImage[] ingredientes;
float distancia;
String tipoDeBolaActual = "Ninguna"; // Variable para mostrar el tipo de bola actual
int gravedad;
Bola nuevaBola = null; // Declarar nuevaBola como una variable global

void setup() {
  size(1000, 650);
  Fisica.init(this);
  world = new FWorld();
  gravedad = int(map(segundos, 120, 0, 100, -120));
  world.setGravity(0, gravedad);
  world.setEdges();
  torta = new Torta(width - 250, height - 250);
  torta.addToWorld(world);
  cannonPos = new PVector(50, height-50);
  fondo = loadImage("fondo.png");
  fondo.resize(width, height);
  counter = second();
  counter = 120;
  if(suma==true){
    puntos +=1;
  }

  ingredientes = new PImage[4];
  ingredientes[0] = loadImage("ing1.png");
  ingredientes[1] = loadImage("ing2.png");
  ingredientes[2] = loadImage("ing3.png");
  ingredientes[3] = loadImage("ing4.png");

  // Inicializar el cañón
  cannon = new Canon(cannonPos.x, cannonPos.y, cannonWidth, cannonHeight);
}

void draw() {
  background(fondo);
  imageMode(CENTER);
  world.step();
  torta.display();
  // Muestra el tipo de bola actual en la pantalla
  textSize(16);
  fill(0);
  //text("Tipo de Bola Actual: " + tipoDeBolaActual, 20, 20);
  pushStyle();
  imageMode(CENTER);
  milisegundos++;
  if(milisegundos > 60){
   milisegundos = 0;
   milisegundos ++;
   segundos -=1;
  }
 // text("Puntos:" + puntos, 20, 50);
  text("Tiempo:" + segundos, 20, 20);
  for (int i = 0; i < targets.size(); i++) {
    Bola target = targets.get(i);
    pushMatrix();
    translate(target.getX(), target.getY());
    rotate(target.getRotation());
    // Cambiar el color por la imagen correspondiente
    image(ingredientes[target.tipo - 1], 0, 0, target.getSize(), 
      (ingredientes[target.tipo - 1].height*target.getSize())/ingredientes[target.tipo - 1].width);
    popMatrix();
  }
  popStyle();

  cannon.display();

  if (nuevaBola != null) {
    // Calcula la distancia entre la bola y la torta
    float distanciaX = nuevaBola.getX() - torta.tortaBody.getX();
    float distanciaY = nuevaBola.getY() - torta.tortaBody.getY();
    float distanciaCentros = sqrt(distanciaX * distanciaX + distanciaY * distanciaY);

    // Comprueba si hay colisión
    if (distanciaCentros < nuevaBola.radio + torta.tortaBody.getHeight() / 2) {
      nuevaBola.contacto = true;
      nuevaBola.setStatic(true);
      suma = true;
      println("CONTACTO");
    } else {
      println("dist:" + distanciaCentros);
    }
  }
}

void mousePressed() {
  nuevaBola = generarNuevaBola();
  if (nuevaBola != null) {
    nuevaBola.setPosition(cannonPos.x, cannonPos.y - cannonHeight / 2 - bolaRadio);
    nuevaBola.setRestitution(0.6);
    nuevaBola.setDensity(nuevaBola.densidad);

    float velocityX = mouseX - cannonPos.x;
    float velocityY = mouseY - cannonPos.y;
    float forceMultiplier = map(mouseY, height, 0, 1, 3);
    velocityX *= forceMultiplier;
    velocityY *= forceMultiplier;
    nuevaBola.setVelocity(velocityX, velocityY);

    world.add(nuevaBola);
    targets.add(nuevaBola);
  }
}

Bola generarNuevaBola() {
  float randomValue = random(1);

  if (randomValue < 0.2) {
    nuevaBola = new Duran();
    tipoDeBolaActual = "Tipo 1";
  } else if (randomValue < 0.6) {
    nuevaBola = new Cabeza();
    tipoDeBolaActual = "Tipo 2";
  } else if (randomValue < 0.8) {
    nuevaBola = new Tentaculo();
    tipoDeBolaActual = "Tipo 3";
  } else {
    nuevaBola = new Ojo();
    tipoDeBolaActual = "Tipo 4";
  }

  // Agrega la nueva bola a la lista de objetivos
  world.add(nuevaBola);
  targets.add(nuevaBola);

  return nuevaBola;
}
