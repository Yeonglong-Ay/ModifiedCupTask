function all_trials_data = generate_all_trial_sequences(params)
% Generates all trial configurations for the entire experiment.
% This is where the core experimental design (FG, RA, RD, predetermined outcomes) is set up. [1]

    num_runs = params.num_runs;
    trials_per_run = params.trials_per_run;
    all_trials_data = cell(num_runs, trials_per_run);

    % Define all possible gamble parameter combinations and calculate EV
    % Example structure: {num_cups, gain_amount, loss_amount, type_string, EV}
    possible_gambles = {};
    for nc = params.num_cups_range(1):params.num_cups_range(2)
        for ga = params.gain_amount_range(1):params.gain_amount_range(2)
            prob_gain = 1/nc;
            prob_loss = (nc-1)/nc;
            ev = (prob_gain * ga) + (prob_loss * params.loss_amount);

            gamble_type = '';
            if abs(ev) < 0.1 % Define a small range for "fair"
                gamble_type = 'FG'; % Fair Gamble
            elseif ev > 0
                gamble_type = 'RA'; % Risk-Advantageous
            else
                gamble_type = 'RD'; % Risk-Disadvantageous
            end
            possible_gambles{end+1} = struct('num_cups', nc, 'gain_amount', ga, ...
                                               'loss_amount', params.loss_amount, 'type', gamble_type, 'ev', ev);
        end
    end

    % Filter for FG, RA, RD gambles
    fg_gambles = possible_gambles(cellfun(@(x) strcmp(x.type, 'FG'), possible_gambles));
    ra_gambles = possible_gambles(cellfun(@(x) strcmp(x.type, 'RA'), possible_gambles));
    rd_gambles = possible_gambles(cellfun(@(x) strcmp(x.type, 'RD'), possible_gambles));

    % Design the trial sequence as described: Exposure (RA/RD) followed by Probe (FG) [1]
    % Half of RA exposure trials are predetermined win/loss if gambled [1].
    % This is a simplified example; a real script would balance these carefully.
    for run_idx = 1:num_runs
        for trial_idx = 1:trials_per_run
            trial_struct = struct();

            % Alternate between exposure and probe, or use a more complex sequence
            if mod(trial_idx, 2) == 1 % Exposure trial
                % Randomly choose RA or RD exposure
                if rand() < 0.5
                    chosen_gamble_template = ra_gambles{randi(length(ra_gambles))};
                    trial_struct.predetermined_outcome = 'none'; % Default
                    % Implement predetermined win/loss for half of RA exposure trials if gambled [1]
                    % This requires careful tracking and balancing.
                    % For example: if this is an RA trial and it's one of the "predetermined" ones
                    % (e.g., first half of all RA trials in the run), set it.
                    % This is a simplified placeholder:
                    if rand() < 0.5 % Simulate ~half RA trials being predetermined
                        trial_struct.predetermined_outcome = 'win'; % Or 'loss'
                    end
                else
                    chosen_gamble_template = rd_gambles{randi(length(rd_gambles))};
                    trial_struct.predetermined_outcome = 'none'; % RD trials are truly random [1]
                end
                trial_struct.is_probe = false;
            else % Probe trial (FG)
                chosen_gamble_template = fg_gambles{randi(length(fg_gambles))};
                trial_struct.is_probe = true;
                trial_struct.predetermined_outcome = 'none'; % Probe trials are truly random [1]
            end

            trial_struct.num_cups = chosen_gamble_template.num_cups;
            trial_struct.gain_amount = chosen_gamble_template.gain_amount;
            trial_struct.loss_amount = chosen_gamble_template.loss_amount;
            trial_struct.gamble_type = chosen_gamble_template.type;
            trial_struct.ev = chosen_gamble_template.ev;

            % Add placeholder for other data points
            trial_struct.choice = 'N/A';
            trial_struct.rt = NaN;
            trial_struct.outcome = NaN;
            trial_struct.decision_stim_onset = NaN;
            trial_struct.feedback_onset = NaN;

            all_trials_data{run_idx, trial_idx} = trial_struct;
        end
        % Shuffle trials within a run, or ensure specific sequences as per design
        % all_trials_data(run_idx, :) = all_trials_data(run_idx, randperm(trials_per_run));
    end
    fprintf('Trial sequences generated.\n');
end