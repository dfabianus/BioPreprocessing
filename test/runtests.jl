using Revise
using BioPreprocessing
using Test
using DifferentialEquations

# load the testing process dataset
include("load_processes.jl")
data = load_processes(process_pathes)

data["EXPORTDATA_20230503_HR01_F20_2"]["metadata_processed"]["parameters"]["qSmax_0"] = 1.20
data["EXPORTDATA_20230503_HR01_F20_2"]["metadata_processed"]["parameters"]["qSmax_1"] = 0.247
data["EXPORTDATA_20230503_HR01_F20_2"]["metadata_processed"]["parameters"]["x0"] = [0.45, 19*1.5, 0, 0]
data["EXPORTDATA_20230503_HR01_F20_2"]["metadata_processed"]["parameters"]["x1"] = [10*data["EXPORTDATA_20230503_HR01_F20_2"]["online_preprocessed"].V_L[1], 0, 0, 0]


for (key, process) in data
    results_K2S1_monod = BioPreprocessing.calc_K2S1C(process["online_preprocessed"].time[process["online_preprocessed"].time.>7],
                        process["online_preprocessed"].Q_S[process["online_preprocessed"].time.>7],
                        process["online_preprocessed"].Q_CO2[process["online_preprocessed"].time.>7],
                        process["online_preprocessed"].Q_O2[process["online_preprocessed"].time.>7],
                        process["online_preprocessed"].V_L[process["online_preprocessed"].time.>7],
                        process["metadata_processed"]["parameters"]["x1"],
                        qSmax_0 = process["metadata_processed"]["parameters"]["qSmax_0"],
                        qSmax_1 = process["metadata_processed"]["parameters"]["qSmax_1"],
                        kS_0 = 0.3,
                        )

    results_K2S1_without_corr = BioPreprocessing.calc_K2S1C(process["online_preprocessed"].time[process["online_preprocessed"].time.>7],
                        process["online_preprocessed"].Q_S[process["online_preprocessed"].time.>7],
                        process["online_preprocessed"].Q_CO2[process["online_preprocessed"].time.>7],
                        process["online_preprocessed"].Q_O2[process["online_preprocessed"].time.>7],
                        process["online_preprocessed"].V_L[process["online_preprocessed"].time.>7],
                        process["metadata_processed"]["parameters"]["x1"],
                        qSmax_0 = process["metadata_processed"]["parameters"]["qSmax_0"],
                        qSmax_1 = process["metadata_processed"]["parameters"]["qSmax_0"],
                        kS_0 = 0.3,
                        )

    results_K2S1_no_kinetics = BioPreprocessing.calc_K2S1C(process["online_preprocessed"].time[process["online_preprocessed"].time.>7],
                        process["online_preprocessed"].Q_S[process["online_preprocessed"].time.>7],
                        process["online_preprocessed"].Q_CO2[process["online_preprocessed"].time.>7],
                        process["online_preprocessed"].Q_O2[process["online_preprocessed"].time.>7],
                        process["online_preprocessed"].V_L[process["online_preprocessed"].time.>7],
                        process["metadata_processed"]["parameters"]["x1"],
                        qSmax_0 = process["metadata_processed"]["parameters"]["qSmax_0"],
                        qSmax_1 = process["metadata_processed"]["parameters"]["qSmax_0"],
                        kS_0 = 0.3,
                        )
    process["results_K2S1_monod_C"] = results_K2S1_monod
    process["results_K2S1_without_corr_C"] = results_K2S1_without_corr
    process["results_K2S1_no_kinetics_C"] = results_K2S1_no_kinetics
end

for (key, process) in data
    results_K2S1_monod = BioPreprocessing.calc_K2S1DOR(process["online_preprocessed"].time[process["online_preprocessed"].time.>7],
                        process["online_preprocessed"].Q_S[process["online_preprocessed"].time.>7],
                        process["online_preprocessed"].Q_CO2[process["online_preprocessed"].time.>7],
                        process["online_preprocessed"].Q_O2[process["online_preprocessed"].time.>7],
                        process["online_preprocessed"].V_L[process["online_preprocessed"].time.>7],
                        process["metadata_processed"]["parameters"]["x1"],
                        qSmax_0 = process["metadata_processed"]["parameters"]["qSmax_0"],
                        qSmax_1 = process["metadata_processed"]["parameters"]["qSmax_1"],
                        kS_0 = 0.3,
                        )

    results_K2S1_without_corr = BioPreprocessing.calc_K2S1DOR(process["online_preprocessed"].time[process["online_preprocessed"].time.>7],
                        process["online_preprocessed"].Q_S[process["online_preprocessed"].time.>7],
                        process["online_preprocessed"].Q_CO2[process["online_preprocessed"].time.>7],
                        process["online_preprocessed"].Q_O2[process["online_preprocessed"].time.>7],
                        process["online_preprocessed"].V_L[process["online_preprocessed"].time.>7],
                        process["metadata_processed"]["parameters"]["x1"],
                        qSmax_0 = process["metadata_processed"]["parameters"]["qSmax_0"],
                        qSmax_1 = process["metadata_processed"]["parameters"]["qSmax_0"],
                        kS_0 = 0.3,
                        )

    results_K2S1_no_kinetics = BioPreprocessing.calc_K2S1DOR(process["online_preprocessed"].time[process["online_preprocessed"].time.>7],
                        process["online_preprocessed"].Q_S[process["online_preprocessed"].time.>7],
                        process["online_preprocessed"].Q_CO2[process["online_preprocessed"].time.>7],
                        process["online_preprocessed"].Q_O2[process["online_preprocessed"].time.>7],
                        process["online_preprocessed"].V_L[process["online_preprocessed"].time.>7],
                        process["metadata_processed"]["parameters"]["x1"],
                        qSmax_0 = process["metadata_processed"]["parameters"]["qSmax_0"],
                        qSmax_1 = process["metadata_processed"]["parameters"]["qSmax_0"],
                        kS_0 = 0.3,
                        )
    process["results_K2S1_monod_DOR"] = results_K2S1_monod
    process["results_K2S1_without_corr_DOR"] = results_K2S1_without_corr
    process["results_K2S1_no_kinetics_DOR"] = results_K2S1_no_kinetics
end



write_processes(data)

@testset "BioPreprocessing.jl" begin
    # Write your tests here.
end


##### TEST K2S1 #####
# function test_1()
#     tx = data["online_preprocessed"].time
#     tInd = data["offline_preprocessed"].time[data["metadata_processed"]["parameters"]["Ind_sample"]]
#     Q_Sf(t) = BioPreprocessing.datafun(t, tx, data["online_preprocessed"].Q_S)
#     Q_CO2f(t) = BioPreprocessing.datafun(t, tx, data["online_preprocessed"].Q_CO2)
#     Q_O2f(t) = BioPreprocessing.datafun(t, tx, data["online_preprocessed"].Q_O2)
#     Q_known = [Q_Sf, Q_CO2f, Q_O2f]
#     V_Lf(t) = BioPreprocessing.datafun(t, tx, data["online_preprocessed"].V_L)
#     tspan = (tx[1], tx[end])
#     p = (Q_known = Q_known,
#         V_L = V_Lf,
#         qSmax = (t) -> t <= tInd ? 1.25 : 0.247,
#         kS = (t) -> 0.1
#         )
#     x0 = [0.55,20*1.5,0,0]
#     prob = ODEProblem(K2S1m!,x0,tspan,p)
#     return solve(prob)
    #p=plot(sol, linewidth=2, xaxis = "t", label=["X" "S" "CO2" "O2"], layout=(2,2))
    #display(p)
    
# data["online_project"] = deepcopy(data["online_preprocessed"])

results_K2S1_monod = BioPreprocessing.calc_K2S1(data["online_preprocessed"].time,
                        data["online_preprocessed"].Q_S,
                        data["online_preprocessed"].Q_CO2,
                        data["online_preprocessed"].Q_O2,
                        data["online_preprocessed"].V_L,
                        [0.45, 20*1.5, 0, 0],
                        qSmax_0 = 1.15,
                        qSmax_1 = 0.247,
                        kS_0 = 0.3,
                        )

results_K2S1_without_corr = BioPreprocessing.calc_K2S1(data["online_preprocessed"].time,
                        data["online_preprocessed"].Q_S,
                        data["online_preprocessed"].Q_CO2,
                        data["online_preprocessed"].Q_O2,
                        data["online_preprocessed"].V_L,
                        [0.45, 20*1.5, 0, 0],
                        qSmax_0 = 1.15,
                        qSmax_1 = 1.15,
                        kS_0 = 0.3,
                        )

results_K2S1_no_kinetics = BioPreprocessing.calc_K2S1(data["online_preprocessed"].time[data["online_preprocessed"].time.>7],
                        data["online_preprocessed"].Q_S[data["online_preprocessed"].time.>7],
                        data["online_preprocessed"].Q_CO2[data["online_preprocessed"].time.>7],
                        data["online_preprocessed"].Q_O2[data["online_preprocessed"].time.>7],
                        data["online_preprocessed"].V_L[data["online_preprocessed"].time.>7],
                        [17.5, 0, 0, 0],
                        qSmax_0 = 1.15,
                        qSmax_1 = 1.15,
                        kS_0 = 0.3,
                        )

data["results_K2S1_monod"] = results_K2S1_monod
data["results_K2S1_without_corr"] = results_K2S1_without_corr
data["results_K2S1_no_kinetics"] = results_K2S1_no_kinetics

pa=plot(results_K2S1_monod.timestamp,results_K2S1_monod.K2S1_cX)
plot!(results_K2S1_monod.timestamp,results_K2S1_monod.K2S1_cS)
plot!(results_K2S1_without_corr.timestamp, results_K2S1_without_corr.K2S1_cX)
plot!(results_K2S1_without_corr.timestamp, results_K2S1_without_corr.K2S1_cS)
plot!(results_K2S1_no_kinetics.timestamp, results_K2S1_no_kinetics.K2S1_cX)
plot!(results_K2S1_no_kinetics.timestamp, results_K2S1_no_kinetics.K2S1_cS)

pb=plot(data["online_project"].time,data["online_project"].K2S1_rX./data["online_project"].K2S1_mX,
ylims=(0,1))
plot(pa,pb,layout=(2,1))

#Yields
pc=plot(data["online_project"].time,-data["online_project"].K2S1_rX./data["online_project"].K2S1_rS,
ylims=(0,1))
plot!(data["online_preprocessed"].time[data["online_preprocessed"].time.>7],
-results_K2S1_without_corr.K2S1_rX./results_K2S1_without_corr.K2S1_rS)
savefig(pc,"yield_fig.pdf")
#h-value
pd=plot(data["online_project"].time,data["online_project"].K2S1_h, ylims=(0,0.0004))
plot!(data["online_preprocessed"].time[data["online_preprocessed"].time.>7],
results_K2S1_without_corr.K2S1_h)
savefig(pd,"h_fig.pdf")

#Yields
pc=plot(results_K2S1_monod.timestamp,
    -results_K2S1_monod.K2S1_rX./results_K2S1_monod.K2S1_rS,
    ylims=(0,1))
plot!(results_K2S1_without_corr.timestamp,
    -results_K2S1_without_corr.K2S1_rX./results_K2S1_without_corr.K2S1_rS)
plot!(results_K2S1_no_kinetics.timestamp,
    -results_K2S1_no_kinetics.K2S1_rX./results_K2S1_no_kinetics.K2S1_rS)
savefig(pc,"yield_fig.pdf")
