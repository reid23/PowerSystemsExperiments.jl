# API Reference

## GridSearchSys

```@autodocs
Modules = [PowerSystemsExperiments]
Pages = ["sysbuilder.jl"]
Order = [:type, :function]
```

## Plotting

```@autodocs
Modules = [PowerSystemsExperiments]
Pages = ["plotting.jl"]
```

## Results Getters
These functions allow you to store results of your simulations. Feel free to write your own; these are just here to get you started.

They all return either a value or a vector of values. If they return a vector, this vector will still be entered into the DataFrame as ONE entry, unless you pass a vector of `titles` with the same length as the returned vector of values to [`add_result!`](@ref). In that case, each entry in `titles` will be its own column.

All results getters have the following signature:

```julia
getter(
    gss::GridSearchSys, 
    sim::Union{Simulation, Missing}, 
    sm::Union{PSID.SmallSignalOutput, Missing}, 
    error::Union{String, Missing},
    dt::Real
)
```
These arguments are:
 - `gss`: the `GridSearchSys` object that this simulation was run from. This allows you to get things like the base system.
 - `sim`: the `PSID.Simulation` object that holds all the information about this sim.
 - `sm`: the `PSID.SmallSignalOutput` object returned by the small signal analysis
 - `error`: a string containing any errors *thrown* (does not include logs printed with `@error`) during small signal or transient simulations
 - `dt`: the amount of time this simulation took to run, in nanoseconds.

!!! note "Future Changes Possible"
    These semantics are precisely the type of thing that should be encoded in a `results` type/struct. This would make getting results significantly more clean, abstracted, and flexible. As such, this interface may change in the future.

When you write your own getters, there are a few things to keep in mind:
- Any of the arguments except `gss` and `dt` could be `missing`
- `sim.results` could be `nothing` if the setup failed (if powerflow fails to solve, for example)
- make sure your getter's signature matches the format, or it will throw type errors.
- These getter functions should be configuration-agnostic. If you need to do something different based on the sweep parameters relevant to this run, you should do that via direct manipulation of the results dataframe.



```@autodocs
Modules = [PowerSystemsExperiments]
Pages = ["getters.jl"]
```

## Sample Models
`device_models.jl` just contains some sample generator and inverter components with sane parameter values to help you get started easily.
Not written by me; not sure who wrote these or where the numbers come from. Will update if I find out.

```@autodocs
Modules = [PowerSystemsExperiments]
Pages = ["device_models.jl"]
```
