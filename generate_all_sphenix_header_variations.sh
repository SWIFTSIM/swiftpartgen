#!/bin/bash

set -eo pipefail

errmsg="
Generate header files for all SPHENIX SoAoS variants, intended to be placed into and
used in the SWIFTGPUPACKSIM repository.

Usage: $0 </path/to/swiftgpupacksim/sim/src>

If no </path/to/swiftsimgpupacksim/sim/src> is provided, the files will be
generated in the current directory.

Options:

-h, --help :  show this message and exit.
"

OUTPUTDIR="."

# Get cmdlineargs.
while [[ $# > 0 ]]; do
  arg="$1"

  case $arg in
    -h | --help)
      echo -e "$errmsg"
      exit
    ;;

    *)
    if [ "$OUTPUTDIR" != "." ]; then
      # we've already read in a path
      echo "You provided a second positional cmdline argument, '"$arg"'."
      echo "Don't know what to do with that."
      echo "Use -h or --help for help."
      exit 1
    fi
    if [ ! -d "$arg" ]; then
      echo "Provided path to swiftsim/src dir, '"$arg"', not found."
      echo "Use -h or --help for help."
      exit 1
    else
      OUTPUTDIR="$arg"
    fi
    ;;
  esac

  shift
done



./swiftpartgen.py -e -g -G input/sphenix_splitting/SPHENIX.yml                    -o "$OUTPUTDIR"/realisations/aos
./swiftpartgen.py -e -g -G input/sphenix_splitting/SPHENIX_pack_force.yml         -o "$OUTPUTDIR"/realisations/pack_force
./swiftpartgen.py -e -g -G input/sphenix_splitting/SPHENIX_pack_force_type.yml    -o "$OUTPUTDIR"/realisations/pack_force_type
./swiftpartgen.py -e -g -G input/sphenix_splitting/SPHENIX_pack_gradient.yml      -o "$OUTPUTDIR"/realisations/pack_gradient
./swiftpartgen.py -e -g -G input/sphenix_splitting/SPHENIX_pack_gradient_type.yml -o "$OUTPUTDIR"/realisations/pack_gradient_type
./swiftpartgen.py -e -g -G input/sphenix_splitting/SPHENIX_pack_shared.yml        -o "$OUTPUTDIR"/realisations/pack_shared
./swiftpartgen.py -e -g -G input/sphenix_splitting/SPHENIX_pack_shared_type.yml   -o "$OUTPUTDIR"/realisations/pack_shared_type
./swiftpartgen.py -e -g -G input/sphenix_splitting/SPHENIX_SOA.yml                -o "$OUTPUTDIR"/realisations/soa
./swiftpartgen.py -e -g -G input/sphenix_splitting/SPHENIX_upstream.yml           -o "$OUTPUTDIR"/realisations/upstream
./swiftpartgen.py -e -g -G input/sphenix_splitting/SPHENIX_random_order.yml       -o "$OUTPUTDIR"/realisations/random_order

