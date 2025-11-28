function [window, windowRect, kbQueueIndex, params] = setup_experiment()
% Initializes Psychtoolbox, opens screen, sets up keyboard, and prepares data logging.

    PsychDefaultSetup(2);
    Screen('Preference', 'SuppressAllWarnings', 1);  % Suppress startup warnings

    % Open display window
    screenNumber = max(Screen('Screens'));
    [window, windowRect] = PsychImaging('OpenWindow', screenNumber, [0 0 0]);

    % Text settings
    Screen('TextFont', window, 'Arial');
    Screen('TextSize', window, 40);
    Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

    % Define response keys (LEFT = "Gamble" or "Pass", depending on trial)
    params.left_key  = KbName('LeftArrow');
    params.right_key = KbName('RightArrow');

    % --- CREATE KEYBOARD QUEUE (this was missing) ---
    deviceIndex = -1;              % default keyboard
    KbQueueCreate(deviceIndex);    % create queue
    kbQueueIndex = deviceIndex;    % return queue index

    % Create output data file
    header = 'Run,Trial,GambleType,NumCups,GainAmt,LossAmt,Choice,RT,Outcome,DecisionStimOnset,FeedbackOnset\n';
    fid = fopen('results.csv', 'wt');
    fprintf(fid, header);
    fclose(fid);

    fprintf('Experiment setup complete.\n');
end