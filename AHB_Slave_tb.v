
module AHB_Slave_tb();

reg Hclk, Hresetn, Hwrite, Hreadyin;
reg [1:0]Htrans;
reg [31:0]Haddr,Hwdata; wire [31:0] Haddr1,Hrdata, Haddr2, Hwdata1, Hwdata2;
wire [1:0]Hresp; 
wire valid, Hwritereg;
wire [2:0]tempselx;

AHB_slave AHB_itfc(Hclk, Hresetn, Hwrite, Hreadyin, Htrans,Haddr,Hwdata,Hresp,Hrdata, valid, Hwritereg,Haddr1,Haddr2,Hwdata1,Hwdata2, tempselx);

//clock generation
initial
begin
Hclk=1'b0;
forever #5 Hclk=~Hclk;
end

//task generation
/*task initialise;
begin
Haddr=0; Hwdata=0;
end
endtask*/

task reset();
begin
@(negedge Hclk)
 Hresetn=1'b0;
@(negedge Hclk)
 Hresetn=1'b1;
end
endtask

task in(input p,q);
begin
@(negedge Hclk)
 Hwrite=p;
 Hreadyin=q;
end
endtask

task inputs(input[31:0] a,b, input[1:0]c);
begin
@(negedge Hclk)
  Haddr=a;
  Hwdata=b;
  Htrans=c;
end
endtask

initial
begin
 //initialise;
 reset;
 in(1'b1,1'b1);#50;
 inputs(32'h80001100, 32'h84000000, 2'b10);
 #300 $finish;
end
endmodule




 
