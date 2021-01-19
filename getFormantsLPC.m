function formants = getFormantsLPC(x, Fs, p)
    dt = 1/Fs;
    I0 = round(0.1/dt);
    Iend = round(0.25/dt);
    x1 = x.*hamming(length(x));
    preemph = [1 0.63];
    x1 = filter(1,preemph,x1);
    A = lpc(x1,p);
    rts = roots(A);
    rts = rts(imag(rts)>=0);
    angz = atan2(imag(rts),real(rts));
    [frqs,indices] = sort(angz.*(Fs/(2*pi)));
    bw = -1/2*(Fs/(2*pi))*log(abs(rts(indices)));
    nn = 1;
    for kk = 1:length(frqs)
        if (frqs(kk) > 90 && bw(kk) <400)
            formants(nn) = frqs(kk);
            nn = nn+1;
        end
    end

end