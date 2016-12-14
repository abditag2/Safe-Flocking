function [channels measurements] = central_coordinator(measurements,c, channels, cur_time, coordinator_id, drop_percent , max_delay)


[packet channels count] = receive( coordinator_id , cur_time, channels)   ;


tic
for i = 1:count

    
    msg = packet(i).msg ;
    
    %check the commands
    %all_msgs = [ [1:para.N]' msg_ID state verified_control time_applied next_control]
    
    veh_id = msg(1); 
    xpos = msg(3) ;
    ypos = msg(4) ;
    theta = msg(6);
    vel = msg(5)  ;
    
   
    
    accel1 = msg(7) ;
    rho1 =  msg(8) ;
    
    time_last_command_was_applied = msg(9) ;
    
    accel2 = msg(10) ;
    rho2 =  msg(11) ;
    
    time_to_be_applied = msg(12) ;
    
    msg;
    
    if msg(5) == 0 
    %if the car is stopping
        is_stopping =1 ;
        c.setStationaryVehicle(veh_id, xpos, ypos, theta, time_to_be_applied);
        
        ack = [msg(2) 1];
        allow = 1 ;

    else 

        
        robSate = javaObjectEDT(  'containers.RobotState', xpos, ypos, theta, vel );
        lastInput = javaObjectEDT('containers.RobotInput' , accel1, rho1 ) ;  
        nextInput = javaObjectEDT('containers.RobotInput' , accel2, rho2 ) ;        
        req =  javaObjectEDT('containers.VehicleCommand' , veh_id, robSate, lastInput, nextInput , time_to_be_applied ) ;        
        
        allow = c.tryAndApplyRequest(req);
        
        ack = [msg(2) allow] ;
        
    end
    
    
    %ack = {msg_ID yes/no]
    
    
    send_res = 11 ;
    channels = send( msg(1), ack, cur_time, drop_percent , max_delay, channels);
    
   
    measurements = [measurements; toc] ; 
    
end









return