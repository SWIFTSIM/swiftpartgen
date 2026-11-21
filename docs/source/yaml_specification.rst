.. _yaml_particle_specification:

Yaml Particle Specification File
================================

The header files containing particle structs are generated using specifications
in ``yaml`` files. Some defaults are stored in ``input/``.

The specification requires you to provide all particle fields necessary for a
specific particle flavour realisation. The script will then generate header
files required to incorporate those structs into ``SWIFT`` and ``SWIFTGPUPACKSIM``.

In general, you need to provide at least 2 items:

- a :ref:`"metadata" item <file_metadata>`, containing file metadata
- one (or arbitrarily many) :ref:`structs containing particle fields <particle_structs>`

Here's a minimal example:

.. code-block:: yaml

   metadata:
     authors: "2026 John Doe"       # year and authors of file, to be inserted into the license
     flavour: my_sph_flavour_name   # name of the SPH flavour. Mainly used in header guard macro

   part_struct1_name:               # name of struct (e.g. 'part', 'density', 'force'...)
     field1_name:                   # name of particle field (e.g. 'x', 'm', 'h'...)
       type: DATA_TYPE              # (Optional) C data type of the field. E.g. float,
                                    #   double, int, long long, timebin_t...
                                    #   If not provided, defaults to 'float'.
       size: N                      # (Optional) If > 1, field is assumed to be fixed size array.
       doc: documentation text      # (Optional) Documents particle data field.



.. _file_metadata:

File Metadata
-------------

The ``metadata`` item in the ``yaml`` specification file carries all file metadata,
such as:

- ``authors``: Year + author names + emails to be inserted into the GPL3 license
  in the file
- ``flavour``: The name of the SPH flavour contained in this file. Mainly used to
  define a header guard and in the file description
- ``doc``: File documentation. What will go in the ``/** @file`` doxygen
  documentation of the file.
- ``includes``: list of headers to include. If this field is not provided, a
  default will be used, stored in ``input/hydro_default_headers_swift.h`` and
  ``input/hydro/default_headers_swiftgpupacksim.h``, respectively.
- ``includes_add``: Rather than providing a full list of includes, only add these
  to the default selection.

Here's an example metadata setup:


.. code-block:: yaml

   metadata:
     authors: "2026 John Doe"          # year and authors of file, to be inserted into the license
     flavour: my_sph_flavour_name      # name of the SPH flavour. Mainly used in header guard macro
     doc: |                            # (Optional) file documentation
       This file contains X, Y, and Z.
     includes:                         # (Optional) headers to be included. If not provided, default 
       - a.h                           #   headers will be used, read in from ``input/default_hydro_headers_swift.h``
       - b.h                           #   or ``input/default_hydro_headers_swiftgpupacksim.h``. 
       - <stdio.h>
     includes_add:                     # (Optional) Additional header files to include aside from the 
       - a.h                           #   "default" ones (see ``includes`` field) 
       - b.h                           # ! WARNING: Cannot be used together with ``includes`` parameter.
       - <stdio.h>




Particle Structs
----------------

Your ``yaml`` specification file must contain at least one particle struct
containing fields, but can contain as many as you like.

A new particle struct containing data is defined by adding a new top-level item
(= item with no indent). To add fields (=actual data) to it, see instructions
below.





Scalar and Array Native Data Types
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The general specification requirement is as follows:


.. code-block:: yaml

   metadata:
     authors: "2026 John Doe"       # year and authors of file, to be inserted into the license
     flavour: my_sph_flavour_name   # name of the SPH flavour. Mainly used in header guard macro

   part_struct1_name:               # name of struct (e.g. 'part', 'density', 'force'...)
     field1_name:                   # name of particle field (e.g. 'x', 'm', 'h'...)
       type: DATA_TYPE              # (Optional) C data type of the field. E.g. float,
                                    #   double, int, long long, timebin_t...
                                    # ! WARNING: If not provided, defaults to 'float'. !
       size: N                      # (Optional) If > 1, field is assumed to be fixed size array,
                                    #   e.g. `DATA_TYPE field1_name[N];`
       doc: documentation text      # (Optional) Documentation of the particle data field.

     # some more concrete examples.
     x:
       type: double
       size: 3
       doc: the particle position
     m: # no further specification works too. Defaults to float.
     u:
       doc: the comoving specific internal energy
     id:
       type: long long


   part_struct2_name:              # name of the second struct containing (parts
                                   #  of) particle data.
     field2_name:
       ... # etc etc



.. warning:: 

   **IMPORTANT**:

   - The top-level entries in the indent hierarchies will be transformed into
     separate structs with that name.
   - An exception is the group ``metadata``, which should contain the file 
     metadata and will not be turned into a struct.
   - No duplicate names of particle fields are allowed -- not even between two 
     different structs!

       - If there are several top level/root particle data structs with identical
         names, the yaml reader will only keep the last one.
       - If there are several fields with identical names, even if they are stored in
         different top level/root particle data structs, this will cause name clashes
         with the generated API.






Nested Structs
~~~~~~~~~~~~~~

To specify a struct defined within a parent particle struct, use the following:

.. code-block:: yaml

   parent_struct:         # such as part, xpart, ...
     your_struct_name:
       type: struct
       contents:
         a:
           type: int
           documentation: "the first field of 'your_struct_name' struct"
         b:
           type: double
           documentation: "the second field of 'your_struct_name' struct"


this results in

.. code-block:: C

   /* header... */

   struct parent_struct {

     struct {

       /*! the first field of 'your_struct_name' struct */
       int a;

       /*! the second field of 'your_struct_name' struct */
       double b;

     } your_struct_name;
   };

   /* getters and setters... */



To use a struct which is defined somewhere else as a data type, just add it as a
type descriptor. Example:


.. code-block:: yaml

   parent_struct:         # such as part, xpart, ...
     timestep_data:
       type: struct limiter_timestep_data;

results in:

.. code-block:: C

   parent_struct {
     struct limiter_timestep_data limiter_data;
   };






Unions
~~~~~~

To specify a union within a parent particle struct, use the following:

.. code-block:: yaml

   parent_struct:         # such as part, xpart, ...
     name_placeholder:
       type: union
       contents:
         a:
           type: int
           documentation: "the first field of union"
         b:
           type: double
           documentation: "the second field of union"


The ``name_placeholder`` name will be unused in the resulting header file.
However, we need a unique identifier for the ``yaml`` syntax - otherwise, the
content will be overwritten by the last element with that name and the others
discarded. So just make sure you give them any unique identifier.

.. note::

   Unions may contain further unions or structs as their members.





enums
~~~~~

``Enum`` s (enumerations) are allowed as a data type for field members if they
are defined somewhere else, i.e. this script will not provide a definition for
them in the resulting header files.

Example:

.. code-block:: yaml

   part:
     my_enum:
       type: enum color
       doc: some enumeration, defined elsewhere

Results in:

.. code-block:: C

   struct part {

     /*! some enumeration, defined elsewhere */
     enum color my_enum;

   };




IFDEF and IFNDEF macros
~~~~~~~~~~~~~~~~~~~~~~~

You may want to hide some particle fields behind a macro guard. To do so, use
the ``ifdef: MACRO_NAME`` keyword or ``ifndef: MACRO_NAME`` keyword,
respectively. Obviously, you may only use one for each member, not both.

However, to have functional getters and setters API when the macros aren't set,
we need to provide a return value for the getters. By default, the values will
be set to the max value of the data type (e.g. ``FLT_MAX``, ``INT_MAX``, etc.).
If you want to modify that value, provide the ``ifdef_return_val`` parameter.


Example:

.. code-block:: yaml

   part:
     debug_counter:
       type: int
       ifdef: SWIFT_DEBUG_CHECKS

     rt_time_bin:
       type: int
       ifndef: RT_NONE        # <- using ifndef, not ifdef

     collect_mpi:
       type: float
       ifdef: WITH_MPI
       ifdef_return_val: 1.f  # <- specific value to return

This results in:

.. code-block:: C

   /* ... header and definitions... */

   /**
    * @brief get debug_counter.
    */
   static __attribute__((always_inline)) INLINE int part_get_debug_counter(const size_t pind) {
   #ifdef SWIFT_DEBUG_CHECKS
     return p->_debug_counter;
   #else
     return INT_MAX;
   #endif
   }

   /**
    * @brief get rt_time_bin.
    */
   static __attribute__((always_inline)) INLINE int part_get_rt_time_bin(const size_t pind) {
   #ifndef RT_NONE
     return p->_rt_time_bin;
   #else
     return INT_MAX;
   #endif
   }

   /**
    * @brief get collect_mpi.
    */
   static __attribute__((always_inline)) INLINE float part_get_collect_mpi(const size_t pind) {
   #ifdef WITH_MPI
     return p->_collect_mpi;
   #else
     return 1.f;
   #endif
   }

   # ... more getters and setters ...


.. warning::

   This is currently not implemented for unions.




Arrays
~~~~~~

To create fields which are fixed-size arrays, add the ``size`` parameter to the
``yaml`` file. For example:

.. code-block:: yaml

  part:
    v:
      size: 3

    radiation_energy:
      size: RT_NGROUPS

    matrix:
      size: 3,3

results in

.. code-block:: C

  struct part {

    float v[3];

    float radiation_energy[RT_NGROUPS];

    float matrix[3][3];
  }







Reserved names
~~~~~~~~~~~~~~


To ensure functionality, some names are reserved and cannot be used as names for
fields. These are:

- ``doc``
- ``documentation``
- ``union``
- ``cell_offset``
- ``cell_part_data``




.. _particle_structs:

Splitting Particle Data Over Multiple Structs
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You may want to split the particle data such that they are contained within
multiple structs instead of a single one. To do so, some **restrictions** apply:

- You *may* choose to define a struct which is named ``part`` in your ``yaml``
  parameter file.

    - If you do, it **must** be the first defined struct [#part_first]_.
    - If you do, ``swiftpartgen`` will also automatically generate getter
      functions to all other structs holding particle data as defined in the yaml
      file.

- You *may* choose *not* to define a struct which is named ``part`` in your
  ``yaml`` parameter file.

    - If you don't, one will be generated for you [#part_autogen]_.
    - If you don't, the script will also automatically generate getter functions to
      all other structs holding particle data as defined in the yaml file.



.. rubric:: footnotes

.. [#part_first] This is necessary for compatibility with the
   ``--part-struct-accessor`` API, wherein particle data is accessed using a
   ``struct part p``. In the body of the getters/setters, the ``struct part p``
   will be accessed to find the index of this particle in the global particle
   arrays or this cell's particle array; In order to do so, the ``struct part
   p`` needs to be defined beforehand, and hence needs to be at the start of the
   file.

.. [#part_autogen] This is again for compatibility with the
   ``--part-struct-accessor`` API, which requires a ``struct part`` to exist.
   In the future, this consequence may be removed.

