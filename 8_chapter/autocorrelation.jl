using CSV, TimeSeries, Dates, Statistics, StatsBase, Measures, Plots; pyplot()

df = CSV.read("../data/oneOnEpsilonBlogs.csv",copycols = true)
n = size(df)[1]

tsA = TimeArray(Date.(df.Day,Dates.DateFormat("m/d/y")),df.Users)
tsB = moving(mean,tsA,7,padding = true)
tsC = TimeArray(timestamp(tsA), values(tsA) - values(tsB))
dayDiv = [filter((x)->!isnan(x), values(tsC)[dow .== d]) for d in 1:7]
dayMeans = mean.(dayDiv)
dow = dayofweek.(timestamp(tsA))
dailyCorrection = dayMeans[dow]
errs = filter((x)->!isnan(x),values(tsC) - dailyCorrection)
diffs = diff(errs)

lags = 1:50
acc = autocor(diffs,lags)

default(legend = false)
p1 = plot(diffs,xlabel="Day",ylabel="Difference Between Corrected Days")
p2 = plot(lags,acc,line=:stem,xlabel="Lag",ylabel="Autocorrelation")
plot(p1,p2,size=(900,400),margin = 5mm)