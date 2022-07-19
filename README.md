# PEG-PHEMA-Organogel
This is a LAMMPS simulation code for simulating PEG-PHEMA organogel with Lithium Chlorides


**0_model_create**

The input data file is not provided, but is able to create through PACKMOL:

https://github.com/m3g/packmol

Other softwares for creating initial model is also recomended:
Winmostar: https://winmostar.com/en/
Material Studio: https://www.3ds.com/products-services/biovia/products/molecular-modeling-simulation/biovia-materials-studio/



**1_LAMMPS_input_code**


The total process is divided into 3 parts:

(1) Minimization:

lmp_serial -in 0_Minimize.in

(2) Equilibrium under NPT and NVT:

lmp_serial -in 1_Equilibrium.in

(3) Tensile test using NVT deform:

lmp_serial -in 2_Tensile.in



**2_analysis_code**

The analyzing software for the result of simualtion is performed mainly in Visual Molecular Dynamics:

https://github.com/nbcrrolls/vmd

TCL script used for analyzing is provided:

(1) End-to-end distance and radius of gyration of per PEG and PHEMA polymers:

vmd -dispdev text -e 0_EL_Rg.tcl


(2) Hydrogen bond calculation due to different group of polymers (PEG-PEG / PEG-PHEMA etc...)

vmd -dispdev text -e 1_Hydrogen_bond.tcl

Hydrogen bond with self definition is also provided in 1_Hydrogen_bond_self_define.tcl
with the distance between hydrogen and acceptor < 3.5 angstrom
and angle > 150 degree

vmd -dispdev text -e 1_Hydrogen_bond_self_define.tcl

(3) Coordination bond calculation

vmd -dispdev text -e 2_Coordination_Bond.tcl

(4) Ion cluster search

vmd -dispdev text -e 3_Ion_cluster.tcl

