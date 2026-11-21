swiftpartgen
============

About
-----

[swiftpartgen](https://github.com/SWIFTSIM/swiftpartgen) is a python utility to
generate C header files for particle data in [SWIFT](https://swiftsim.com>`)
and [SWIFTGPUPACKSIM](https://github.com/mladenivkovic/swiftgpupacksim>).

Get it on [github](https://github.com/SWIFTSIM/swiftpartgen).


Installation
------------

``swiftpartgen`` is not intended to be installed as a python package, but to be
run from this directory instead. As such, no further installation steps are
required beyond a working ``python 3`` installation and the required
dependencies.

The python package dependencies are listed in ``swiftpartgen/requirements.txt``.
You can install them using

```
   pip3 install [--user] requirements.txt
```



Documentation
-------------

The documentation can be found online as a [github page](https://swiftsim.github.io/swiftpartgen/).
It is also part of this repository. To build a ``html`` version, do the
following:

```
cd docs
make html
```

or

```
sphinx-build docs/source docs/build
```

The resulting documentation will be built in ``docs/build/index.html``.



Usage
-----

Please consult the [documentation](#documentation).


