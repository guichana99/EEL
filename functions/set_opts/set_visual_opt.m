function visual_opt = set_visual_opt(monkey)
    % Minimal visual_opt without Psychtoolbox Screen calls
    visual_opt.screen_color = [211, 211, 211];
    visual_opt.choice_color_avtr = [204, 153, 0];
    visual_opt.pursuit_color_avtr = [239, 191, 4];
    visual_opt.color_avtr_gray = [137, 137, 137];
    visual_opt.color_fish = [255, 165, 0];
    visual_opt.catch_animation_frames = 30;
    visual_opt.winPtr = -1;

    % Define fake screen size for calculations
    visual_opt.refresh_rate = 60; 
    visual_opt.wWth = 800; % example width
    visual_opt.wHgt = 600; % example height
    visual_opt.screen_center = [visual_opt.wWth / 2, visual_opt.wHgt / 2];

    % Define coordinate_window explicitly (e.g., center height)
    visual_opt.coordinate_window = visual_opt.wHgt / 2;

    % Corridor and game boundaries (same as your original logic)
    visual_opt.corridor_thickness = 50;
    visual_opt.gap_size = 200;
    visual_opt.corridor_color = [0, 0, 0];

    visual_opt.corridor_coord = [
        visual_opt.wWth / 2 - visual_opt.corridor_thickness, visual_opt.coordinate_window - visual_opt.corridor_thickness;
        visual_opt.wWth / 2 - visual_opt.corridor_thickness, visual_opt.coordinate_window + visual_opt.corridor_thickness;
        visual_opt.wWth / 2 + visual_opt.corridor_thickness, 1;
        visual_opt.wWth / 2 + visual_opt.corridor_thickness, visual_opt.wHgt
    ];

    % Eel movement range
    visual_opt.eel_rnd_range = 50; % Maximum random movement for eels

    % Left and right boundaries (simplified)
    safe_plase = 300;
    visual_opt.left_boundary = struct( ...
        'left', 0, ...
        'right', visual_opt.wWth / 2 - visual_opt.corridor_thickness, ...
        'top', safe_plase, ...
        'bottom', visual_opt.wHgt - safe_plase, ...
        'window_top', visual_opt.coordinate_window - visual_opt.gap_size / 2, ...
        'window_bottom', visual_opt.coordinate_window + visual_opt.gap_size / 2 ...
    );

    visual_opt.right_boundary = struct( ...
        'left', visual_opt.wWth / 2 + visual_opt.corridor_thickness, ...
        'right', visual_opt.wWth, ...
        'top', safe_plase, ...
        'bottom', visual_opt.wHgt - safe_plase ...
    );

    [visual_opt.left_center, visual_opt.right_center] = calculateCorridorCenters( ...
        visual_opt.wWth, visual_opt.wHgt, visual_opt.corridor_thickness);

    % Visual flags
    visual_opt.visualize_pot = false;
    visual_opt.alpha = 0;
    visual_opt.visualize_radius = false;
end

function [left_center, right_center] = calculateCorridorCenters(wWth, wHgt, corridor_thickness)
    left_x = (0 + (wWth / 2 - corridor_thickness)) / 2; % Left side center x
    right_x = ((wWth / 2 + corridor_thickness) + wWth) / 2; % Right side center x
    center_y = wHgt / 2; % Center y (same for both sides)

    left_center = [left_x, center_y];
    right_center = [right_x, center_y];
end