import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

Minim minim;
AudioPlayer song;
AudioSample keySound, notKeySound, explosion, diffuse;


final String WORD_LENGTH_ERROR = "WORD_LENGTH_ERROR";
final int GAME_START = 0;
final int JUMBLE_MODE = 1;
final int BUILD_MODE = 2;
final int DEFEND_MODE = 3;
final int GAME_OVER = 4;
final int GAME_VICTORY = 5;

Player player;
Town town;
int count = 0;
ArrayList<Word> words = new ArrayList<Word>();
ArrayList<Guess> guesses = new ArrayList<Guess>();
int wordsPerLevel = 60;
int currentLength = 3;
int maxLength = 7;
int gameMode = GAME_START;  
Timer time = new Timer();
boolean[] keys = new boolean[255];
String introMessage = "Your town of Lexico City is under attack! You must unscramble the jamming signal on each incoming bomb to protect your city. Type your best guess and press ENTER to attempt to diffuse.";  

void setup(){
  fullScreen();
  //size(1080, 720);
  player = new Player();
  town = new Town();
  int randomUpgrade = 0;
  for(int i = 0; i < wordsPerLevel; i++){
    randomUpgrade = round(random(1));
    words.add(new Word(currentLength+randomUpgrade, random(width-120), (-50)*i+100));   
    if(i != 0 && i % 15 == 0){
      currentLength++;
    }
  }
  createAudio();
  //song.loop();
}

void draw(){
  checkInput(gameMode);
  background(155,155,155);
  switch(gameMode){
    case GAME_START: drawIntroSplash(); break;
    case JUMBLE_MODE: drawGame(); break;
    case GAME_OVER: drawEndSplash(); break;
    case GAME_VICTORY: drawVictorySplash(); break;
  }

  drawHUD();
}

void keyPressed()
{
  if(key < 255)
  {
    keys[key] = true;
  }
  if(key >= 65 && key <= 90 || key >= 97 && key <= 122){ 
      player.addToGuess(char(key));
  }
}

void keyReleased()
{  
  if(key < 255)
  {
    keys[key] = false;
  }
}

void checkInput(int mode){
  if(mode == GAME_START){
    if(keys[' '] || keys[ENTER]){
        time.start();
        gameMode = JUMBLE_MODE;
    }
  }
  else if(mode == JUMBLE_MODE){
    if(keys[' ']){
      player.clearGuess();
      keys[' '] = false;
    }
    if(keys[BACKSPACE]){
      player.removeFromGuess();
      keys[BACKSPACE] = false;
    }
    if(keys[ENTER]){
      String finalAnswer = player.getCurrentGuess();
      if(finalAnswer.length() < 3){
        //Too short
      }
      else{
        for(int i = 0; i < words.size(); i++){
          if(words.get(i).checkOnScreen()){
            if(words.get(i).compare(finalAnswer)){
              player.scoreWord(finalAnswer.length());
              guesses.add(new Guess(finalAnswer, i, width/2-100, height-100));
            }
          }
        }
      }
      for(int i = 0; i < maxLength; i++){
        player.removeFromGuess();
      }
      keys[ENTER] = false;
    }
  }
  else if(mode == GAME_OVER){
    if(keys[' '] || keys[ENTER]){
      resetGame();
    }
    keys[' '] = false;
    keys[ENTER] = false;
  }
  else if(mode == GAME_VICTORY){
    if(keys[' '] || keys[ENTER]){
      resetGame();
    }
    keys[' '] = false;
    keys[ENTER] = false;
  }
}

void drawGame(){
  player.drawGuess();
  town.drawTown();
  for(int i = 0; i < guesses.size(); i++){
    guesses.get(i).drawGuess();
    guesses.get(i).updateGuess();
  }
  count = 0;
  for(int i = 0; i < words.size(); i++){
    words.get(i).drawWord();
    words.get(i).updateWord();
    if(words.get(i).getExploded() || words.get(i).getSolved()){
      println("yep");
      println(words.get(i).getExploded());
      println(words.get(i).getSolved());
      count++;
      if(count == wordsPerLevel && town.getHealth() > 0){
        gameMode = GAME_VICTORY;
      }
    }
  }
}

void drawIntroSplash(){
  background(0,255,255);
  town.drawTown();
  fill(0,0,0);
  text("Press ENTER to begin",width/2-200, height/2-250);
  text(introMessage, width/2-250, height/2-200, 600, 600);
}

void drawEndSplash(){
  background(0,0,0);
  fill(255,0,0);
  text("GAME OVER", width/2 - 100, height/2);
  textSize(20);
  text("Press SPACE to restart", width/2-100, height/2+75);
}

void drawVictorySplash(){
  background(0,255,255);
  fill(0,0,0);
  text("You saved Lexico City!", width/2 - 200, height/2-50);
  textSize(20);
  text("You are a true logophile.", width/2-100, height/2+25);
  text("Press SPACE to restart", width/2-100, height/2+75);
}

void drawHUD(){
  fill(205,205,205);
  rect(0,0, width, height/8);
  fill(0,0,0);
  textSize(42);
  text("Points: "+player.getPoints(), 50,75);
  text("Lexico City: ", width/2-200, 75);
  text(nf(time.hour(),2)+":"+nf(time.minute(),2)+":"+nf(time.second(),2), width-210, 75);
  noFill();
  stroke(0,255,0);
  rect(width/2+50, 40, 200, 40);
  noStroke();
  fill(0,255,0);
  rect(width/2 +50, 40, town.getHealth(), 40);
}

void resetGame(){
  gameMode = GAME_START;
  currentLength = 3;
  town.resetTown();
  player.setPoints(0);
  for(int i = 0; i < words.size(); i++){
      words.get(i).generateWord();
      words.get(i).resetWord();
      println(words.get(i).getExploded());
      println(words.get(i).getSolved());
  }
  for(int i = guesses.size()-1; i >= 0; i--){
    guesses.remove(i);
  }
}

void createAudio(){
  minim = new Minim(this);
  song = minim.loadFile("intro.mp3");
  keySound = minim.loadSample("key.wav");
  notKeySound = minim.loadSample("notKey.wav");
  explosion = minim.loadSample("explosion.wav");
  diffuse = minim.loadSample("diffuse.aiff");
}
