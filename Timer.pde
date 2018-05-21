class Timer {
  int startTime = 0, stopTime = 0;
  boolean running = false;
  
    
  void start() 
  {
    startTime = millis();
    running = true;
  }
  void stop() 
  {
    stopTime = millis();
    running = false;
  }
  
  int getRemainingTime() 
  {
    int elapsed;
    if (running) 
    {
      elapsed = (millis() - startTime);
    }
    else 
    {
      elapsed = (stopTime - startTime);
    }
    return elapsed;
  }
  
  
  int hundredth()
  {
    return (getRemainingTime() / 10) % 100;
  }
  
  int second()
  {
    return (getRemainingTime() / 1000) % 60;
  }
  
  int minute() 
  {
    return (getRemainingTime() / (1000*60)) % 60;
  }
  
  int hour()
  {
    return (getRemainingTime() / (1000*60*60)) % 24;
  }
  
  boolean isRunning()
  {
    return running;
  }
}
