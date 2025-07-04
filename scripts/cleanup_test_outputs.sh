#!/bin/bash
# Cleanup temporary test outputs
set -e

SOURCE_DIR=$1

TEMP_TEST_RESULTS=${SOURCE_DIR}/test/test_data/temp_test_results

rm -rf $TEMP_TEST_RESULTS
