include("profile_functions.jl") # Assuming this was done previously
include("sweep_profile.jl")

## Generate values
t_end = 275.0
t = 0.0:0.02:t_end
θ = [jasons_profile(t_val, 0.0, 87.0) for t_val in t]
plot(t, θ; ticks=:native)

# using DataFrames, CSV
# df = DataFrame("time [s]" => t, "roll commanded [deg]" => θ)
# CSV.write("sys_id.csv", df)