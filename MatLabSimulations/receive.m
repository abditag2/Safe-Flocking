function [packet channels count] = receive(id, cur_time, channels)

count = 1 ;

i = 1 ; 


packet = struct('msg' , [] ,'time' , [] )  ;

 
while i <= channels(id).count

    
    if (channels(id).packet(i).time <= cur_time ) 
        
        packet(count) = channels(id).packet(i); 
       
       %shift
       channels(id).count = channels(id).count - 1 ;
       
       for j = i:channels(id).count 
          channels(id).packet(j).time = channels(id).packet(j+1).time;
          channels(id).packet(j).msg = channels(id).packet(j+1).msg;
       end
       
       
       
       count = count + 1 ; 
    else
       i = i + 1 ;
       
    end
    
end

count = count -1 ; 
return



return