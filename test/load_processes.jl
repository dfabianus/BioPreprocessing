using CSV
using DataFrames
using YAML

base_data_path = "data/"
process_pathes = readdir(base_data_path, join=true)

function load_process(process_pathes=process_pathes)
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