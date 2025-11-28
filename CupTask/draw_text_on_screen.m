function draw_text_on_screen(window, windowRect, text_string, text_color)
% Draws formatted text on the Psychtoolbox window, centered by default.
%
%   window: The Psychtoolbox window pointer.
%   windowRect: The rectangle defining the window's dimensions.
%   text_string: The string of text to display.
%   text_color: A [R G B] vector for the text color (e.g., [255 255 255] for white).

    % Get the center coordinates of the window
    [centerX, centerY] = RectCenter(windowRect);

    % Draw the formatted text
    % 'center' and 'center' arguments automatically center the text horizontally and vertically
    DrawFormattedText(window, text_string, 'center', 'center', text_color);

end