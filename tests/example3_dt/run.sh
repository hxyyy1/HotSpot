#!/usr/bin/env bash

set -euo pipefail

test_dir=$(cd "$(dirname "$0")" && pwd)
repo_dir=$(cd "$test_dir/../.." && pwd)
output_dir="$test_dir/outputs"

mkdir -p "$output_dir/fixed" "$output_dir/dt"
rm -f \
  "$output_dir/fixed/example.steady" \
  "$output_dir/fixed/example.grid.steady" \
  "$output_dir/fixed/example.ttrace" \
  "$output_dir/fixed/example.grid.ttrace" \
  "$output_dir/dt/example.steady" \
  "$output_dir/dt/example.grid.steady" \
  "$output_dir/dt/example.ttrace" \
  "$output_dir/dt/example.grid.ttrace"

# Floorplan paths inside the LCF are relative to this directory.
cd "$test_dir"

for mode in fixed dt; do
  if [[ "$mode" == fixed ]]; then
    power_trace="$test_dir/example.fixed.ptrace"
  else
    power_trace="$test_dir/example.ptrace"
  fi

  "$repo_dir/hotspot" \
    -c "$test_dir/example.config" \
    -p "$power_trace" \
    -grid_layer_file "$test_dir/example.lcf" \
    -materials_file "$test_dir/example.materials" \
    -model_type grid \
    -detailed_3D on \
    -steady_file "$output_dir/$mode/example.steady" \
    -grid_steady_file "$output_dir/$mode/example.grid.steady" \
    >"$output_dir/$mode/steady.log" 2>&1

  "$repo_dir/hotspot" \
    -c "$test_dir/example.config" \
    -p "$power_trace" \
    -grid_layer_file "$test_dir/example.lcf" \
    -materials_file "$test_dir/example.materials" \
    -model_type grid \
    -detailed_3D on \
    -init_file "$output_dir/$mode/example.steady" \
    -o "$output_dir/$mode/example.ttrace" \
    -grid_transient_file "$output_dir/$mode/example.grid.ttrace" \
    >"$output_dir/$mode/transient.log" 2>&1
done

for result in example.steady example.grid.steady example.ttrace example.grid.ttrace; do
  if cmp -s "$output_dir/fixed/$result" "$output_dir/dt/$result"; then
    echo "Expected non-uniform dt to change $result" >&2
    exit 1
  fi
done

test "$(head -n 1 "$output_dir/dt/example.ttrace")" = \
  "$(head -n 1 "$test_dir/example.fixed.ptrace")"
test "$(grep -c '^t = ' "$output_dir/dt/example.grid.ttrace")" -eq 2
grep -q '^t = 0.005$' "$output_dir/dt/example.grid.ttrace"
grep -q '^t = 0.02$' "$output_dir/dt/example.grid.ttrace"

echo "Example 3 non-uniform variable-dt validation passed"
