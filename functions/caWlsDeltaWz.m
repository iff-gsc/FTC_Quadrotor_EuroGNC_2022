function Delta_Wz = caWlsDeltaWz( Omega_Kb, M_bg, Delta_Wz_max, r_mid, r_range )

% Disclamer:
%   SPDX-License-Identifier: GPL-2.0-only
% 
%   Copyright (C) 2020-2022 Yannic Beyer
%   Copyright (C) 2022 TU Braunschweig, Institute of Flight Guidance
% *************************************************************************

Delta_Wz = 0;
r = Omega_Kb(3);
n_g = dcm2LeanVector(M_bg);
n_b = M_bg*n_g;
factor_0_1 = divideFinite(abs(dot(n_b,Omega_Kb)),norm(Omega_Kb));
if n_g(3) < 0
    Delta_Wz(:) = Delta_Wz_max * 0.5 * ...
        ( 1 + tanh( 2.297/r_range * (factor_0_1*abs(r) - r_mid) ) );
end

end