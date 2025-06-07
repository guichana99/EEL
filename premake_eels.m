% This script generates and saves premade eel data for use in RL

clear; clc;

% ======== CONFIGURATION ========
num_trials = 10;  % Adjust this as needed
output_folder = 'premade_eels';  % Folder to save .mat files

% Create folder if it doesn't exist
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

% Load the real configs here, assuming set_game_opt.m returns or sets these variables
[game_opt] = set_game_opt();  

% Define visual_opt here or load from a similar function/script
visual_opt.wHgt = 800;
visual_opt.wWth = 1280;
visual_opt.eel_rnd_range = 50;
visual_opt.coordinate_window = 300;

game_opt.premade_eels = false;  % keep false when generating premade eels
game_opt.eels_src = output_folder;  % point to output folder for later loading

for trial_idx = 1:num_trials
    curr_trial_data.trial_idx = trial_idx;
    curr_trial_data = generate_eels_info(curr_trial_data, visual_opt, game_opt);
    save(fullfile(output_folder, sprintf('trial_%03d.mat', trial_idx)), 'curr_trial_data');
end

fprintf('Done generating %d premade eel trials in %s/\n', num_trials, output_folder);