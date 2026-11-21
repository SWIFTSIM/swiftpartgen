#!/bin/bash

./swiftpartgen.py -e -g -G input/SPHENIX.yml                    -o ../sim/src/realisations/aos
./swiftpartgen.py -e -g -G input/SPHENIX_pack_force.yml         -o ../sim/src/realisations/pack_force
./swiftpartgen.py -e -g -G input/SPHENIX_pack_force_type.yml    -o ../sim/src/realisations/pack_force_type
./swiftpartgen.py -e -g -G input/SPHENIX_pack_gradient.yml      -o ../sim/src/realisations/pack_gradient
./swiftpartgen.py -e -g -G input/SPHENIX_pack_gradient_type.yml -o ../sim/src/realisations/pack_gradient_type
./swiftpartgen.py -e -g -G input/SPHENIX_pack_shared.yml        -o ../sim/src/realisations/pack_shared
./swiftpartgen.py -e -g -G input/SPHENIX_pack_shared_type.yml   -o ../sim/src/realisations/pack_shared_type
./swiftpartgen.py -e -g -G input/SPHENIX_SOA.yml                -o ../sim/src/realisations/soa
./swiftpartgen.py -e -g -G input/SPHENIX_upstream.yml           -o ../sim/src/realisations/upstream
./swiftpartgen.py -e -g -G input/SPHENIX_random_order.yml       -o ../sim/src/realisations/random_order
