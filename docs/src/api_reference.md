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

When you write your own getters, there are a few things to keep in mind:
- Any of the arguments except `gss` and `dt` could be `missing`
- `sim.results` could be `nothing` if the setup failed (if powerflow fails to solve, for example)
Take a look at the existing getters to see how to write your own.

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
