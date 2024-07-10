using Plots

include("profile_functions.jl") # Assuming this was done previously
include("sweep_profile.jl")

struct SignalSegment
    duration::Float64
    function_ref::Function
    parameters::Dict{Symbol,Any}
end

# Example usage
signal_segments = [
    SignalSegment(10.0, sine, Dict(:amplitude => 0.0)),
    SignalSegment(10.0, square_step, Dict(:step_size => 5.0, :frequency => 0.2)),
    SignalSegment(10.0, sine, Dict(:amplitude => 0.0)),
    SignalSegment(10.0, sine, Dict(:amplitude => 45.0))]

time_points, concatenated_series = generate_time_series(signal_segments, 0.2)
plot(time_points, concatenated_series, title="Timeseries of Angle Commands", xlabel="Time (s)", ylabel="Angle Command", legend=false)