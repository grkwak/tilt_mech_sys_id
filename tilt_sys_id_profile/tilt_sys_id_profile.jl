using Plots, LinearAlgebra, Serialization, DataFrames
include("profiles_functions.jl")
plotly()

# import Pkg; Pkg.add("DataFrames")
# import Pkg; Pkg.add("PlotlyBase")

struct ProfileConfig
    min_angle::Float64
    max_angle::Float64
    t_h::Float64
    t_square_step::Float64
    t_sine::Float64
    t_sine_sweep_0::Float64
    t_sine_sweep_1::Float64
    t_sine_sweep_2::Float64
    t_sine_sweep_3::Float64
    t_step::Float64
    offset::Float64
end

# # Constructor with default values
# ProfileConfig(; min_angle=-45.0, max_angle=45.0, t_h=1.0, t_square_step=2.0, t_sine=3.0,
#     t_sine_sweep_0=4.0, t_sine_sweep_1=5.0, t_sine_sweep_2=6.0,
#     t_sine_sweep_3=7.0, t_step=8.0, offset=0.0) =
#     ProfileConfig(min_angle, max_angle, t_h, t_square_step, t_sine,
#         t_sine_sweep_0, t_sine_sweep_1, t_sine_sweep_2,
#         t_sine_sweep_3, t_step, offset)

# prof_config = ProfileConfig(offset=45.0)

## Define profile

function jasons_profile(t, min_angle, max_angle)

    profile_offset = min_angle + 45.0
    profile_scaling = (max_angle - min_angle) / 45.0

    t_h = 5.0 # hold time
    t_square_step = 109.0 #49
    t_sine = 20.0
    t_sine_sweep_0 = 32.0
    t_sine_sweep_1 = 32.0
    t_sine_sweep_2 = 32.0
    t_sine_sweep_3 = 32.0
    t_step = 39.9

    if t <= t_h # hold at 0 degrees
        return sine(t; amplitude=0.0) # hold at 0 deg
    elseif t <= t_h + t_square_step # Step across range
        t_segment = t - t_h
        return square_step(t_segment; step_size=5.0, frequency=0.2)
    elseif t <= t_h + t_square_step + t_h
        t_segment = t - t_h - t_square_step
        return sine(t_segment; amplitude=0.0) # hold at 0 deg
    elseif t <= t_h + t_square_step + t_h + t_sine
        t_segment = t - t_h - t_square_step - t_h
        return sine(t_segment; amplitude=30.0, frequency=0.25, offset=profile_offset) # Sine wave (30 deg)
    elseif t <= t_h + t_square_step + t_h + t_sine + t_h
        t_segment = t - t_h - t_square_step - t_h - t_sine
        return sine(t_segment; amplitude=0.0) # hold at 0 deg
    elseif t <= t_h + t_square_step + t_h + t_sine + t_h + t_sine_sweep_0
        t_segment = t - t_h - t_square_step - t_h - t_sine - t_h
        return sine_sweep(t_segment; amplitude=10.0, starting_frequency=0.25, ending_frequency=1.0, T=t_sine_sweep_0, type="linear", offset=profile_offset) # Sine sweep 0
    elseif t <= t_h + t_square_step + t_h + t_sine + t_h + t_sine_sweep_0 + t_h
        t_segment = t - t_h - t_square_step - t_h - t_sine - t_h - t_sine_sweep_0
        return sine(t_segment; amplitude=0.0) # hold at 0 deg
    elseif t <= t_h + t_square_step + t_h + t_sine + t_h + t_sine_sweep_0 + t_h + t_sine_sweep_1
        t_segment = t - t_h - t_square_step - t_h - t_sine - t_h - t_sine_sweep_0 - t_h
        return sine_sweep(t_segment; amplitude=10.0, starting_frequency=0.25, ending_frequency=4.0, T=t_sine_sweep_1, type="linear", offset=profile_offset)  # Sine sweep 1
    elseif t <= t_h + t_square_step + t_h + t_sine + t_h + t_sine_sweep_0 + t_h + t_sine_sweep_1 + t_h
        t_segment = t - t_h - t_square_step - t_h - t_sine - t_h - t_sine_sweep_0 - t_h - t_sine_sweep_1
        return sine(t_segment; amplitude=0.0) # hold at 0 deg
    elseif t <= t_h + t_square_step + t_h + t_sine + t_h + t_sine_sweep_0 + t_h + t_sine_sweep_1 + t_h + t_sine_sweep_2
        t_segment = t - t_h - t_square_step - t_h - t_sine - t_h - t_sine_sweep_0 - t_h - t_sine_sweep_1 - t_h
        return sine_sweep(t_segment; amplitude=5.0, starting_frequency=0.25, ending_frequency=1.0, T=t_sine_sweep_2, type="linear", offset=profile_offset)  # Sine sweep 2
    elseif t <= t_h + t_square_step + t_h + t_sine + t_h + t_sine_sweep_0 + t_h + t_sine_sweep_1 + t_h + t_sine_sweep_2 + t_h
        t_segment = t - t_h - t_square_step - t_h - t_sine - t_h - t_sine_sweep_0 - t_h - t_sine_sweep_1 - t_sine_sweep_2
        return sine(t_segment; amplitude=0.0) # hold at 0 deg
    elseif t <= t_h + t_square_step + t_h + t_sine + t_h + t_sine_sweep_0 + t_h + t_sine_sweep_1 + t_h + t_sine_sweep_2 + t_h + t_sine_sweep_3
        t_segment = t - t_h - t_square_step - t_h - t_sine - t_h - t_sine_sweep_0 - t_h - t_sine_sweep_1 - t_h - t_sine_sweep_2 - t_h
        return sine_sweep(t_segment; amplitude=5.0, starting_frequency=0.25, ending_frequency=4.0, T=t_sine_sweep_3, type="linear", offset=profile_offset)  # Sine sweep 3
    elseif t <= t_h + t_square_step + t_h + t_sine + t_h + t_sine_sweep_0 + t_h + t_sine_sweep_1 + t_h + t_sine_sweep_2 + t_h + t_sine_sweep_3 + t_h
        t_segment = t - t_h - t_square_step - t_h - t_sine - t_h - t_sine_sweep_0 - t_h - t_sine_sweep_1 - t_h - t_sine_sweep_2 - t_h - t_sine_sweep_3
        return sine(t_segment; amplitude=0.0) # hold at 0 deg
    elseif t <= t_h + t_square_step + t_h + t_sine + t_h + t_sine_sweep_0 + t_h + t_sine_sweep_1 + t_h + t_sine_sweep_2 + t_h + t_sine_sweep_3 + t_h + t_step
        t_segment = t - t_h - t_square_step - t_h - t_sine - t_h - t_sine_sweep_0 - t_h - t_sine_sweep_1 - t_h - t_sine_sweep_2 - t_h - t_sine_sweep_3 - t_h
        return step(t_segment; step_size=5.0, frequency=0.25)
    else
        t_segment = t - t_h - t_square_step - t_h - t_sine - t_h - t_sine_sweep_0 - t_h - t_sine_sweep_1 - t_h - t_sine_sweep_2 - t_h - t_sine_sweep_3 - t_h - t_step
        return sine(t_segment; amplitude=0.0) # hold at 0 deg
    end
end
