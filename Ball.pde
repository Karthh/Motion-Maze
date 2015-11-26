public class Ball {
  int x = 400;
  int y = 300;

  public void drawBall() {
    fill(0, 255, 0);
    ellipse(x, y, 20, 20);
    moveBall();
  }

  private void moveBall() {
    x += pitch * 4;
    y += roll * 4;
  }
} //end class ball