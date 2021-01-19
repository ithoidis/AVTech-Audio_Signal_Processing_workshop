%% intro
fullfile(matlabroot,'toolbox','audio','samples')

file = 'DrumSolo.wav';
[wave, fs] = audioread(file);
plot(wave)
sound(wave, fs);

[wave_stereo, fs] = audioread('stereoGMM.wav');
sound(wave_stereo, fs);

% play in another sampling rate
sound(wave_stereo, 44100);

% convert to mono one way or another
wave_mono = sum(wave_stereo, 2)/2;
wave_mono = wave_stereo(:,1);

recObj = audiorecorder(22050, 16, 1);
disp('Start speaking.')
recordblocking(recObj, 5);
disp('End of Recording.');
y = getaudiodata(recObj);
sound(y, 22050);

%% Audio Effects - EQ and Compression

mPEQ = multibandParametricEQ('NumEQBands',3,'Frequencies',[300,1200,5000], 'QualityFactors', [1.6, 1.6, 1.6], 'PeakGains', [-20, -5, -20]);
visualize(mPEQ);
audioOut = mPEQ(y);

drc = compressor(-25, 2, ...
    'SampleRate',fs, ...
    'AttackTime',0.050, ...
    'ReleaseTime',0.200, ...
    'MakeUpGainMode','Property');

visualize(drc);

x = [ones(Fs,1);0.1*ones(fs,1)];
x = wave_mono;
[y,g] = drc(x);
sound(y, fs)

figure
subplot(211)
t = (1/Fs) * (0: size(y,1)-1)';
plot(t,x);
hold on
grid on
plot(t,y,'r')
ylabel('Amplitude')
legend('Input','Compressed Output')

subplot(212)
plot(t,g)
grid on
legend('Compressor gain (dB)')
xlabel('Time (sec)')
ylabel('Gain (dB)')


%% Analysis - spectrogram and filterbanks

[audio, fs] = audioread('TADA.WAV');
audio = sum(audio, 2)/2;
spectrogram(audio,512,256,fs,'yaxis')
sound(audio, fs);




[v_sc, tt] = ComputeFeature('SpectralSpread', x, fs, w, 1024, 512);
plot(tt,v_sc), grid on, xlabel('t'), ylabel('v_sc');

[f,spectral_hps] = ComputePitch('TimeAcf', x, fs, w, 256, 128);
plot(spectral_hps, f);

%% Features
% - Trumpet spectrum visualization
% - Spectral Centroid 
% - Framing
% - Feature evolution
% - Feature Distribution

file = 'trumpet.wav';
audio_mir = miraudio(file);
s = mirspectrum(audio_mir)
mirplay(audio_mir);
centroid = mircentroid(s); 


file = 'Counting-16-44p1-mono-15secs.wav';
[audio, fs] = audioread(file);
audio_mir = miraudio(audio);
mirplay(audio_mir)
s = mirspectrum(audio_mir)
centroid = mirentropy(s);
% mirspread(s)
% mirskewness(s)
% mirkurtosis(s)
% mirflatness(s)
% mirregularity(s)
% mirentropy(s)

% split 2*N-1 frames
audio_framed = mirframe(file, 'Length', 0.05, 'Hop', 0.5);
centroid = mirgetdata(mircentroid(audio_framed))';
subplot(2,1,1)
t = linspace(0,size(audio,1)/fs,size(audio,1));
plot(t,audio)
ylabel('Amplitude')
subplot(2,1,2)
t = linspace(0,size(audio,1)/fs,size(centroid,1));
plot(t, centroid)
xlabel('Time (s)')
ylabel('Centroid (Hz)')

file = 'ripple.wav';
[audio, fs] = audioread(file);
audio_framed = mirframe(file, 'Length', 0.05, 'Hop', 0.5);
centroid = mirgetdata(mircentroid(audio_framed))';
subplot(2,1,1)
t = linspace(0,size(audio,1)/fs,size(audio,1));
plot(t,audio)
ylabel('Amplitude')
subplot(2,1,2)
t = linspace(0,size(audio,1)/fs,size(centroid,1));
plot(t, centroid)
xlabel('Time (s)')
ylabel('Centroid (Hz)')

% Oscillator Harmonics
fs = 16000;
duration = 5;
tone = audioOscillator('SampleRate',fs,'NumTones',4,'SamplesPerFrame',fs,'Frequency',[500,1000,2500,4000]);
signal = [];
for i = 1:duration
    signal = [signal;tone()];
tone.Amplitude = tone.Amplitude + [0.1,0,0,-0.1];
end
audio_mir = miraudio(signal .* 0.1, fs);
skewness = mirgetdata(mirskewness(mirframe(audio_mir)));
t = linspace(0,size(signal,1)/fs,size(skewness,1))/60;
subplot(2,1,1) 
spectrogram(signal,round(fs*0.05),round(fs*0.04),round(fs*0.05),fs,'yaxis','power') 
view([-58 33])
subplot(2,1,2)
plot(skewness);

% Tone Grouping - Pitch
fs = 16000;
tone = audioOscillator('SampleRate',fs,'NumTones',2,'SamplesPerFrame',512,'Frequency',[2000, 200]); 
duration = 5;
numLoops = floor(duration*fs/tone.SamplesPerFrame);
signal = [];
for i = 1:numLoops
    signal = [signal ;tone()];
     if i<numLoops/2
         tone.Frequency = tone.Frequency + [0, 50];
     end
end
signal = signal / max(signal) * 0.3;
subplot(2,1,1)
spectrogram(signal,round(fs*0.05),round(fs*0.04),2048,fs,'yaxis') 
subplot(2,1,2)
[f, tim] = ComputePitch('TimeAcf', signal, fs);
plot(tim, f);



%%


[audio,fs] = audioread('FunkyDrums-44p1-stereo-25secs.mp3');
audio = audio(1:fs*5);
sound(audio,fs);

a = miraudio('ragtime.wav','Center','Sampling',11025);
mirplay(a);

centroid = mirgetdata(mircentroid(audio));

subplot(2,1,1)
t = linspace(0,size(audio,1)/fs,size(audio,1));
plot(t,audio)
ylabel('Amplitude')

subplot(2,1,2)
t = linspace(0,size(audio,1)/fs,size(centroid,1));
plot(t,centroid)
xlabel('Time (s)')
ylabel('Centroid (Hz)')


figure
subplot(2,1,1)
plot(audio)
subplot(2,1,2)
spectrogram(audio,512,256,512,fs,'yaxis','power')
view([-58 33])
xlabel('Time')
ylabel('Frequency')

%% LPC features and formant tracking

load mtlb
segmentlen = 100;
noverlap = 90;
NFFT = 128;


%%
features = extract(aFE,audioIn);
features = (features - mean(features,1))./std(features,[],1);

idx = info(aFE);
duration = size(audioIn,1)/fs;

subplot(2,1,1)
t = linspace(0,duration,size(audioIn,1));
plot(t,audioIn)

subplot(2,1,2)
t = linspace(0,duration,size(features,1));
plot(t,features(:,idx.spectralCentroid), ...
     t,features(:,idx.spectralKurtosis), ...
     t,features(:,idx.pitch));
legend("Spectral Centroid","Spectral Kurtosis", "Pitch")
xlabel("Time (s)")