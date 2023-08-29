using CSV
using DataFrames
using YAML

base_data_path = "C:\\Users\\Fabian\\OneDrive\\Data\\LUCULLUS_EXPORT_DB\\"
process_pathes = readdir(base_data_path, join=true)

function load_processes(process_pathes)
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

data = load_processes(process_pathes)

P1 = data["EXPORTDATA_20230503_HR01_F20_2"]
P2 = data["EXPORTDATA_FMU_23_03"]