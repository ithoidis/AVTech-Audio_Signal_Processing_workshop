%dirName='C:\data\wave_out';

%this function extracts a feature vector for a window of 1s with an overlap of 0.5
%window and overlap length are adjustable

function AF=extractor_win_overlap(filename, win, over)
    % win=1;
    % over=0.5;
    [a, fs] = audioread(filename);
    a = a(:,1); % keep only the left channel
    a = miraudio(a);
    duration=mirgetdata(mirlength(a));
    k=1;
    for i=0:ceil((duration/over)-1)
        audio=miraudio(a,'Extract',over*i,over*i+win);
        
        %basic operators
        AF(k,1)=length(mirgetdata(mirpeaks(audio)));
    
        %dynamics
        AF(k,2)=mirgetdata(mirrms(audio));
        AF(k,3)=mirgetdata(mirlowenergy(audio));
    
        %rhythm
        AF(k,4)=mirgetdata(mireventdensity(audio));
     
        %timbre
        AF(k,5)=mirgetdata(mirzerocross(audio));
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
        %timbre
        AF(k,6)=mirgetdata(mirrolloff(audio,'Threshold',0.2));
        AF(k,7)=mirgetdata(mirrolloff(audio,'Threshold',0.5));
        AF(k,8)=mirgetdata(mirrolloff(audio,'Threshold',0.8));
        AF(k,9)=mirgetdata(mirrolloff(audio,'Threshold',0.9));
        AF(k,10)=mirgetdata(mirrolloff(audio,'Threshold',0.99));
        AF(k,11)=mirgetdata(mirbrightness(audio,'CutOff',500));
        AF(k,12)=mirgetdata(mirbrightness(audio,'CutOff',1000));
        AF(k,13)=mirgetdata(mirbrightness(audio,'CutOff',1500));
        AF(k,14)=mirgetdata(mirbrightness(audio,'CutOff',2000));
        AF(k,15)=mirgetdata(mirbrightness(audio,'CutOff',3000));
        AF(k,16)=mirgetdata(mirbrightness(audio,'CutOff',4000));
        AF(k,17)=mirgetdata(mirbrightness(audio,'CutOff',8000));
        AF(k,18)=mirgetdata(mirregularity(audio));
      
        %statistics
        AF(k,19)=mirgetdata(mircentroid(audio));
        AF(k,20)=mirgetdata(mirspread(audio));
        AF(k,21)=mirgetdata(mirskewness(audio));
        AF(k,22)=mirgetdata(mirkurtosis(audio));
        AF(k,23)=mirgetdata(mirflatness(audio));
        AF(k,24)=mirgetdata(mirentropy(audio));

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %timbre
        mfccs=mirgetdata(mirmfcc(audio));
        AF(k,25)= mfccs(1);
        AF(k,26)= mfccs(2);
        AF(k,27)= mfccs(3);
        AF(k,28)= mfccs(4);
        AF(k,29)= mfccs(5);
        AF(k,30)=mfccs(6);
        AF(k,31)=mfccs(7);
        AF(k,32)=mfccs(8);
        AF(k,33)=mfccs(9);
        AF(k,34)=mfccs(10);
        AF(k,35)=mfccs(11);
        AF(k,36)=mfccs(12);
        AF(k,37)=mfccs(13);        
        k=k+1;
    end
end




