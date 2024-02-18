Config = {}

Config.DiscordWebhook = 'https://discord.com/api/webhooks/1185775896032985149/1TjyyYtjoM2oi-tFY9H5-Hb0DP7KYvUFCn0ag7evqDSp3bb79-xPgoSNA3xlFUMMXSu8' -- use discord webhook

Config.jobRestriction = false  -- Change this to false if you dont want to use Job

Config.whiteListJobs = { -- Add/Change job only job here will be allowed to wash money
    'unemployed',
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

