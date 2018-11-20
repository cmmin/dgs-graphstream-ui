# Emergency Shelter Reunification Visualizer Setup Manual

## Requirements for ESRVisualizer-ui

For ```macOS``` this guide requires that you have basic tools for compiling and building programs. This means either ```clang``` compiler or ```g++``` compiler must be installed. ```clang``` is available by making sure that ```XCode``` is updated and its license is accepted (just launch it once installed and confirm the license agreement). ```g++``` (GNU C++ compiler) can be installed using ```homebrew``` package manager or ```macports```.

For ```ubuntu```, the main requirement is that the ```build-essential``` tools are installed.

## Installing Python

We require ```python3``` version ```3.6+``` with ```pip3``` installed.

On ```macOS``` we suggest installing python3 via ```homebrew```:

```bash
>> brew install python3
```

On ```ubuntu```, ```python3``` should already be installed, however you may need to install ```pip3``` separately.

To check if you have the right packages installed, run:

```bash
>> which python3
/usr/bin/python3 #for ubuntu
>> which pip3
/usr/bin/pip3 #for ubuntu
```

## Step 1: create a folder for the whole project

At a location of your choosing, make a folder for all the dependencies and programs:

```bash
>> mkdir /path/to/graphstream
```

## Step 2: Install ```dgs-graphstream``` and its dependencies

### 2.1 Clone ```dgs-graphstream```

[dgs-graphstream](https://github.com/paulantoineb/dgs-graphstream) can be cloned from github:

```bash
>> cd /path/to/graphstream
>> git clone https://github.com/paulantoineb/dgs-graphstream.git
```

### 2.2 Build [OSLOM2](http://www.oslom.org/software.htm)

```bash
>> wget http://www.oslom.org/code/OSLOM2.tar.gz
>> tar -xvzf OSLOM2.tar.gz
>> cd OSLOM2/
>> ./compile_all.sh
```

### 2.3 Build [Infomap](http://www.mapequation.org/code.html#Linux)

```bash
>> wget http://www.mapequation.org/downloads/Infomap.zip
>> unzip Infomap.zip -d Infomap
>> cd Infomap/
>> make
```

### 2.4 Build modified [Graphviz](https://gitlab.com/paulantoineb/graphviz) ([dependencies](https://graphviz.gitlab.io/_pages/Download/Download_source.html))

This fork of Graphviz is required. It modifies ```gvmap``` to color individual nodes instead of clusters. There are several dependencies required to build the modified version of ```gvmap```, see below for the instructions on the dependencies.

```bash
# depends on "libtool", "automake", and "autoconf"
>> git clone https://gitlab.com/paulantoineb/graphviz.git
>> cd graphviz/
>> ./autogen.sh
>> ./configure
>> make
```

If needed, ```autoconf``` can be installed with the following command if required.

```bash
# Ubuntu
>> sudo apt-get install autoconf
```

If needed, ```libtool``` can be installed with the following command if required.

```bash
# Ubuntu
>> sudo apt install libtool-bin
```

```gvmap``` requires ```gts``` to be installed and available, for the compilation to proceed. If you see the line "gts: No (gts library not available)" when running ```./autogen.sh```, you need to install ```gts``` and then repeat the build steps from the point where you run ```./autogen.sh```. If everything is setup properly, you will see "gts: Yes" when running ```autogen.sh```.

Installing ```gts```:

```bash
# Ubuntu
sudo apt install libgts-dev
sudo pkg-config --libs gts
sudo pkg-config --cflags gts
```

Installing ```flex``` and ```bison```, required for building ```graphviz```:

```bash
# ubuntu
# flex and bison may be required
>> sudo apt-get install flex
>> sudo apt-get install bison
```

```graphviz``` may encounter issues when running ```make```. To build ```gvmap``` only do the following:


```bash
# Compiling graphviz if there are crashes
>> cd graphviz/lib
>> make
# wait for building the libraries of graphviz
>> cd graphviz/cmd/gvmap
>> make #build gvmpa only
```


### 2.5 Install ImageMagick ```montage```

On Ubuntu systems, ```montage``` utility should be installed. On ```macOS``` you may install it:

```bash
>> brew install montage
```

### 2.6 Install ```ffmpeg``` 

On Ubuntu systems, ```ffmpeg``` utility should be installed. On ```macOS``` you may install it:

```bash
# ubuntu
>> sudo apt install ffmpeg
# macOS
>> brew install ffmpeg
```

### 2.7 Building ```dgs-graphstream``` JAVA library

This requires Java JDK and ```ant```:

```bash
# Ubuntu
>> sudo apt-get install default-jdk
>> sudo apt install ant
```

You can then install the python packages that are required and build the Java library.

``` bash
# installing most python package dependencies
cd dgs-graphstream/
pip3 install -r requirements.txt

# Building the Java library (depends on the `Java JDK` and `ant`)
cd dgs-graphstream/
ant
cd ..
```

### 2.8 Updating the configuration file
After installing the dependencies and dgs-graphstream , update (or create if it doesn't exist) the ```config.ini``` file which s with the installation directories of ```OSLOM2```, ```infomap``` and ```gvmap```:

```bash
[install_dirs]
oslom2 = /home/paulantoineb/bin/OSLOM2/
infomap = /home/paulantoineb/bin/infomap/
gvmap = /home/paulantoineb/bin/graphviz/cmd/gvmap/
```

## Step 3: Installing ```python``` dependencies

### 3.1 Installing [```nxmetis``` Python Package](https://networkx-metis.readthedocs.io/en/latest/install.html)

This package cannot be installed using ```pip3``` for ```python3``` as it doesn't seem to be available at the time of writing this [Aug 2018].

The alternative approach to installing the package consists in following the "install from source" instructions on the ```networkx-metis``` [installation page](https://networkx-metis.readthedocs.io/en/latest/install.html).

The build process requires ```Cython```:

``` bash
>> pip3 install Cython
```


### 3.2 Other python packages

They can be installed via the requirements.txt file.

If there are problems with ```pip3 install pygraphviz``` installation on ```ubuntu```:

```bash
>> sudo apt-get install lib-graphviz-dev # or libgraphviz-dev
```


## Step 4: Running ```dgs-graphstream```

For a trial run, to check everything is setup properly execute:

```bash
>> cd path/to/dgs-graphstream
>> python3 genGraphStream.py -g inputs/network_1.txt -f metis -a ./inputs/assignments.txt  -o output/ -c oslom2 --video output/vid.mp4 --pdf 5
```

### 4.1 Fixing ```svglib``` ```error xrange not found```

In case you get ```xrange``` not found error, this is due to the fact that ```svglib``` requires ```python2.7``` that has the old ```xrange``` function which is called ```range``` in ```python3+```.

Updating ```svglib.py``` in case you get the error inside ```svglib.py```. You need to locate the folder in which your ```python``` packages are installed. See below for instructions in updating the ```svglib``` package once you know the path. On ```Ubunutu```:

```bash
# Error message you get if xrange is not defined:
File "/home/<your-username>/.local/lib/python3.6/site-packages/svglib/svglib.py", line 747, in convertPath
   for i in xrange(0, len(normPath), 2):
NameError: name 'xrange' is not defined
```

Manually update ```svglib```

```bash
>> nano /home/<your-username>/.local/lib/python3.6/site-packages/svglib/svglib.py
# add: xrange = range after the imports instructions
# save

>> nano /home/<your-username>/.local/lib/python3.6/site-packages/svglib/utils.py
# add: xrange = range after the imports instructions
# save

```

### 4.2 Fixing ```xrange missing``` from ```dgs-graphstream/image.py```

Open ```dgs-graphstream/image.py``` in a plain text editor. Add ```xrange = range``` after all the import statements. Save and close the file.

## Step 5: Installing ```ESRVisualizer-ui```

### 5.1 Clone the repository
[ESRVisualizer-ui](https://github.com/cmmin/ESRVisualizer-ui.git) can be cloned from github:

```bash
>> cd /path/to/graphstream
>> git clone https://github.com/cmmin/ESRVisualizer-ui.git
```

### 5.2 Install ```PyQt5``` (requires ```python3.6+```)

```bash
>> pip3 install PyQt5
```

### 5.3 Running ```ESRVisualizer-ui```

You can launch the program by running the ```__main__.py``` with ```python3```:

```bash
>> cd ESRVisualizer-ui/src
>> python3 __main__.py
# The first time you run this it will take a while for
# the application to launch, since Qt will be generating
# all the UI component files.
```

### 5.4 Updating application settings: dependencies

When you launch the application, you may see, in red, "DGS GRAPHSTREAM - errors in settings, cannot run". This is because 

1. ```ESRVisualizer-ui``` needs to know the full paths to ```dgs-graphstream```, ```ffmpeg```, ```montage``` and the full paths to the folders that contain the executables for```OSLOM2```, ```gvmap``` & ```infomap```.

- Graphstream Folder: ```path/to/dgs-graphstream```
- OSLOM2 Folder: ```/full/path/to/OSLOM2/```
- Infomap Folder: ```/full/path/to/Infomap```
- Gvmap Folder: ```/full/path/to/graphviz/cmd/gvmap```

To get the ```montage``` and ```ffmpeg``` paths, type:

```bash
# macOS
>> which montage
/usr/local/bin/montage
>> which ffmpeg
/usr/local/bin/ffmpeg
```

2. ```ESRVisualizer-ui``` checks for all the available ```python3``` packages and warns whether any still need to be installed (install via: ```pip3 install <packagename>``` and then relaunch ```ESRVisualizer-ui```)

## Step 6: Creating and loading Projects

### 6.1 Creating an Empty new Project

When ```ESRVisualizer-ui``` launches, select "Create New Project".

You will need to pick a new folder that is empty, that contains no ```dgs_config.txt``` file.

You can then click "Create Project" and you will be taken to the Run screen.


### 6.2 Creating a new Project from Examples

When ```ESRVisualizer-ui``` launches, select "Create New Project".

You will need to pick a new folder that is empty, that contains no ```dgs_config.txt``` file.

You can then select "Example Project" from the dropdown. 

If any examples are available, you will see the title in a dropdown component. Selecting an example will show the example's description as well.

Finally, click "Create Project" and you will be taken to the Run screen.
 
### 6.3 Loading an existing Project

When ```ESRVisualizer-ui``` launches, select "Load Existing Project".

You will need to pick the existing project folder that contains the ```dgs_config.txt``` file.

You can then click "Open Project" and you will be taken to the Run screen.

## Other Information

### Adding new Examples

1. Create an empty new project in a new folder located at ```path/to/ESRVisualizer-ui/examples/```
2. In that folder, create a subfolder called ```inputs```. In this folder, copy over the input files required for the examples. This will include the netwok graph file and possibly the assignments, node order, etc files. 
3. Use the ```ESRVisualizer-ui``` program to setup the full example parameters
4. Add the new example and commit to the repository via ```git```, if you want to share this with everyone else

### Changing the UI tooltip texts

Open ```path/to/ESRVisualizer-ui/src/qml/assets/uitext.csv``` in a plain text editor. The file is organised with comma separated values. 

Each row consists of: ```tooltipCodeName,<text to be displayed for that tooltip>```

Do not modify the ```tooltipCodeName``` part. The second part may contain as many commas as required, but no new lines (the text should all be on a single line in this csv file).


