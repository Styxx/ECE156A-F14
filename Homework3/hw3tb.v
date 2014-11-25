/*
*   TestBench for Homework 3
*/


module hw3tb();

//-----Coin Sensor TestBench-----//
// module coinSensor(penny,nickel,dime,quarter, clk,reset,serialIn);
reg clk, reset, serialIn;
wire penny, nickel, dime, quarter;

coinSensor coinS (penny,nickel,dime,quarter, clk,reset,serialIn);

initial begin
  clk <= 0;
  reset <= 1;
  serialIn <= 0;

  #150 reset = 0;
  #100 reset = 1;
  #100 serialIn = 0; #100 serialIn = 1; #100 serialIn = 0; #100 serialIn = 0;				// 0100
  #100 serialIn = 0; #100 serialIn = 0; #100 serialIn = 0; #100 serialIn = 1; #100 serialIn = 0;	//00010
  #100 serialIn = 0; #100 serialIn = 1; #100 serialIn = 1; #100 serialIn = 1; #100 serialIn = 0;	//01110
  #100 serialIn = 0; #100 serialIn = 1; #100 serialIn = 0; #100 serialIn = 1; #100 serialIn = 0;	//01010
  end

  always begin
  #100 clk <= ~clk;
  end

//-----End coinSensor TB-----//


endmodule