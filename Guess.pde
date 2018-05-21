class Guess{
  PVector pos;
  PVector target;
  String answer;
  int targetIndex;
  float velocity = 2;
  boolean moving = true;
  
  Guess(String guess, int aim, float x, float y){
    answer = guess;
    targetIndex = aim;
    pos = new PVector(x,y);
  }
  
  void drawGuess(){
    if(moving){
      fill(0,255,0);
      textSize(50);
      text(answer, pos.x, pos.y);
    }
  }
  
  void updateGuess(){
    target = words.get(targetIndex).getVector();
    float dist = pos.dist(target);
    PVector direction = PVector.sub(target,pos);
    direction.normalize();
    
    pos.add(direction.mult(velocity)); 
    if(pos.dist(target) < velocity && !words.get(targetIndex).getSolved()){
      words.get(targetIndex).setSolved();
      moving = false;
    }
  }
  
}
