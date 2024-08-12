
module APB_Controller(Hclk, Hresetn, valid,Hwrite,Hwdata,Haddr, Haddr1, Haddr2, Hwdata1, Hwdata2, Hwritereg, tempselx, Hreadyout, Pwrite, Penable, Pselx, Pwdata, Paddr, Prdata,/*Hrdata*/);

input Hclk, Hresetn, Hwrite,valid, Hwritereg;
input [31:0]Hwdata,Haddr,Haddr1,Haddr2,Hwdata1,Hwdata2,Prdata;
input [2:0]tempselx;
output reg Hreadyout,Pwrite,Penable;
output reg[2:0]Pselx;
output reg [31:0]Pwdata,Paddr;
//output [31:0]Hrdata;

parameter ST_IDLE=3'b000,
          ST_WWAIT=3'b001,
          ST_READ=3'b010,
          ST_WRITE_P=3'b011,
          ST_WRITE=3'b100,
          ST_WENABLE=3'b101,
          ST_WENABLE_P=3'b110,
          ST_RENABLE=3'b111;

reg [2:0] PS,NS;

//present state logic
always@(posedge Hclk)
begin
 //PS<=ST_IDLE;
 if(!Hresetn)
    PS<=ST_IDLE;
 else
    PS<=NS;
end


//next state logic

always@(*)

begin
  //NS=ST_IDLE;
  case(PS)
  ST_IDLE: begin
           if (valid && Hwrite)
           NS=ST_WWAIT;
           else if(valid && ~Hwrite)
           NS=ST_READ;
           else
           NS=ST_IDLE;
           end

  ST_WWAIT: begin
            if (valid)
            NS=ST_WRITE_P;
            else if(~valid)
            NS=ST_WRITE;
            else NS=ST_IDLE;
            end

  ST_WRITE_P: begin
            NS=ST_WENABLE_P;
             end

  ST_READ:begin
            NS=ST_RENABLE;
          end
 
  ST_WRITE:begin
           if (valid)
           NS=ST_WENABLE_P;
           else if (~valid)
           NS=ST_WENABLE;
           else NS=ST_IDLE;
           end

  ST_WENABLE:begin
             if (valid && ~Hwrite)
             NS=ST_READ;
             else if(valid && Hwrite)
             NS=ST_WWAIT;
             else if (~valid)
             NS=ST_IDLE;
             else NS=ST_IDLE;
             end

  ST_WENABLE_P:begin
             if (~valid && Hwritereg)
             NS=ST_WRITE;
             else if(valid && Hwritereg)
             NS=ST_WRITE_P;
             else if(~Hwritereg)
             NS=ST_READ;
             else NS=ST_IDLE;
             end

  ST_RENABLE:begin
             if(valid && Hwrite)
             NS=ST_WWAIT;
             else if(valid && ~Hwrite)
             NS=ST_READ;
             else if(~valid)
             NS=ST_IDLE;
             else NS=ST_IDLE;
             end
    default : NS=ST_IDLE;

  endcase
end

//output logic

reg Penable_temp,Hreadyout_temp,Pwrite_temp;
reg [2:0] Pselx_temp;
reg [31:0] Paddr_temp, Pwdata_temp;

//output combinational logic
always @(*)
begin
  case(PS)
    ST_IDLE: begin
                if(valid && ~Hwrite)
                 begin //idle to read
                     Paddr_temp=Haddr;
                     Pwrite_temp=Hwrite;
                     Pselx_temp=tempselx;
                     Penable_temp=0;
                     Hreadyout_temp=0;
                 end


                else if(valid && Hwrite)
                  begin //idle to wwait
                     Pselx_temp=0;
                     Penable_temp=0;
                     Hreadyout_temp=1;
                  end

                else
                  begin //idle to idle
                     Pselx_temp=0;
                     Penable_temp=0;
                     Hreadyout_temp=1;
                  end
             end

     ST_WWAIT:begin
               if(~valid)
                  begin //wwait to write
                     Paddr_temp=Haddr1;
                     Pwrite_temp=1;
                     Pselx_temp=tempselx;
                     Penable_temp=0;
                     Pwdata_temp=Hwdata;
                     Hreadyout_temp=0;
                  end

               else
                  begin //wwait to write_p
                     Paddr_temp=Haddr1;
                     Pwrite_temp=1;
                     Pselx_temp=tempselx;
                     Penable_temp=0;
                     Pwdata_temp=Hwdata;
                     Hreadyout_temp=0;
                  end
              end

      ST_READ:begin //read to renable
                 Penable_temp=1;
                 Hreadyout_temp=1;
              end

      ST_WRITE:begin
                 if(~valid)
                    begin //write to wenable
                       Penable_temp=1;
                       Hreadyout_temp=1;
                    end

                  else
                    begin //write to wenable_p
                       Penable_temp=1;
                       Hreadyout_temp=1;
                    end
                end
      
       ST_WRITE_P:begin  //write_p to  wenable_p
                 Penable_temp=1;
                 Hreadyout_temp=1;
                 end

       ST_RENABLE:begin
                   if(valid && ~Hwrite)
                      begin //renable to read
                         Paddr_temp=Haddr;
                         Pwrite_temp=Hwrite;
                         Pselx_temp=tempselx;
                         Penable_temp=0;
                         Hreadyout_temp=0;
                      end
                   else if(valid && Hwrite)
                      begin // renable to wwait
                         Pselx_temp=0;
                         Penable_temp=0;
                         Hreadyout_temp=1;
                       end
                   else
                      begin //renable to idle
                          Pselx_temp=0;
                          Penable_temp=0;
                          Hreadyout_temp=1;
                       end
                 end


       ST_WENABLE_P:begin
                     if(valid && Hwritereg)
                        begin //wenable_p to write_p
                         Paddr_temp=Haddr2;
                         Pwrite_temp=Hwrite;
                         Pselx_temp=tempselx;
                         Penable_temp=0;
                         Pwdata_temp=Hwdata;
                         Hreadyout_temp=0;
                        end
                   
                       else if(~valid && Hwritereg)
                          begin //wenable_p to write
                           Paddr_temp=Haddr2;
                           Pwrite_temp=1;
                           Pselx_temp=tempselx;
                           Penable_temp=0;
                           Pwdata_temp=Hwdata;
                           Hreadyout_temp=0;
                          end
                      else if(~Hwritereg)
                        begin //wenable_p to read
                          Paddr_temp=Haddr;
		          Pwrite_temp=0;
			  Pselx_temp=tempselx;
		          //Pwdata_temp=Hwdata;
		          Penable_temp=1;
		          Hreadyout_temp=1;
                        end
                   end
                    

      ST_WENABLE:begin
                   if (valid && Hwrite)
				begin // wenable to wwait
				   Pselx_temp=0;
				   Penable_temp=0;
				   Hreadyout_temp=1;	
				end
			else if (valid && ~Hwrite)
				begin // wenable to read
				   Hreadyout_temp = 1;
				   Paddr_temp = Haddr;
				   Pwrite_temp = 0;
				   Pselx_temp = tempselx;
				   Penable_temp = 1;
				end
			else if (~valid) // wenable to idle
			      begin
				   Pselx_temp = 0;
				   Penable_temp = 0;
				   Hreadyout_temp = 1;
				end

		        end
              default :  begin
				   Pselx_temp = 0;
				   Penable_temp = 0;
				   Hreadyout_temp = 1;
				end


              endcase
end



//////output logic sequential

always@(posedge Hclk)
/*begin
  if(~Hresetn)
    begin
      Paddr<=0;
      Pwrite<=0;
      Pselx<=0;
      Pwdata<=0;
      Penable<=0;
      Hreadyout<=0;
    end
  else */
    begin
      Paddr<=Paddr_temp;
      Pwrite<=Pwrite_temp;
      Pselx<=Pselx_temp;
      Pwdata<=Pwdata_temp;
      Penable<=Penable_temp;
      Hreadyout<=Hreadyout_temp;
    end

// for testbench purpose only
//assign Hrdata = Prdata;


endmodule
