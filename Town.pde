class Town{
  int health;
  int startingHealth;
  int damage = 25;
  Building[] buildings = new Building[20];
  boolean destroyed = false;
  
  
  Town(){
    startingHealth = 205;
    health = startingHealth;
    generateTown();
  }
  
  void takeDamage(){
    health -= damage;
    explosion.trigger();
    if(health < 0){
      health = 0;
      destroyed = true;
      gameMode = GAME_OVER;
      time.stop();
    }
  }
  
  int getHealth(){
    return health;
  }
  
  void resetTown(){
    health = startingHealth;
  }
  
  void generateTown(){
    float averageWidth = width/buildings.length;
    for(int i = 0; i < buildings.length; i++){
      buildings[i] = new Building(averageWidth*i+random(-50,50), float(height), averageWidth+random(-averageWidth/2,averageWidth/2), random(50,100));
    }
  }
  
  void drawTown(){
    fill(75,75,75);
    rect(0, height-10, width, 10);
    for(int i = 0; i < buildings.length; i++){
      buildings[i].drawBuilding();
    }
  }
}

class Building{
  final int windowSpace = 25;
  float x;
  float y;
  float wide;
  float tall;
  
  Building(float x, float y, float w, float h){   //{x, y} is bottom left
    this.x = x;
    this.y = y;
    this.wide = w;
    this.tall = h;
  }
  
  void drawBuilding(){
    noStroke();
    fill(75,75,75);
    rect(x, y-tall, wide, tall);
    
    int cols = int(wide)/windowSpace;
    int rows = int(tall)/windowSpace;
    
    for(int i = 0; i < cols; i++){
      for(int j = 0; j < rows; j++){
        if(i % 2 != 0 && j % 2 != 0 && int(x) % 2 == 0){
          fill(75,75,75);
        }
        else if(i % 2 == 0 && j % 2 == 0 && int(x) % 2 != 0){
          fill(75,75,75);
        }
        else{
          fill(255,255,51);
        }
        rect(x+(i*windowSpace)+10, y-(j*windowSpace)-25, 10, 10);
      }
    }
  }
}
