
################################################################
# This is a generated script based on design: bd
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2020.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source bd_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# classifier

# Please add the sources of those modules before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7z020clg400-3
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name bd

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_gid_msg -ssname BD::TCL -id 2001 -severity "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_gid_msg -ssname BD::TCL -id 2002 -severity "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_gid_msg -ssname BD::TCL -id 2003 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_gid_msg -ssname BD::TCL -id 2004 -severity "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_gid_msg -ssname BD::TCL -id 2005 -severity "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_gid_msg -ssname BD::TCL -id 2006 -severity "ERROR" $errMsg}
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set DDR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR ]

  set FIXED_IO [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO ]


  # Create ports

  # Create instance: axi_dma_pl2ps, and set properties
  set axi_dma_pl2ps [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_pl2ps ]
  set_property -dict [ list \
   CONFIG.c_include_mm2s {0} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_s_axis_s2mm_tdata_width {32} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $axi_dma_pl2ps

  # Create instance: axi_dma_ps2pl, and set properties
  set axi_dma_ps2pl [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_ps2pl ]
  set_property -dict [ list \
   CONFIG.c_include_s2mm {0} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axis_mm2s_tdata_width {32} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $axi_dma_ps2pl

  # Create instance: axis_data_fifo_pl2ps, and set properties
  set axis_data_fifo_pl2ps [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_pl2ps ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {8192} \
   CONFIG.HAS_TLAST {1} \
   CONFIG.TDATA_NUM_BYTES {4} \
 ] $axis_data_fifo_pl2ps

  # Create instance: axis_data_fifo_ps2pl, and set properties
  set axis_data_fifo_ps2pl [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_ps2pl ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {8192} \
   CONFIG.HAS_TLAST {1} \
   CONFIG.TDATA_NUM_BYTES {4} \
 ] $axis_data_fifo_ps2pl

  # Create instance: classifier_0, and set properties
  set block_name classifier
  set block_cell_name classifier_0
  if { [catch {set classifier_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $classifier_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]
  set_property -dict [ list \
   CONFIG.C_AUX_RESET_HIGH {0} \
 ] $proc_sys_reset_0

  # Create instance: processing_system7_0, and set properties
  set processing_system7_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0 ]
  set_property -dict [ list \
   CONFIG.PCW_FPGA_FCLK0_ENABLE {1} \
   CONFIG.PCW_FPGA_FCLK1_ENABLE {0} \
   CONFIG.PCW_FPGA_FCLK2_ENABLE {0} \
   CONFIG.PCW_FPGA_FCLK3_ENABLE {0} \
   CONFIG.PCW_S_AXI_HP0_DATA_WIDTH {64} \
   CONFIG.PCW_S_AXI_HP2_DATA_WIDTH {64} \
   CONFIG.PCW_USE_S_AXI_HP0 {1} \
   CONFIG.PCW_USE_S_AXI_HP2 {1} \
 ] $processing_system7_0

  # Create instance: smartconnect_0, and set properties
  set smartconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_0 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {2} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_0

  # Create instance: smartconnect_pl2ps, and set properties
  set smartconnect_pl2ps [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_pl2ps ]
  set_property -dict [ list \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_pl2ps

  # Create instance: smartconnect_ps2pl, and set properties
  set smartconnect_ps2pl [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_ps2pl ]
  set_property -dict [ list \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_ps2pl

  # Create interface connections
  connect_bd_intf_net -intf_net axi_dma_pl2ps_M_AXI_S2MM [get_bd_intf_pins axi_dma_pl2ps/M_AXI_S2MM] [get_bd_intf_pins smartconnect_pl2ps/S00_AXI]
  connect_bd_intf_net -intf_net axi_dma_ps2pl_M_AXIS_MM2S [get_bd_intf_pins axi_dma_ps2pl/M_AXIS_MM2S] [get_bd_intf_pins axis_data_fifo_ps2pl/S_AXIS]
  connect_bd_intf_net -intf_net axi_dma_ps2pl_M_AXI_MM2S [get_bd_intf_pins axi_dma_ps2pl/M_AXI_MM2S] [get_bd_intf_pins smartconnect_ps2pl/S00_AXI]
  connect_bd_intf_net -intf_net axis_data_fifo_pl2ps_M_AXIS [get_bd_intf_pins axi_dma_pl2ps/S_AXIS_S2MM] [get_bd_intf_pins axis_data_fifo_pl2ps/M_AXIS]
  connect_bd_intf_net -intf_net axis_data_fifo_ps2pl_M_AXIS [get_bd_intf_pins axis_data_fifo_ps2pl/M_AXIS] [get_bd_intf_pins classifier_0/S_AXIS]
  connect_bd_intf_net -intf_net classifier_0_M_AXIS [get_bd_intf_pins axis_data_fifo_pl2ps/S_AXIS] [get_bd_intf_pins classifier_0/M_AXIS]
  connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins processing_system7_0/DDR]
  connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins processing_system7_0/FIXED_IO]
  connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP0 [get_bd_intf_pins processing_system7_0/M_AXI_GP0] [get_bd_intf_pins smartconnect_0/S00_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M00_AXI [get_bd_intf_pins axi_dma_ps2pl/S_AXI_LITE] [get_bd_intf_pins smartconnect_0/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M01_AXI [get_bd_intf_pins axi_dma_pl2ps/S_AXI_LITE] [get_bd_intf_pins smartconnect_0/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_pl2ps_M00_AXI [get_bd_intf_pins processing_system7_0/S_AXI_HP0] [get_bd_intf_pins smartconnect_pl2ps/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_ps2pl_M00_AXI [get_bd_intf_pins processing_system7_0/S_AXI_HP2] [get_bd_intf_pins smartconnect_ps2pl/M00_AXI]

  # Create port connections
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn [get_bd_pins axi_dma_pl2ps/axi_resetn] [get_bd_pins axi_dma_ps2pl/axi_resetn] [get_bd_pins axis_data_fifo_pl2ps/s_axis_aresetn] [get_bd_pins axis_data_fifo_ps2pl/s_axis_aresetn] [get_bd_pins classifier_0/M_AXIS_ARESETN] [get_bd_pins classifier_0/S_AXIS_ARESETN] [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins smartconnect_0/aresetn] [get_bd_pins smartconnect_pl2ps/aresetn] [get_bd_pins smartconnect_ps2pl/aresetn]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins axi_dma_pl2ps/m_axi_s2mm_aclk] [get_bd_pins axi_dma_pl2ps/s_axi_lite_aclk] [get_bd_pins axi_dma_ps2pl/m_axi_mm2s_aclk] [get_bd_pins axi_dma_ps2pl/s_axi_lite_aclk] [get_bd_pins axis_data_fifo_pl2ps/s_axis_aclk] [get_bd_pins axis_data_fifo_ps2pl/s_axis_aclk] [get_bd_pins classifier_0/M_AXIS_ACLK] [get_bd_pins classifier_0/S_AXIS_ACLK] [get_bd_pins proc_sys_reset_0/slowest_sync_clk] [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins processing_system7_0/S_AXI_HP0_ACLK] [get_bd_pins processing_system7_0/S_AXI_HP2_ACLK] [get_bd_pins smartconnect_0/aclk] [get_bd_pins smartconnect_pl2ps/aclk] [get_bd_pins smartconnect_ps2pl/aclk]
  connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins proc_sys_reset_0/ext_reset_in] [get_bd_pins processing_system7_0/FCLK_RESET0_N]

  # Create address segments
  assign_bd_address -offset 0x00000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces axi_dma_pl2ps/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] -force
  assign_bd_address -offset 0x00000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces axi_dma_ps2pl/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP2/HP2_DDR_LOWOCM] -force
  assign_bd_address -offset 0x40410000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_dma_pl2ps/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0x40400000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_dma_ps2pl/S_AXI_LITE/Reg] -force


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


