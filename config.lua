Config = {}

Config.jobRestriction = true  -- Change this to false if you dont want to use Job

Config.whiteListJobs = { -- Add/Change job only job here will be allowed to wash money
    'police',
    'ems',
    'mechanic',
}

Config.Min = 10   -- Minimum to start washing dirty money
Config.Max = 100000 -- Maximum to wash ur dirty money

Config.percentage = 0.60 -- How much clean money you will get in return

-- add more washing coord if you want.
Config.washing = {
    washing1 ={
        loc   = vector3(635.169, 2774.861, 41.851),

    },
    washing2 = {
        loc   = vector3(155.414, -1034.240, 28.370),
    },
    -- add more if you want

}

