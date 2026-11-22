
About
=======

Tl;dr
-------

`swiftpartgen <https://github.com/SWIFTSIM/swiftpartgen>`_ is a python utility to
generate C header files for particle data in `SWIFT <https://swiftsim.com>`_ and
`SWIFTGPUPACKSIM <https://github.com/mladenivkovic/swiftgpupacksim>`_. 

It will generate both ``struct`` s whose members are particle data along
with an API to access them uniformly throughout the rest of the code, where the
API hides where exactly ``struct`` members are stored in global memory. All that
while only reading in simple ``yaml`` files specifying the particle contents and
layouts.




Rationale
---------

How particle data is stored in memory can have significant effects on the codes'
performance (e.g. `Ivkovic et al. 2026 <https://arxiv.org/abs/2606.23891>`_). 
One approach is, for example, to split a monolithic single ``struct part`` into
several smaller ones like this:

.. code-block:: C

   /* Monolithic particle struct containing all particle data */
   struct part {
      float a;
      float b;
      /* many more... */
      float z;
   };

turns into

.. code-block:: C

   /* First set of particle data */
   struct part_a_g {
      float a;
      float b;
      /* ... */
      float g;
   };

   /* Second set of particle data */
   struct part_h_m {
      float h;
      float i;
      /* ... */
      float m;
   };

   /* etc... */

It then becomes more convenient to use specific getter and setter functions to
access particle data (i.e. members of ``struct part`` and any other ``struct``
containing a fraction of the full particle data) rather than accessing those
fields directly, e.g. through ``p->member`` -- if ``struct part p`` does not
contain ``member`` any more because it has been moved to a different ``struct``,
dozens or even hundreds of SWIFT's files need to be modified accordingly.

Instead, the more convenient approach is to access particle data using an API
such as ``part_get_member(...)`` and ``part_set_member(...)``. This way, we can
only modify the contents of the ``part_[gs]et_member(...)`` functions, while the
rest of the code needs no further modifications.

While that is all good and well, writing such an API manually is cumbersome,
repetitive, and mindless work, which needs to be redone for any change of choice
in particle data memory layout. Hence why ``swiftpartgen`` was developed --
given a simple ``yaml`` parameter file specifying a particle's contents and
layout, it will both generate the ``struct`` s necessary along with the
according API.

