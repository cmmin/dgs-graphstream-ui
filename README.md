# dgs-graphstream-ui
Graphical User Interface (GUI) for the dgs-graphstream program.

# Installation Notes
## `dgs-graphstream` Installation Notes

### [`nxmetis` Python Package](https://networkx-metis.readthedocs.io/en/latest/install.html)

This package cannot be installed using `pip3` for `python3` as it doesn't seem to be available at the time of writing this [Aug 2018].

The alternative approach to installing the package consists in following the "insall from source" instructions on the `networkx-metis` [installation page](https://networkx-metis.readthedocs.io/en/latest/install.html). 

The build process requires `Cython`:

```shell
pip3 install Cython
```

### Other Dependencies

`montage` can be installed using `brew install montage` on `macOS`.

`GTS`, required for building `graphviz gvmap` can be installed using `brew install gts` on `macOS`.

`ffmpeg` can be installed using `brew install ffmpeg` on `macOS`.

### `svglib` python3 fix

SVGlib is python2, tried to port it.

/usr/local/lib/python3.7/site-packages/svglib/svglib.py modify xrange -> range
