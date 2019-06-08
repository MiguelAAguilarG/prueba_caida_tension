close;
clc;
clear;

V_base = 1000;

Longitud = 100;
fp_carga = [0.9 0.8 0.7];
%Tabla 9. NEC/NOM-001-SEDE
R_cable = 10.2; %Calibre 14
X_cable = 0.240; %Calibre 14

basemva=1/1000;
Z_base = (V_base^2)/(basemva*1e6);

%Acelerar
accel=0;

%Exactitud
accuracy=1e-12;

maxiter=80;

carga = [10000 9900 9800];%Carga (W)

for mmm=1:length(fp_carga)
fprintf('\nfp: %1.1f\n',fp_carga(mmm))
for nnn=1:length(carga)
% 1--slack
% 0--load
% 2--generation

%	bus	bus	voltage	angle	----Load----	-----Generator-----Injected
%	No	code	mag	degree	MW	Mvar	MW	Mvar	Qmin	Qmax	Mvar	
busdata=[1	1 	1	0	0	0	0	0	0	0	0
	2	0	1	0	carga(nnn)/1000000	carga(nnn)/1000000*tan(acos(fp_carga(mmm)))	0	0	0	0	0];

%	Bus	bus	R	X	1/2 B	TAP
%	NL	NR	pu	pu	pu
linedata=[1	2	R_cable/1000*Longitud/Z_base	X_cable/1000*Longitud/Z_base	0	1];

lfybus %Power System Analysis by Hadi Saadat
lfnewton %Power System Analysis by Hadi Saadat
busout %Power System Analysis by Hadi Saadat
lineflow %Power System Analysis by Hadi Saadat

V_caida_porcentaje(nnn,mmm) = (1-Vm(2))*100;

end

Ze = R_cable/1000*Longitud*fp_carga(mmm) + X_cable/1000*Longitud*sin(acos(fp_carga(mmm))); %Formula NEC/NOM-001-SEDE

fprintf('n\t'), fprintf('(W)Carg\t'), fprintf('%%V(flujos)\t'), fprintf('%%V(fórmula)\t'), fprintf('dif\n')
for nnn=1:length(carga)
  
Inom(nnn,mmm) = carga(nnn)/(sqrt(3)*V_base*fp_carga(mmm));
caida_tension_calculada_simple(nnn,mmm) = sqrt(3)*Ze*Inom(nnn,mmm)*100/V_base;   
fprintf('%g\t ', nnn), fprintf('%g\t',carga(nnn)), fprintf('%f\t', V_caida_porcentaje(nnn,mmm)), fprintf('%f\t', caida_tension_calculada_simple(nnn,mmm)),
fprintf('%f\n', V_caida_porcentaje(nnn,mmm)-caida_tension_calculada_simple(nnn,mmm))

end

end


for mmm=1:length(fp_carga)
fprintf('\nfp: %1.1f\n',fp_carga(mmm))
fprintf('n\t'), fprintf('(W)Carg\t'), fprintf('%%V(flujos)\t'), fprintf('%%V(fórmula)\t'), fprintf('dif\n')
for nnn=1:length(carga)
fprintf('%g\t ', nnn), fprintf('%g\t',carga(nnn)), fprintf('%f\t', V_caida_porcentaje(nnn,mmm)), fprintf('%f\t', caida_tension_calculada_simple(nnn,mmm)),
fprintf('%f\n', V_caida_porcentaje(nnn,mmm)-caida_tension_calculada_simple(nnn,mmm))
end

subplot(2,1,1);
plot(carga,V_caida_porcentaje(:,mmm),'b',carga,caida_tension_calculada_simple(:,mmm),'g')
xlabel('Carga (W)')
ylabel('%\DeltaV')
legend('%\DeltaV(flujos)', '%\DeltaV(fórmula)')
str = strcat('fp: ', num2str(fp_carga(mmm)));
text(carga(length(carga)), V_caida_porcentaje(length(carga),mmm), str)
text(carga(length(carga))+ (carga(1)-carga(length(carga)))/20, caida_tension_calculada_simple(length(carga),mmm)+ (caida_tension_calculada_simple(1)-caida_tension_calculada_simple(length(carga),mmm))/7, str)

grid on
hold on

subplot(2,1,2); 
plot(carga,(V_caida_porcentaje(:,mmm)-caida_tension_calculada_simple(:,mmm)),'r')
xlabel('Carga (W)')
ylabel('%\DeltaV')
legend('(%\DeltaV(flujos) - %\DeltaV(fórmula))')
str = strcat('fp: ', num2str(fp_carga(mmm)));
text(carga(length(carga)), (V_caida_porcentaje(length(carga),mmm)-caida_tension_calculada_simple(length(carga),mmm)), str)

grid on
hold on
end