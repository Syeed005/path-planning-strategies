function[] = path(type)
    %% Random POI
    %clear;
    % network size: width (w) x height (h)
    % e.g., 1000 (m) x 1000 (m) by default
    w_begin= 0;
    w_end = 1000;
    h_begin = 0;
    h_end = 1000;
    
    % number of cells (subareas): 5-by-5, by default
    n_cell = 5;
    tot_cell = n_cell * n_cell;
    size_cell = w_end / n_cell;
    
    % n number of target points: 
    n = 100;
    
    % a set of rectangular subareas: 5-by-5
    x_ = linspace(w_begin, w_end - size_cell, n_cell);
    ux = [];
    for i = 1:n_cell
        ux = [ux, x_]; 
    end 
    ux = ux'
    
    y_ = ones(1, n_cell);  
    uy = [];
    for i = 1:n_cell
        uy = [uy, y_ .* (size_cell * (i - 1))];
    end 
    uy = uy'
    
    % n number of weights: w, n-by-1, uniform
    uw = ones(n, 1);
    
    % n number of weights: w, n-by-1, uniform
    % -- between the interval (w_begin, w_end) 
    w_begin = 0;
    w_end = 10;
    w = w_begin + (w_end - w_begin) .* rand(n, 1);
    
    % coverage area with radius, r (m), by default 100
    r = 100;
    
    % -----------------------
    % scale-free distribution 
    % -----------------------
    
    % clustering exponent, alpha
    alpha = 1.4;
    
    % population, pop  
    % -- initialize to zero
    pop = ones(tot_cell, 1) - 1;
    
    % probability, prob
    % -- initialize to zero
    prob = ones(tot_cell, 1) - 1;
    
    % a set of rectangular subareas, 25-by-5
    subarea_loc = [ux, uy];
    
    % the first target point is randomly assigned to one of cells
    pos_subarea = randi(tot_cell);
    
    pos_x = randi(size_cell) + ux(pos_subarea);
    pos_y = randi(size_cell) + uy(pos_subarea);
    pop(pos_subarea) = pop(pos_subarea) + 1;
    
    % the first target point - randomly assigned
    loc(1, 1) = pos_x;
    loc(1, 2) = pos_y;
    
    % generate all scale-free target points (x, y)
    for i = 2:n
        % calculate probabilities
        % -- sigma_pop = sum(pop, "all")
        sigma_pop = 0;
        for j = 1: tot_cell
            sigma_pop = sigma_pop + power(pop(j) + 1, alpha);
        end
        for j = 1: tot_cell
            prob(j) = power(pop(j) + 1, alpha) / sigma_pop; %power(sigma_pop, alpha);
            %prob(j) = power(pop(j), alpha) / power(sigma_pop, alpha)
        end
        % sanity check: if total probabilities are one
        %tot_prob = sum(prob, "all")
    
        % randomly choose one of subareas
        % -- pos_subarea = randi(tot_cell);
        
        % choose one of subareas based on the probability
        % -- generate a random and compare with cumulative probabilities 
        rand_prob = rand(1, 1); % generate between 0 to 1
        cumu_prob = 0; 
        for j = 1: tot_cell
            cumu_prob = cumu_prob + prob(j);
            if (cumu_prob >= rand_prob)
                pos_subarea = j;
                break
            end
        end
    
        % generate a position within the chosen subarea
        pos_x = randi(size_cell) + ux(pos_subarea);
        pos_y = randi(size_cell) + uy(pos_subarea);
        % increment the population of subarea
        pop(pos_subarea) = pop(pos_subarea) + 1;
    
        % add a new target point's (x, y) into a row
        loc = [loc; [pos_x, pos_y]];
    end    
    
    % draw target points
    plot(loc(:, 1), loc(:, 2), "rx")
    hold on
    
    set(gca, 'FontSize', 16);
    set(gca, 'xTick', [-200:200:1200]);
    set(gca, 'yTick', [-200:200:1200]);
    xlabel('X', 'FontSize', 16);
    ylabel('Y', 'FontSize', 16); 
    axis([-200 1200 -200 1200]);
    print -depsc sf_topo;
    savefig('sf_topo.fig');

    %% Clustering
    % calculate location dimension and create zero matrix
    dimensions = size(loc);
    col = dimensions(1);    
    un = zeros(col,5);
    
    % loop for calculating normal distance of each points and store the
    % result in col 3
    for i= 1:col    
        k = -1;
        point_i = [loc(i,1),loc(i,2)];
        for j = 1:col
            c_point = [loc(j,1),loc(j,2)];
            dist = norm(c_point - point_i);
            if dist <= 100
                k = k+1;
            end
        end
       un(i,1) =  loc(i,1);
       un(i,2) = loc(i,2);
       un(i,3) = k;
    end
    
    % sort descending by col 3
    so = sortrows(un,3,"descend");
    so_sim = size(so);
    so_col = so_sim(1);
    c_count = 0;
    
    % Calculate nearest neighbors and marked them 0 or 1 and store at col 4
    for i = 1:so_col
        if so(i,4) == 0
            for j = i+1:so_col
                d = norm([so(i,1),so(i,2)]-[so(j,1),so(j,2)]);
                if d <= 100
                    so(j,4) = 1;
                end
            end
            rectangle('Position', [so(i,1) - 100, so(i,2) - 100, 2 * 100, 2 * 100], ...
              'Curvature', [1, 1], 'EdgeColor', 'b', 'LineWidth', 0.5);
            plot(so(i, 1), so(i, 2), "b^");
            so(i,4) = 1;
            so(i,5) = 1;
            c_count = c_count + 1;
        end
    end
    title('Clustering');

    % create another matrix for only cluster center points
    ac = zeros(c_count,2);
    j= 1;
    for i = 1:so_col
        if (so(i,5)==1)
            ac(j,1) = so(i,1);
            ac(j,2) = so(i,2);
            %ac(j,3) = j;
            j= j +1;
        end
    end
    
    %% Random Path
    if (type == 0)
        % Shuffle rows of matrix
        r_ac = ac(randperm(size(ac,1)),:);
    
        start = [0,0];
        figure;
        % run loop to go the each row of the shuffled matrix and generate
        % line
        for i = 1:c_count    
            st_m = [start(1), r_ac(i,1)];
            en_m = [start(2),r_ac(i,2)];
            plot(st_m, en_m,"b^");
            plot(st_m, en_m,"red");
            hold on;
            start = [r_ac(i,1), r_ac(i,2)];
        end
        title('Random');
        set(gca, 'FontSize', 16);
        set(gca, 'xTick', [-200:200:1200]);
        set(gca, 'yTick', [-200:200:1200]);
        xlabel('X', 'FontSize', 16);
        ylabel('Y', 'FontSize', 16); 
        axis([-200 1200 -200 1200]);
    end

    %% NNF
    if (type == 1)
        c = c_count +1;
        % create 4 col zero matrix
        nac = zeros(c,4);
        for i=2:c
            nac(i,1) = ac(i-1,1);
            nac(i,2) = ac(i-1,2);
        end
        
        start = [nac(1,1),nac(1,2)];    
        figure;
        % two loop for measuring distance between one point to others
        for i=1:c_count
            nac_s= size(nac);
            nac_d = nac_s(1);
            for j=2:nac_d
                second = [nac(j,1),nac(j,2)];
                di = norm(start-second);
                nac(j,3) = ceil(di);
            end
            nac(1,:) = [];
            nac = sortrows(nac,3,"ascend");
            st_m = [start(1), nac(1,1)];
            en_m = [start(2), nac(1,2)];
            plot(st_m, en_m,"b^");
            plot(st_m, en_m,"red");
            hold on;
            start = [nac(1,1), nac(1,2)];
            %nac(1,:) = [];    
        end
        title('NNF');
        set(gca, 'FontSize', 16);
        set(gca, 'xTick', [-200:200:1200]);
        set(gca, 'yTick', [-200:200:1200]);
        xlabel('X', 'FontSize', 16);
        ylabel('Y', 'FontSize', 16); 
        axis([-200 1200 -200 1200]); 
    end

    %% DF
    if (type == 2)
        ac_sz = size(ac);
        ac_dm = ac_sz(1);
        start = [0, 0];
        figure;
        for i = 1:ac_dm
            st_m = [start(1), ac(i,1)];
            en_m = [start(2), ac(i,2)];
            plot(st_m, en_m,"b^");
            plot(st_m, en_m,"red");
            hold on;
            start = [ac(i,1), ac(i,2)];
        end
        title('DF');
        set(gca, 'FontSize', 16);
        set(gca, 'xTick', [-200:200:1200]);
        set(gca, 'yTick', [-200:200:1200]);
        xlabel('X', 'FontSize', 16);
        ylabel('Y', 'FontSize', 16); 
        axis([-200 1200 -200 1200]);
    end
end