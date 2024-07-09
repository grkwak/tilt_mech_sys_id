include("profiles_functions.jl") # Assuming this was done previously
include("roll_tilt_sys_id_profile.jl")

## Generate values
t_end = 275.0
t = 0.0:0.02:t_end
θ = [jasons_profile(t_val, 45.0) for t_val in t]
plot(t, θ; ticks=:native)

# using DataFrames, CSV
# df = DataFrame("time [s]" => t, "roll commanded [deg]" => θ)
# CSV.write("sys_id.csv", df)