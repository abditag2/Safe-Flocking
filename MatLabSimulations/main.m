close; clear; clc;
%% parameters
global para;
para.com_period = .5;           % communication period
para.upd_period = 0.01;         % update period of the figure
para.N = 4;                     % # of cars
para.timerate = 4;              % sim time / real time, 1 means real time
para.sep = .5;                  % safe separation
para.xybnd = 10;                % bound of x,y coordinates
para.vbnd = [-2 5];             % bound of velocity
para.abnd = [-5, 2];            % bound of acceleration
para.cbnd = [-0.2, 0.2];        % bound of turning curvature accelaration
para.arr = 0.03;                % velocity/length_of_arrow
para.Tbnd = inf;                % maximum simulation time (before collision or reach)
para.coldetect = 1;             % collision detect on/off

para.tspan = [0,para.upd_period];
para.cyc = round(para.com_period/para.upd_period);
para.count = 0;

para.drop_percent = 0 ;
para.max_delay = 0.0 ; 
para.control_update_period = 0.10 ; 
para.movement_update = 0.5 ; 

%% initialize state

% state is a matrix whose each row is a vector of [x y v heading] of a car
% dest is the destimation coordinate 
[state, dest] = initial(para);
% next_control is a matrix of next_control input

next_control = zeros(para.N,2);
for i = 1:para.N
    [next_control(i,1), next_control(i,2)] = controlinput(state(i,:),dest(i,:));
end

%% initialize figure

% F is the figure handle
F = iniFigure(state,dest);

%% Simulation

t=0;
flag_reach = 0;
flag_collision = 0;

collisionpair=[]; % the indices of pair of cars collide

msg_ID = zeros(para.N, 1) ; 
time_applied = zeros(para.N,1) ; 
stopping_flag = zeros(para.N,1);
ack_received_flag = zeros(para.N,1);

verified_control = zeros(para.N, 2) ; 
last_update = 0 ;
last_control_update = 0 ;


stop_command_matrix = [para.abnd(1)*ones(para.N,1) zeros(para.N,1)] 
                                                                      

%set up the Central coordinator java object
    c = javaObjectEDT('main.Coordinator');
    c.setVehicleRadius(0.5);

measurements = [];

for i=1:para.N + 1
   channels(i).count = 0 ;
end

        verified_next_control = zeros(para.N,2);

while t<para.Tbnd && ~flag_reach && ~flag_collision

    
    % check collision and reach
    flag_reach = checkReach(state,dest);
    
    if para.coldetect
        [flag_collision,collisionpair] = checkCollision(state);
    end
    
    

    %if the robot is moving and the stopping flag is 1 it should remain 1
    %if the robot is stopped and the sopping_flag is one is should be zero
    
    stopping_flag(:,1) = logical(state(:,3)) & stopping_flag ; 
    
    
    for j = 1:para.N
        if stopping_flag(j) == 1 && state(j,3) <= 0.0001
            stopping_flag(j) = 0 ;
        end
    end
    
    
    
    if t - last_control_update > para.control_update_period

        % update next_control each para.com_period time
        %para.count=mod(para.count+1,para.cyc);
        
%        if para.count == 0
%         next_control = updateControl(state,dest);
%        end


        % create the command to be sent to central cordinator
  
        next_control = zeros(para.N,2);

        for i = 1:para.N  
            [next_control(i,1), next_control(i,2)] = predictNext(state(i,:) ,dest(i,:), verified_control(i,:), stopping_flag(i),last_update + para.movement_update-t);
        end

%        [1:para.N]' 
%        msg_ID 
%        state 
%        verified_control 
%        time_applied 
%        next_control
        
        time_to_be_applied = time_applied+ para.movement_update*ones(para.N,1) ; 
        all_msgs = [ [1:para.N]' msg_ID state verified_control time_applied next_control time_to_be_applied, t*ones(para.N,1)] ;

        %%send the next_control to central coordinator

        for i= 1:para.N 
            
            if stopping_flag(i) == 0 && ack_received_flag(i) == 0 
                channels = send(para.N + 1, all_msgs(i,:), t, para.drop_percent , para.max_delay, channels);
            end
        end

        
        last_control_update = t ; 
    end
    
    

    %run the central coordinator
    
    [channels measurements]= central_coordinator(measurements,c, channels, t,para.N + 1 ,  para.drop_percent , para.max_delay) ; 
    

    
    %measurements = [measurements t] ; 
        
    %check for the arrived communication
    %update next_control command based on msges from central coordinator
    
    for i = 1:para.N 
        [packet channels count] = receive(i,t, channels) ; 
        
        for j = 1:count
            if packet(j).msg(1) == msg_ID(i) 
                %new ack arrived
                if packet(j).msg(2) == 1
                   %ack is yes
                   ack_received_flag(i) = 1 ; 

                   verified_next_control(i,:) = next_control(i,:) ;
                   msg_ID(i) = msg_ID(i)+ 1 ;
                else
                    %ack is no
                    msg_ID(i)  = msg_ID(i)  + 1 ; 
                end
                
            end
        end
        
        
        
    end
    
    
    
    %update the verified_control every 500 mSecs
    
    if t - last_update >= para.movement_update
    
        update_time = t  ;
        state_in_update_time = state ; 
    
        time_applied = t*ones(para.N*1,1) ;
        %%update the verified_control
        verified_control = bsxfun(@times , ack_received_flag , verified_next_control);
        stopping_flag = ~ack_received_flag ; 
        ack_received_flag = zeros(para.N, 1) ; 
        last_update = t ; 
    end

    
    
    % agent move and update figure
    %t
    %state
    %verified_control
    %stopping_flag
    
    state = agentMove(state,verified_control, stopping_flag);
    %afterupdate = 1
    %state 
    updateFigure(F,state);   
    
    % update time
    t = t+ para.upd_period;
    pause(para.upd_period/para.timerate);
end



