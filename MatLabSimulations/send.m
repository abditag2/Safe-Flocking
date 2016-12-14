function channels = send(id, msg, cur_time, drop_percent, max_delay, channels)

%id is the destination 

delay = max_delay * rand(1) ;

if (rand(1) > drop_percent/100 )

    %find the right place in sorted array opf packets
    deliver_time = cur_time + delay ; 
    location_to_be_inserted = channels(id).count + 1 ;
    
    for i = 1:channels(id).count
        if (channels(id).packet(i).time > deliver_time )
            location_to_be_inserted = i ; 
            break ; 
        end
    end
    
    %shift all the elements to the right
    
    for i = location_to_be_inserted:channels(id).count
        channels(id).packet(i+1).msg = channels(id).packet(i).msg;
        channels(id).packet(i+1).time = channels(id).packet(i).time;
    end
    
    
    %add
    channels(id).packet(location_to_be_inserted).msg = msg ;
    channels(id).packet(location_to_be_inserted).time = deliver_time;
    channels(id).count = channels(id).count + 1 ;
    
end



return




