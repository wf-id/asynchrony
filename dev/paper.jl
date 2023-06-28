using Pkg
using DataFrames
using Plots
using asynchrony
using LaTeXStrings
using Measures

# Asynchonous Scenario
out1 = TwoPatch_Global_SIR_Sine(.57, .1, .32, .32, 0.004, 1, 0.01, 40, .87)
out0 = TwoPatch_Global_SIR_Sine(.57, .1, .32, .32, 0.004, 0, 0.01, 40, .87)

end_use = 1400
col_use = cgrad(:viridis, 10, categorical = true, scale = :exp);

function plot_cases(dat, main, add_y  = true)
    begin
        plot(dat.timestamp[1:end_use], dat.value3[1:end_use],linewidth = 3, 
        color = col_use[1], label = false,showaxis = :x)
        plot!(dat.timestamp[1:end_use], dat.value4[1:end_use],linestyle = :dash,
        label = false,linewidth = 3, color = col_use[7])
        if add_y
            ylabel!("Infections")
        end
        title!(main)
    end
end

p_cases_async = plot_cases(out1, "Asynchrony", false);

p_cases_sync = plot_cases(out0, "Synchrony");


p_cases = plot(p_cases_sync, p_cases_async, layout = (1, 2))

savefig(p_cases,"dev/synchron_cases.pdf")
savefig(p_cases,"dev/synchron_cases.png")

# Now let's try an scenario where R < 1
out1control = TwoPatch_Global_SIR_Sine(.57 * .8, .1, .32, .32, 0.004, 1, 0.01, 40, .87)
out0control = TwoPatch_Global_SIR_Sine(.57 * .8 , .1, .32, .32, 0.004, 0, 0.01, 40, .87)


function sigmoid(x)
    1/(1+exp())
end

function plot_cases_total(dat1, dat2, add_y, main, add_labels = false)

    use_row = min(nrow(dat1),nrow(dat2))

    dat_plot = DataFrame(InfectionAsynch = dat1.value3[1:use_row] .+ dat1.value4[1:use_row] , 
                         timestamp = dat1.timestamp[1:use_row] , 
                         InfectionSynch = dat2.value3[1:use_row]  .+ dat2.value4[1:use_row] )

    plot(dat_plot.timestamp[1:end_use], dat_plot.InfectionAsynch[1:end_use],linewidth = 3,
        showaxis = :x,
        color = col_use[1], 
        label = if add_labels 
            "Asychrony"
        else 
            false
        end,
        #showaxis = :x,  
        fg_legend = :false)
        plot!(dat_plot.timestamp[1:end_use], dat_plot.InfectionSynch[1:end_use],linestyle = :dash,
        label =if add_labels 
            "Sychrony"
        else 
            false
        end,
        linewidth = 3, color = col_use[7],  fg_legend = :false)
    if add_y
            ylabel!("Infections")
    end
        title!(main)


end

p_effective = plot_cases_total(out1control, out0control, false, "Effective Control")
p_no_control = plot_cases_total(out1, out0, true, "Ineffective Control", true)

p_novel = plot_cases_total(out1, out0, true, "Outbreak of Pathogen", true)

savefig(p_novel,"dev/novel_pathogen_cases_nocontrol.pdf")

p_control = plot(p_no_control, p_effective, layout = (1, 2))
savefig(p_control,"dev/control_scenarios_cases.pdf")


beta_max_set = [0.57,0.67];
beta_min_set = [0.045,0.12];
gamma_max_set = [0.32,0.32];
gamma_min_set = [0.32, 0.32];

mu = 0.015; 

cycle_length = 40; 

phi = 0.87; 

m = 0.005;

init_cycle_number = 3; 
w = 1
beta_max = beta_max_set[w];    
beta_min = beta_min_set[w];

gamma_max = gamma_max_set[w];  
gamma_min = gamma_min_set[w];

r_max = beta_max - gamma_max - (1-phi)*mu;
r_min = beta_min - gamma_min - (1-phi)*mu;
rbar = (r_max + r_min)/2;
R0_max = beta_max/(gamma_max + (1-phi)*mu);
R0_min = beta_min/(gamma_min + (1-phi)*mu);

t = collect(0:0.1:(init_cycle_number + 1)*cycle_length)

beta_bar = (beta_max + beta_min)/2; beta_amp = (beta_max - beta_min)/2;
beta_sine = beta_bar .+ beta_amp*sin.(2*pi/cycle_length.*t .+ pi/2);

gamma_bar = (gamma_max + gamma_min)/2; gamma_amp = (gamma_max - gamma_min)/2;

gamma_sine = gamma_bar .+ gamma_amp*sin.(2*pi/cycle_length.*t .+ pi/2);


function figure_control()

begin 
    plot(t, beta_sine - gamma_sine .- (1-phi)*mu, label = false, yguidefontrotation=-90,leftmargin=25mm, showaxis = :x,linewidth = 3, color = col_use[1])
    plot!(t, beta_sine - gamma_sine .- (1-phi)*mu, linestyle = :dash,label = false,linewidth = 3, color = col_use[7])
    hline!([rbar],label = false, color = :black, linestyle = :dash)
    hline!([r_max],label = false, color = :black, linestyle = :dash)
    hline!([r_min],label = false, color = :black, linestyle = :dash)
    ylabel!("\$r(t)\$ =\n \$β_i(t) - γ - (1-ϕ)μ\$")
    xlabel!("")
    title!("Synchronous Control")
end
end
p1 = figure_control();


asynchrony2 = 1

tau = acos(1 - 2*asynchrony2)*cycle_length/(2*pi);
t2 = tau:0.1:(init_cycle_number + 1)*cycle_length;

beta_sine_2 = beta_bar .+ beta_amp*sin.(2*pi/cycle_length.*(t2 .- tau .+ cycle_length/4));
gamma_sine_2 = gamma_bar .+ gamma_amp*sin.(2*pi/cycle_length.*(t2 .- tau .+ cycle_length/4));

function secondplot()
begin 
    plot(t, beta_sine - gamma_sine .- (1-phi)*mu, label = false, yguidefontrotation=-90,leftmargin=15mm, showaxis = :x,linewidth = 3, color = col_use[1])
    plot!(t2, beta_sine_2 - gamma_sine_2 .- (1-phi)*mu, linestyle = :dash,label = false,linewidth = 3, color = col_use[7])
    hline!([rbar],label = false, color = :black, linestyle = :dash)
    hline!([r_max],label = false, color = :black, linestyle = :dash)
    hline!([r_min],label = false, color = :black, linestyle = :dash)
    ylabel!("")
    annotate!(-15, r_max, L"r_{max}")
    annotate!(-15, rbar, L"\bar r")
    annotate!(-15, r_min, L"r_{min}")
    xlabel!("")
    title!("Asynchronous Control")
end
end

p_control = plot(p1, secondplot(), layout = (1,2),size = (800, 400))



savefig(p_control,"dev/synchron_growth.pdf")

savefig(p_control,"dev/synchron_growth.png")

plot(p_control, p_cases, layout = (2,1))


function run_simulation(;omega_in, m_in)
    o2 = TwoPatch_Global_SIR_Sine(0.57, 0.045, .32, .32, m_in, omega_in, 0.01, 40, .87)

    N = 10.0^7
    infections = N - sum(o2[end,1:2])

    prop = infections / N

    z = DataFrame(InfectionCNT = infections,
              AttackRate = prop,
              Omega = omega_in,
              Movement = m_in)

    return z

end

function run_simulation_red(omega_in, m_in)
    o2 = TwoPatch_Global_SIR_Sine(0.57, 0.045, .32, .32, m_in, omega_in, 0.01, 40, .87)

    N = 10.0^7
    infections = N - sum(o2[end,1:2])

    prop = infections / N

    z = DataFrame(InfectionCNT = infections,
              AttackRate = prop,
              Omega = omega_in,
              Movement = m_in)

    return prop

end

run_simulation(omega_in = 0,m_in=.01)
run_simulation(omega_in = 1,m_in=.01)

function expand_grid(; kws...)
    names, vals = keys(kws), values(kws)
    return DataFrame(NamedTuple{names}(t) for t in Iterators.product(vals...))
end

params = expand_grid(omega_in=collect(0:.1:1), m_in =  collect(0.0001:.0001:.01));


simz = map(eachrow(params)) do r
    run_simulation(;pairs(r)...)
end;


simz_out = reduce(vcat, simz)


plot(simz_out.Omega, simz_out.Movement, simz_out.AttackRate, st=[:surface, :contour], camera = (30,30))
xlabel!(L"\omega")

contour(0:0.1:1, 0:0.001:.1, run_simulation_red)
xlabel!(L"Synchrony \omega")