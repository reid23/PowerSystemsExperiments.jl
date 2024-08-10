# push!(LOAD_PATH,"../src/")
using Pkg; 
Pkg.activate(joinpath(@__DIR__, ".."))
using PowerSystems
using PowerSimulationsDynamics


using Documenter, PowerSystemsExperiments
DocMeta.setdocmeta!(PowerSystemsExperiments, :DocTestSetup, :(using PowerSystemsExperiments; using Pkg; Pkg.activate(".."); using PowerSystems; using PowerSimulationsDynamics); recursive=true)
makedocs(
    sitename="PowerSystemsExperiments.jl", 
    modules=[PowerSystemsExperiments],
    pages = [
        "index.md",
        "Example" => [
            "setup.md",
            "running.md",
            "saving.md",
            "plotting.md",
        ],
        "api_reference.md"
    ],
    format = Documenter.HTML(size_threshold=10000000),
    # draft = true,
)