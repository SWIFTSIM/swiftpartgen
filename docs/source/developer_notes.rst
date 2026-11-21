
Notes for Developers
====================


Mandatory Particle Fields
-------------------------

You may want to prohibit the generation of hydro particles which miss a
mandatory field, e.g. some variable which is used outside of the hydro kernels
such as ``struct gpart*``, ``long long id``, etc.

To do so, add it to the appropriate list in ``required_data.py``. Checks will be
run at generation time and according errors will be raised if somethin's missing.




Tests
------


Some tests are available in ``/tests/pytests.sh``. There are 3 sorts of tests:

1) Whether the prescribed yaml syntax results in expected outputs (and produces
valid C code).
2) Whether the inclusion of other header files works correctly
3) Whether the generation of SWIFT hydro particles produces valid C code outputs.

By default, ``tests/pytests.sh`` runs all of them. You can select to only run
only a single of these test groups using the ``-a``, ``-H``, and ``-p`` flags,
respectively.

The general usage of ``tests/pytests.sh`` demands you specify whether you want
``SWIFT`` outputs (``--swift`` cmdline arg) or ``SWIFTGPUPACKSIM`` outputs
(``--gpupacksim`` flag). Moreover, it requires a path to a ``SWIFT`` or
``SWIFTGPUPACKSIM`` repository, respectively, in order to find the neccessary
headers needed to compile a test code which includes the generated particle
headers. ``tests/pytests.sh`` will first try some default directories, but if it
doesn't find them, it will ask you to provide a path. You can do that using the
``-i`` flag, e.g.

.. code-block:: bash

   # for swiftsim headers
   ./pytests.sh --swift -i /path/to/swiftsim/

   # for swiftgpupacksim headers
   ./pytests.sh --gpupacksim -i /path/to/swiftgpupacksim/sim/


.. warning::

   The provided path is assumed to be the directory containing ``/src`` in
   either case. So, for SWIFTGPUPACKSIM, it needs to be
   ``swiftgpupacksim/sim/``.


