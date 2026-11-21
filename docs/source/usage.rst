Usage
=======

Basic Usage
-----------

The basic usage is

.. code-block:: bash

   python3 swiftpartgen.py [--swift] [--gpupacksim] [--full] [-o OUTPUT_DIR] [--explicit-var-accessors] [--global-var-accessors] [--part-struct-accessors] input_file

At least one of ``--explicit-var-accessors``, ``--global-var-accessors``, or
``--part-struct-accessors`` must be chosen. See the :ref:`Section on accessors
<accessor_variants>` for more details. For use of the generated header files in
``SWIFT``, the ``--global-var-accessors`` flag is required.

Use

.. code-block:: bash

   python3 swiftpartgen.py -h

to see all available command line options.


By default, this script will create files used by ``SWIFT``. If you want to
produce header files intended for use in the ``SWIFTGPUPACKSIM`` code, use the
``--gpupacksim`` flag.

As input, the script requires a ``yaml`` file specifying the particle struct and
field layouts. Some are provided in the ``input/`` directory. For further
specification, see the :ref:`documentation on yaml specification <yaml_particle_specification>`.



SWIFT
~~~~~

To generate header files for a specific hydro particle flavour for use in ``SWIFT``
(i.e. files that will go in ``src/hydro/<SPH-flavour>``), use

.. code-block:: bash

   python3 swiftpartgen.py --global-var-accessor input.yml


where ``input.yml`` should be the ``yaml`` parameter file containing all the
relevant particle data.

.. note::

   All SWIFT hydro particle flavours have pre-existing templates stored in
   ``input/hydro/``.

.. note::

   SWIFT is implemented to use ``--global-var-accessors``.



To generate **all** files for a specific hydro particle flavour (see
:ref:`Generated Files <generated_files>` for details), add the ``--full`` flag:


.. code-block:: bash

   python3 swiftpartgen.py --global-var-accessor --full input.yml



.. note::

   If you want to generate the outputs for all particle flavours, you may want
   to take advantage of the ``swiftpartgen/generate_all_swift_hydro_particles.sh`` 
   script.




SWIFTGPUPACKSIM
~~~~~~~~~~~~~~~

To generate header files for a specific hydro particle flavour for use in
``SWIFTGPUPACKSIM``, (i.e. files that will go in ``sim/src/realisations/<flavour>``), 
use e.g.

.. code-block:: bash

   python3 swiftpartgen.py --gpupacksim --global-var-accessor input.yml

Again, ``input.yml`` should be the ``yaml`` parameter file containing all the
relevant particle data.

.. note::

   Many pre-existing templates for variations for the SPHENIX particle are
   stored in ``input/hydro/sphenix_splitting``.


.. To generate **all** files for a shydro particle flavour (see
.. :ref:`Generated Files <generated_files>` for details), add the ``--full`` flag:
..
..
.. .. code-block:: bash
..
..    python3 swiftpartgen.py --global-var-accessor --full input.yml
..


.. note::

   If you want to generate the outputs for all SPHENIX splitting variants, you
   may want to take advantage of the
   ``swiftpartgen/generate_all_sphenix_header_variations.sh`` script.



