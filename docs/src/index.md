# PowerSystemsExperiments.jl

## Overview
This package is for running experiments with NREL Sienna's [PowerSimulationsDynamics.jl](https://nrel-sienna.github.io/PowerSimulationsDynamics.jl/stable/). It provides two main utilities:
- [`GridSearchSys`](@ref) for running simulations with high-dimensional parameter sweeps and organizing the resulting data
- [`makeplots`](@ref) for visualizing high-dimensional data with interactive plots.

!!! note "Under Development"
    This package is still under development. It is certainly functional, but only at a pre-release stage. There will be bugs and changes, espeically on the plotting side, as development continues. If you encounter bugs, please create issues on GitHub, and if you want to help out, please feel free to make changes and pull requests!

A `GridSearchSys` struct holds all the information needed to organize, run, and save a large number of PSID simulations.
```julia
mutable struct GridSearchSys
    base::System
    header::Vector{AbstractString}
    sysdict::Dict{Vector{Any}, Function}
    results_header::Vector{String}
    results_getters::Vector{Function}
    df::DataFrame
    chunksize::Union{Int, Float64}
    hfile::String
end
```
It has a `base` system, a bunch of variables to store how modifications are made to the system, and a few more variables to specify how to save results.
### Installation
To install, simply run
```julia
pkg> add "https://github.com/reid23/PowerSystemsExperiments.jl.git"
```
### Workflow
Here's how to use this package:
1. use the constructor the create a `GridSearchSys` with all injector variations required
2. add sweeps of various parameters using `add_generic_sweep!` or one of the specific methods supplied
3. add results to track with `add_result!` and the [Results Getters](@ref)
4. run simulations with `execute_sims!`, creating a DataFrame with all the results
5. if not done already, save to file with `save_serde_data`
6. load your results back with `load_serde_data` (if needed)
7. add any more results you want to see with `add_result!`
8. Analyze the data with `makeplots` or however you like (`makeplots` is still very much pre-release)

## (Super) Quick Start
Do you just need to run a simulation or two, and don't have time to really understand your code?

Are you a proud owner of the Stack Overflow copy-paste keyboard?

Do you enjoy copy-pasting example code without reading it because you think it'll save you time (you know it won't)?

Try this.

```@example
using Pkg; Pkg.activate("../..") # hide
using PlotlyDocumenter # hide
using Downloads
using PowerSystems
using PowerSimulationsDynamics
using PowerSystemsExperiments
const PSE = PowerSystemsExperiments
path_to_my_raw_file = Downloads.download("https://raw.githubusercontent.com/gecolonr/loads/main/data/raw_data/WSCC_9bus.raw"); # hide
mv(path_to_my_raw_file, path_to_my_raw_file*".raw") # hide
path_to_my_raw_file *= ".raw" # hide

# some machines for us to use
gfm_inj() = DynamicInverter("GFM", 1.0,
    PSE.converter_high_power(),
    PSE.VSM_outer_control(), 
    PSE.GFM_inner_control(), 
    PSE.dc_source_lv(),
    PSE.pll(), PSE.filt(), 
)
sm_inj() = DynamicGenerator("SM", 1.0, 
    PSE.AF_machine(),
    PSE.shaft_no_damping(), 
    PSE.avr_type1(),
    PSE.tg_none(), PSE.pss_none(),
)

# construct GridSearchSys
gss = GridSearchSys(
    System(path_to_my_raw_file),
    [gfm_inj() gfm_inj() gfm_inj()   # test case 1
     sm_inj()  sm_inj()  sm_inj()],  # test case 2
    ["Bus1",   "Bus 2",  "Bus 3"],   # corresponding order of buses
)

# tell it to record injector currents
add_result!(gss, 
    ["Bus 3 Injector Current", "Bus 1 Injector Current", "Bus 2 Injector Current"], 
    PSE.get_injector_currents,
)
# tell it to record the timestamps
add_result!(gss, "Time", PSE.get_time)

# run simulations
execute_sims!(
    gss,
    BranchImpedanceChange(0.5, ACBranch, "Bus 5-Bus 4-i_1", 1.2), 
    tspan=(0.49, 0.55), 
    dtmax=0.05, 
    run_transient=true, 
)
# plot results
p = makeplots(
    gss.df,
    supertitle="Transient Current at Bus 2",
    x="Time",
    y="Bus 3 Injector Current",
    x_title="Time (s)",
    y_title="Current (p.u.)",
    legendgroup="injector at {Bus 2}",
    margin=100,
    fontsize=12,
    scattermode="lines",
)

to_documenter(p) # hide
```
Et voilà! A nice interactive plot. Try zooming, clicking on the legend, and hovering over the traces!

