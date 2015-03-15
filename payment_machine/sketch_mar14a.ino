#include <Keypad.h>
#include <LiquidCrystal.h>

LiquidCrystal lcd(12, 11, A0, A1, A2, A3);

const byte red = 4;
const byte kolona = 3;

char tipke[red][kolona] = {
  {'1','2','3'},
  {'4','5','6'},
  {'7','8','9'},
  {'*','0','#'}
};

byte redpin[red] = {9, 8, 7, 6};
byte kolonapin[kolona] = {4, 3, 2};
Keypad tastatura = Keypad( makeKeymap(tipke), redpin, kolonapin, red, kolona );

void setup() {
  
  Serial.begin(9600);
  lcd.begin(16,2);
  
}  


void loop() {
  int brojac1 = 0;
  int brojac2 = 0;
  int brojac3 = 0;
  int brojac4 = 0;
  int suma = 0;
  int h = 0;
  int m = 0;
  char tipka = NO_KEY;
pocetak: 
//prvi ispis
for(;;){
  tipka = tastatura.getKey();
  if(tipka == '1') { goto mjesto; } 
  delay(1);
  lcd.setCursor(0,0);
  lcd.print("PARKING HRASNO");
  delay(1);
  tipka = tastatura.getKey();
  if(tipka == '1') { goto mjesto; }
  delay(1);
  lcd.setCursor(0,1);
  tipka = tastatura.getKey();
  if(tipka == '1') { goto mjesto; }
  delay(1);
  lcd.print("DOBRODOSLI !");
  lcd.noDisplay();
  delay(300);
  tipka = tastatura.getKey();
  if(tipka == '1') { goto mjesto; }
  delay(1);
  lcd.display();
  delay(2000);
  
// drugi ispis
  tipka = tastatura.getKey();
  if(tipka == 1) goto mjesto; 
  lcd.clear();
  lcd.setCursor(0,0);
  tipka = tastatura.getKey();
  lcd.print("zadrzite tipku");
  lcd.setCursor(0,1);
  lcd.print("|1|za dalji unos");
  lcd.noDisplay();
  tipka = tastatura.getKey();
  if(tipka == '1') goto mjesto; 
  
  delay(300);
  lcd.display();
  delay(2000);
  lcd.clear();
  
 tipka = tastatura.getKey();
 if(tipka == '1') goto mjesto; 
  
  
  }
mjesto:
delay(1000);
tipka = NO_KEY;
lcd.clear();
for(;;){
lcd.clear();
lcd.setCursor(0,0);
lcd.print("Unesite broj ");
lcd.setCursor(0,1);
lcd.print("mjesta: ");
lcd.setCursor(9,1);
  
  
 char waitForKey();
 tipka = tastatura.getKey();
 if(tipka == '1'){ lcd.print("1"); brojac1 = 1; goto cifra2;} 
 if(tipka == '2'){ lcd.print("2"); brojac1 = 2; goto cifra2;}
 if(tipka == '3'){ lcd.print("3"); brojac1 = 3; goto cifra2;}
 if(tipka == '4'){ lcd.print("4"); brojac1 = 4; goto cifra2;}
 if(tipka == '5'){ lcd.print("5"); brojac1 = 5; goto cifra2;}
 if(tipka == '6'){ lcd.print("6"); brojac1 = 6; goto cifra2;}
 if(tipka == '7'){ lcd.print("7"); brojac1 = 7; goto cifra2;}
 if(tipka == '8'){ lcd.print("8"); brojac1 = 8; goto cifra2;}
 if(tipka == '9'){ lcd.print("9"); brojac1 = 9; goto cifra2;}
 if(tipka == '0'){ lcd.print("0"); brojac1 = 0; goto cifra2;}
 
 delay(300);

  }
cifra2:
delay(1000);
tipka = NO_KEY;
for(;;){
lcd.setCursor(10,1);

 char waitForKey();
 tipka = tastatura.getKey();
 
 if(tipka == '1'){ lcd.print("1"); brojac2 = 1; goto sati1;}
 if(tipka == '2'){ lcd.print("2"); brojac2 = 2; goto sati1;}
 if(tipka == '3'){ lcd.print("3"); brojac2 = 3; goto sati1;}
 if(tipka == '4'){ lcd.print("4"); brojac2 = 4; goto sati1;}
 if(tipka == '5'){ lcd.print("5"); brojac2 = 5; goto sati1;}
 if(tipka == '6'){ lcd.print("6"); brojac2 = 6; goto sati1;}
 if(tipka == '7'){ lcd.print("7"); brojac2 = 7; goto sati1;}
 if(tipka == '8'){ lcd.print("8"); brojac2 = 8; goto sati1;}
 if(tipka == '9'){ lcd.print("9"); brojac2 = 9; goto sati1;}
 if(tipka == '0'){ lcd.print("0"); brojac2 = 0; goto sati1;}
 
 delay (300);
}

sati1:
delay(1000);
tipka = NO_KEY;
for(;;){
lcd.clear();
lcd.setCursor(0,0);
lcd.print("Unesite broj ");
lcd.setCursor(0,1);
lcd.print("sati: ");
lcd.setCursor(9,1);

char waitForKey();
tipka = tastatura.getKey();

 if(tipka == '1'){ lcd.print("1"); brojac3 = 1; goto sati2; }
 if(tipka == '2'){ lcd.print("2"); brojac3 = 2; goto sati2; }
 if(tipka == '3'){ lcd.print("3"); brojac3 = 3; goto sati2; }
 if(tipka == '4'){ lcd.print("4"); brojac3 = 4; goto sati2; }
 if(tipka == '5'){ lcd.print("5"); brojac3 = 5; goto sati2; }
 if(tipka == '6'){ lcd.print("6"); brojac3 = 6; goto sati2; }
 if(tipka == '7'){ lcd.print("7"); brojac3 = 7; goto sati2; }
 if(tipka == '8'){ lcd.print("8"); brojac3 = 8; goto sati2; }
 if(tipka == '9'){ lcd.print("9"); brojac3 = 9; goto sati2; }
 if(tipka == '0'){ lcd.print("0"); brojac3 = 0; goto sati2; }

 delay(300);
}

sati2:
delay(1000);
tipka = NO_KEY;
for(;;){
  lcd.setCursor(10,1);
  
  char waitForKey();
  tipka = tastatura.getKey();
  
 if(tipka == '1'){ lcd.print("1"); brojac4 = 1; goto ispis; }
 if(tipka == '2'){ lcd.print("2"); brojac4 = 2; goto ispis; }
 if(tipka == '3'){ lcd.print("3"); brojac4 = 3; goto ispis; }
 if(tipka == '4'){ lcd.print("4"); brojac4 = 4; goto ispis; }
 if(tipka == '5'){ lcd.print("5"); brojac4 = 5; goto ispis; }
 if(tipka == '6'){ lcd.print("6"); brojac4 = 6; goto ispis; }
 if(tipka == '7'){ lcd.print("7"); brojac4 = 7; goto ispis; }
 if(tipka == '8'){ lcd.print("8"); brojac4 = 8; goto ispis; }
 if(tipka == '9'){ lcd.print("9"); brojac4 = 9; goto ispis; }
 if(tipka == '0'){ lcd.print("0"); brojac4 = 0; goto ispis; }
 
 delay(300);
 
}

ispis:
delay(1000);
lcd.clear();

lcd.setCursor(0,0);
lcd.print("MJESTO: ");
delay(1);
lcd.setCursor(8,0);
lcd.print(brojac1);
delay(1);
lcd.setCursor(9,0);
lcd.print(brojac2);
lcd.setCursor(0,1);
delay(1);
lcd.print("SATI: ");
lcd.setCursor(6,1);
lcd.print(brojac3);
delay(1);
lcd.setCursor(7,1);
lcd.print(brojac4);

delay(2000);
  
  suma = brojac3 * 10 + brojac4;
  h = suma;
  m = brojac1*10 + brojac2;
  lcd.clear();
  lcd.setCursor(0,0);
  lcd.print("ZA PLATITI: ");
  lcd.setCursor(0,1);
  delay(1);
  if (suma <= 9){ lcd.setCursor(0,1); lcd.print("0"); lcd.print(suma); }
  else { lcd.setCursor(0,1); lcd.print(suma); }
  delay(1);
  lcd.setCursor(3,1);
  lcd.print("KM");
  

slucaj1:

  for(;;){
    
    tipka = NO_KEY;
    char waitForKey();
    tipka = tastatura.getKey();
    delay(1);
    if((tipka == '#') && (suma > 10)) { suma = suma - 1; lcd.setCursor(0,1); lcd.print(suma); }
    delay(1);
    if(suma == 10) delay(700);
    if((tipka == '#') && (suma <= 10)) { lcd.setCursor(0,1); lcd.print("0"); suma = suma - 1; lcd.setCursor(1,1); lcd.print(suma); }
   
    if (suma == 0) goto kraj;
  }

kraj:
Serial.write(m);
delay(1);
Serial.write(h);
delay(1);
lcd.clear();
delay(1);
lcd.print("HVALA NA ");
delay(1);
lcd.setCursor(0,1);
lcd.print("POVJERENJU !");
delay(3000);

}

