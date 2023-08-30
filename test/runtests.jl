using Revise
using BioPreprocessing
using Test
using ModelingToolkit
using DifferentialEquations
using Plots

# load the testing process dataset
include("load_processes.jl")
data = load_process(process_pathes)["EXPORTDATA_20230503_HR01_F20_2"]

@testset "BioPreprocessing.jl" begin
    # Write your tests here.
end


##### TEST K2S1 #####
function test_1()
    tx = data["online_preprocessed"].time
    tInd = data["offline_preprocessed"].time[data["metadata_processed"]["parameters"]["Ind_sample"]]
    Q_Sf(t) = BioPreprocessing.datafun(t, tx, data["online_preprocessed"].Q_S)
    Q_CO2f(t) = BioPreprocessing.datafun(t, tx, data["online_preprocessed"].Q_CO2)
    Q_O2f(t) = BioPreprocessing.datafun(t, tx, data["online_preprocessed"].Q_O2)
    V_Lf(t) = BioPreprocessing.datafun(t, tx, data["online_preprocessed"].V_L)
    tspan = (tx[1], tx[end])
    p = (Q_S = Q_Sf, 
        Q_CO2 = Q_CO2f,
        Q_O2 = Q_O2f,
        V_L = V_Lf,
        qSmax = (t) -> t <= tInd ? 1.25 : 0.247,
        kS = (t) -> 0.1
        )
    x0 = [0.55,20*1.5,0,0]
    prob = ODEProblem(K2S1m!,x0,tspan,p)
    sol = solve(prob)
    p=plot(sol, linewidth=2, xaxis = "t", label=["X" "S" "CO2" "O2"], layout=(2,2))
    display(p)
end
test_1()


#### Prototyping
tx = [1.0,2.0,3.0,4.0,7.0,8.0,9.0]
x = [0,0,0,0,0,0.05,0.05]
Feed(t) = BioPreprocessing.datafun(t,tx,x)
function growth!(dx, x, p, t)
    qSmax, kS, yXS, c_SR, F_in = p
    qS = qSmax * x[2] / (kS + x[2])
    dx[1] = yXS * qS * x[1]
    dx[2] = F_in(t) * c_SR - qS * x[1]
end
p = [1.2, 0.4, 0.5, 200, Feed]
x0 = [0.2, 10.0]
tspan = (0, 9)
prob = ODEProblem(growth!, x0, tspan, p)
sol = solve(prob)
plot(sol, linewidth=2, xaxis = "t", label=["X" "S"], layout=(1,2))