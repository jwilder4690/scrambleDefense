class Word{
  final float FALL_SPEED = .2;
  
  String[] threeLetterWords = new String[1044];
  String[] fourLetterWords = new String[4268];
  String[] fiveLetterWords = new String[9320];
  String[] sixLetterWords = new String[15762];
  String[] sevenLetterWords = new String[22247];
  
  String currentWord = "";
  int currentLength;
  char[] scrambledWord;
  //ArrayList wordsGuessed = new ArrayList<String>();
  float xPos;
  float yPos;
  float yStart;
  boolean onScreen = false;
  boolean solved = false;
  boolean exploded = false;
  int fade = 255;
  float explosionSize;
  
  Word(int size, float x, float y){
    xPos = x;
    yPos = y;
    yStart = y;
    currentLength = size;
    explosionSize = random(70,200);
    loadWords("threeLetterWords.txt", threeLetterWords);
    loadWords("fourLetterWords.txt", fourLetterWords);
    loadWords("fiveLetterWords.txt", fiveLetterWords);
    loadWords("sixLetterWords.txt", sixLetterWords);
    loadWords("sevenLetterWords.txt", sevenLetterWords);
    generateWord();
  }
  
  void generateWord(){
    switch(currentLength){ //<>//
      case 3: currentWord = threeLetterWords[int(random(threeLetterWords.length))]; break;
      case 4: currentWord = fourLetterWords[int(random(fourLetterWords.length))]; break;
      case 5: currentWord = fiveLetterWords[int(random(fiveLetterWords.length))]; break;
      case 6: currentWord = sixLetterWords[int(random(sixLetterWords.length))]; break;
      case 7: currentWord = sevenLetterWords[int(random(sevenLetterWords.length))]; break;
      default: currentWord = WORD_LENGTH_ERROR; 
    }
      scrambledWord = scrambleWord(currentWord); 
  }
  
  void loadWords(String file, String[] list){
    try{
      BufferedReader reader = createReader(file);
      for(int i = 0; i < list.length; i++){
        list[i] = reader.readLine();
      }
    }
    catch (Exception e){
      e.printStackTrace();
    }
  }
  
  PVector getVector(){
    return new PVector(xPos,yPos);
  }
  
  char[] getScrambledWord(){
    return scrambledWord;
  }
  
  boolean getExploded(){
    return exploded;
  }

  char[] scrambleWord(String inWord){   //Fisher-Yates Shuffle
    char[] pieces = inWord.toCharArray();
    for(int i = pieces.length-1; i > 0; i--){
      int index = int(random(i+1));
      char temp = pieces[index];
      pieces[index] = pieces[i];
      pieces[i] = temp;
    }
    return pieces;
  }
  
  void setSolved(){
    solved = true;
    diffuse.trigger();
  }
  
  boolean getSolved(){
    return solved;
  }

  void resetWord(){
    yPos = yStart;
    exploded = false;
    solved = false;
  }
  
  boolean compare(String answer){
    if(currentWord.equals(answer)){
      return true;
    }
    return false;
  }
  
  boolean checkOnScreen(){
    return onScreen;
  }
  
  void drawWord(){
    if(solved){
      fill(0,255,0, fade);
      text(currentWord, xPos, yPos);
    }
    else if(exploded){
      fill(255,55,0, fade);
      ellipse(xPos+explosionSize/2, yPos, explosionSize, explosionSize);
      fade -= 3;
    }
    else{
      fill(0,0,0);
      text(new String(scrambledWord), xPos, yPos);
    }
  }
  
  void updateWord(){
    yPos += FALL_SPEED;
    if(yPos > 0){
      onScreen = true;
    }
    if(yPos > height-20 && !solved && !exploded){
      town.takeDamage();
      exploded = true;
    }
    if(solved){
      fade--;
    }
  }
}
