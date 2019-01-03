%  This program prints the power flow solution in a tabulated form
%  on the screen.
%
%  Copyright (C) 1998 by H. Saadat.

%clc
disp(tech)
fprintf('                      Maximum Power Mismatch = %g \n', maxerror)
fprintf('                             No. of Iterations = %g \n\n', iter)
head =['    Bus  Voltage  Angle    ------Load------    ---Generation---   Injected'
       '    No.  Mag.     Degree     MW       Mvar       MW       Mvar       Mvar '
       '                                                                          '];
disp(head)
for n=1:nbus
     fprintf(' %5g', n), fprintf(' %7f', Vm(n)),
     fprintf(' %8f', deltad(n)), fprintf(' %9f', Pd(n)),
     fprintf(' %9f', Qd(n)),  fprintf(' %9f', Pg(n)),
     fprintf(' %9f ', Qg(n)), fprintf(' %8f\n', Qsh(n))
end
    fprintf('      \n'), fprintf('    Total              ')
    fprintf(' %9f', Pdt), fprintf(' %9f', Qdt),
    fprintf(' %9f', Pgt), fprintf(' %9f', Qgt), fprintf(' %9f\n\n', Qsht)
