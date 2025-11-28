% Main script to run the Modified Cups Task

clear all;
close all;
clc;

% --- 1. Experiment Setup ---
% Initialize Psychtoolbox, screen, keyboard, and data file
[window, windowRect, kbQueueIndex, params] = setup_experiment();

% --- 2. Load Task Parameters and Stimuli ---
% Define all gamble configurations, timings, and trial sequences
% This would typically involve pre-calculating Expected Values (EV)
% for Fair Gambles (FG), Risk-Advantageous (RA), and Risk-Disadvantageous (RD) [1].
% Also, define predetermined outcomes for RA exposure trials [1].
% For simplicity, we'll store basic params directly here, but
% in a real script, this would be more complex, possibly from a file.

% Timing parameters (jittered delays) [1]
params.decision_delay_mean = 10;    params.decision_delay_range = [5, 10];
params.post_response_delay_mean = 4; params.post_response_delay_range = [2.5, 6];
params.iti_delay_mean = 2.5;       params.iti_delay_range = [1, 4];
params.response_window = 5; % seconds [1]
params.feedback_duration = 3; % seconds [1]

% Gamble parameters [1]
params.num_cups_range = [3, 11];
params.gain_amount_range = [4, 8]; % $4 to $8
params.loss_amount = -1; % -$1

% Trial structure [1]
params.num_runs = 2;
params.trials_per_run = 6
; % 72
params.exposure_types = {'RA', 'RD'}; % Risk-Advantageous, Risk-Disadvantageous
params.probe_type = 'FG'; % Fair Gamble

% Pre-generate all trial sequences and gamble parameters for all runs
% This is a complex step, crucial for balancing trial types and pre-determining outcomes.
% For half of the RA exposure trials, outcomes are predetermined if participant gambles [1].
% This function would create a list of trial structures.
all_trials_data = generate_all_trial_sequences(params);

% Initialize overall participant score
current_score = 0;

% --- Present Instructions ---
present_instructions(window, windowRect, params); 

% --- 3. Experiment Loop (Runs and Trials) ---
for run_idx = 1:params.num_runs
    fprintf('Starting Run %d...\n', run_idx);

    % Present start screen for run, wait for scanner trigger (e.g., 's')
    draw_text_on_screen(window, windowRect, sprintf('Run %d: Press ''s'' to start when ready.', run_idx), [255 255 255]);
    Screen('Flip', window);
    KbWait(); % Wait for any key press, or use KbQueue for specific trigger

    % --- Add ESC or 's' wait loop here ---
    while true
        [keyIsDown,~,keyCode] = KbCheck;
        if keyIsDown
            if keyCode(KbName('ESCAPE'))
                sca;
                error('Task aborted by user.');
            elseif keyCode(KbName('s'))
                break;   % Begin the run
            end
        end
    end

    run_start_time = GetSecs; % For fMRI synchronization

    for trial_idx = 1:params.trials_per_run
        trial_data = all_trials_data{run_idx, trial_idx};

        % --- a. Jittered Inter-Trial Interval (ITI) ---
        iti_duration = generate_jittered_delay(params.iti_delay_mean, params.iti_delay_range);
        draw_fixation_cross(window, windowRect); % Show fixation cross during ITI
        Screen('Flip', window);
        WaitSecs(iti_duration);

        % --- b. Decision Stage ---
        % Present gamble stimuli (cups, gain/loss amounts) [1]
        draw_gamble_stimuli(window, windowRect, trial_data.num_cups, trial_data.gain_amount, params.loss_amount);
        trial_data.decision_stim_onset = Screen('Flip', window);

        % Jittered delay for contemplation [1]
        decision_delay = generate_jittered_delay(params.decision_delay_mean, params.decision_delay_range);
        WaitSecs(decision_delay);

        % --- c. Response Stage ---
        % Present response cue ('Gamble' / 'Pass') with randomized position [1]
        [response_cue_onset, response_mapping] = draw_response_cue(window, windowRect);
        
        % Collect response within a time limit [1]
        [choice, rt] = collect_response(kbQueueIndex, params.response_window, response_cue_onset, response_mapping);
        
        trial_data.choice = choice;
        trial_data.rt = rt;

        % If no response, participant loses $1 [1]
        if strcmp(choice, 'No Response')
            current_score = current_score + params.loss_amount;
            outcome_message = 'No Response! You Lost $1!'; % Explicitly state the loss
            trial_data.outcome = params.loss_amount;
        else
            % Jittered delay post-response [1]
            post_response_delay = generate_jittered_delay(params.post_response_delay_mean, params.post_response_delay_range);
            draw_fixation_cross(window, windowRect); % Clear screen with fixation during delay
            Screen('Flip', window);
            WaitSecs(post_response_delay);

            % --- d. Outcome Determination ---
            [outcome, outcome_message] = determine_outcome(choice, trial_data, params);
            current_score = current_score + outcome;
            trial_data.outcome = outcome;
        end

        % --- e. Feedback Stage ---
        % Present feedback (outcome) [1]
        feedback_onset = present_feedback(window, windowRect, outcome_message, params.feedback_duration);
        trial_data.feedback_onset = feedback_onset;
        
        % --- f. Log Data ---
        log_trial_data(trial_idx, run_idx, trial_data, 'results.csv'); % Save to CSV
    end % End trial loop
end % End run loop

% --- 4. End of Experiment ---
% Thank participant and display final score (optional)
draw_text_on_screen(window, windowRect, sprintf('Thank You for Participating! Your final score is: $%.2f', current_score), [255 255 255]);
Screen('Flip', window);
WaitSecs(2); % Display for 2 seconds

% --- 5. Cleanup ---
cleanup_experiment(kbQueueIndex);
fprintf('Experiment finished. Final score: $%.2f\n', current_score);

% Post-experiment debriefing: Check if participants noticed the manipulation [1]
% This would be a verbal questionnaire administered by the experimenter.