
# Simulation configuration
set_property top TbImageDownscaler [get_filesets sim_1]
set_property -name {xsim.simulate.runtime} -value {1000ns} -objects [get_filesets sim_1]