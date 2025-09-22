//Fault Detection FSM
//Assuming Persistence if fault exists more than 10 clk cycles
//Transient spike if fault less than 10 clk cycles
module fault_detect(
  input logic clk, rst,
  input logic [3:0]cell_volts,//Assuming normal volt required is 12V
  input logic [3:0]current,//Assuming ideal required current is 10A
  input logic [5:0]temp, //Assuming safe temperature of battery is 30 degree C

  
  output logic minor_fault, major_fault, //minor fault for transient spike and major fault for fault which require immediate assistance
  output logic[1:0] state
  
);
    localparam Persistence=4'd10;
    parameter [1:0]Normal=2'b00,Warning=2'b01, Fault=2'b10,Shutdown=2'b11;
    logic [3:0] cnt;      // persistence counter
    logic       cur_fault;
    logic volt_fault, curr_fault, temp_fault;

	// Fault detection
    assign volt_fault = (cell_volts != 4'd12); // Medium priority = voltage     
    assign curr_fault = (current   != 4'd10); // Lowest priority = current   
    assign temp_fault = (temp > 6'd30); // Highest priority = temperature   

    assign cur_fault = temp_fault | volt_fault | curr_fault;

    logic [1:0] fault_prio;
    always_comb begin
      if (temp_fault)       fault_prio = 2'd3; // highest
      else if (volt_fault)  fault_prio = 2'd2;
      else if (curr_fault)  fault_prio = 2'd1;
      else                  fault_prio = 2'd0;
    end

        
  always_ff @(posedge clk or posedge rst) begin
    if (rst)
      cnt <= 0;
    else if (cur_fault) begin
      if (cnt < Persistence)
        cnt <= cnt + 1;
    end else begin
      cnt <= 0;
    end
  end
//To find the type of fault  
  assign minor_fault = (cur_fault && cnt < Persistence);
  assign major_fault = (cnt >= Persistence);

  
  always_ff @(posedge clk or posedge rst) begin
    if(rst)
      state<=Normal;
    else begin
      case (state)
        Normal: begin
          if (fault_prio == 2'd3) state <= Fault; //if fault is of highest priority 
          else if (major_fault)   state <= Fault; // if the fault persist  
          else if (minor_fault)   state <= Warning;
        end
        Warning: begin
          if (fault_prio == 2'd3) state <= Fault; 
          else if (major_fault) state <= Fault;
          else if (!cur_fault) state <= Normal;
        end
        Fault: begin
          if (fault_prio == 2'd3) state <= Shutdown;
          else if (major_fault) state <= Shutdown;  // if the fault persist
          else if (!cur_fault) state <= Normal;
        end
        Shutdown: state <= Shutdown; // latch until reset
        	
      endcase
    end 
        
  end
endmodule
    