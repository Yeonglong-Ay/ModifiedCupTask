function draw_fixation_cross(window, windowRect)
% Draws a simple fixation cross.

    [centerX, centerY] = RectCenter(windowRect);
    fix_length = 20; % Length of each arm of the cross
    fix_width = 2;   % Thickness of the cross arms
    fix_color = [255 255 255]; % White

    Screen('DrawLine', window, fix_color, centerX - fix_length, centerY, centerX + fix_length, centerY, fix_width);
    Screen('DrawLine', window, fix_color, centerX, centerY - fix_length, centerX, centerY + fix_length, fix_width);
end