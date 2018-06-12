//  this timer is used to delay the shots of the Laser Gun
class Timer {
  int nTimerLength;
  int nTimeAtTimerStart;     
  int nTimeSinceTimerStarted ;
  // ============== CONSTRUCTOR =============================================
  Timer(int nTempTimerLength) {
    nTimerLength=nTempTimerLength;
  } // ============== START =============================================
  void start() {
    nTimeAtTimerStart=millis();
  }
  // ============== IS-REACHED-TIME=============================================
  boolean isReachedTime() { 
    // Check how much time has passed
    nTimeSinceTimerStarted = millis() - nTimeAtTimerStart;
    if (nTimeSinceTimerStarted >= nTimerLength) {
      return true;
    } else {
      return false;
    }
  }
}