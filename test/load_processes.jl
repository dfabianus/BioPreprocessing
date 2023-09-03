using CSV
using DataFrames
using YAML

base_data_path = "data/"
process_pathes = readdir(base_data_path, join=true)

function load_processes(process_pathes=process_pathes)
    processes = Dict()
    for process in process_pathes
        processes[splitpath(process)[end]] = Dict{Any,Any}("files" => readdir(process, join=true))
        all_files = readdir(process, join=true)
        for file in all_files
            if occursin("online_preprocessed.csv", file)
                processes[splitpath(process)[end]]["online_preprocessed"] = CSV.read(file, DataFrame, header=1)
            elseif occursin("offline_preprocessed.csv", file)
                processes[splitpath(process)[end]]["offline_preprocessed"] = CSV.read(file, DataFrame, header=1)
            elseif occursin("metadata_processed", file)
                processes[splitpath(process)[end]]["metadata_processed"] = YAML.load_file(file)
            end
        end
    end
    return processes
end

function write_processes(data)
    for (key,process) in data
        #process = deepcopy(process)
        signals_offline = process["offline_preprocessed"] 
        signals_online = process["online_preprocessed"]
        metaData = process["metadata_processed"]
        parameters = metaData["parameters"]
        
        # save offline data
        CSV.write(joinpath(base_data_path*key,"offline_preprocessed.csv"), signals_offline)
        
        # save online data
        CSV.write(joinpath(base_data_path*key,"online_preprocessed.csv"), signals_online)
        CSV.write(joinpath(base_data_path*key,"results_K2S1_monod_C.csv"), process["results_K2S1_monod_C"])
        CSV.write(joinpath(base_data_path*key,"results_K2S1_without_corr_C.csv"), process["results_K2S1_without_corr_C"])
        CSV.write(joinpath(base_data_path*key,"results_K2S1_no_kinetics_C.csv"), process["results_K2S1_no_kinetics_C"])
        CSV.write(joinpath(base_data_path*key,"results_K2S1_monod_DOR.csv"), process["results_K2S1_monod_DOR"])
        CSV.write(joinpath(base_data_path*key,"results_K2S1_without_corr_DOR.csv"), process["results_K2S1_without_corr_DOR"])
        CSV.write(joinpath(base_data_path*key,"results_K2S1_no_kinetics_DOR.csv"), process["results_K2S1_no_kinetics_DOR"])

        YAML.write_file(joinpath(base_data_path*key,"metadata_processed.yml"), metaData)
        
        println("Saving of process $key finished.")
    end
end