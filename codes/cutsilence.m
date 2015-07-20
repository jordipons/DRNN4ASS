function  train_wav_out = cutsilence(train_wav)
    
    % This function removes the silence from the beggining and the end of
    % a song.
    
    threshold=mean(mean(abs(train_wav)))/2;
    
    init=abs(train_wav)<threshold;
    begin=1;
    while sum(init(begin,:))==2
        begin=begin+1;
    end
    fin=1;
    while sum(init(length(init)-fin,:))==2
        fin=fin+1;
    end
    fin=length(init)-fin;
    
    train_wav_out=train_wav(begin:fin,:);
    disp('Cutting silence..')
%     begin
%     fin
% 
%     plot(train_wav);hold on;plot(init,'red');

end