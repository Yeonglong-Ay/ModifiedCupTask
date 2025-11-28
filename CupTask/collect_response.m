function [choice, rt] = collect_response(kbQueueIndex, response_window, cue_onset_time, response_mapping)

choice = 'No Response';
rt = NaN;

KbQueueFlush(kbQueueIndex);
KbQueueStart(kbQueueIndex);

end_time = cue_onset_time + response_window;

while GetSecs < end_time
    [pressed, firstPress] = KbQueueCheck(kbQueueIndex);

    if pressed

        % ESC abort
        if firstPress(KbName('ESCAPE'))
            sca;
            error('Task aborted by user.');
        end

        % LEFT ARROW PRESSES LEFT OPTION
        if firstPress(KbName('LeftArrow'))
            choice = response_mapping.left_option;  
            rt = firstPress(KbName('LeftArrow')) - cue_onset_time;
            break;
        end

        % RIGHT ARROW PRESSES RIGHT OPTION
        if firstPress(KbName('RightArrow'))
            choice = response_mapping.right_option;
            rt = firstPress(KbName('RightArrow')) - cue_onset_time;
            break;
        end

    end
end

KbQueueStop(kbQueueIndex);