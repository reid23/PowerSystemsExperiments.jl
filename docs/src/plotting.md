# Plotting

build your plots with `makeplots` and save them to interactive html with `savehtmlplot`.

!!! Note "warning"
    This feature is complicated and unstable. There is some undefined behavior because the PlotlyJS documentation doesn't quite specify what happens in all cases.
    Additionally, the documentation here is focused on explaining everything as well as possible, so it is very long and complicated. Do not be intimidated! This code was designed so that (ideally; development is still ongoing) if you don't need some bit of functionality, you can simply ignore it, and things will work.


For `makeplots`, you pass the dataframe (typically `gss.df` or similar), a bunch of Strings or Symbols specifying columns to map to various variables, and whatever other random settings you need.

```@docs
savehtmlplot
makeplots
```

This interfaces with `PlotlyJS.jl`, so many options are carried directly over. Reading through the [PlotlyJS.jl documentation](https://plotly.com/julia/reference/) can be very helpful for understanding this package and why it is the way it is.

## Additional Commentary
As this functionality is still under construction, there are a few kinks in the implementation. This is a non-exhaustive list of unexpected things to be aware of.
 - if `colorbar==false`, `color` is assumed to be categorical and each unique color is mapped to an element of `colorlist` after being sorted by `color_sort_func`
 - colorbar doesn't really work with lines because you can't have lines of variable color. To get it to work, you need to pass `colorlist` and ensure that it matches the right values on the colorscale you give in `colorbar_args`
 - `colorbar_args` are kinda complicated. Here's an example:
```julia
Dict(attr(
    autocolorscale=false, 
    cmax= 1.0,
    # cmid=0.5,
    cmin= -1.2,
    title="",
    colorbar=attr(
        outlinecolor=colorant"black",
        outlinewidth=1,
        tickmode="array",
        ticktext=(["Z=1.0", "P=1.0", "P=0.8", "P=0.6", "P=0.4", "P=0.2", "P=E=0", "E=0.2", "E=0.4", "E=0.6", "E=0.8", "E=1.0"]),
        tickvals=(collect(range(-1.2, 1, 13)).+(2.2/(2*12)))[1:end - 1],
        xref="paper",
        yref="paper",
        x=1.02,
        thickness=40
    ),
    colorscale=[[0.0, RGB(colorant"yellow")], 
                [1.0, RGB(colorant"purple")]]
))
```
Note that `colorscale`'s numerical scale is in $$[0, 1]$$, which is different from `cmax` and `cmin`.
See the [PlotlyJS.jl docs](https://plotly.com/julia/reference/#scatter-marker-colorbar) for more detailed documentation.

 - You can have a legend and a colorbar at the same time, but it is recommended to just use `hide_legend_duplicates=true` (which is default `true`) and use the legend to represent a *different* variable. Since color cannot be used, you'll have to pair it with another method of conveying information, like opacity or marker shape.
 - `symbollist` and `colorlist` provide some initial values, but if you have more unique values represented by symbol or color respectively, you'll need to provide new lists with more new values.
 - `scattertext` and `hovertext` can make plot files MASSIVE. Take care to include as little information as possible in them. Round numbers to the appropriate length.
 - similarly, high values of `data_sigdigits` can increase plot file size. Do not set it to a high number unless you absolutely need to.
 - `slider_trace_id` is a patch at best - it's often better to just use the order of the rows in the dataframe. Just make sure to sort the dataframe beforehand by as many things as possible so that you have a very predictable and consistent order of traces across slider values.