function delay_s = generate_jittered_delay(mean_delay, delay_range)
% Generates a jittered delay within a specified range. [1]

    min_delay = delay_range(1);
    max_delay = delay_range(2);
    
    % A simple linear jittering approach
    delay_s = min_delay + rand() * (max_delay - min_delay);
    
    % If a specific distribution (e.g., exponential for fMRI) is needed, implement that here.
    % The paper mentions "optimized for design efficiency [Dale, 1999]" which often implies
    % specific distributions, but for basic implementation, a uniform random distribution works.
end