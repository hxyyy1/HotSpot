# Example 3 variable-time-step validation

This directory copies the model inputs and parameters from `examples/example3`.

- `example.fixed.ptrace` is the original fixed-step power trace. Its rows use the `sampling_intvl = 0.01 s` setting in `example.config`.
- `example.ptrace` contains the same power values with a leading `dt` column. The rows use `dt = 0.005 s` and `dt = 0.015 s`, respectively, so the total simulated time remains `0.02 s` while the time steps are non-uniform.
- `run.sh` runs steady-state and transient 3D grid simulations for both traces and verifies that the non-uniform time steps change their block-level and grid-level outputs. It also checks the accumulated grid timestamps (`0.005 s` and `0.02 s`).

Run from any directory:

```bash
bash tests/example3_dt/run.sh
```

Successful validation prints:

```text
Example 3 non-uniform variable-dt validation passed
```

Generated files are written below `tests/example3_dt/outputs/`.
