#!/bin/bash
# Generate test outputs for the specified dimension (2D or 3D)
set -e

DIM=$1
BUILD_DIR=$2
SOURCE_DIR=$3

REF_DIRECTORY=${SOURCE_DIR}/test/test_data

EXECUTABLE_DIR=${BUILD_DIR}/app
TEMP_TEST_RESULTS=${REF_DIRECTORY}/temp_test_results
REFERENCE_CONFIGS=${REF_DIRECTORY}/reference_configs

mkdir -p $TEMP_TEST_RESULTS

cd $REFERENCE_CONFIGS

if [[ "$DIM" == "2" ]]; then
  gmsh -2 circular_hole.geo
  ${EXECUTABLE_DIR}/static circular_hole.toml \
    --matrix_free yes --mg_strategy twolevel \
    --mg_coarse_level 1 --output ${TEMP_TEST_RESULTS}/output2D \
    --petsc -options_file mg_cheby.cfg
  for i in 1 2 4 8; do
    mpirun --oversubscribe -n $i ${EXECUTABLE_DIR}/static circular_hole.toml \
      --matrix_free yes --mg_strategy twolevel \
      --mg_coarse_level 1 --output ${TEMP_TEST_RESULTS}/parallel_output2D_$i \
      --petsc -options_file mg_cheby.cfg
  done
  for h in 0.017 0.034 0.074 0.150 0.380 0.7845; do
    gmsh -2 circular_hole.geo -setnumber h $h
    ${EXECUTABLE_DIR}/static circular_hole.toml \
      --petsc -options_file mg_cheby.cfg >>${TEMP_TEST_RESULTS}/convergence_2D.log
  done
  gmsh -2 bp1_ref.geo
  ${EXECUTABLE_DIR}/tandem bp1_ref_QD.toml \
    --petsc -options_file solver.cfg
  ${EXECUTABLE_DIR}/tandem bp1_ref_QDGreen.toml \
    --petsc -options_file solver.cfg
  rm circular_hole.msh
  rm bp1_ref.msh
elif [[ "$DIM" == "3" ]]; then
  gmsh -3 spherical_hole.geo
  ${EXECUTABLE_DIR}/static spherical_hole.toml \
    --matrix_free yes --mg_strategy twolevel \
    --mg_coarse_level 1 --output ${TEMP_TEST_RESULTS}/output3D \
    --petsc -options_file mg_cheby.cfg
  for i in 1 2 4 8; do
    mpirun --oversubscribe -n $i ${EXECUTABLE_DIR}/static spherical_hole.toml \
      --matrix_free yes --mg_strategy twolevel \
      --mg_coarse_level 1 --output ${TEMP_TEST_RESULTS}/parallel_output3D_$i \
      --petsc -options_file mg_cheby.cfg
  done
  for h in 0.074 0.147 0.289 0.540 0.712; do
    gmsh -3 spherical_hole.geo -setnumber h $h
    ${EXECUTABLE_DIR}/static spherical_hole.toml \
      --petsc -options_file mg_cheby.cfg >>${TEMP_TEST_RESULTS}/convergence_3D.log
  done
  rm spherical_hole.msh
else
  echo "Unsupported dimension: $DIM"
  exit 1
fi
