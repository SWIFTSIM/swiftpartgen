.. _outputs:

Generated Outputs
===================


.. _accessor_variants: 

Data Accessor Variants
------------------------

``swiftpartgen`` offers three variants of accessing the getters/setters API:

- :ref:`part struct accessors <part_struct_accessors>`
- :ref:`explicit accessors <explicit_var_accessors>`
- :ref:`global_accessors <global_var_accessors>`


.. note::

   When running ``swiftpartgen``, at least one of those flags must be selected.
   However, you may also select several of these flags. In that case, all API
   functions will get a suffix (``_part_struct``, ``_explicit``, and
   ``_global``, respectively) to enable unique API function names.




.. _part_struct_accessors:

part struct accessors (``--part-struct-accessors``) 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Generated getters/setters require a ``struct part* p`` to access correct
particle fields. If the field is not contained within ``struct part`` itself,
but some other particle sub-struct, it will access it using the particle's index
in the global particle arrays as well as a pointer to all global particle
arrays, which are two additional variables automatically added to the 
``struct part``.

**Minimal Example**: For a data layout of the form

.. code-block:: yaml

   part:
      x:
         type: float

   substruct1:
      y:
         type: float


the resulting header file will be (much other generated code omitted for demonstrative
purposes):

.. code-block:: C

   struct part {

     /*! offset/index of particle in cell particle data array */
     size_t _cell_offset;

     /*! pointer to particle data array struct of the cell this particle is located in */
     struct part_arrays* _cell_part_arrays;

     float _x;
   };

   struct substruct1 {
     float _y;
   };

   /**
    * @brief get x.
    */
   static __attribute__((always_inline)) INLINE float
     part_get_x(const struct part *restrict p) {
     return p->_x;
   }

   /**
    * @brief set the value of x.
    */
   static __attribute__((always_inline)) INLINE void
     part_set_x(struct part *restrict p, const float x) {
     p->_x = x;
   }

   /**
    * @brief get y.
    */
   static __attribute__((always_inline)) INLINE float
     part_get_y(const struct part *restrict p) {
    
     const struct substruct1* restrict substruct1_s = p->_cell_part_arrays->_substruct1 + p->_cell_offset;
     return substruct1_s->_y;
   }

   /**
    * @brief set the value of y.
    */
   static __attribute__((always_inline)) INLINE void
     part_set_y(struct part *restrict p, const float y) {

     struct substruct1* restrict substruct1_s = p->_cell_part_arrays->_substruct1 + p->_cell_offset;
     substruct1_s->_y = y;
   }



.. _explicit_var_accessors:

explicit var accessors (``--explicit-var-accessors``)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Generated getters/setters require a struct which holds pointers to all global
particle arrays as well as the particle's index in that array to be passed
explicitly as arguments. The header file containin the definition of the struct
holding pointers to all global particle arrays is automatically generated too.

**Minimal Example**: For a data layout of the form

.. code-block:: yaml

   part:
      x:
         type: float

   substruct1:
      y:
         type: float


the resulting header file will be (much other generated code omitted for demonstrative
purposes):

.. code-block:: C

   struct part {
     float _x;
   };

   struct substruct1 {
     float _y;
   };


   /**
    * @brief get x.
    */
   static __attribute__((always_inline)) INLINE float
     part_get_x(const struct part_arrays *restrict pd, const size_t pind) {

     const struct part* restrict part_s = pd->_part + pind;
     return part_s->_x;
   }

   /**
    * @brief set the value of x.
    */
   static __attribute__((always_inline)) INLINE void
     part_set_x(struct part_arrays *restrict pd, const size_t pind, const float x) {

     struct part* restrict part_s = pd->_part + pind;
     part_s->_x = x;
   }

   /**
    * @brief get y.
    */
   static __attribute__((always_inline)) INLINE float
     part_get_y(const struct part_arrays *restrict pd, const size_t pind) {

     const struct substruct1* restrict substruct1_s = pd->_substruct1 + pind;
     return substruct1_s->_y;
   }

   /**
    * @brief set the value of y.
    */
   static __attribute__((always_inline)) INLINE void
     part_set_y(struct part_arrays *restrict pd, const size_t pind, const float y) {

     struct substruct1* restrict substruct1_s = pd->_substruct1 + pind;
     substruct1_s->_y = y;
   }





.. _global_var_accessors:

global var accessors (``--global-var-accessors``)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Generated getters/setters only require a particle's index in the global particle
arrays to access its data. The global particle arrays are kept as a global
variable somewhere in the code.

**Minimal Example**: For a data layout of the form

.. code-block:: yaml

   part:
      x:
         type: float

   substruct1:
      y:
         type: float


the resulting header file will be (much other generated code omitted for demonstrative
purposes):

.. code-block:: C

   struct part {
     float _x;
   };

   struct substruct1 {
     float _y;
   };


   /**
    * @brief get x.
    */
   static __attribute__((always_inline)) INLINE float
     part_get_x(const size_t pind) {

     const struct part* restrict part_s = global_part_arrays._part + pind;
     return part_s->_x;
   }

   /**
    * @brief set the value of x.
    */
   static __attribute__((always_inline)) INLINE void
     part_set_x(const size_t pind, const float x) {

     struct part* restrict part_s = global_part_arrays._part + pind;
     part_s->_x = x;
   }

   /**
    * @brief get y.
    */
   static __attribute__((always_inline)) INLINE float
     part_get_y_global(const size_t pind) {

     const struct substruct1* restrict substruct1_s = global_part_arrays._substruct1 + pind;
     return substruct1_s->_y;
   }

   /**
    * @brief set the value of y.
    */
   static __attribute__((always_inline)) INLINE void
     part_set_y(const size_t pind, const float y) {

     struct substruct1* restrict substruct1_s = global_part_arrays._substruct1 + pind;
     substruct1_s->_y = y;
   }






Generated API
-------------

Scalars
~~~~~~~

For any scalar field ``X`` (e.g. a ``float``, ``int``, ``double``, 
``struct <something>``, etc.), the following API will be generated:

- ``part_get_X(...)``: returns the value of ``X``.
- ``part_get_X_p(...)``: returns a pointer to ``X``.
- ``part_get_const_X_p(...)``: returns a ``const`` pointer to ``X`` for
  read-only access.
- ``part_set_X(..., <type of X> val)``: set a value for ``X``.


See the documentation on the :ref:`yaml particle data specification
<yaml_particle_specification>` for details on limitations.



Arrays
~~~~~~

For any array ``ARR``, (e.g. ``double[3]``, ``int[2]``, etc.), the following API
will be generated:

- ``part_get_ARR(...)``: returns the pointer to the start of the array ``ARR``
- ``part_get_const_ARR(...)``: returns a ``const`` pointer to the start of the array ``ARR`` for read-only access
- ``part_get_ARR_ind(..., int ind)``: returns ``ARR[ind]``
- ``part_set_ARR(..., <type of ARR>* newarr)``: sets all the values of ``ARR`` to the values of ``newarr`` 
- ``part_set_ARR_ind(..., int ind, <type of ARR>* newarr)``: sets the value of the ``ARR[ind]`` to ``newarr[ind]`` 

This also works for multi-dimensional arrays, e.g. ``double[3][3]``, with the caveat that accordingly
more indices ``ind`` will be added.







.. _generated_files:

Generated Files
---------------


When generating ``SWIFT`` header output (``--swift`` flag or default run),
``swiftpartgen`` will generate the following files:

- ``src/hydro/<SPH_FLAVOUR>/hydro_part.h``: Header containing one or more
  ``struct`` s holding particle data and their respective getters/setters API 
- ``src/hydro/<SPH_FLAVOUR>/hydro_part_arrays_struct.h``: Header containing the
  definition of a ``struct`` which holds pointers to all ``struct`` s which hold
  particle data.

When running with the ``--swift --full`` options, additionally the following
files will be generated:

- ``src/hydro_part.h``: Top-level ``hydro_part.h``. This header includes the
  appropriate specific headers for different hydro flavours based on SWIFT
  configuration, as well as getters/setters for timestep limiter and RT
  timestepping data related structs.
- ``src/timestep_limiter_struct.h``: Contains the definition of the
  ``timestep_limiter_data`` struct and associated getters/setters.
- ``src/rt_struct.h``: Contains the definition of the ``rt_timestepping_data``
  struct and associated getters/setters.


When generating ``SWIFTGPUPACKSIM`` header output (``--gpupacksim`` flag), it
will create the following files:

- ``hydro_part.h``: (same as for ``SWIFT``) Header containing one or more ``struct`` s 
  holding particle data and their respective getters/setters API 
- ``hydro_part_arrays_struct.h``: (same as for ``SWIFT``) Header containing the
  definition of a ``struct`` which holds pointers to all ``struct`` s which hold
  particle data.
- ``parts.h``: Functions related to dealing with particles, such as allocating
  all arrays etc.
- ``hydro_part_arrays_flush.h``: Functions related to dealing with flushing
  particle arrays from cache.


