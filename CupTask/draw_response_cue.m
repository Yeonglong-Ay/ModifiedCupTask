function [cue_onset_time, response_mapping] = draw_response_cue(window, windowRect)
% Presents the 'Gamble' and 'Pass' cues, randomized left/right. [1]

    [centerX, centerY] = RectCenter(windowRect);
    response_mapping = struct();
    text_color = [255 255 255]; % White

    % Randomize position of 'Gamble' and 'Pass' [1]
    if rand() < 0.5
        left_text = 'Gamble';
        right_text = 'Pass';
    else
        left_text = 'Pass';
        right_text = 'Gamble';
    end
    
    response_mapping.left_option = left_text;
    response_mapping.right_option = right_text;

    DrawFormattedText(window, left_text, centerX - 200, centerY, text_color);
    DrawFormattedText(window, right_text, centerX + 100, centerY, text_color);

    cue_onset_time = Screen('Flip', window);
end