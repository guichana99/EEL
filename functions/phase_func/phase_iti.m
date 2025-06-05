function [curr_trial_data, game_opt] = phase_iti(curr_trial_data, visual_opt, ...
                                        game_opt, eye_opt, device_opt, initial_ITI, phase_str)
    % Record the start time of the ITI phase in the current trial data
    curr_trial_data.(phase_str).phase_start = tic;
    
    % If eel info generation is required and it is not visual, keep it
    if initial_ITI
         curr_trial_data = generate_eels_info(curr_trial_data, visual_opt, game_opt);
    end 
    
    % For timing, just pause for ITI duration (optional)
    pause(game_opt.ITI_time);
    
    % No eye tracking or visual screen updates here
    
    % Simulate empty eye data struct (if needed)
    all_eye_data = struct('eyeX', [], 'eyeY', [], 'pupSize', []);
    
    % Concatenate_pos_data might depend on eye data — if so, stub or skip
    % For safety, let's create a minimal stub version here to avoid error:
    curr_trial_data = concatenate_pos_data(curr_trial_data, -1, -1, -1, all_eye_data, -1, phase_str);
    
    % Record the end time of the ITI phase and calculate duration
    curr_trial_data.(phase_str).phase_end = toc(curr_trial_data.(phase_str).phase_start);
    curr_trial_data.(phase_str).phase_duration = curr_trial_data.(phase_str).phase_end;
end
