
module APB_Controller_tb();

reg Hclk, Hresetn, Hwrite,valid, Hwritereg;
reg [31:0]Hwdata,Haddr,Haddr1,Haddr2,Hwdata1,Hwdata2,Prdata;
reg [2:0]tempselx;
wire Hreadyout,Pwrite,Penable;
wire [2:0]Pselx;
wire [31:0]Pwdata,Paddr;

//instantiation

APB_Controller APB_CONTROLLER(Hclk, Hresetn, valid,Hwrite,Hwdata,Haddr, Haddr1, Haddr2, Hwdata1, Hwdata2, Hwritereg, tempselx, Hreadyout, Pwrite, Penable, Pselx, Pwdata, Paddr, Prdata);


//clock generation

initial
begin
Hclk=0;
forever #10 Hclk=~Hclk;
end

task reset();
begin
@(negedge Hclk)
  Hresetn=1'b0;
@(negedge Hclk)
  Hresetn=1'b1;
end
endtask


task in(input a,b,a1,input[2:0]c);
begin
  valid=a;
  Hwrite=b;
  tempselx=c;
  Hwritereg=a1;
end
endtask

task inps(input [31:0]d,e,f,g,h,i);
begin
  Haddr=d;
  Haddr1=e;
  Haddr2=f;
  Hwdata=g;
  Hwdata1=h;
  Hwdata2=i;
  
end
endtask

task inp(input [31:0]j);
begin
  Prdata=j; //for read operation 
end
endtask

initial
begin
reset();
//for single write
in(1'b1,1'b1,1'b0,3'b010);
inps(31'b1,31'b1,31'b1,31'b1,31'b1,31'b1);
#300 $finish;
end
endmodule

