# using Dates: Millisecond

function generate_time_series(signal_segments, interval_seconds::Float64)
    concatenated_series = Float64[]
    all_time_points = Float64[]
    current_start_time_ms = 0 # Initialize start time of the first segment

    for segment in signal_segments
        duration_ms = round(Int, segment.duration * 1000) # Convert segment duration from seconds to milliseconds
        end_time_ms = current_start_time_ms + duration_ms # Calculate end time of the current segment

        # Create a range of milliseconds as integers
        time_points_ms = current_start_time_ms:interval_seconds*1000:end_time_ms

        # Convert milliseconds to seconds for storage and function calls
        append!(all_time_points, [t / 1000 for t in time_points_ms])
        for t in time_points_ms
            signal_value = segment.function_ref(t / 1000 - current_start_time_ms / 1000; segment.parameters...) # Adjust time for function call
            push!(concatenated_series, signal_value)
        end

        current_start_time_ms = end_time_ms # Update start time for the next segment
    end
    return all_time_points, concatenated_series
end

# Not used in Jason's profile
function square(t; amplitude=1.0, frequency=1.0, offset=0.0)
    return amplitude * (2.0 * (2.0 * floor(frequency * t) - floor(2.0 * frequency * t)) + 1.0) + offset
end

function step(t; step_size=1.0, frequency=1.0, min_value=0.0)
    return step_size * floor(frequency * t) + min_value
end

function square_step(t; step_size=1.0, frequency=1.0, min_value=0.0)
    max_value = step_size * floor(frequency * t) + min_value
    amplitude = (max_value - min_value) / 2.0
    offset = amplitude + min_value
    return amplitude * (2.0 * (2.0 * floor(frequency * t) - floor(2.0 * frequency * t)) + 1.0) + offset
end

function lin_phase(t, starting_frequency, ending_frequency, T)
    β = (ending_frequency - starting_frequency) / T
    return 2 * π * (starting_frequency * t + 0.5 * β * t * t)
end

function log_phase(t, starting_frequency, ending_frequency, T)
    β = T / log(ending_frequency / starting_frequency)
    return 2 * π * β * starting_frequency * (((ending_frequency / starting_frequency)^(t / T)) - 1.0)
end

function sine_sweep(t; amplitude=1.0, starting_frequency=1.0, ending_frequency=1.0, phase_shift=0.0, offset=0.0, T=10.0, type="linear")
    if type == "linear"
        return amplitude * sin(lin_phase(t, starting_frequency, ending_frequency, T) + phase_shift) + offset
    elseif type == "log"
        return amplitude * sin(log_phase(t, starting_frequency, ending_frequency, T) + phase_shift) + offset
    end
end

function sine(t; amplitude=1.0, frequency=1.0, phase_shift=0.0, offset=0.0)
    return amplitude * sin(2π * frequency * t + phase_shift) + offset
end