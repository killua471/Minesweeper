import de.bezier.guido.*;
public int NUM_ROWS = 20;
public int NUM_COLS = 20;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

public void keyPressed(){
  if(key == 'r'){
    for(int i = 0; i<70; i++){
      mines.remove(0);
    }
    for (int r=0; r<NUM_ROWS; r++) {
      for (int c=0; c<NUM_COLS; c++) {
        buttons[r][c].setClicked(false);
        buttons[r][c].setLabel("");
        buttons[r][c].setFlagged(false);
      }
    }
  }
}

void setup ()
{
  size(600, 650);
  textAlign(CENTER, CENTER);

  // make the manager
  Interactive.make( this );

  //your code to initialize buttons goes here
  buttons= new MSButton[NUM_ROWS][NUM_COLS];
  for (int r=0; r<NUM_ROWS; r++) {
    for (int c=0; c<NUM_COLS; c++) {
      buttons[r][c]= new MSButton(r, c);
    }
  }
}
public void setMines()
{
  //your code
  int countMines=0;
  while(countMines!=70){
    int r= (int)(Math.random()*NUM_ROWS);
    int c= (int)(Math.random()*NUM_COLS);
    if (!mines.contains(buttons[r][c]) && buttons[r][c].isClicked() == false) {
      mines.add(buttons[r][c]);
      countMines++;
    }
  }
}
public int countFlagged(){
  int count =0;
  for (int r=0; r<NUM_ROWS; r++) {
    for (int c=0; c<NUM_COLS; c++) {
      if(buttons[r][c].isFlagged()==true){
        count++;
      }
    }
  }
  
  return mines.size()-count;
}
public void draw ()
{
  background( 0 );
  fill(255);
    text("mines left: " + countFlagged(),300,625);
    for(int r=0; r<NUM_ROWS; r++){
      for(int c=0; c<NUM_ROWS; c++){
        if(buttons[r][c].isClicked()==true && countMines(r,c)==0){
          buttons[r][c].setLabel("");
        }
      }
    }

  if (isWon() == true){
    displayWinningMessage();
      for (int r=0; r<NUM_ROWS; r++) {
        for (int c=0; c<NUM_COLS; c++) {
          buttons[r][c].setCanClick(false);
        }
      }
  }
}
public boolean isWon()
{
  //your code here
  int count =0;
  for (int r=0; r<NUM_ROWS; r++) {
    for (int c=0; c<NUM_COLS; c++) {
      if (buttons[r][c].isClicked()&& !mines.contains(buttons[r][c])) {
        count++;
      }
    }
  }
  if (count== NUM_ROWS*NUM_COLS-mines.size()) {
    return true;
  }
  return false;
}
public void displayLosingMessage()
{
  //your code here
  for (int r=0; r<NUM_ROWS; r++) {
    for (int c=0; c<NUM_COLS; c++) {
      if (mines.contains(buttons[r][c])) {
        buttons[r][c].setClicked(true);
        buttons[r][c].setFlagged(false);
      }
      buttons[r][c].setCanClick(false);
    }
  }
}
public void displayWinningMessage()
{
  //your code here
  for (int r=0; r<NUM_ROWS; r++) {
    for (int c=0; c<NUM_COLS; c++) {
      if (buttons[r][c].isClicked()&& !mines.contains(buttons[r][c])) {
        buttons[r][c].setLabel("you win");
      }
    }
  }
}
public boolean isValid(int r, int c)
{
  //your code here
  if (r>=0 && r<NUM_ROWS && c>=0 && c<NUM_COLS) {
    return true;
  }
  return false;
}
public int countMines(int row, int col)
{
  int numMines = 0;
  //your code here
  for (int r=row-1; r<row+2; r++) {
    for (int c=col-1; c<col+2; c++) {
      if (isValid(r, c)&& mines.contains(buttons[r][c])) {
        numMines++;
      }
    }
  }

  return numMines;
}
public class MSButton
{
  
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged, canClick;
  private String myLabel;

  public MSButton ( int row, int col )
  {
    width = 600/NUM_COLS;
    height = 600/NUM_ROWS;
    myRow = row;
    myCol = col; 
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    flagged = clicked = false;
    canClick=true;
    Interactive.add( this ); // register it with the manager
  }

  // called by manager
  public void mousePressed () 
  {
    if (mouseButton!=RIGHT &&canClick==true)
      clicked = true;
    //your code here

    if (mines.size()==0) {
      
      for (int r=myRow-1; r<myRow+2; r++) {
        for (int c=myCol-1; c<myCol+2; c++) {
          if (isValid(r, c)) {
            buttons[r][c].setClicked(true);
          
          }
        }
      }
      
      //buttons[myRow][myCol].setClicked(true);

      setMines();

      for (int r=myRow-1; r<myRow+2; r++) {
        for (int c=myCol-1; c<myCol+2; c++) {
            if (countMines(r, c) >0) {
              setLabel(countMines(r, c));
            }
            if(countMines(r,c)==0){
              setLabel("");
            }
          }
        }
      

      openSpace(true);

      //buttons[myRow][myCol].mousePressed();
     /*
      for (int r=myRow-1; r<myRow+2; r++) {
        for (int c=myCol-1; c<myCol+2; c++) {
          if (countMines(r, c) ==0 && isValid(r,c) && buttons[r][c].clicked==true &&r!=myRow&&c!=myCol) {
            buttons[r][c].mousePressed();
          }
        }
      }
      */
    } else if (mouseButton == RIGHT) {
      if (clicked == false) {
        if (flagged ==true) {
          flagged =false;
          canClick=true;
        } else {
          flagged =true;
          canClick=false;
        }
      }
    } else if (mines.contains(this)&&canClick==true) {
      setLabel("you lose");
      displayLosingMessage();

      //rect(0,0,height,width);
      //text("you lose",height/2,width/2);
    } else if (countMines(myRow, myCol) >0&&canClick==true) {
      setLabel(countMines(myRow, myCol));
    } else if(canClick==true){
      openSpace(false);



    }
/*
    for(int r=0; r<NUM_ROWS; r++){
      for(int c=0; c<NUM_ROWS; c++){
        if(buttons[r][c].isClicked()==true && countMines(r,c)==0){
          buttons[r][c].setLabel("");
        }
      }
    }
*/
  }
  public void draw () 
  {    
    if (flagged)
      fill(0);
    else if ( clicked && mines.contains(this) ) 
      fill(255, 0, 0);
    else if (clicked)
      fill( 200 );
    else 
    fill(0,255,0 );

    rect(x, y, width, height);
    fill(0);
    text(myLabel, x+width/2, y+height/2);
  }
  public void setLabel(String newLabel)
  {
    myLabel = newLabel;
  }
  public String getLabel() {
    return myLabel;
  }
  public void setLabel(int newLabel)
  {
    myLabel = ""+ newLabel;
  }
  public boolean isFlagged()
  {
    return flagged;
  }
  public void fills(int r, int g, int b){
    fill(r,g,b);
  }
  public boolean isClicked() {
    return clicked;
  }
  public void setClicked(boolean b) {
    clicked =b;
  }
  public void setFlagged(boolean b){
    flagged =b;
  }
  public void setCanClick(boolean b){
    canClick=b;
  }
  public void openSpace(boolean b){
          if (isValid(myRow, myCol-1) && buttons[myRow][myCol-1].clicked==b) {
        buttons[myRow][myCol-1].mousePressed();
      }
      if (isValid(myRow, myCol+1) && buttons[myRow][myCol+1].clicked==b) {
        buttons[myRow][myCol+1].mousePressed();
      }

      if (isValid(myRow-1, myCol) && buttons[myRow-1][myCol].clicked==b) {
        buttons[myRow-1][myCol].mousePressed();
      }
      if (isValid(myRow+1, myCol) && buttons[myRow+1][myCol].clicked==b) {
        buttons[myRow+1][myCol].mousePressed();
      }


      if (isValid(myRow+1, myCol+1) && buttons[myRow+1][myCol+1].clicked==b) {
        buttons[myRow+1][myCol+1].mousePressed();
      }
      if (isValid(myRow-1, myCol-1) && buttons[myRow-1][myCol-1].clicked==b) {
        buttons[myRow-1][myCol-1].mousePressed();
      }
      if (isValid(myRow+1, myCol-1) && buttons[myRow+1][myCol-1].clicked==b) {
        buttons[myRow+1][myCol-1].mousePressed();
      }
      if (isValid(myRow-1, myCol+1) && buttons[myRow-1][myCol+1].clicked==b) {
        buttons[myRow-1][myCol+1].mousePressed();
      }
  }
  
}
