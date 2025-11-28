function feedback_onset_time = present_feedback(window, windowRect, outcome_message, feedback_duration)
% Displays the outcome feedback. [1]

    text_color = [255 255 255]; % White
    if contains(outcome_message, 'Won')
        text_color = [0 255 0]; % Green for win
    elseif contains(outcome_message, 'Lost')
        text_color = [255 0 0]; % Red for loss
    end

    DrawFormattedText(window, outcome_message, 'center', 'center', text_color);
    feedback_onset_time = Screen('Flip', window);
    WaitSecs(feedback_duration); % Feedback duration is 0.5s [1]
    
    % Clear screen after feedback
    Screen('FillRect', window, [0 0 0]);
    Screen('Flip', window);
end