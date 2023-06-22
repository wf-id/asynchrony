

function TwoPatch_Global_SIR_Sine(beta_max, beta_min, gamma_max, gamma_min, m, asynchrony, mu, cycle_length, phi;
periods = 50, Ntotal = 10^7, initial_infected = 10)

  tau = acos(1 - 2*asynchrony)*cycle_length/(2*pi)

  beta_bar = (beta_max + beta_min)/2;
  gamma_bar = (gamma_max + gamma_min)/2;

  # These are the amplitude of beta and gamma
  beta_amp = (beta_max - beta_min)/2;
  gamma_amp = (gamma_max - gamma_min)/2;

  params1 = [beta_bar, gamma_bar, beta_amp, gamma_amp, 
               mu, m,  phi, tau, cycle_length]

  if tau == 0
    SIR_init = [(Ntotal/2 - initial_infected),
               (Ntotal/2 - initial_infected),
               initial_infected,
               initial_infected,
               0,
               0]
    tspan = (0,(cycle_length*periods) )
    sir_prob1 = ODEProblem(SIRSineWave,SIR_init,tspan,params1)

    sir_sol1 = solve(sir_prob1,saveat = 0.1)


    out = DataFrame(sir_sol1);

    
  else
    SIR_init = [Ntotal/2 - initial_infected, 
                Ntotal/2,
                initial_infected, 
                0,
                0, 
                0]
    
    # Run the model forward for a cycle to account for the asynchrony
    tspan = (0.0,tau)
    sir_prob1 = ODEProblem(SIRSineWave,SIR_init,tspan,params1)

    sir_sol1 = solve(sir_prob1,saveat = 0.1)

    SIR_init = [sir_sol1[1, end],
               (Ntotal/2 - initial_infected),
               sir_sol1[3, end],
               initial_infected,
               sir_sol1[5, end],
               0]

  # Now run entire simulation forward
  tspan = (tau,(cycle_length*periods))

  sir_prob2 = ODEProblem(SIRSineWave,SIR_init,tspan,params1)

  sir_sol2 = solve(sir_prob2,saveat = 0.1)

  out =  vcat(DataFrame(sir_sol1), DataFrame(sir_sol2));

  end

  return out;

end

#=
using DifferentialEquations
using DataFrames
using Plots
out = TwoPatch_Global_SIR_Sine(.57, .1, .32, .32, 0.004, 1, 0.01, 40, .87)
out0 = TwoPatch_Global_SIR_Sine(.57, .1, .32, .32, 0.004, 0, 0.01, 40, .87)
end_use = 1000
begin
    plot(out.timestamp[1:end_use], out.value3[1:end_use])
    plot!(out.timestamp[1:end_use], out.value4[1:end_use],linestyle=:dash, color = "green")
end

begin
    plot(out0.timestamp[1:end_use], out0.value3[1:end_use])
    plot!(out0.timestamp[1:end_use], out0.value4[1:end_use], linestyle=:dash, color = "green")
end
=#