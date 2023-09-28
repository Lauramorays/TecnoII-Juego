import processing.sound.*;
import fisica.*;

//__captura
int PUERTO_OSC = 12345;
Receptor receptor;

float poscX;
float poscY;
boolean monitor=true;

SoundFile sonido1;
SoundFile sonido2;
SoundFile sonido3;
SoundFile sonido4;

FWorld world;
Canon cannon;
Torta torta;
SoundFile sonido;

int milisegundos = 0;
int segundos = 120;
int Valor = 1;
PVector cannonPos;
int puntos = 0;
boolean suma = false;
int sumapuntaje;
int counter;
float cannonWidth = 40;
float cannonHeight = 20;
ArrayList<Bola> targets = new ArrayList<Bola>();
float bolaRadio = 10; // Radio de la bola
PImage inicioimg;
PImage fondo;
PImage[] ingredientes;
PImage ganasteimg;
PImage perdisteimg;
float distancia;
String tipoDeBolaActual = "Ninguna"; // Variable para mostrar el tipo de bola actual
int gravedad;
int countpuntaje = 0;
Bola nuevaBola = null; // Declarar nuevaBola como una variable global
Bola bolaActual;

boolean juego;
boolean inicio;
boolean perdiste;
boolean ganaste;

void setup() {
  size(1000, 650);
  //Inicio cap
  setupOSC(PUERTO_OSC);
  receptor = new Receptor();

  juego = false;
  inicio = true;
  perdiste = false;
  ganaste = false;
  sonido1 = new SoundFile(this, "boton.wav"); // SONIDO
  sonido2= new SoundFile (this, "ambiente.mp3"); //SONIDO
  sonido3= new SoundFile (this, "fallaste.mp3"); //SONIDO
  sonido4= new SoundFile (this, "ganaste.mp3"); //SONIDO

  sonido = new SoundFile(this, "ambiente.mp3");
  sonido.play();
  Fisica.init(this);
  world = new FWorld();
  gravedad = int(map(segundos, 120, 0, 100, -300));
  world.setGravity(0, gravedad);
  world.setEdges();
  torta = new Torta(width - 250, height - 100);
  torta.addToWorld(world);
  cannonPos = new PVector(50, height - 50);
  inicioimg = loadImage("inicio.png");
  inicioimg.resize(width, height);
  fondo = loadImage("fondo.png");
  perdisteimg = loadImage("perdiste.png");
  ganasteimg = loadImage("ganaste.png");
  fondo.resize(width, height);
  counter = 120;
  ingredientes = new PImage[4];
  ingredientes[0] = loadImage("ing1.png");
  ingredientes[1] = loadImage("ing2.png");
  ingredientes[2] = loadImage("ing3.png");
  ingredientes[3] = loadImage("ing4.png");

  // Inicializar el cañón
  cannon = new Canon(cannonPos.x, cannonPos.y, cannonWidth, cannonHeight);

  // Crear la primera bola con valor 1
  bolaActual = generarNuevaBola(Valor);
}

void draw() {

  receptor.actualizar(mensajes); //
  receptor.dibujarBlobs(width, height);

  /* float totalcy=0;
   float totalcX=0;
   int cantC=0;*/


  if (inicio == true) {
    nuevaBola = null;
    println("INICIO");
    background(inicioimg);
  } else if (juego == true) {

    println("JUEGO");
    inicio = false;
    perdiste = false;
    background(fondo);
    imageMode(CENTER);
    world.step();
    torta.display();

    // Muestra el tipo de bola actual en la pantalla
    textSize(16);
    fill(0);
    pushStyle();
    imageMode(CENTER);
    milisegundos++;

    if (milisegundos > 60) {
      milisegundos = 0;
      segundos--;
    }
    text("Tiempo:" + segundos, 20, 20);
    for (int i = 0; i < targets.size(); i++) {
      Bola target = targets.get(i);
      pushMatrix();
      translate(target.getX(), target.getY());
      rotate(target.getRotation());
      // Cambiar el color por la imagen correspondiente
      image(ingredientes[target.tipo - 1], 0, 0, target.getSize(),
        (ingredientes[target.tipo - 1].height * target.getSize()) / ingredientes[target.tipo - 1].width);
      popMatrix();
    }
    popStyle();
    cannon.display();
    if (nuevaBola != null) {

      if (nuevaBola.getX() > torta.tortaBody.getX() - 150 &&
        nuevaBola.getX() < torta.tortaBody.getX() + 150 &&
        nuevaBola.getY() > torta.tortaBody.getY() - 55) {
        if (!nuevaBola.contacto) {
          nuevaBola.contacto = true;
          // sonido1.play();
          nuevaBola.setStatic(true);
          sumapuntaje++;
          Valor = (Valor % 4) + 1; // Actualiza el valor en un ciclo de 1 a 4
          bolaActual = generarNuevaBola(Valor);
        }
      }
    }

    text("Puntos: " + sumapuntaje, 40, 40);
    if (segundos < 0 && sumapuntaje < 4) {
      perdiste = true;
      juego = false; 
      
    }
    if (sumapuntaje >= 4) {
      //sonido4.play();
      ganaste = true;
      juego = false;
    }
  } else if (perdiste == true) {
    nuevaBola = null;
    println("PERDISTE");
    juego = false;
    inicio = false;
    perdisteimg.resize(width, height);
    background(perdisteimg);
    text("PERDISTE", 40, 40);
  } else if (ganaste == true) {
    nuevaBola = null;
    //println("GANASTE");
    juego = false;
    inicio = false;
    ganasteimg.resize(width, height);
    background(ganasteimg);
    textSize(50);
    text("GANASTE", 40, 40);
  }
  for (Blob b : receptor.blobs) {
    if (b.entro) {
      b.dibujar(b.centerX, b.centerY);
      println("--> entro blob: " + b.id);
    }
    if (b.salio) {
      println("<-- salio blob: " + b.id);
    }
  }
  world.drawDebug();
}

/*if (monitor) {
 //
 ellipse(poscX, poscY, 50, 50);
 }*/

void mousePressed() {
  if (juego == true) {
    nuevaBola = generarNuevaBola(Valor);
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

  if (inicio == true && mousePressed) {
    juego = true;
    inicio = false;
    //sonido1.play();
  }
}

Bola generarNuevaBola(int Valor) {
  Bola nuevaBola = null;
  if (Valor == 1) {
    nuevaBola = new Duran();
    tipoDeBolaActual = "Tipo 1";
  } else if (Valor == 2) {
    nuevaBola = new Cabeza();
    ingredientes[0].resize(50, 80);
    tipoDeBolaActual = "Tipo 2";
  } else if (Valor == 3) {
    nuevaBola = new Tentaculo();
    ingredientes[3].resize(40, 60);
    tipoDeBolaActual = "Tipo 3";
  } else if (Valor == 4) {
    nuevaBola = new Ojo();
    tipoDeBolaActual = "Tipo 4";
  }
  return nuevaBola;
}
