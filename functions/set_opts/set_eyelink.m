function eye_opt = set_eyelink(visual_opt, test)
    eye_opt = struct();
    
    % Make sure eyelink is turned off explicitly
    eye_opt.eyelink_on = false;

    if test
        eye_opt.ENABLE = false;
        return
    end
end

