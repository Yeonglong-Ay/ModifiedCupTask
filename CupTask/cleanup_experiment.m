function cleanup_experiment(kbQueueIndex)
% Closes Psychtoolbox screen and cleans up keyboard queues.

    KbQueueRelease(kbQueueIndex);
    sca; % Closes screen and cleans up Psychtoolbox
    fprintf('Experiment cleanup complete.\n');
end