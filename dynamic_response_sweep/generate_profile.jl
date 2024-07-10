using Plots

include("profile_functions.jl") # Assuming this was done previously
include("sweep_profile.jl")

struct SignalSegment
    duration::Float64
    function_ref::Function
    parameters::Dict{Symbol,Any}
end

const min_angle = 0.0
const max_angle = 87.0
const angle_range = max_angle - min_angle

const profile_offset = min_angle + 45.0
const profile_scaling = angle_range / 45.0

# Example usage
signal_segments = [
    SignalSegment(10.0, sine, Dict(:amplitude => 0.0)),
    SignalSegment(10.0, square_step, Dict(:step_size => 5.0, :frequency => 0.2)),
    SignalSegment(10.0, sine, Dict(:amplitude => 0.0)),
    SignalSegment(10.0, sine, Dict(:amplitude => 45.0, :frequency => 0.25, :offset => profile_offset)),
    SignalSegment(10.0, sine, Dict(:amplitude => 0.0)),
    SignalSegment(10.0, sine_sweep, Dict(:amplitude => 10.0, :starting_frequency => 0.25, :ending_frequency => 1.0, :offset => profile_offset)),
    SignalSegment(10.0, sine, Dict(:amplitude => 0.0)),
    SignalSegment(10.0, sine_sweep, Dict(:amplitude => 10.0, :starting_frequency => 0.25, :ending_frequency => 4.0, :offset => profile_offset)),
    SignalSegment(10.0, sine, Dict(:amplitude => 0.0)),
    SignalSegment(10.0, sine_sweep, Dict(:amplitude => 5.0, :starting_frequency => 0.25, :ending_frequency => 1.0, :offset => profile_offset)),
    SignalSegment(10.0, sine, Dict(:amplitude => 0.0)),
    SignalSegment(10.0, sine_sweep, Dict(:amplitude => 5.0, :starting_frequency => 0.25, :ending_frequency => 4.0, :offset => profile_offset)),
    SignalSegment(10.0, sine, Dict(:amplitude => 0.0)),
    SignalSegment(10.0, step, Dict(:step_size => 5.0, :frequency => 0.25)),
    SignalSegment(10.0, sine, Dict(:amplitude => 0.0))
]

time_points, concatenated_series = generate_time_series(signal_segments, 0.2)
plot(time_points, concatenated_series, title="Timeseries of Angle Commands", xlabel="Time (s)", ylabel="Angle Command", legend=false)