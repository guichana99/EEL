%% MAIN FILE

[visual_opt, device_opt, game_opt, eye_opt, save_directory] = initalize();

total_trials = 300; % Total number of trials

trial_onset = true;

time_info = struct();
time_info.exp_init_time = tic;
all_trials = initialize_all_trials_info();

% Initialize reliability mapping (if needed for logic)
[game_opt, all_trials] = initialize_reliability(game_opt, all_trials, visual_opt);

% Ensure save directory exists
if ~exist(save_directory, 'dir')
    mkdir(save_directory);
end

game_opt.save_directory = save_directory;

prev_eel_color = [];
prev_choice = -1;

if exist(save_directory, 'dir')
    prev_trial_idx = get_last_saved_trial(save_directory);
else
    prev_trial_idx = 0;
end

%current_session = floor(prev_trial_idx / trials_per_session) + 1;

% *** No visual start screen ***
fprintf('Experiment starting from trial %d\n', prev_trial_idx + 1);

while trial_onset && prev_trial_idx < total_trials
    time_info = initialize_time_info(time_info);
    time_info.trial_init_time = tic;
    
    curr_trial_data = struct();
    curr_trial_data.trial_idx = prev_trial_idx + 1;
    
    if curr_trial_data.trial_idx > 25
        visual_opt.visualize_pot = false; % kept for compatibility; no visuals used
    end
    
    % ITI phase (no visual)
    [curr_trial_data, game_opt] = phase_iti(curr_trial_data, visual_opt, game_opt, eye_opt, device_opt, true, 'ITI1'); 
    
    % REPORT phase, with previous choice and eel color
    curr_trial_data = phase_report(curr_trial_data, visual_opt, game_opt, eye_opt, device_opt, 'REPORT', prev_choice, prev_eel_color);

    % ITI phase (no visual)
    [curr_trial_data, game_opt] = phase_iti(curr_trial_data, visual_opt, game_opt, eye_opt, device_opt, false, 'ITI2'); 
    
    % CHOICE phase - replace joystick input with your agent's input or keyboard logic
    curr_trial_data = phase_choice(curr_trial_data, visual_opt, game_opt, eye_opt, 'CHOICE', device_opt);
    
    % Store current choice for next trial
    if isfield(curr_trial_data, 'CHOICE') && isfield(curr_trial_data.CHOICE, 'choice')
        prev_choice = curr_trial_data.CHOICE.choice;
        
        [left_eel_color, right_eel_color] = get_eel_colors(curr_trial_data);
        
        if prev_choice == 1
            prev_eel_color = left_eel_color;
        elseif prev_choice == 2
            prev_eel_color = right_eel_color;
        else
            prev_eel_color = [];
        end
    else
        prev_choice = -1;
        prev_eel_color = [];
    end
    
    % --- ADD: Save competency info into curr_trial_data ---
    if isfield(curr_trial_data, 'eels')
        left_competency = NaN;
        right_competency = NaN;
        for i = 1:length(curr_trial_data.eels)
            if curr_trial_data.eels(i).initial_side == 1 && isfield(curr_trial_data.eels(i), 'competency')
                left_competency = curr_trial_data.eels(i).competency;
            elseif curr_trial_data.eels(i).initial_side == 2 && isfield(curr_trial_data.eels(i), 'competency')
                right_competency = curr_trial_data.eels(i).competency;
            end
        end
        curr_trial_data.COMPETENCY.left = left_competency;
        curr_trial_data.COMPETENCY.right = right_competency;
    else
        curr_trial_data.COMPETENCY.left = NaN;
        curr_trial_data.COMPETENCY.right = NaN;
    end
    
    if curr_trial_data.CHOICE.choice ~= -1
        % Print reward result (no pursuit, no visuals)
        fprintf('Trial %d: Choice = %d, Reward = %d\n', ...
            curr_trial_data.trial_idx, ...
            curr_trial_data.CHOICE.choice, ...
            curr_trial_data.CHOICE.reward);
    else
        % Instead of gray screen, just print waiting message
        fprintf('No choice made on trial %d\n', curr_trial_data.trial_idx);
    end
    
    % Save trial data
    try
        full_file_path = fullfile(save_directory, ['trial_', num2str(curr_trial_data.trial_idx), '.mat']);
        save(full_file_path, 'curr_trial_data');
    catch
        warning('Unable to save trial data to file: %s', full_file_path);
    end
    
    prev_trial_idx = curr_trial_data.trial_idx;
end

fprintf('Experiment complete!\n');

% No eyelink or screen close calls

% Helper functions unchanged here
function [left_eel_color, right_eel_color] = get_eel_colors(curr_trial_data)
    left_eel_color = [];
    right_eel_color = [];
    for i = 1:length(curr_trial_data.eels)
        if curr_trial_data.eels(i).initial_side == 1
            left_eel_color = curr_trial_data.eels(i).eel_col;
        elseif curr_trial_data.eels(i).initial_side == 2
            right_eel_color = curr_trial_data.eels(i).eel_col;
        end
    end
end

function [next_trial_idx] = get_last_saved_trial(save_directory)
    try
        files = dir(fullfile(save_directory, 'trial_*.mat'));
        if isempty(files)
            next_trial_idx = 0;
            return;
        end
        trial_nums = zeros(length(files), 1);
        for i = 1:length(files)
            filename = files(i).name;
            trial_nums(i) = str2double(regexprep(filename, 'trial_|.mat', ''));
        end
        last_trial_idx = max(trial_nums);
        next_trial_idx = last_trial_idx;
    catch
        warning('Error reading save directory, starting from trial 1');
        next_trial_idx = 0;
    end
end