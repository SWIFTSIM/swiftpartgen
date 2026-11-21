# Configuration file for the Sphinx documentation builder.
#
# For the full list of built-in configuration values, see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# -- Project information -----------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#project-information

project = 'swiftpartgen'
copyright = '2026, Mladen Ivkovic'
author = 'Mladen Ivkovic'
release = '1.0'

# -- General configuration ---------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#general-configuration

extensions = [
    #  "recommonmark",
    "sphinx.ext.autodoc",
    #  "sphinx.ext.viewcode",
    #  "sphinx.ext.doctest",
    "sphinx.ext.napoleon",
    #  "sphinx.ext.mathjax",
    #  "sphinx.ext.autosummary",
    #  "sphinx.ext.intersphinx",
    #  "sphinx_design",
]
templates_path = ['_templates']
exclude_patterns = []

source_suffix = [".rst", ".md"]



# -- Options for HTML output -------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#options-for-html-output

html_theme = "sphinx_rtd_theme"

html_static_path = ['_static']
