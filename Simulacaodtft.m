
M = 600;
n0 = 1;
nf = 10;
n = n0:nf;
k = zeros(1,2*M);
x = zeros(1,10);

function [z] = x1(n)

    z = (0.9*exp(1i*pi/3))^n;

  end


for i =n0:nf

    %n(i) = i;
    x(i) = x1(n(i));
end




for i =1:2*M

      k(i) = -M+i-1;


end



function [X] = dtft(x,n,k)

  M = 600;
  X = x*exp(-1*1i*pi*(n'*k)/M);




end


X = dtft(x,n,k);
disp(X);

modX = abs(X);
FaseX = angle(X);
w = linspace(-pi,pi,length(X));

figure
plot(w,modX,'cyan');
xlabel('k');
ylabel('Magnitude');
title('Magnitude de X(w)');

figure
plot(w,FaseX,'red');
xlabel('k');
ylabel('Fase (radianos)');
title('Fase de X(w)');







