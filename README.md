# Description
HotSpot is a pre-RTL thermal simulator intended for use early in the design process. HotSpot supports simulation of traditional 2D Integrated Circuits (2D ICs) and [3D ICs](https://en.wikipedia.org/wiki/Three-dimensional_integrated_circuit) as well as  [microfluidic cooling](https://en.wikipedia.org/wiki/Microfluidics). If this is your first time seeing HotSpot, check out our [Getting Started](https://github.com/uvahotspot/HotSpot/wiki/Getting-Started) page. To see HotSpot in action, check out our simulation examples in the `examples` directory! Please send questions, comments, concerns, bugs, etc. to hotspot@virginia.edu.

## Power trace time steps

The traditional power trace format uses one fixed duration for every data row. The first row contains the floorplan unit names, and the remaining rows contain power values in watts. The duration is set by `-sampling_intvl`:

```text
Core0  Cache0
10.0   3.0
12.0   4.2
```

Power traces may instead specify a different duration for each row by making `dt` the first header field and adding the duration in seconds as the first value of every data row:

```text
dt      Core0  Cache0
0.001   10.0   3.0
0.005   12.0   4.2
0.0005  8.5    2.7
```

Every `dt` must be finite and greater than zero. When `dt` is present, `-sampling_intvl` is ignored for the trace rows. Transient temperatures are computed using each row's duration, grid-transient timestamps contain the accumulated elapsed time, and the final steady-state calculation uses time-weighted average power. Temperature trace output remains backward compatible: it contains only the unit-name header and one temperature row for each input power row.
