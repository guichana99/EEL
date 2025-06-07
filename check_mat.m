% Specify the path to your trial file
<<<<<<< Updated upstream
trial_file = 'C:/Users/user/Documents/Python Scripts/EEL/Data/2025-06-05_Game1/trial_1.mat';
=======
trial_file = 'C:/Users/user/Documents/Python Scripts/EEL/premade_eels/trial_001.mat';
>>>>>>> Stashed changes

% List variables inside the file without loading
fprintf('Contents of %s:\n', trial_file);
whos('-file', trial_file);

% Load the .mat file into a struct
data = load(trial_file);

% Assuming main data is saved as 'curr_trial_data'
if isfield(data, 'curr_trial_data')
    trial_data = data.curr_trial_data;
    
    fprintf('\nFields in curr_trial_data:\n');
    disp(fieldnames(trial_data));
    
    % Display basic info if available
    if isfield(trial_data, 'trial_idx')
        fprintf('Trial index: %d\n', trial_data.trial_idx);
    end
    
    if isfield(trial_data, 'CHOICE')
        choice = trial_data.CHOICE.choice;
        fprintf('Choice made: %d\n', choice);
        
        if isfield(trial_data.CHOICE, 'reward')
            reward = trial_data.CHOICE.reward;
            fprintf('Reward: %d\n', reward);
        else
            fprintf('Reward field not found.\n');
        end
    else
        fprintf('CHOICE field not found in trial data.\n');
    end

    % --- Check COMPETENCY field ---
    if isfield(trial_data, 'COMPETENCY')
        comp = trial_data.COMPETENCY;
        fprintf('Competency info found:\n');
        if isfield(comp, 'left')
            fprintf('  Left competency: %f\n', comp.left);
        else
            fprintf('  Left competency field missing.\n');
        end
        if isfield(comp, 'right')
            fprintf('  Right competency: %f\n', comp.right);
        else
            fprintf('  Right competency field missing.\n');
        end
    else
        fprintf('COMPETENCY field not found in trial data.\n');
    end
else
    fprintf('curr_trial_data not found in file.\n');
end