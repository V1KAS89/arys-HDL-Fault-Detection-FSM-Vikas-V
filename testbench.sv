//Testbench for Fault detection FSM
//`timescale 1ns/1ps
module tb_fsm;
  logic clk,rst;
  logic[3:0] cell_volts,current;
  logic[5:0]temp;
  logic minor_fault,major_fault;
  logic [1:0] state;
  fault_detect dut(
    .clk(clk),.rst(rst),
    .cell_volts(cell_volts),
    .current(current),
    .temp(temp),
    .minor_fault(minor_fault),
    .major_fault(major_fault),
    .state(state)
  );
  localparam Persistence=4'd10;
  initial clk = 0;
    always #5 clk = ~clk; 
  initial begin
     $dumpfile("tb_fault_fsm.vcd");
     $dumpvars();
  end

  initial begin
    
    rst=1'b1;
    cell_volts=4'd12;
    current=4'd10;
    temp=6'd25;
    #20 rst=1'b0;
    $display("[%0t] Starting FSM operation ", $time);
	#20 cell_volts=4'd8; //Injecting a fault
    repeat(2) #20;
    cell_volts=4'd12;//restoring to normal volt
    #20 cell_volts=4'd15;//Injecting overvolt
    repeat(5) #20;
    cell_volts=4'd12;//restoring to normal volt
    #20 current=4'd7;//low current
    #20
    current=4'd10;//normal current
    #30
    temp=6'd45;// a high temperature 
    repeat(5) #20;
    #40 $finish;
  end
  
  
  always @(posedge clk) begin
    string state_name;
    case(state)
      2'b00: state_name = "Normal";
      2'b01: state_name = "Warning";
      2'b10: state_name = "Fault";
      2'b11: state_name = "Shutdown";
      default: state_name = "Unknown";
    endcase
    $display("%0t : state=%0s minor_fault=%b major_fault=%b",$time, state_name, minor_fault, major_fault);
      end
endmodule