function AF=extraction(audio)

%synartisi pou kanei extraction ena feature vector apo arxeio xyma (xwris parathyra)

% AF=ones([1,37]);
tic
%basic operators
peaks=mirpeaks(audio);
AF(1)=length(mirgetdata(peaks));
AF(1)=0;
%dynamics
AF(2)=mirgetdata(mirrms(audio));
AF(3)=mirgetdata(mirlowenergy(audio));
    

%rhythm
AF(4)=mirgetdata(mireventdensity(audio));
     
%timbre
AF(5)=mirgetdata(mirzerocross(audio));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 

%timbre

AF(6)=mirgetdata(mirrolloff(audio,'Threshold',0.2));
AF(7)=mirgetdata(mirrolloff(audio,'Threshold',0.5));
AF(8)=mirgetdata(mirrolloff(audio,'Threshold',0.8));
AF(9)=mirgetdata(mirrolloff(audio,'Threshold',0.9));
AF(10)=mirgetdata(mirrolloff(audio,'Threshold',0.99));
AF(11)=mirgetdata(mirbrightness(audio,'CutOff',500));
AF(12)=mirgetdata(mirbrightness(audio,'CutOff',1000));
AF(13)=mirgetdata(mirbrightness(audio,'CutOff',1500));
AF(14)=mirgetdata(mirbrightness(audio,'CutOff',2000));
AF(15)=mirgetdata(mirbrightness(audio,'CutOff',3000));
AF(16)=mirgetdata(mirbrightness(audio,'CutOff',4000));
AF(17)=mirgetdata(mirbrightness(audio,'CutOff',8000));
AF(18)=mirgetdata(mirregularity(peaks));
      

%statistics
AF(19)=mirgetdata(mircentroid(audio));
AF(20)=mirgetdata(mirspread(audio));
AF(21)=mirgetdata(mirskewness(audio));
AF(22)=mirgetdata(mirkurtosis(audio));
AF(23)=mirgetdata(mirflatness(audio));
AF(24)=mirgetdata(mirentropy(audio));



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%timbre
mfccs=mirgetdata(mirmfcc(audio));
AF(25)= mfccs(1);
AF(26)= mfccs(2);
AF(27)= mfccs(3);
AF(28)= mfccs(4);
AF(29)= mfccs(5);
AF(30)=mfccs(6);
AF(31)=mfccs(7);
AF(32)=mfccs(8);
AF(33)=mfccs(9);
AF(34)=mfccs(10);
AF(35)=mfccs(11);
AF(36)=mfccs(12);
AF(37)=mfccs(13);   
toc
        
       
