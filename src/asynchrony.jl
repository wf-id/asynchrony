module asynchrony

using DataFrames
using DifferentialEquations
using Plots


export SIRSineWave, TwoPatch_Global_SIR_Sine

include("SIRSinewave.jl")
include("TwoPatch_Global_SIR_Sine.jl")

end # module asynchrony

