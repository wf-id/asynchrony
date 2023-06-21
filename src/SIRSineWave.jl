function SIRSineWave(du, u, p, t)
  S1, S2, I1, I2, R1, R2 = u
  beta_bar, gamma_bar, beta_amp, gamma_amp, mu, m, phi, tau, T = p

  # Determine the instantaneous value of beta and gamma in each population
  betaA = beta_bar + beta_amp*sin(2*pi/T*(t + T/4));
  betaB = beta_bar + beta_amp*sin(2*pi/T*(t + T/4 - tau));
  gammaA = gamma_bar + gamma_amp*sin(2*pi/T*(t + T/4));
  gammaB = gamma_bar + gamma_amp*sin(2*pi/T*(t + T/4 - tau));

  # Convenience
  N1 = S1 + I1 + R1
  N2 = S2 + I2 + R2

  # Compartments
  ## Susceptibles
  du[1] = -S1 * betaA * I1/(N1) + m*S2 - m*S1
  du[2] = -S2 * betaB * I2 /(N2) + m*S1 - m*S2

  ## Infected
  du[3] = S1 * betaA * I1/(N1) - gammaA*I1 - (1-phi)*mu*I1 - phi*m*I1 + phi*m*I2;
  du[4] = S2 * betaB * I2 /(N2) - gammaB*I2 - (1-phi)*mu*I2 - phi*m*I2 + phi*m*I1;

  ## Removed
  du[5] = gammaA*I1 + m*R2 - m*R1;
  du[6] = gammaB*I2 + m*R1 - m*R2;

end

#= Testing
cycle_length = 40
asynchrony = 0;

function generate_tau(asynchrony, cycle_length)
  acos(1-2*asynchrony)*cycle_length/(2*pi);
end

tau = acos(1-2*asynchrony)*cycle_length/(2*pi);
params0 = [.5, .3, .1, .1, 0.01, 0.005,  0.87, generate_tau(0, cycle_length), cycle_length]
params1 = [.5, .3, .1, .1, 0.01, 0.005,  0.87, generate_tau(1, cycle_length), cycle_length]
inits = [900000, 900000, 100, 100, 0, 0]
tspan = (0.0,200.0)
sir_prob0 = ODEProblem(SIRSineWave,inits,tspan,params0)
sir_sol0 = solve(sir_prob,saveat = 0.1)

sir_prob1 = ODEProblem(SIRSineWave,inits,tspan,params1)
sir_sol1 = solve(sir_prob1,saveat = 0.1)

using Plots
p0 = plot(sir_sol0,xlabel="Time",ylabel="Number", labels = ["S1" "S2" "I1" "I2" "R1" "R2"], title = "Asynchrony 0")
p1 = plot(sir_sol1,xlabel="Time",ylabel="Number", title = "Asynchrony 1")

l = @layout [a ; b]

plot(p0,p1, layout = l)
=#
