# correctionlib

[![Actions Status][actions-badge]][actions-link]
[![Documentation Status][rtd-badge]][rtd-link]
[![Code style: black][black-badge]][black-link]

[![PyPI version][pypi-version]][pypi-link]
[![PyPI platforms][pypi-platforms]][pypi-link]

[![GitHub Discussion][github-discussions-badge]][github-discussions-link]

## Introduction
The purpose of this library is to provide a well-structured JSON data format for a
wide variety of ad-hoc correction factors encountered in a typical HEP analysis and
a companion evaluation tool suitable for use in C++ and python programs.
Here we restrict our definition of correction factors to a class of functions with
scalar inputs that produce a scalar output.

In python, the function signature is:

```python
from typing import Union

def f(*args: Union[str,int,float]) -> float:
    return ...
```

In C++, the evaluator implements this currently as:
```cpp
double Correction::evaluate(const std::vector<std::variant<int, double, std::string>>& values) const;
```

The supported function classes may include:

  * multi-dimensional binned lookups;
  * binned lookups pointing to multi-argument formulas with a restricted
    math function set (`exp`, `sqrt`, etc.);
  * categorical (string or integer enumeration) maps; and
  * compositions of the above.

Each function type is represented by a "node" in a call graph and holds all
of its parameters in a JSON structure, described by the JSON schema.
Possible future extension nodes might include weigted sums (which, when composed with
the others, could represent a BDT) and perhaps simple MLPs.

The tool should provide:

  * standardized, versioned [JSON schemas](https://json-schema.org/);
  * forward-porting tools (to migrate data written in older schema versions); and
  * a well-optimized C++ evaluator and python bindings (with numpy vectorization support).

This tool will definitely not provide:

  * support for `TLorentzVector` or other object-type inputs (such tools should be written
    as a higher-level tool depending on this library as a low-level tool)

Formula support is currently planned via linking to ROOT libraries and using `TFormula`,
however if possible we would like to avoid this external dependency. One alternative could
be using the [boost.spirit](http://boost-spirit.com/home/) parser with some reasonable grammar--
this is the approach used for CMSSW's [expression parser](https://github.com/cms-sw/cmssw/blob/master/CommonTools/Utils/src/Grammar.h).
There are also various C++ formula parsers such as [ExprTk](http://www.partow.net/programming/exprtk/index.html),
and the python bindings may be able to call into [numexpr](https://numexpr.readthedocs.io/en/latest/user_guide.html),
though, due to the tree-like structure of the corrections, it may prove difficult to exploit vectorization
at levels other than the entrypoint.

## Installation

The build process is Makefile-based for the C++ evaluator and via setuptools for the python bindings.
Builds have been tested in Windows, OS X, and Linux, and python bindings can be compiled against both
python2 and python3, as well as from within a CMSSW environment. The python bindings are distributed as a
pip-installable package.

If you use python 3, you can simply `pip install correctionlib` (possibly with `--user`, or in a virtualenv, etc.)

To build the C++ evaluator in most environments:
```bash
git clone --recursive git@github.com:nsmith-/correctionlib.git
cd correctionlib
make
# demo C++ binding, main function at src/demo.cc
./demo data/examples.json
```

To compile with python2 support, consider using python 3 :) If you considered that and still
want to us python2, follow the C++ build instructions and then call `make PYTHON=python2 correctionlib` to compile.
Inside CMSSW you should use `make PYTHON=python correctionlib` assuming `python` is the name of the scram tool you intend to link against.
This will output a `correctionlib` directory that acts as a python package, and can be moved where needed.
This package will only provide the `correctionlib._core` evaluator module, as the schema tools and high-level bindings are python3-only.

## Creating new corrections

The `correctionlib` python package provides a helpful
framework for defining correction objects. Nodes can be type-checked as they are constructed using the
[parse_obj](https://pydantic-docs.helpmanual.io/usage/models/#helper-functions) class method.
Some examples can be found in `convert.ipynb`.


[actions-badge]:            https://github.com/nsmith-/correctionlib/workflows/CI/badge.svg
[actions-link]:             https://github.com/nsmith-/correctionlib/actions
[black-badge]:              https://img.shields.io/badge/code%20style-black-000000.svg
[black-link]:               https://github.com/psf/black
[conda-badge]:              https://img.shields.io/conda/vn/conda-forge/correctionlib
[conda-link]:               https://github.com/conda-forge/correctionlib-feedstock
[github-discussions-badge]: https://img.shields.io/static/v1?label=Discussions&message=Ask&color=blue&logo=github
[github-discussions-link]:  https://github.com/nsmith-/correctionlib/discussions
[gitter-badge]:             https://badges.gitter.im/https://github.com/nsmith-/correctionlib/community.svg
[gitter-link]:              https://gitter.im/https://github.com/nsmith-/correctionlib/community?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge
[pypi-link]:                https://pypi.org/project/correctionlib/
[pypi-platforms]:           https://img.shields.io/pypi/pyversions/correctionlib
[pypi-version]:             https://badge.fury.io/py/correctionlib.svg
[rtd-badge]:                https://github.com/nsmith-/correctionlib/actions/workflows/docs.yml/badge.svg
[rtd-link]:                 https://nsmith-.github.io/correctionlib/
