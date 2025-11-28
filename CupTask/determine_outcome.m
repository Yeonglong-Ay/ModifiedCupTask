function [outcome, outcome_message] = determine_outcome(choice, trial_data, params)
% Determines the outcome of the gamble. [1]

    outcome = 0; % Default for 'Pass'
    outcome_message = 'You Passed! Outcome: $0';

    if strcmp(choice, 'Gamble')
        if strcmp(trial_data.predetermined_outcome, 'win')
            % For predetermined RA win trials [1]
            outcome = trial_data.gain_amount;
            outcome_message = sprintf('You Gambled and Won! +$%d', outcome);
        elseif strcmp(trial_data.predetermined_outcome, 'loss')
            % For predetermined RA loss trials (if implemented)
            outcome = trial_data.loss_amount;
            outcome_message = sprintf('You Gambled and Lost! %d', outcome);
        else
            % Random outcome for other trials (FG probe, RD exposure, other RA) [1]
            chosen_cup = randi(trial_data.num_cups);
            if chosen_cup == 1
                outcome = trial_data.gain_amount;
                outcome_message = sprintf('You Gambled and Won! +$%d', outcome);
            else
                outcome = trial_data.loss_amount;
                outcome_message = sprintf('You Gambled and Lost! %d', outcome);
            end
        end
    end
end