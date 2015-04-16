Da French Team Blog
===================

To build the blog
-----------------

Just install pelican and run the Makefile::

    pip install pelican
    make html


To publish the blog
-------------------

First install ghp-import::

    pip install ghp-import

Then build the content::

    make github
