using Plots

include("profile_functions.jl")

struct SignalSegment
    duration::Float64 # seconds
    function_ref::Function
    parameters::Dict{Symbol,Any}
end

# Overall profile parameters
time_interval = 0.02 # seconds

min_angle = 0.0
max_angle = 87.0
angle_range = max_angle - min_angle

profile_offset = min_angle + 45.0
profile_scaling = angle_range / 45.0

# Segment-specific parameters
square_step_duration = 80.0
square_step_params = Dict(:step_size => 5.0, :frequency => 0.2)

sine_duration = 20.0
sine_params = Dict(:amplitude => 40.0, :frequency => 0.25, :offset => profile_offset)

sine_sweep_duration = 20.0
# since_sweep_params are all different

step_duration = 70.0
step_params = Dict(:step_size => 5.0, :frequency => 0.25)

hold_segment_duration = 5.0

hold_segment = SignalSegment(hold_segment_duration, sine, Dict(:amplitude => 0.0))

# Construct the signal segments
signal_segments = [
    hold_segment,
    SignalSegment(square_step_duration, square_step, square_step_params),
    hold_segment,
    SignalSegment(sine_duration, sine, sine_params),
    hold_segment,
    SignalSegment(sine_sweep_duration, sine_sweep, Dict(:amplitude => 10.0, :starting_frequency => 0.25, :ending_frequency => 1.0, :offset => profile_offset)),
    hold_segment,
    SignalSegment(sine_sweep_duration, sine_sweep, Dict(:amplitude => 10.0, :starting_frequency => 0.25, :ending_frequency => 4.0, :offset => profile_offset)),
    hold_segment,
    SignalSegment(sine_sweep_duration, sine_sweep, Dict(:amplitude => 5.0, :starting_frequency => 0.25, :ending_frequency => 1.0, :offset => profile_offset)),
    hold_segment,
    SignalSegment(sine_sweep_duration, sine_sweep, Dict(:amplitude => 5.0, :starting_frequency => 0.25, :ending_frequency => 4.0, :offset => profile_offset)),
    hold_segment,
    SignalSegment(step_duration, step, step_params),
    hold_segment
]

time_points, concatenated_series = generate_time_series(signal_segments, time_interval)
plot(time_points, concatenated_series, title="Timeseries of Angle Commands", xlabel="Time (s)", ylabel="Angle Command", legend=false)