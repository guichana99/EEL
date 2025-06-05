function curr_trial_data = phase_choice(curr_trial_data, visual_opt, game_opt, eye_opt, phase_str, device_opt)
    % Simulated PHASE_CHOICE: Random choice between left/right, reward based on eel competency
    
    if ~isfield(curr_trial_data, phase_str)
        curr_trial_data.(phase_str) = struct();
        curr_trial_data.(phase_str).choice = -1;
    end
    
    curr_trial_data.(phase_str).phase_start = tic;

    % Simulate random choice (1 = left, 2 = right)
    choice = randi([1, 2]);

    % Record choice
    curr_trial_data.(phase_str).choice = choice;
    if choice == 1
        curr_trial_data.(phase_str).choice_side = 'left';
    else
        curr_trial_data.(phase_str).choice_side = 'right';
    end

    % Extract eel competencies
    left_comp = NaN;
    right_comp = NaN;
    for i = 1:length(curr_trial_data.eels)
        if curr_trial_data.eels(i).initial_side == 1
            left_comp = curr_trial_data.eels(i).competency;
        elseif curr_trial_data.eels(i).initial_side == 2
            right_comp = curr_trial_data.eels(i).competency;
        end
    end

    % Determine reward (choose eel with lower competency is rewarded)
    reward = 0;
    if choice == 1 && left_comp < right_comp
        reward = 1;
    elseif choice == 2 && right_comp < left_comp
        reward = 1;
    end
    curr_trial_data.(phase_str).reward = reward;

    % Skip joystick, eye, and avatar logging
    curr_trial_data = concatenate_pos_data(curr_trial_data, [], -1, -1, [], [], phase_str);

    curr_trial_data.(phase_str).phase_end = tic;
    curr_trial_data.(phase_str).phase_duration = ...
        curr_trial_data.(phase_str).phase_end - curr_trial_data.(phase_str).phase_start;
end
