# Data Processor

This data processor takes .lvm files, converts them to .csv, and allows the user to plot data from csv files.

---
## Table of Contents

* [About](#about)
* [Installation](#installation)
* [Usage](#usage)

---
## About

This is for processing LabView data from the WSU MARS Hybrid Rocket. This script runs as a webapp. It functions as follows:

**Tab 1:**
1. Reads .lvm files.
2. Manipulates column data and perform calculations.
3. Exports manipulated data in .csv format.

**Tab 2:**
4. Reads .csv files.
    * Works with almost any .csv file containing column headers.
5. Generate, save, and export data plots.

### Column Data Manipulation

There are several columns of data that are modified by this script:

* All pressure columns [PS, PU, PI, PC] multiplied by 110
* Mass Flow Rate [MDOT] calculated 
    * PU and PD converted from units of psig to Pa
    * Intermediate calculations for Orifice Plate Area, β (Diameter Ratio of Orifice Plate), and Upstream Densirty 
    * Mass Flow calculated
    * Original PD column replaced with MDOT
* Potentiometer [POT1] data converted to Valve % Open

### Plotting Data

This app allows the user to select which columns of data are used for the x and y-axis. The y-axis supports multiple columns of data.
Each plot can be saved and a new plot may be generated. This can be done as many times as desired.
All saved plots can be exported and downloaded as one .png image.

---
## Installation

This section covers creating a virtual environment (venv) and the installation of required dependencies.
*If Python is not installed, [click here](https://www.python.org/downloads/) for instructions on how to install it.*
**Ensure** dataprocessor.py **and** requirements.txt **are located within the same folder** (this should already be the case if extracted from .zip file).
This process may be done in Terminal, Microsoft VS Code, or any terminal of choice. *(Note: If using VS Code, ensure the terminal is opened to Command Prompt and not Powershell.)*

### Opening Terminal

* In the terminal, open the directory to the folder containing dataprocessor.py.
    * Type "cd " followed by the folder address. The address can be found by right clicking on folder and selecting "Copy as path". *Alternatively: Right click on the folder and select "Open in Terminal".*

### Creating Virtual Envionment (venv)

**To create venv:**
"python -m venv venv"

**To activate venv:**
"source venv/bin/activate"

### Install Dependencies
"pip install -r requirements.txt"

The required dependencies must be installed for the app to work.

---
## Usage

If the terminal is not already in the venv follow these steps:
* To open the correct directory, see [Opening Terminal](#opening-terminal)
* To activate the venv enter "source venv/bin/activate"

### Runing the App
"streamlit run dataprocessor.py"

---
 -- End of README_Unix --
