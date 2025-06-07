function curr_trial_data = phase_choice(curr_trial_data, visual_opt, game_opt, eye_opt, phase_str, device_opt)
<<<<<<< Updated upstream
    % Simulated PHASE_CHOICE: Random choice between left/right, reward based on eel competency
    
=======
    % Simulated PHASE_CHOICE: Random choice between left/right, fish count based on competency and reliability

>>>>>>> Stashed changes
    if ~isfield(curr_trial_data, phase_str)
        curr_trial_data.(phase_str) = struct();
        curr_trial_data.(phase_str).choice = -1;
    end
<<<<<<< Updated upstream
    
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
=======

    curr_trial_data.(phase_str).phase_start = tic;

    % Simulate random choice (1 = left, 2 = right)
    choice = randi([1, 2]);
    curr_trial_data.(phase_str).choice = choice;
    sides = {'left', 'right'};
    curr_trial_data.(phase_str).choice_side = sides{choice};

    % Extract competencies and reliabilities
    left_comp = NaN; right_comp = NaN;
    left_rel = NaN;  right_rel = NaN;

    for i = 1:length(curr_trial_data.eels)
        eel = curr_trial_data.eels(i);
        if eel.initial_side == 1
            left_comp = eel.competency;
            if isfield(eel, 'reliability')
                left_rel = eel.reliability;
            end
        elseif eel.initial_side == 2
            right_comp = eel.competency;
            if isfield(eel, 'reliability')
                right_rel = eel.reliability;
            end
        end
    end

    % Get selected side's competency and reliability
    if choice == 1
        comp = left_comp;
        rel = left_rel;
    else
        comp = right_comp;
        rel = right_rel;
    end

    % --- Simulate fish catching ---
    % Fish count range
    fish_counts = 0:3;

    % Probability distribution based on competency
    % More biased toward higher fish counts as competency increases
    weights = [1 - comp, comp / 2, comp, 2 * comp];
    fish_probs = weights / sum(weights);

    % Sample number of fish caught
    fish_caught = randsample(fish_counts, 1, true, fish_probs);

    % Final effective fish count with reliability
    effective_fish = fish_caught * rel;

    % --- Save in trial_data ---
    curr_trial_data.(phase_str).competency = comp;
    curr_trial_data.(phase_str).reliability = rel;
    curr_trial_data.(phase_str).fish_caught = fish_caught;
    curr_trial_data.(phase_str).effective_fish = effective_fish;

    % Optional reward logic (e.g., reward if effective_fish ≥ 1.5)
    if effective_fish >= 1.5
        reward = 1;
    else
        reward = 0;
>>>>>>> Stashed changes
    end
    curr_trial_data.(phase_str).reward = reward;

    % Skip joystick, eye, and avatar logging
    curr_trial_data = concatenate_pos_data(curr_trial_data, [], -1, -1, [], [], phase_str);

    curr_trial_data.(phase_str).phase_end = tic;
    curr_trial_data.(phase_str).phase_duration = ...
        curr_trial_data.(phase_str).phase_end - curr_trial_data.(phase_str).phase_start;
end
