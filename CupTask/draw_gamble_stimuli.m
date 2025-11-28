function draw_gamble_stimuli(window, windowRect, num_cups, gain_amount, loss_amount)
% Draws the cups and amounts on the screen. [1]
    
    [centerX, centerY] = RectCenter(windowRect);
    
    % --- Cup drawing parameters ---
    cup_width_top = 80;
    cup_width_bottom = 60;
    cup_height = 100;
    cup_spacing = 150; % Spacing between cup centers
    
    cup_body_color = [100 100 100]; % Grey
    cup_rim_color = [200 200 200];  % Lighter grey for rim/outline
    cup_rim_thickness = 3;

    % Calculate total width needed for cups and center them
    total_display_width = num_cups * cup_spacing;
    start_x_center = centerX - total_display_width / 2 + cup_spacing / 2; % Center of the first cup

    for i = 1:num_cups
        current_x_center = start_x_center + (i-1) * cup_spacing;
        
        % Define cup shape (a trapezoid)
        % Vertices: [top_left_x, top_right_x, bottom_right_x, bottom_left_x;
        %            top_left_y, top_right_y, bottom_right_y, bottom_left_y]
        cup_vertices_x = [current_x_center - cup_width_top/2, ... % Top-left
                          current_x_center + cup_width_top/2, ... % Top-right
                          current_x_center + cup_width_bottom/2, ... % Bottom-right
                          current_x_center - cup_width_bottom/2]; % Bottom-left
        cup_vertices_y = [centerY - cup_height/2, ... % Top
                          centerY - cup_height/2, ... % Top
                          centerY + cup_height/2, ... % Bottom
                          centerY + cup_height/2]; % Bottom

        % Draw filled cup body
        Screen('FillPoly', window, cup_body_color, [cup_vertices_x; cup_vertices_y]');

        % Draw cup rim (using two polygons or lines, simplified here as just framing the top)
        % For a more detailed rim, you might draw a slightly larger polygon and then the inner body.
        % For simplicity, we'll draw a line across the top and thicker lines for sides if needed.
        Screen('DrawLine', window, cup_rim_color, cup_vertices_x(1), cup_vertices_y(1), cup_vertices_x(2), cup_vertices_y(2), cup_rim_thickness); % Top rim
        Screen('DrawLine', window, cup_rim_color, cup_vertices_x(2), cup_vertices_y(2), cup_vertices_x(3), cup_vertices_y(3), cup_rim_thickness); % Right side
        Screen('DrawLine', window, cup_rim_color, cup_vertices_x(3), cup_vertices_y(3), cup_vertices_x(4), cup_vertices_y(4), cup_rim_thickness); % Bottom
        Screen('DrawLine', window, cup_rim_color, cup_vertices_x(4), cup_vertices_y(4), cup_vertices_x(1), cup_vertices_y(1), cup_rim_thickness); % Left side


        % Display amount
        amount_y_pos = centerY + cup_height/2 + 30; % Position below the cup
        if i == 1
            amount_text = sprintf('+$%d', gain_amount); % Gain on first cup [1]
            text_color = [0 255 0]; % Green for gain
        else
            amount_text = sprintf('-$%d', abs(loss_amount)); % Loss on other cups [1]
            text_color = [255 0 0]; % Red for loss
        end
        
        % Center the text below each cup
        DrawFormattedText(window, amount_text, 'center', amount_y_pos, text_color, [], [], [], [], [], ...
                          [current_x_center - 50, amount_y_pos, current_x_center + 50, amount_y_pos + 40]);
    end
    
    % Optional: Add general instruction like "Decide: Gamble or Pass?"
    DrawFormattedText(window, 'Decide: Gamble or Pass?', 'center', windowRect(4)*0.8, [255 255 255]);
end