function IsLeoJob(jobName)
    if not jobName then return false end
    for i = 1, #Config.PoliceJobs do
        if Config.PoliceJobs[i] == jobName then
            return true
        end
    end
    return false
end
