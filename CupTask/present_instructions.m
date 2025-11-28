function present_instructions(window, windowRect, params)
% Displays the task instructions to the participant.
%
%   window: The Psychtoolbox window pointer.
%   windowRect: The rectangle defining the window's dimensions.
%   params: Structure containing experiment parameters (for dynamic text).

    text_color = [255 255 255]; % White text
    
    % Define the instruction text as a cell array for multi-line display
    instructions_text = {
        'Welcome to the Cups Task!',
        '',
        'In this game, you will see a series of gambles presented as cups.',
        sprintf('One cup contains a potential gain (between $%d and $%d).', params.gain_amount_range(1), params.gain_amount_range(2)),
        sprintf('All other cups contain a small loss (-$%d).', abs(params.loss_amount)),
        '',
        'Your goal is to decide whether to **GAMBLE** or **PASS** for each situation.',
        '',
        'Try to earn as much money as possible!',
        '',
        'Press any key to begin.'
    };

    % Join the lines of text with newline characters for DrawFormattedText
    full_instruction_string = strjoin(instructions_text, '\n');

    % Draw the instructions on the screen
    DrawFormattedText(window, full_instruction_string, 'center', 'center', text_color);
    Screen('Flip', window);

    % Wait for the participant to press any key to continue
        while true
        [keyIsDown,~,keyCode] = KbCheck;
        if keyIsDown
            if keyCode(KbName('ESCAPE'))
                sca;
                error('Task aborted by user.');
            else
                break;  % Any other key continues
            end
        end
    end
    
    % Clear the screen after instructions
    Screen('FillRect', window, [0 0 0]);
    Screen('Flip', window);
end