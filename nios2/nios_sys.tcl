# qsys scripting (.tcl) file for nios_sys
package require -exact qsys 16.0

create_system {nios_sys}

set_project_property DEVICE_FAMILY {Cyclone V}
set_project_property DEVICE {5CSEMA5F31C6}
set_project_property HIDE_FROM_IP_CATALOG {false}

# Instances and instance parameters
# (disabled instances are intentionally culled)
add_instance AXI_light_7seg_slave_0 AXI_light_7seg_slave 1.0
set_instance_parameter_value AXI_light_7seg_slave_0 {ADDR_WIDTH} {5}

add_instance OnChipMem altera_avalon_onchip_memory2 21.1
set_instance_parameter_value OnChipMem {allowInSystemMemoryContentEditor} {0}
set_instance_parameter_value OnChipMem {blockType} {AUTO}
set_instance_parameter_value OnChipMem {copyInitFile} {0}
set_instance_parameter_value OnChipMem {dataWidth} {32}
set_instance_parameter_value OnChipMem {dataWidth2} {32}
set_instance_parameter_value OnChipMem {dualPort} {0}
set_instance_parameter_value OnChipMem {ecc_enabled} {0}
set_instance_parameter_value OnChipMem {enPRInitMode} {0}
set_instance_parameter_value OnChipMem {enableDiffWidth} {0}
set_instance_parameter_value OnChipMem {initMemContent} {1}
set_instance_parameter_value OnChipMem {initializationFileName} {onchip_mem.hex}
set_instance_parameter_value OnChipMem {instanceID} {NONE}
set_instance_parameter_value OnChipMem {memorySize} {40960.0}
set_instance_parameter_value OnChipMem {readDuringWriteMode} {DONT_CARE}
set_instance_parameter_value OnChipMem {resetrequest_enabled} {1}
set_instance_parameter_value OnChipMem {simAllowMRAMContentsFile} {0}
set_instance_parameter_value OnChipMem {simMemInitOnlyFilename} {0}
set_instance_parameter_value OnChipMem {singleClockOperation} {0}
set_instance_parameter_value OnChipMem {slave1Latency} {1}
set_instance_parameter_value OnChipMem {slave2Latency} {1}
set_instance_parameter_value OnChipMem {useNonDefaultInitFile} {0}
set_instance_parameter_value OnChipMem {useShallowMemBlocks} {0}
set_instance_parameter_value OnChipMem {writable} {1}

add_instance clk_0 clock_source 21.1
set_instance_parameter_value clk_0 {clockFrequency} {50000000.0}
set_instance_parameter_value clk_0 {clockFrequencyKnown} {1}
set_instance_parameter_value clk_0 {resetSynchronousEdges} {NONE}

add_instance juart altera_avalon_jtag_uart 21.1
set_instance_parameter_value juart {allowMultipleConnections} {0}
set_instance_parameter_value juart {hubInstanceID} {0}
set_instance_parameter_value juart {readBufferDepth} {64}
set_instance_parameter_value juart {readIRQThreshold} {8}
set_instance_parameter_value juart {simInputCharacterStream} {}
set_instance_parameter_value juart {simInteractiveOptions} {NO_INTERACTIVE_WINDOWS}
set_instance_parameter_value juart {useRegistersForReadBuffer} {0}
set_instance_parameter_value juart {useRegistersForWriteBuffer} {0}
set_instance_parameter_value juart {useRelativePathForSimFile} {0}
set_instance_parameter_value juart {writeBufferDepth} {64}
set_instance_parameter_value juart {writeIRQThreshold} {8}

add_instance leds_pio altera_avalon_pio 21.1
set_instance_parameter_value leds_pio {bitClearingEdgeCapReg} {0}
set_instance_parameter_value leds_pio {bitModifyingOutReg} {0}
set_instance_parameter_value leds_pio {captureEdge} {0}
set_instance_parameter_value leds_pio {direction} {Output}
set_instance_parameter_value leds_pio {edgeType} {RISING}
set_instance_parameter_value leds_pio {generateIRQ} {0}
set_instance_parameter_value leds_pio {irqType} {LEVEL}
set_instance_parameter_value leds_pio {resetValue} {0.0}
set_instance_parameter_value leds_pio {simDoTestBenchWiring} {0}
set_instance_parameter_value leds_pio {simDrivenValue} {0.0}
set_instance_parameter_value leds_pio {width} {10}

add_instance nios2_cpu altera_nios2_gen2 21.1
set_instance_parameter_value nios2_cpu {bht_ramBlockType} {Automatic}
set_instance_parameter_value nios2_cpu {breakOffset} {32}
set_instance_parameter_value nios2_cpu {breakSlave} {None}
set_instance_parameter_value nios2_cpu {cdx_enabled} {0}
set_instance_parameter_value nios2_cpu {cpuArchRev} {1}
set_instance_parameter_value nios2_cpu {cpuID} {0}
set_instance_parameter_value nios2_cpu {cpuReset} {0}
set_instance_parameter_value nios2_cpu {data_master_high_performance_paddr_base} {0}
set_instance_parameter_value nios2_cpu {data_master_high_performance_paddr_size} {0.0}
set_instance_parameter_value nios2_cpu {data_master_paddr_base} {0}
set_instance_parameter_value nios2_cpu {data_master_paddr_size} {0.0}
set_instance_parameter_value nios2_cpu {dcache_bursts} {false}
set_instance_parameter_value nios2_cpu {dcache_numTCDM} {0}
set_instance_parameter_value nios2_cpu {dcache_ramBlockType} {Automatic}
set_instance_parameter_value nios2_cpu {dcache_size} {2048}
set_instance_parameter_value nios2_cpu {dcache_tagramBlockType} {Automatic}
set_instance_parameter_value nios2_cpu {dcache_victim_buf_impl} {ram}
set_instance_parameter_value nios2_cpu {debug_OCIOnchipTrace} {_128}
set_instance_parameter_value nios2_cpu {debug_assignJtagInstanceID} {0}
set_instance_parameter_value nios2_cpu {debug_datatrigger} {0}
set_instance_parameter_value nios2_cpu {debug_debugReqSignals} {0}
set_instance_parameter_value nios2_cpu {debug_enabled} {1}
set_instance_parameter_value nios2_cpu {debug_hwbreakpoint} {0}
set_instance_parameter_value nios2_cpu {debug_jtagInstanceID} {0}
set_instance_parameter_value nios2_cpu {debug_traceStorage} {onchip_trace}
set_instance_parameter_value nios2_cpu {debug_traceType} {none}
set_instance_parameter_value nios2_cpu {debug_triggerArming} {1}
set_instance_parameter_value nios2_cpu {dividerType} {no_div}
set_instance_parameter_value nios2_cpu {exceptionOffset} {32}
set_instance_parameter_value nios2_cpu {exceptionSlave} {OnChipMem.s1}
set_instance_parameter_value nios2_cpu {fa_cache_line} {2}
set_instance_parameter_value nios2_cpu {fa_cache_linesize} {0}
set_instance_parameter_value nios2_cpu {flash_instruction_master_paddr_base} {0}
set_instance_parameter_value nios2_cpu {flash_instruction_master_paddr_size} {0.0}
set_instance_parameter_value nios2_cpu {icache_burstType} {None}
set_instance_parameter_value nios2_cpu {icache_numTCIM} {0}
set_instance_parameter_value nios2_cpu {icache_ramBlockType} {Automatic}
set_instance_parameter_value nios2_cpu {icache_size} {4096}
set_instance_parameter_value nios2_cpu {icache_tagramBlockType} {Automatic}
set_instance_parameter_value nios2_cpu {impl} {Tiny}
set_instance_parameter_value nios2_cpu {instruction_master_high_performance_paddr_base} {0}
set_instance_parameter_value nios2_cpu {instruction_master_high_performance_paddr_size} {0.0}
set_instance_parameter_value nios2_cpu {instruction_master_paddr_base} {0}
set_instance_parameter_value nios2_cpu {instruction_master_paddr_size} {0.0}
set_instance_parameter_value nios2_cpu {io_regionbase} {0}
set_instance_parameter_value nios2_cpu {io_regionsize} {0}
set_instance_parameter_value nios2_cpu {master_addr_map} {0}
set_instance_parameter_value nios2_cpu {mmu_TLBMissExcOffset} {0}
set_instance_parameter_value nios2_cpu {mmu_TLBMissExcSlave} {None}
set_instance_parameter_value nios2_cpu {mmu_autoAssignTlbPtrSz} {1}
set_instance_parameter_value nios2_cpu {mmu_enabled} {0}
set_instance_parameter_value nios2_cpu {mmu_processIDNumBits} {8}
set_instance_parameter_value nios2_cpu {mmu_ramBlockType} {Automatic}
set_instance_parameter_value nios2_cpu {mmu_tlbNumWays} {16}
set_instance_parameter_value nios2_cpu {mmu_tlbPtrSz} {7}
set_instance_parameter_value nios2_cpu {mmu_udtlbNumEntries} {6}
set_instance_parameter_value nios2_cpu {mmu_uitlbNumEntries} {4}
set_instance_parameter_value nios2_cpu {mpu_enabled} {0}
set_instance_parameter_value nios2_cpu {mpu_minDataRegionSize} {12}
set_instance_parameter_value nios2_cpu {mpu_minInstRegionSize} {12}
set_instance_parameter_value nios2_cpu {mpu_numOfDataRegion} {8}
set_instance_parameter_value nios2_cpu {mpu_numOfInstRegion} {8}
set_instance_parameter_value nios2_cpu {mpu_useLimit} {0}
set_instance_parameter_value nios2_cpu {mpx_enabled} {0}
set_instance_parameter_value nios2_cpu {mul_32_impl} {2}
set_instance_parameter_value nios2_cpu {mul_64_impl} {0}
set_instance_parameter_value nios2_cpu {mul_shift_choice} {0}
set_instance_parameter_value nios2_cpu {ocimem_ramBlockType} {Automatic}
set_instance_parameter_value nios2_cpu {ocimem_ramInit} {0}
set_instance_parameter_value nios2_cpu {regfile_ramBlockType} {Automatic}
set_instance_parameter_value nios2_cpu {register_file_por} {0}
set_instance_parameter_value nios2_cpu {resetOffset} {0}
set_instance_parameter_value nios2_cpu {resetSlave} {OnChipMem.s1}
set_instance_parameter_value nios2_cpu {resetrequest_enabled} {1}
set_instance_parameter_value nios2_cpu {setting_HBreakTest} {0}
set_instance_parameter_value nios2_cpu {setting_HDLSimCachesCleared} {1}
set_instance_parameter_value nios2_cpu {setting_activateMonitors} {1}
set_instance_parameter_value nios2_cpu {setting_activateTestEndChecker} {0}
set_instance_parameter_value nios2_cpu {setting_activateTrace} {0}
set_instance_parameter_value nios2_cpu {setting_allow_break_inst} {0}
set_instance_parameter_value nios2_cpu {setting_alwaysEncrypt} {1}
set_instance_parameter_value nios2_cpu {setting_asic_add_scan_mode_input} {0}
set_instance_parameter_value nios2_cpu {setting_asic_enabled} {0}
set_instance_parameter_value nios2_cpu {setting_asic_synopsys_translate_on_off} {0}
set_instance_parameter_value nios2_cpu {setting_asic_third_party_synthesis} {0}
set_instance_parameter_value nios2_cpu {setting_avalonDebugPortPresent} {0}
set_instance_parameter_value nios2_cpu {setting_bhtPtrSz} {8}
set_instance_parameter_value nios2_cpu {setting_bigEndian} {0}
set_instance_parameter_value nios2_cpu {setting_branchpredictiontype} {Dynamic}
set_instance_parameter_value nios2_cpu {setting_breakslaveoveride} {0}
set_instance_parameter_value nios2_cpu {setting_clearXBitsLDNonBypass} {1}
set_instance_parameter_value nios2_cpu {setting_dc_ecc_present} {1}
set_instance_parameter_value nios2_cpu {setting_disable_tmr_inj} {0}
set_instance_parameter_value nios2_cpu {setting_disableocitrace} {0}
set_instance_parameter_value nios2_cpu {setting_dtcm_ecc_present} {1}
set_instance_parameter_value nios2_cpu {setting_ecc_present} {0}
set_instance_parameter_value nios2_cpu {setting_ecc_sim_test_ports} {0}
set_instance_parameter_value nios2_cpu {setting_exportHostDebugPort} {0}
set_instance_parameter_value nios2_cpu {setting_exportPCB} {0}
set_instance_parameter_value nios2_cpu {setting_export_large_RAMs} {0}
set_instance_parameter_value nios2_cpu {setting_exportdebuginfo} {0}
set_instance_parameter_value nios2_cpu {setting_exportvectors} {0}
set_instance_parameter_value nios2_cpu {setting_fast_register_read} {0}
set_instance_parameter_value nios2_cpu {setting_ic_ecc_present} {1}
set_instance_parameter_value nios2_cpu {setting_interruptControllerType} {Internal}
set_instance_parameter_value nios2_cpu {setting_itcm_ecc_present} {1}
set_instance_parameter_value nios2_cpu {setting_mmu_ecc_present} {1}
set_instance_parameter_value nios2_cpu {setting_oci_export_jtag_signals} {0}
set_instance_parameter_value nios2_cpu {setting_oci_version} {1}
set_instance_parameter_value nios2_cpu {setting_preciseIllegalMemAccessException} {0}
set_instance_parameter_value nios2_cpu {setting_removeRAMinit} {0}
set_instance_parameter_value nios2_cpu {setting_rf_ecc_present} {1}
set_instance_parameter_value nios2_cpu {setting_shadowRegisterSets} {0}
set_instance_parameter_value nios2_cpu {setting_showInternalSettings} {0}
set_instance_parameter_value nios2_cpu {setting_showUnpublishedSettings} {0}
set_instance_parameter_value nios2_cpu {setting_support31bitdcachebypass} {1}
set_instance_parameter_value nios2_cpu {setting_tmr_output_disable} {0}
set_instance_parameter_value nios2_cpu {setting_usedesignware} {0}
set_instance_parameter_value nios2_cpu {shift_rot_impl} {1}
set_instance_parameter_value nios2_cpu {tightly_coupled_data_master_0_paddr_base} {0}
set_instance_parameter_value nios2_cpu {tightly_coupled_data_master_0_paddr_size} {0.0}
set_instance_parameter_value nios2_cpu {tightly_coupled_data_master_1_paddr_base} {0}
set_instance_parameter_value nios2_cpu {tightly_coupled_data_master_1_paddr_size} {0.0}
set_instance_parameter_value nios2_cpu {tightly_coupled_data_master_2_paddr_base} {0}
set_instance_parameter_value nios2_cpu {tightly_coupled_data_master_2_paddr_size} {0.0}
set_instance_parameter_value nios2_cpu {tightly_coupled_data_master_3_paddr_base} {0}
set_instance_parameter_value nios2_cpu {tightly_coupled_data_master_3_paddr_size} {0.0}
set_instance_parameter_value nios2_cpu {tightly_coupled_instruction_master_0_paddr_base} {0}
set_instance_parameter_value nios2_cpu {tightly_coupled_instruction_master_0_paddr_size} {0.0}
set_instance_parameter_value nios2_cpu {tightly_coupled_instruction_master_1_paddr_base} {0}
set_instance_parameter_value nios2_cpu {tightly_coupled_instruction_master_1_paddr_size} {0.0}
set_instance_parameter_value nios2_cpu {tightly_coupled_instruction_master_2_paddr_base} {0}
set_instance_parameter_value nios2_cpu {tightly_coupled_instruction_master_2_paddr_size} {0.0}
set_instance_parameter_value nios2_cpu {tightly_coupled_instruction_master_3_paddr_base} {0}
set_instance_parameter_value nios2_cpu {tightly_coupled_instruction_master_3_paddr_size} {0.0}
set_instance_parameter_value nios2_cpu {tmr_enabled} {0}
set_instance_parameter_value nios2_cpu {tracefilename} {}
set_instance_parameter_value nios2_cpu {userDefinedSettings} {}

add_instance pb_pio altera_avalon_pio 21.1
set_instance_parameter_value pb_pio {bitClearingEdgeCapReg} {0}
set_instance_parameter_value pb_pio {bitModifyingOutReg} {0}
set_instance_parameter_value pb_pio {captureEdge} {1}
set_instance_parameter_value pb_pio {direction} {Input}
set_instance_parameter_value pb_pio {edgeType} {FALLING}
set_instance_parameter_value pb_pio {generateIRQ} {1}
set_instance_parameter_value pb_pio {irqType} {EDGE}
set_instance_parameter_value pb_pio {resetValue} {0.0}
set_instance_parameter_value pb_pio {simDoTestBenchWiring} {0}
set_instance_parameter_value pb_pio {simDrivenValue} {0.0}
set_instance_parameter_value pb_pio {width} {3}

add_instance sw_pio altera_avalon_pio 21.1
set_instance_parameter_value sw_pio {bitClearingEdgeCapReg} {0}
set_instance_parameter_value sw_pio {bitModifyingOutReg} {0}
set_instance_parameter_value sw_pio {captureEdge} {0}
set_instance_parameter_value sw_pio {direction} {Input}
set_instance_parameter_value sw_pio {edgeType} {RISING}
set_instance_parameter_value sw_pio {generateIRQ} {0}
set_instance_parameter_value sw_pio {irqType} {LEVEL}
set_instance_parameter_value sw_pio {resetValue} {0.0}
set_instance_parameter_value sw_pio {simDoTestBenchWiring} {0}
set_instance_parameter_value sw_pio {simDrivenValue} {0.0}
set_instance_parameter_value sw_pio {width} {10}

add_instance timer altera_avalon_timer 21.1
set_instance_parameter_value timer {alwaysRun} {0}
set_instance_parameter_value timer {counterSize} {32}
set_instance_parameter_value timer {fixedPeriod} {0}
set_instance_parameter_value timer {period} {1}
set_instance_parameter_value timer {periodUnits} {MSEC}
set_instance_parameter_value timer {resetOutput} {0}
set_instance_parameter_value timer {snapshot} {1}
set_instance_parameter_value timer {timeoutPulseOutput} {0}
set_instance_parameter_value timer {watchdogPulse} {2}

# exported interfaces
add_interface axi_light_7seg_slave_0_conduit_end conduit end
set_interface_property axi_light_7seg_slave_0_conduit_end EXPORT_OF AXI_light_7seg_slave_0.conduit_end
add_interface clk clock sink
set_interface_property clk EXPORT_OF clk_0.clk_in
add_interface leds conduit end
set_interface_property leds EXPORT_OF leds_pio.external_connection
add_interface pb conduit end
set_interface_property pb EXPORT_OF pb_pio.external_connection
add_interface reset reset sink
set_interface_property reset EXPORT_OF clk_0.clk_in_reset
add_interface sw conduit end
set_interface_property sw EXPORT_OF sw_pio.external_connection

# connections and connection parameters
add_connection clk_0.clk AXI_light_7seg_slave_0.clock_sink

add_connection clk_0.clk OnChipMem.clk1

add_connection clk_0.clk juart.clk

add_connection clk_0.clk leds_pio.clk

add_connection clk_0.clk nios2_cpu.clk

add_connection clk_0.clk pb_pio.clk

add_connection clk_0.clk sw_pio.clk

add_connection clk_0.clk timer.clk

add_connection clk_0.clk_reset AXI_light_7seg_slave_0.reset_sink

add_connection clk_0.clk_reset OnChipMem.reset1

add_connection clk_0.clk_reset juart.reset

add_connection clk_0.clk_reset leds_pio.reset

add_connection clk_0.clk_reset nios2_cpu.reset

add_connection clk_0.clk_reset pb_pio.reset

add_connection clk_0.clk_reset sw_pio.reset

add_connection clk_0.clk_reset timer.reset

add_connection nios2_cpu.data_master AXI_light_7seg_slave_0.altera_axi4lite_slave
set_connection_parameter_value nios2_cpu.data_master/AXI_light_7seg_slave_0.altera_axi4lite_slave arbitrationPriority {1}
set_connection_parameter_value nios2_cpu.data_master/AXI_light_7seg_slave_0.altera_axi4lite_slave baseAddress {0x00012000}
set_connection_parameter_value nios2_cpu.data_master/AXI_light_7seg_slave_0.altera_axi4lite_slave defaultConnection {0}

add_connection nios2_cpu.data_master OnChipMem.s1
set_connection_parameter_value nios2_cpu.data_master/OnChipMem.s1 arbitrationPriority {1}
set_connection_parameter_value nios2_cpu.data_master/OnChipMem.s1 baseAddress {0x0000}
set_connection_parameter_value nios2_cpu.data_master/OnChipMem.s1 defaultConnection {0}

add_connection nios2_cpu.data_master juart.avalon_jtag_slave
set_connection_parameter_value nios2_cpu.data_master/juart.avalon_jtag_slave arbitrationPriority {1}
set_connection_parameter_value nios2_cpu.data_master/juart.avalon_jtag_slave baseAddress {0x00011000}
set_connection_parameter_value nios2_cpu.data_master/juart.avalon_jtag_slave defaultConnection {0}

add_connection nios2_cpu.data_master leds_pio.s1
set_connection_parameter_value nios2_cpu.data_master/leds_pio.s1 arbitrationPriority {1}
set_connection_parameter_value nios2_cpu.data_master/leds_pio.s1 baseAddress {0x00011020}
set_connection_parameter_value nios2_cpu.data_master/leds_pio.s1 defaultConnection {0}

add_connection nios2_cpu.data_master nios2_cpu.debug_mem_slave
set_connection_parameter_value nios2_cpu.data_master/nios2_cpu.debug_mem_slave arbitrationPriority {1}
set_connection_parameter_value nios2_cpu.data_master/nios2_cpu.debug_mem_slave baseAddress {0x00010800}
set_connection_parameter_value nios2_cpu.data_master/nios2_cpu.debug_mem_slave defaultConnection {0}

add_connection nios2_cpu.data_master pb_pio.s1
set_connection_parameter_value nios2_cpu.data_master/pb_pio.s1 arbitrationPriority {1}
set_connection_parameter_value nios2_cpu.data_master/pb_pio.s1 baseAddress {0x00011030}
set_connection_parameter_value nios2_cpu.data_master/pb_pio.s1 defaultConnection {0}

add_connection nios2_cpu.data_master sw_pio.s1
set_connection_parameter_value nios2_cpu.data_master/sw_pio.s1 arbitrationPriority {1}
set_connection_parameter_value nios2_cpu.data_master/sw_pio.s1 baseAddress {0x00011010}
set_connection_parameter_value nios2_cpu.data_master/sw_pio.s1 defaultConnection {0}

add_connection nios2_cpu.data_master timer.s1
set_connection_parameter_value nios2_cpu.data_master/timer.s1 arbitrationPriority {1}
set_connection_parameter_value nios2_cpu.data_master/timer.s1 baseAddress {0x00011040}
set_connection_parameter_value nios2_cpu.data_master/timer.s1 defaultConnection {0}

add_connection nios2_cpu.instruction_master OnChipMem.s1
set_connection_parameter_value nios2_cpu.instruction_master/OnChipMem.s1 arbitrationPriority {1}
set_connection_parameter_value nios2_cpu.instruction_master/OnChipMem.s1 baseAddress {0x0000}
set_connection_parameter_value nios2_cpu.instruction_master/OnChipMem.s1 defaultConnection {0}

add_connection nios2_cpu.instruction_master nios2_cpu.debug_mem_slave
set_connection_parameter_value nios2_cpu.instruction_master/nios2_cpu.debug_mem_slave arbitrationPriority {1}
set_connection_parameter_value nios2_cpu.instruction_master/nios2_cpu.debug_mem_slave baseAddress {0x00010800}
set_connection_parameter_value nios2_cpu.instruction_master/nios2_cpu.debug_mem_slave defaultConnection {0}

add_connection nios2_cpu.irq juart.irq
set_connection_parameter_value nios2_cpu.irq/juart.irq irqNumber {5}

add_connection nios2_cpu.irq pb_pio.irq
set_connection_parameter_value nios2_cpu.irq/pb_pio.irq irqNumber {1}

add_connection nios2_cpu.irq timer.irq
set_connection_parameter_value nios2_cpu.irq/timer.irq irqNumber {0}

# interconnect requirements
set_interconnect_requirement {$system} {qsys_mm.clockCrossingAdapter} {HANDSHAKE}
set_interconnect_requirement {$system} {qsys_mm.enableEccProtection} {FALSE}
set_interconnect_requirement {$system} {qsys_mm.insertDefaultSlave} {FALSE}
set_interconnect_requirement {$system} {qsys_mm.maxAdditionalLatency} {1}

save_system {nios_sys.qsys}
