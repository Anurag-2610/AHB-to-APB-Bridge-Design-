
module top_tb();
 
reg Hclk,Hresetn;

wire [31:0] Haddr,Hwdata,Hrdata,Paddr,Pwdata,Pwdata_out,Paddr_out,Prdata;
wire [1:0] Hresp,Htrans;

wire [2:0] temp_selx,Pselx,Psel_out;
wire Hreadyout,Hwrite,Hreadyin,Hwrite_reg1,Hwrite_reg2,Penable ,Pwrite_out,Penable_out;



AHB_Master AHB(Hclk,Hresetn,Hreadyout,Hrdata,Haddr,Hwdata,Hwrite,Hreadyin,Htrans);
Bridge_Top Bridge(Hclk,Hresetn,Hwrite,Hreadyin,Hwdata,Haddr,Prdata,Htrans,Hresp,Pwrite,Penable,Hreadyout,Pselx,Paddr,Pwdata,Hrdata);
APB_Interface APB(Pwrite,Penable,Pselx,Paddr,Pwdata,Pwrite_out,Penable_out,Psel_out,Paddr_out,Pwdata_out,Prdata);


initial
begin
Hclk=1'b0;
forever #10 Hclk=~Hclk;
end

task reset();
begin
 @(negedge Hclk);
   Hresetn=1'b0;
 @(negedge Hclk);
   Hresetn=1'b1;
end
endtask 

initial
begin
 reset;
 //AHB.single_write();
 AHB.burst_write();
 //AHB.single_read();
 //AHB.wrap_write();
 #300 $finish;
end
endmodule
