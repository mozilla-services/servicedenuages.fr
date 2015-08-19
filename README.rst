Service de nuages
=================

Load and update plugins submodule::

    git submodule init
    git submodule update --recursive
    git submodule status

To build the blog, just run::

    make html

and to publish it::

    make publish

Publish to gh-pages::

    make github

Dependencies
------------

Most of the dependencies are pure Python and are thus handled by ``pip``
directly; however, in order to build graphs dynamically, the ``dot`` binary
from `Graphviz <http://graphviz.org/Download..php>`_ is required.
