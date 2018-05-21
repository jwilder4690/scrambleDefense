class Player{
  int points;
  char[] currentGuess; 
  int guessIndex;
  
  Player(){
    points = 0;
    currentGuess = new char[7];
    guessIndex = 0;
  }
  
  String getCurrentGuess(){
    String guess = new String(currentGuess).substring(0,guessIndex);
    return guess;
  }
  
  int getGuessIndex(){
    return guessIndex;
  }
  
  int getPoints(){
    return points;
  }
  
  void setPoints(int value){
    points = value;
  }
  
  void scoreWord(int size){
    int score = 0;
    switch(size){
      case 3: score = 50; break;
      case 4: score = 100; break;
      case 5: score = 200; break;
      case 6: score = 400; break;
      case 7: score = 1000; break;
      default: break;
    }
    points += score;
  }
  
  void addToGuess(char guess){
    keySound.trigger(); 
    if(guessIndex < maxLength-1){
      currentGuess[guessIndex] = guess;
      guessIndex++;
    }
    else{
      currentGuess[guessIndex] = guess;
    }
  }
  
  void clearGuess(){
    for(int i = 0; i < currentGuess.length; i++){
      currentGuess[i] = Character.MIN_VALUE;
    }
    guessIndex = 0;
  }
  
  void removeFromGuess(){
    currentGuess[guessIndex] = Character.MIN_VALUE;
    if(guessIndex > 0){
      guessIndex--;
    }
    currentGuess[guessIndex] = Character.MIN_VALUE;
  }
  
  void drawGuess(){
    fill(0,0,0);
    textSize(50);
    text(new String(currentGuess), width/2-100, height-100);
  }
  
}
