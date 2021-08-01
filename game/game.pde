/* @pjs preload="background1.jpg ,background2.jpg,goal1.jpeg,goal2.jpg,hunter1.jpg,hunter2.jpg,player1.jpg,player2.jpg,treasure.jpg"; */
boolean button = false;

class Board {
  int x;
  int y;
  int size;
  int n;
  Board(int size0) {
    x = width/size0;
    y = height/size0;
    size = width/size0;
    n = size0;
  }

  void display() {
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
        stroke(0);
        line(j*x, i*y, j*x, height);
        line(i*x, j*y, width, j*y);
      }
    }
  }
}

class Screen {
  int start=-1;
  int difflevel;
  Screen() {
  }

    void Start() {
    background(255);
    fill(0);
    textSize(32);
    textAlign(CENTER);
    text("スタート画面", width/2, 200);
    text("難易度", width/2, 300);
    text("1：やさしい",width/2, height/2-50);
    text("2：ふつう",width/2, height/2);
    text("3：むずかしい",width/2, height/2+50);
    text("から選択してください",width/2, height/2+100);


  void Run() {
    background(255);
    fill(0);
    textSize(32);
    textAlign(CENTER);
    text("STAGE CLEAR!", width/2, 300);
    text("spaceを押して次のステージに進んでね！", width/2, height/2);
  }

  void End() {
    background(255);
    fill(0);
    textSize(32);
    textAlign(CENTER);
    text("GAME OVER!", width/2, 300);
    text("獲得した宝箱の数: " + Tcnt + "個", width/2, height/2);
  }
  void Clear() {
    background(255);
    fill(0);
    textSize(32);
    textAlign(CENTER);
    text("GAME CLEAR!", width/2, 300);
    text("獲得した宝箱の数: " + Tcnt + "個", width/2, height/2);
  }
}

class Player {
  int x;
  int y;
  int size;

  Player(int size0) {
    x = width/size0-width/(size0*2);
    y = height-height/(size0*2);
    size = width/size0;
  }

  void display() {
    player_img(x, y, size);
  }

  void move() {
    if (x - 3*size/2 < mouseX && mouseX < x - size/2 && y - size/2 < mouseY && mouseY < y + size/2) {
      x -= size;
    } else if (x + size/2 < mouseX && mouseX < x + 3*size/2 && y - size/2 < mouseY && mouseY < y + size/2) {
      x += size;
    } else if (y - 3*size/2 < mouseY && mouseY < y - size/2 && x - size/2 < mouseX && mouseX < x + size/2) {
      y -= size;
    } else if (y + size/2 < mouseY && mouseY < y + 3*size/2 && x - size/2 < mouseX && mouseX < x + size/2) {
      y += size;
    }
  }
}

class Hunter {
  int x;
  int y;
  int r;
  boolean[] inView = {false, false, false, false};
  Hunter (int size0, int i, int len) {
    int randX = int(random(size0/len*i, size0/len*(i+1)));
    int randY = int(random(0, size0/2));
    //println(randX, randY);
    r = width/size0;
    x = randX*r+(width/size0-width/(size0*2));
    y = randY*r+(height/size0-height/(size0*2));
  }

  void display() {
    hunter_img(x, y, r);
  }

  void view(int len) {
    fill(255);
    rect(x-r/2, y+r/2, len, len*3);
    rect(x+r/2, y-r/2, len*3, len);
    rect(x-r/2, y-len*3-r/2, len, len*3);
    rect(x-len*3-r/2, y-r/2, len*3, len);
  }

  void judge(int px, int py, int len) {
    if (px >= x-r/2 && px <= x+r/2 && py >= y-len*3-r/2 && py <= y-r/2) {
      move(0, -len);
    } else if (px >= x-r/2 && px <= x+r/2 && py >= y+r/2 && py <= y+len*3+r/2) {
      move(0, len);
    } else if (px >= x-len*3-r/2 && px <= x-r/2 && py >= y-r/2 && py <= y+r/2) {
      move(-len, 0);
    } else if (px >= x+r/2 && px <= x+len*3+r/2 && py >= y-r/2 && py <= y+r/2) {
      move(len, 0);
    } 
  }
  void move(int stepX, int stepY) {
    x += stepX;
    y += stepY;
  }
}

class Goal {
  int x ;
  int y ;
  int size;

  Goal(int sizeg) {
    x = 4*(height/sizeg);
    y = 0;
    size = width/sizeg;
  }

  void display() {
    goal_img(x, y, size);
  }
}

class Treasure {
  int x,y,len;
  Treasure (int randomX, int randomY, int size){
   int randX = randomX;
   int randY = randomY;
   len = width/size;
   x = randX*len;
   y = randY*len;
  }
  
  void display(){
    treasure_img(x, y, len);
  }
}

Board b;
Screen s;
Player p;
Hunter[] h;
Goal g;
Treasure t;

int scene = 1;
int imgscene = 1;
int judge = 0;
int Scnt = 0;
int Tcnt = 0;
boolean treasureGetJudge = false;
boolean sequal = false;
int NoH = 0;
int n = 0;

void setup() {
  size(840, 840);
  PFont font = createFont("Meiryo", 50);
  textFont(font);
}

void draw() {
  switch(scene) {
  case 1:
    Title();
    break;
  case 2:
    Game();
    break;
  case 3:
    GameOver();
    break;
  case 4:
    Run();
    break;
  case 5:
    Clear();
    break;
  }
}

void Title() {
  s = new Screen();
  s.Start();
  if (judge == 1) {
    b = new Board(6);
    p = new Player(6);
    t = new Treasure(int(random(1, 6)), int(random(1, 6/2)), 6);
    g = new Goal(6);
    h = new Hunter[2];
    for (int i = 0; i < h.length; i++) {
      h[i] = new Hunter(6, i, h.length);
    }
    scene = 2;
    n = 6;
    NoH = 2;
  } else if (judge == 2) {
    b = new Board(8);
    p = new Player(8);
    t = new Treasure(int(random(1, 8)), int(random(1, 8/2)), 8);
    g = new Goal(8);
    h = new Hunter[3];
    for (int i = 0; i < h.length; i++) {
      h[i] = new Hunter(8, i, h.length);
    }
    scene = 2;
    n = 8;
    NoH = 3;
  } else if (judge == 3) {
    b = new Board(10);
    p = new Player(10);
    t = new Treasure(int(random(1, 10)), int(random(1, 10/2)), 10);
    g = new Goal(10);
    h = new Hunter[4];
    for (int i = 0; i < h.length; i++) {
      h[i] = new Hunter(10, i, h.length);
    }
    scene = 2;
    n = 10;
    NoH = 4;
  }
}

void keyPressed() {
  if (key == '1') {
    judge = 1;
    imgscene = 1;
  } else if (key == '2') {
    judge = 2;
    imgscene = 2;
  } else if (key == '3') {
    judge = 3;
    imgscene = 3;
  }
  if(key == 'r') {
    scene = 1;
    judge = 0;
  }
  if(key == 32) {
    sequal = true;
  }
}

void Game() {
  background_img(0, 0);
  b.display();
  p.display();
  if(!treasureGetJudge) {
    t.display();
  }
  g.display();
  for (int i = 0; i < h.length; i++) {
    h[i].display();
  }
  for (int i = 0; i < h.length; i++) {
    if (h[i].x == p.x && h[i].y == p.y) {
      scene = 3;
    }
  }
  if (g.x < p.x && g.x+g.size > p.x && g.y < p.y && g.y + g.size > p.y) {
    Scnt++;
    if (Scnt < 3) {
      treasureGetJudge = false;
      scene = 4;
    } else {
      scene = 5;
    }
  }
  if (t.x < p.x && t.x+t.len > p.x && t.y < p.y && t.y+t.len > p.y && !treasureGetJudge) {
    treasureGetJudge = true;
    Tcnt++;
  }
}

void mousePressed() {
  if (judge != 0) {
    p.move();
    for (int i = 0; i < h.length; i++) {
      h[i].judge(p.x, p.y, h[i].r);
    }
  }
}

void GameOver() {
  s.End();
}

void Run() {
  s = new Screen();
  s.Run();
  if(sequal){
    b = new Board(n);
    p = new Player(n);
    t = new Treasure(int(random(1, n)), int(random(1, n/2)), n);
    g = new Goal(n);
    h = new Hunter[NoH];
    for (int i = 0; i < h.length; i++) {
      h[i] = new Hunter(n, i, h.length);
    }
    sequal = false;
    scene = 2;
    println(n);
  }
}

void Clear() {
  s.Clear();
}

void background_img() {
  PImage img;
  if (imgscene==1) {
    img = loadImage("background1.jpg");
    img.resize( width, height );
    background(img);
  } else if (imgscene==2) {
    img = loadImage("background2.jpg");
    img.resize( width, height );
    background(img);
  } else if (imgscene==3) {
    img = loadImage("background3.jpg");
    img.resize( width, height );
    background(img);
  }
}


void player_img(int x, int y, int size) {
  PImage img;
  if (imgscene==1) {
    img = loadImage("player1.jpg");
    img.resize(size, size);
    image(img, x-size/2, y-size/2, size, size);
  } else if (imgscene==2) {
    img = loadImage("player2.jpg");
    img.resize(size, size);
    image(img, x-size/2, y-size/2, size, size);
  } else if (imgscene==3) {
    img = loadImage("player3.jpg");
    img.resize(size, size);
    image(img, x-size/2, y-size/2, size, size);
  }
}

void hunter_img(int x, int y, int size) {
  PImage img;
  if (imgscene==1) {
    img = loadImage("hunter1.jpg");
    img.resize(size, size);
    image(img, x-size/2, y-size/2, size, size);
  } else if (imgscene==2) {
    img = loadImage("hunter2.jpg");
    img.resize(size, size);
    image(img, x-size/2, y-size/2, size, size);
  } else if (imgscene==3) {
    img = loadImage("hunter3.jpg");
    img.resize(size, size);
    image(img, x-size/2, y-size/2, size, size);
  }
}

void treasure_img(int x, int y, int size) {
  PImage img;
  img = loadImage("treasure.jpg");
  img.resize(size, size);
  image(img, x, y, size, size);
}

void background_img(int x, int y) {
  PImage img;
  if(imgscene == 1) {
    img = loadImage("background1.jpg");
    img.resize(width, height);
    image(img, x, y, width, height);
  } else if(imgscene == 2) {
    img = loadImage("background2.jpg");
    img.resize(width, height);
    image(img, x, y, width, height);
  } else if(imgscene == 3) {
    img = loadImage("background3.jpg");
    img.resize(width, height);
    image(img, x, y, width, height);
  }
}

void goal_img(int x, int y, int size) {
  PImage img;
  if (imgscene==1) {
    img = loadImage("goal1.jpg");
    img.resize(size, size);
    image(img, x, y, size, size);
  } else if (imgscene==2) {
    img = loadImage("goal2.jpg");
    img.resize(size, size);
    image(img, x, y, size, size);
  } else if (imgscene==3) {
    img = loadImage("goal3.jpg");
    img.resize(size, size);
    image(img, x, y, size, size);
  }
}