;2015/10/16
;Just generalize, my man
;
;2016/02/25
;Added DIVIDE_BY_WIDTH_X and can_div_by_w_x to make sure only quantities for which it makes sense can be divided by width_x
;2016/03/01 Added MULTIPLY_BY_WIDTH_X and can_mlt_by_w_x
;
;TO DO:
;2015/12/03 Fix e- number flux; most of those aren't actually number fluxes
; I've added this information to CORRECT_ALFVENDB_FLUXES


PRO GET_FLUX_PLOTDATA,maximus,plot_i,MINM=minM,MAXM=maxM, $
                      BINM=binM, $
                      SHIFTM=shiftM, $
                      MINI=minI,MAXI=maxI,BINI=binI, $
                      DO_LSHELL=do_lshell, MINL=minL,MAXL=maxL,BINL=binL, $
                      OUTH2DBINSMLT=outH2DBinsMLT,OUTH2DBINSILAT=outH2DBinsILAT,OUTH2DBINSLSHELL=outH2DBinsLShell, $
                      FLUXPLOTTYPE=fluxPlotType, $
                      PLOTRANGE=plotRange, $
                      PLOTAUTOSCALE=plotAutoscale, $
                      NOPOSFLUX=noPosFlux, $
                      NONEGFLUX=noNegFlux, $
                      ABSFLUX=absFlux, $
                      OUT_REMOVED_II=out_removed_ii, $
                      LOGFLUXPLOT=logFluxPlot, $
                      DIVIDE_BY_WIDTH_X=divide_by_width_x, $
                      MULTIPLY_BY_WIDTH_X=multiply_by_width_x, $
                      DO_TIMEAVG_FLUXQUANTITIES=do_timeAvg_fluxQuantities, $
                      DO_LOGAVG_THE_TIMEAVG=do_logavg_the_timeAvg, $
                      DO_GROSSRATE_FLUXQUANTITIES=do_grossRate_fluxQuantities, $
                      GROSSRATE__H2D_AREAS=h2dAreas, $
                      DO_GROSSRATE_WITH_LONG_WIDTH=do_grossRate_with_long_width, $
                      GROSSRATE__H2D_LONGWIDTHS=h2dLongWidths, $
                      GROSSRATE__CENTERS_MLT=centersMLT, $
                      GROSSRATE__CENTERS_ILAT=centersILAT, $
                      THISTDENOMINATOR=tHistDenominator, $
                      H2DSTR=h2dStr, $
                      TMPLT_H2DSTR=tmplt_h2dStr, $
                      H2D_NONZERO_NEV_I=h2d_nonzero_nEv_i, $
                      H2DFLUXN=h2dFluxN, $
                      H2DMASK=h2dMask, $
                      OUT_H2DMASK=out_h2dMask, $
                      DATANAME=dataName,DATARAWPTR=dataRawPtr, $
                      MEDIANPLOT=medianplot, $
                      MEDHISTOUTDATA=medHistOutData, $
                      MEDHISTOUTTXT=medHistOutTxt, $
                      MEDHISTDATADIR=medHistDataDir, $
                      LOGAVGPLOT=logAvgPlot, $
                      DIV_FLUXPLOTS_BY_APPLICABLE_ORBS=div_fluxPlots_by_applicable_orbs, $
                      ORBCONTRIB_H2DSTR_FOR_DIVISION=orbContrib_h2dStr_for_division, $
                      GET_EFLUX=get_eflux, $
                      GET_ENUMFLUX=get_eNumFlux, $
                      GET_PFLUX=get_pFlux, $
                      GET_IFLUX=get_iFlux, $
                      GET_OXYFLUX=get_oxyFlux, $
                      GET_CHAREE=get_ChareE, $
                      GET_CHARIE=get_chariE, $
                      DO_PLOT_I_INSTEAD_OF_HISTOS=do_plot_i_instead_of_histos, $
                      PRINT_MAX_AND_MIN=print_mandm, $
                      FANCY_PLOTNAMES=fancy_plotNames, $
                      LUN=lun
  
  COMPILE_OPT idl2

  ;;The loaded defaults take advantage of KEYWORD_SET(fancy_plotNames)
  @fluxplot_defaults.pro

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1
  IF N_ELEMENTS(print_mandm) EQ 0 THEN print_mandm = 1

  nDataz = 0

  IF KEYWORD_SET(get_eFlux) THEN nDataz++
  IF KEYWORD_SET(get_eNumFlux) THEN nDataz++
  IF KEYWORD_SET(get_pFlux) THEN nDataz++
  IF KEYWORD_SET(get_iFlux) THEN nDataz++
  IF KEYWORD_SET(get_ChareE) THEN nDataz++
  IF KEYWORD_SET(get_ChariE) THEN nDataz++

  IF nDataz GT 1 THEN BEGIN
     PRINTF,lun,"Multiple plots at once currently not supported, you fool!"
     STOP
  ENDIF

  ;;Don't mod everyone's plot indices
  tmp_i = plot_i

  ;; Flux plot safety
  IF KEYWORD_SET(logFluxPlot) AND NOT KEYWORD_SET(absFlux) AND NOT KEYWORD_SET(noNegFlux) AND NOT KEYWORD_SET(noPosFlux) THEN BEGIN 
     PRINTF,lun,"Warning!: You're trying to do logplots of flux but you don't have 'absFlux', 'noNegFlux', or 'noPosFlux' set!"
     PRINTF,lun,"Can't make log plots without using absolute value or only positive values..."
     PRINTF,lun,"Default: junking all negative flux values"
     WAIT, 1
     noNegFlux=1
  ENDIF
  IF KEYWORD_SET(noPosFlux) AND KEYWORD_SET (logFluxPlot) THEN absFlux = 1

  IF N_ELEMENTS(tmplt_h2dStr) EQ 0 THEN BEGIN
     tmplt_h2dStr  = MAKE_H2DSTR_TMPLT(BIN1=binM,BIN2=(KEYWORD_SET(DO_lshell) ? binL : binI),$
                                       MIN1=MINM,MIN2=(KEYWORD_SET(DO_LSHELL) ? MINL : MINI),$
                                       MAX1=MAXM,MAX2=(KEYWORD_SET(DO_LSHELL) ? MAXL : MAXI), $
                                       SHIFT1=shiftM,SHIFT2=shiftI, $
                                       DO_PLOT_I_INSTEAD_OF_HISTOS=do_plot_i_instead_of_histos, $
                                       ;; PLOT_I=plot_i, $
                                       DO_TIMEAVG_FLUXQUANTITIES=do_timeAvg_fluxQuantities, $
                                       CB_FORCE_OOBHIGH=cb_force_oobHigh, $
                                       CB_FORCE_OOBLOW=cb_force_oobLow)
  ENDIF

  ;; h2dStr                    = {tmplt_h2dStr}
  h2dStr                    = tmplt_h2dStr
  h2dStr.is_fluxData        = 1

  IF KEYWORD_SET(get_eFlux) THEN BEGIN
     dataName               = "eFlux"
     h2dStr.labelFormat     = fluxPlotEPlotCBLabelFormat
     h2dStr.logLabels       = logeFluxLabels
     h2dStr.do_plotIntegral = eFlux_do_plotIntegral
     h2dStr.do_midCBLabel   = eFlux_do_midCBLabel

     ;;If not allowing negative fluxes
     CASE 1 OF
        STRUPCASE(fluxplottype) EQ STRUPCASE("Integ"): BEGIN
           h2dStr.title     = title__alfDB_ind_09
           inData           = maximus.integ_elec_energy_flux[tmp_i] 
        END
        STRUPCASE(fluxplottype) EQ STRUPCASE("Max"): BEGIN
           h2dStr.title     = title__alfDB_ind_08
           inData           = maximus.elec_energy_flux[tmp_i]
        END
     ENDCASE

     can_div_by_w_x         = 0
     can_mlt_by_w_x         = 1
  ENDIF

  IF KEYWORD_SET(get_eNumFlux) THEN BEGIN
     dataName               = "eNumFl"
     h2dStr.labelFormat     = fluxPlotColorBarLabelFormat
     h2dStr.logLabels       = logeNumFluxLabels
     h2dStr.do_plotIntegral = eNumFlux_do_plotIntegral
     h2dStr.do_midCBLabel   = eNumFlux_do_midCBLabel

     CASE 1 OF
        STRUPCASE(fluxPlotType) EQ STRUPCASE("total_eflux_integ"): BEGIN
           h2dStr.title     = title__alfDB_ind_11
           inData           = maximus.total_eflux_integ[tmp_i] 
           can_div_by_w_x   = 1
           can_mlt_by_w_x   = 0
           IF KEYWORD_SET(divide_by_width_x) THEN BEGIN
              h2dStr.title  = title__alfDB_ind_11__div_by_width_x
              ;; dataName     += '__div_by_width_x'
              LOAD_MAPPING_RATIO_DB,mapRatio, $
                                    DO_DESPUNDB=maximus.despun
              magFieldFactor        = SQRT(mapRatio.ratio[tmp_i]) ;This scales width_x to the ionosphere
           ENDIF
        END
        STRUPCASE(fluxPlotType) EQ STRUPCASE("Eflux_Losscone_Integ"): BEGIN
           h2dStr.title     = title__alfDB_ind_10
           inData           = maximus.eflux_losscone_integ[tmp_i]
           can_div_by_w_x   = 1
           can_mlt_by_w_x   = 0
           IF KEYWORD_SET(divide_by_width_x) THEN BEGIN
              h2dStr.title  = title__alfDB_ind_10__div_by_width_x
              ;; dataName     += '__div_by_width_x'
              LOAD_MAPPING_RATIO_DB,mapRatio, $
                                    DO_DESPUNDB=maximus.despun
              magFieldFactor        = SQRT(mapRatio.ratio[tmp_i]) ;This scales width_x to the ionosphere
           ENDIF

           IF KEYWORD_SET(do_timeAvg_fluxQuantities) THEN BEGIN
              h2dStr.title  = title__alfDB_ind_10 + '(time-averaged)'
           ENDIF

           IF KEYWORD_SET(do_grossRate_fluxQuantities) OR KEYWORD_SET(do_grossRate_with_long_with) THEN BEGIN
              CASE 1 OF
                 KEYWORD_SET(do_grossRate_fluxQuantities): BEGIN
                    h2dStr.title = title__alfDB_ind_10_grossRate
                    grossConvFactor = 1e3 ;Areas are given in km^2, but we need them in m^2 (less a factor of 10^3 to junk 'milli' prefix on mW)
                 END
                 KEYWORD_SET(do_grossRate_with_long_width): BEGIN
                    h2dStr.title = title__alfDB_ind_10_grossRate + '(long. wid.)'
                    grossConvFactor = 1 ;Lengths given in km, but we need them in m. To junk 'milli' prefix in mW, we get a net factor of 1
                 END
                 ELSE: BEGIN
                 END
              ENDCASE
           ENDIF
        END
        STRUPCASE(fluxPlotType) EQ STRUPCASE("ESA_Number_flux"): BEGIN
           h2dStr.title  = title__alfDB_esa_nFlux
           ;;NOTE: microCoul_per_m2__to_num_per_cm2 = 1. / 1.6e-9
           inData           = maximus.esa_current[tmp_i] * 1. / 1.6e-9
           can_div_by_w_x   = 0
           can_mlt_by_w_x   = 1
        END
        STRUPCASE(fluxPlotType) EQ STRUPCASE("ESA_Current"): BEGIN
           h2dStr.title  = title__alfDB_ind_
           ;;NOTE: microCoul_per_m2__to_num_per_cm2 = 1. / 1.6e-9
           inData           = maximus.esa_current[tmp_i]
           can_div_by_w_x   = 0
           can_mlt_by_w_x   = 1
        END
     ENDCASE

     IF KEYWORD_SET(multiply_by_width_x) AND can_mlt_by_w_x THEN BEGIN
        scale_width_for_these_plots = [STRUPCASE("ESA_Number_flux")]
        scale_to_cm = WHERE(STRUPCASE(fluxPlotType) EQ scale_width_for_these_plots)
        IF scale_to_cm[0] EQ -1 THEN BEGIN
           factor = 1.D
        ENDIF ELSE BEGIN 
           factor = .01D 
           PRINT,'...Scaling WIDTH_X to centimeters for '+fluxPlotType+' plots...'
        ENDELSE
     ENDIF
  ENDIF
     
  IF KEYWORD_SET(get_pFlux) THEN BEGIN

     CASE 1 OF
        KEYWORD_SET(multiply_by_width_x): BEGIN
           h2dStr.title     = title__alfDB_ind_49_integ
           LOAD_MAPPING_RATIO_DB,mapRatio, $
                                 DO_DESPUNDB=maximus.despun
           IF maximus.corrected_fluxes THEN BEGIN ;Assume that pFlux has been multiplied by mapRatio
              PRINT,'Undoing a square-root factor of multiplication by magField ratio for Poynting flux ...'
              magFieldFactor        = 1.D/SQRT(mapRatio.ratio[tmp_i]) ;This undoes the full multiplication by mapRatio performed in CORRECT_ALFVENDB_FLUXES
           ENDIF ELSE BEGIN
              magFieldFactor        = SQRT(mapRatio.ratio[tmp_i])
           ENDELSE
        END
        KEYWORD_SET(do_timeAvg_fluxQuantities): BEGIN
           ;; CASE 1 OF
           ;;    KEYWORD_SET(do_grossRate_fluxQuantities): BEGIN
           ;;       h2dStr.title= title__alfDB_ind_49_grossRate
           ;;       grossConvFactor =   1e3 ;Areas are given in km^2, but we need them in m^2 (less a factor of 10^3 to junk 'milli' prefix on mW)
           ;;    END
           ;;    KEYWORD_SET(do_grossRate_with_long_width): BEGIN
           ;;       h2dStr.title    = title__alfDB_ind_49_grossRate + '(long. wid.)'
           ;;       grossConvFactor = 1 ;Lengths given in km, but we need them in m. To junk 'milli' prefix in mW, we get a net factor of 1
           ;;    END              
           ;;    ELSE: BEGIN
                 ;; h2dStr.title    = title__alfDB_ind_49_tAvg
           h2dStr.title          = title__alfDB_ind_49 + '(time-averaged)'
           ;;    END
           ;; ENDCASE
        END
        ELSE: BEGIN
           h2dStr.title          = title__alfDB_ind_49
        END
     ENDCASE

     IF KEYWORD_SET(do_grossRate_fluxQuantities) OR KEYWORD_SET(do_grossRate_with_long_with) THEN BEGIN
        CASE 1 OF
           KEYWORD_SET(do_grossRate_fluxQuantities): BEGIN
              h2dStr.title = title__alfDB_ind_49_grossRate
              grossConvFactor = 1e3 ;Areas are given in km^2, but we need them in m^2 (less a factor of 10^3 to junk 'milli' prefix on mW)
           END
           KEYWORD_SET(do_grossRate_with_long_width): BEGIN
              h2dStr.title = title__alfDB_ind_49_grossRate + '(long. wid.)'
              grossConvFactor = 1 ;Lengths given in km, but we need them in m. To junk 'milli' prefix in mW, we get a net factor of 1
           END
           ELSE: BEGIN
           END
        ENDCASE
     ENDIF
     
     dataName               = "pFlux"
     h2dStr.labelFormat     = fluxPlotPPlotCBLabelFormat
     h2dStr.logLabels       = logPFluxLabels
     h2dStr.do_plotIntegral = PFlux_do_plotIntegral
     h2dStr.do_midCBLabel   = PFlux_do_midCBLabel

     inData                 = maximus.pFluxEst[tmp_i]

     can_div_by_w_x         = 0
     can_mlt_by_w_x         = 1

  ENDIF

  IF KEYWORD_SET(get_iFlux) THEN BEGIN
     ;; h2dStr.title= "Ion Flux (ergs/cm!U2!N-s)"
     dataName               = "iflux" 
     h2dStr.labelFormat     = fluxPlotColorBarLabelFormat
     h2dStr.logLabels       = logiFluxLabels
     h2dStr.do_plotIntegral = iFlux_do_plotIntegral
     h2dStr.do_midCBLabel   = iFlux_do_midCBLabel

     CASE 1 OF
        STRUPCASE(fluxplottype) EQ STRUPCASE("Integ"): BEGIN
           h2dStr.title     = title__alfDB_ind_17
           inData           = maximus.integ_ion_flux[tmp_i]
           can_div_by_w_x   = 1
           can_mlt_by_w_x   = 0
           IF KEYWORD_SET(divide_by_width_x) THEN BEGIN
              h2dStr.title  = title__alfDB_ind_17__div_by_width_x
              ;; dataName     += '__div_by_width_x'
              LOAD_MAPPING_RATIO_DB,mapRatio, $
                                    DO_DESPUNDB=maximus.despun
              magFieldFactor        = SQRT(mapRatio.ratio[tmp_i]) ;This scales width_x to the ionosphere
           ENDIF
        END
        STRUPCASE(fluxplottype) EQ STRUPCASE("Max"): BEGIN
           h2dStr.title     = title__alfDB_ind_15
           inData           = maximus.ion_flux[tmp_i]
           can_div_by_w_x   = 0
           can_mlt_by_w_x   = 1
        END
        STRUPCASE(fluxplottype) EQ STRUPCASE("Max_Up"): BEGIN
           h2dStr.title     = title__alfDB_ind_16
           inData           = maximus.ion_flux_up[tmp_i]
           can_div_by_w_x   = 0
           can_mlt_by_w_x   = 1
        END
        STRUPCASE(fluxplottype) EQ STRUPCASE("Integ_Up"): BEGIN
           h2dStr.title     = title__alfDB_ind_18
           inData           = maximus.integ_ion_flux_up[tmp_i]
           can_div_by_w_x   = 1
           can_mlt_by_w_x   = 0
           IF KEYWORD_SET(divide_by_width_x) THEN BEGIN
              h2dStr.title  = title__alfDB_ind_18__div_by_width_x
              ;; dataName     += '__div_by_width_x'
              LOAD_MAPPING_RATIO_DB,mapRatio, $
                                    DO_DESPUNDB=maximus.despun
              magFieldFactor        = SQRT(mapRatio.ratio[tmp_i]) ;This scales width_x to the ionosphere
           ENDIF
           IF KEYWORD_SET(do_timeAvg_fluxQuantities) THEN BEGIN
              ;; CASE 1 OF
              ;;    KEYWORD_SET(do_grossRate_fluxQuantities): BEGIN
              ;;       h2dStr.title    = title__alfDB_ind_18_grossRate
              ;;       grossConvFactor = 1e10 ;Areas are given in km^2, but we need them in cm^2
              ;;    END
              ;;    KEYWORD_SET(do_grossRate_with_long_width): BEGIN
              ;;       h2dStr.title    = title__alfDB_ind_18_grossRate + '(long. wid.)'
              ;;       grossConvFactor = 1e5 ;Lengths given in km, but we need them in cm.
              ;;    END
              ;;    ELSE: BEGIN
              ;; h2dStr.title       = title__alfDB_ind_18_tAvg + '(time-averaged)'
              h2dStr.title       = title__alfDB_ind_18 + '(time-averaged)'
              ;;    END
              ;; ENDCASE
           ENDIF

           IF KEYWORD_SET(do_grossRate_fluxQuantities) OR KEYWORD_SET(do_grossRate_with_long_with) THEN BEGIN
              CASE 1 OF
                 KEYWORD_SET(do_grossRate_fluxQuantities): BEGIN
                    h2dStr.title    = title__alfDB_ind_18_grossRate
                    grossConvFactor = 1e10 ;Areas are given in km^2, but we need them in cm^2
                 END
                 KEYWORD_SET(do_grossRate_with_long_width): BEGIN
                    h2dStr.title    = title__alfDB_ind_18_grossRate + '(long. wid.)'
                    grossConvFactor = 1e5 ;Lengths given in km, but we need them in cm.
                 END
              ENDCASE
           ENDIF
        END
        STRUPCASE(fluxplottype) EQ STRUPCASE("Energy"): BEGIN
           h2dStr.title     = title__alfDB_ind_14
           inData           = maximus.ion_energy_flux[tmp_i]
           can_div_by_w_x   = 0
           can_mlt_by_w_x   = 1
        END
     ENDCASE

     IF KEYWORD_SET(divide_by_width_x) AND can_div_by_w_x THEN BEGIN
        scale_width_for_these_plots = [STRUPCASE("Integ"),STRUPCASE("Max"),STRUPCASE("Max_Up"),STRUPCASE("Integ_Up")]
        scale_to_cm = WHERE(STRUPCASE(fluxPlotType) EQ scale_width_for_these_plots)
        IF scale_to_cm[0] EQ -1 THEN BEGIN
           factor           = 1.D
        ENDIF ELSE BEGIN 
           factor           = .01D 
           PRINT,'...Scaling WIDTH_X to centimeters for dividing '+fluxPlotType+' plots...'
        ENDELSE
     ENDIF
  ENDIF

  IF KEYWORD_SET(get_ChareE) THEN BEGIN
     dataName               = 'charEE'
     h2dStr.labelFormat     = fluxPlotChareCBLabelFormat
     h2dStr.logLabels       = logChareLabels
     h2dStr.do_plotIntegral = Charee_do_plotIntegral
     h2dStr.do_midCBLabel   = Charee_do_midCBLabel

     CASE 1 OF
        STRUPCASE(fluxplottype) EQ STRUPCASE("lossCone"): BEGIN
           h2dStr.title     = title__alfDB_ind_12
           inData           = maximus.max_chare_losscone[tmp_i] 
        END
        STRUPCASE(fluxplottype) EQ STRUPCASE("Total"): BEGIN
           h2dStr.title     = title__alfDB_ind_13
           inData           = maximus.max_chare_total[tmp_i]
        END
     ENDCASE
     can_div_by_w_x         = 0
     can_mlt_by_w_x         = 0
  ENDIF

  IF KEYWORD_SET(get_ChariE) THEN BEGIN
     h2dStr.title           = title__alfDB_ind_19
     dataName               = 'charIE'
     h2dStr.labelFormat     = fluxPlotChariCBLabelFormat
     h2dStr.logLabels       = logChariLabels
     h2dStr.do_plotIntegral = Charie_do_plotIntegral
     h2dStr.do_midCBLabel   = Charie_do_midCBLabel
     inData                 = maximus.char_ion_energy[tmp_i] 

     can_div_by_w_x         = 0
     can_mlt_by_w_x         = 0
  ENDIF

  ;;Handle name of data
  ;;Log plots desired?
  absStr                    = ""
  negStr                    = ""
  posStr                    = ""
  logStr                    = ""
  IF KEYWORD_SET(absFlux)THEN BEGIN
     PRINTF,lun,"N pos elements in " + dataName + " data: ",N_ELEMENTS(where(inData GT 0.))
     PRINTF,lun,"N neg elements in " + dataName + " data: ",N_ELEMENTS(where(inData LT 0.))
     IF KEYWORD_SET(noPosFlux) THEN BEGIN
        posStr                = 'NoPos--'
        PRINTF,lun,"N elements in " + dataName + " before junking pos vals: ",N_ELEMENTS(inData)
        lt_i                   =  WHERE(inData LT 0.,COMPLEMENT=removed_ii)
        inData                 = inData[lt_i]
        tmp_i                 = tmp_i[lt_i]
        PRINTF,lun,"N elements in " + dataName + " after junking pos vals: ",N_ELEMENTS(inData)
        inData                 = ABS(inData)
     ENDIF ELSE BEGIN
        absStr                = 'Abs--' 
     ENDELSE
     inData = ABS(inData)
  ENDIF
  IF KEYWORD_SET(noNegFlux) THEN BEGIN
     negStr                = 'NoNegs--'
     PRINTF,lun,"N elements in " + dataName + " before junking neg vals: ",N_ELEMENTS(inData)
     gt_i                   =  WHERE(inData GT 0.,COMPLEMENT=removed_ii)
     inData                 = inData[gt_i]
     tmp_i                 = tmp_i[gt_i]
     PRINTF,lun,"N elements in " + dataName + " after junking neg vals: ",N_ELEMENTS(inData)
  ENDIF
  IF KEYWORD_SET(noPosFlux) AND ~KEYWORD_SET(absFlux) THEN BEGIN
     posStr                = 'NoPos--'
     PRINTF,lun,"N elements in " + dataName + " before junking pos vals: ",N_ELEMENTS(inData)
     lt_i                   =  WHERE(inData LT 0.,COMPLEMENT=removed_ii)
     inData                 = inData[lt_i]
     tmp_i                 = tmp_i[lt_i]
     PRINTF,lun,"N elements in " + dataName + " after junking pos vals: ",N_ELEMENTS(inData)
     inData                 = ABS(inData)
  ENDIF
  IF KEYWORD_SET(logFluxPlot) AND ~h2dStr.logLabels THEN BEGIN
     logStr                 = "Log "
  ENDIF

  absnegslogStr             = absStr + negStr + posStr + logStr
  dataName                  = STRTRIM(absnegslogStr,2)+dataName + $
                              (KEYWORD_SET(fluxPlotType) ? '_' + STRUPCASE(fluxplottype) : '')
  ;; h2dStr.title              = absnegslogStr + h2dStr.title

  IF KEYWORD_SET(divide_by_width_x) THEN BEGIN
     IF can_div_by_w_x THEN BEGIN
        PRINT,'Dividing by WIDTH_X!'
        
        dataName               = 'spatialAvg_' + dataName

        ;;If the ion plots or one of the select electron plots didn't pick this up, set it to 1
        ;;NOTE, oxy also needs to be scaled!!!
        IF N_ELEMENTS(factor) EQ 0 THEN factor = 1.0D
        IF N_ELEMENTS(magFieldFactor) EQ 0 THEN magFieldFactor = 1.0D

        inData                 = inData*factor*magFieldFactor/maximus.width_x[tmp_i]
     ENDIF ELSE BEGIN
        PRINTF,lun,"Can't divide " + dataName + " by width_x! Not in the cards."
     ENDELSE
  ENDIF

  IF KEYWORD_SET(multiply_by_width_x) THEN BEGIN
     IF can_mlt_by_w_x THEN BEGIN
        PRINT,'Multiplying by WIDTH_X!'
        
        dataName               = 'spatialInteg_' + dataName
        
        ;;If the ion plots or one of the select electron plots didn't pick this up, set it to 1
        ;;NOTE, oxy also needs to be scaled!!!
        IF N_ELEMENTS(factor) EQ 0 THEN factor = 1.0D
        IF N_ELEMENTS(magFieldFactor) EQ 0 THEN magFieldFactor = 1.0D
        
        inData                 = inData*factor*magFieldFactor*maximus.width_x[tmp_i]
     ENDIF ELSE BEGIN
        PRINTF,lun,"Can't multiply " + dataName + " by width_x! Not in the cards."
     ENDELSE
  ENDIF

  ;;Is this going to be a time-averaged plot?
  IF KEYWORD_SET(do_timeAvg_fluxQuantities) THEN BEGIN
     inData                 = inData * maximus.width_time[tmp_i]
     ;; h2dStr.title           = 'Time-averaged ' + h2dStr.title
     dataName               = 'timeAvgd_' + dataName
  ENDIF

  ;;gross rates?
  IF KEYWORD_SET(do_grossRate_fluxQuantities) $
     OR KEYWORD_SET(do_grossRate_with_long_with) THEN BEGIN
     CASE 1 OF
        KEYWORD_SET(do_grossRate_fluxQuantities): BEGIN
           dataName         = 'grossRate_' + dataName
        END
        KEYWORD_SET(do_grossRate_with_long_width): BEGIN
           dataName         = 'grossRate_longWid_' + dataName
        END
     ENDCASE
  ENDIF

  ;;Averaging based on number of orbits passing through instead of nEvents, perhaps?
  IF KEYWORD_SET(div_fluxPlots_by_applicable_orbs) THEN BEGIN
     h2dStr.title           = 'Orbit-averaged ' + h2dStr.title
     dataName               = 'orbAvgd_' + dataName
  ENDIF

  ;;fix MLTs
  mlts                      = SHIFT_MLTS_FOR_H2D(maximus,tmp_i,shiftM)
  ilats                     = (KEYWORD_SET(DO_LSHELL) ? maximus.lshell : maximus.ilat)[tmp_i]

  IF KEYWORD_SET(do_plot_i_instead_of_histos) THEN BEGIN
     h2dStr.data.add,inData
     h2d_nonzero_nEv_i      = INDGEN(N_ELEMENTS(inData))
  ENDIF ELSE BEGIN
     CASE 1 OF
        KEYWORD_SET(medianplot): BEGIN 

           IF KEYWORD_SET(medHistOutData) THEN BEGIN
              medHistDatFile      = medHistDataDir + dataName+"medhist_data.sav"
           ENDIF
           
           h2dStr.data=median_hist(mlts, $
                                   ilats,$
                                   inData,$
                                   MIN1=MINM,MIN2=(KEYWORD_SET(DO_LSHELL) ? MINL : MINI),$
                                   MAX1=MAXM,MAX2=(KEYWORD_SET(DO_LSHELL) ? MAXL : MAXI),$
                                   BINSIZE1=binM,BINSIZE2=(KEYWORD_SET(do_lshell) ? binL : binI),$
                                   OBIN1=outH2DBinsMLT,OBIN2=(KEYWORD_SET(do_lshell) ? outH2DBinsLShell : outH2DBinsILAT),$
                                   ABSMED=absFlux,OUTFILE=medHistDatFile,PLOT_I=tmp_i) 
           
           IF KEYWORD_SET(medHistOutTxt) THEN MEDHISTANALYZER,INFILE=medHistDatFile,outFile=medHistDataDir + dataName + "medhist.txt"
        END
        KEYWORD_SET(do_timeAvg_fluxQuantities): BEGIN

           h2dStr.data=hist2d(mlts, $
                              ilats,$
                              (KEYWORD_SET(do_logAvg_the_timeAvg) ? ALOG10(inData) : inData),$
                              MIN1=minM,MIN2=(KEYWORD_SET(do_lshell) ? minL : minI),$
                              MAX1=maxM,MAX2=(KEYWORD_SET(do_lshell) ? maxL : maxI),$
                              BINSIZE1=binM,BINSIZE2=(KEYWORD_SET(do_lshell) ? binL : binI),$
                              OBIN1=outH2DBinsMLT,OBIN2=outH2DBinsILAT) 

           IF KEYWORD_SET(do_logAvg_the_timeAvg) THEN BEGIN
              h2dStr.data[h2d_nonzero_nEv_i]=h2dStr.data[h2d_nonzero_nEv_i]/h2dFluxN[h2d_nonzero_nEv_i] 
              h2dStr.data[where(h2dFluxN GT 0,/NULL)] = 10^(h2dStr.data[where(h2dFluxN GT 0,/NULL)])
           ENDIF

           PROBOCCURRENCE_AND_TIMEAVG_SANITY_CHECK,h2dStr,tHistDenominator,outH2DBinsMLT,outH2DBinsILAT,H2DFluxN,dataName,h2dMask

           ;;junked all those WHERE(h2dstr.data GT 0) as of 2016/04/23
           ;; h2dStr.data[WHERE(h2dstr.data GT 0)] = h2dStr.data[WHERE(h2dstr.data GT 0)]/tHistDenominator[WHERE(h2dstr.data GT 0)]
           h2dStr.data[h2d_nonzero_nEv_i] = h2dStr.data[h2d_nonzero_nEv_i]/tHistDenominator[h2d_nonzero_nEv_i]

        END
        ELSE: BEGIN
           h2dStr.data                          = HIST2D(mlts, $
                                                         ilats,$
                                                         (KEYWORD_SET(logAvgPlot) ? ALOG10(inData) : inData),$
                                                         MIN1=MINM,MIN2=(KEYWORD_SET(DO_LSHELL) ? MINL : MINI),$
                                                         MAX1=MAXM,MAX2=(KEYWORD_SET(DO_LSHELL) ? MAXL : MAXI),$
                                                         BINSIZE1=binM,BINSIZE2=(KEYWORD_SET(do_lshell) ? binL : binI),$
                                                         OBIN1=outH2DBinsMLT,OBIN2=outH2DBinsILAT) 
           
           IF KEYWORD_SET(div_fluxPlots_by_applicable_orbs) THEN BEGIN
              
              tempDenom                                = orbContrib_h2dStr_for_division.data
              IF orbContrib_H2DStr_FOR_division.is_logged THEN BEGIN
                 tempDenom[h2d_nonzero_nEv_i]          = 10.^(tempDenom[h2d_nonzero_nEv_i])
              ENDIF

              h2dStr.data[h2d_nonzero_nEv_i]           = h2dStr.data[h2d_nonzero_nEv_i]/tempDenom[h2d_nonzero_nEv_i]

           ENDIF ELSE BEGIN
              h2dStr.data[h2d_nonzero_nEv_i]           = h2dStr.data[h2d_nonzero_nEv_i]/h2dFluxN[h2d_nonzero_nEv_i] 
           ENDELSE
           
           IF KEYWORD_SET(logAvgPlot) THEN BEGIN
              h2dStr.data[where(h2dFluxN NE 0,/NULL)]  = 10^(h2dStr.data[where(h2dFluxN NE 0,/NULL)])
           ENDIF
           
        END
     ENDCASE

     IF KEYWORD_SET(do_grossRate_fluxQuantities) $
        OR KEYWORD_SET(do_grossRate_with_long_width) THEN BEGIN
        CASE 1 OF
           KEYWORD_SET(do_grossRate_fluxQuantities): BEGIN
              ;; h2dStr.data[WHERE(h2dstr.data GT 0)] = h2dStr.data[WHERE(h2dstr.data GT 0)]*h2dAreas[WHERE(h2dstr.data GT 0)]*grossConvFactor
              h2dStr.data[h2d_nonzero_nEv_i] = h2dStr.data[h2d_nonzero_nEv_i]*h2dAreas[h2d_nonzero_nEv_i]*grossConvFactor
           END
           KEYWORD_SET(do_grossRate_with_long_width): BEGIN
              ;; h2dStr.data[WHERE(h2dstr.data GT 0)] = h2dStr.data[WHERE(h2dstr.data GT 0)]*h2dLongWidths[WHERE(h2dstr.data GT 0)]*grossConvFactor
              h2dStr.data[h2d_nonzero_nEv_i] = h2dStr.data[h2d_nonzero_nEv_i]*h2dLongWidths[h2d_nonzero_nEv_i]*grossConvFactor
           END
        ENDCASE

        dayInds                           = WHERE(centersMLT GE 6*15 AND centersMLT LT 18*15 AND ~h2dMask)
        nightInds                         = WHERE((centersMLT GE 18*15 OR centersMLT LT 6*15) AND ~h2dMask)

        IF dayInds[0] NE -1 THEN BEGIN
           grossDay                       = TOTAL(h2dStr.data[dayInds])
        ENDIF ELSE grossDay               = 0

        IF nightInds[0] NE -1 THEN BEGIN
           grossNight                     = TOTAL(h2dStr.data[nightInds])
        ENDIF ELSE grossNight             = 0
     ENDIF
  ENDELSE

  IF KEYWORD_SET(print_mandm) THEN BEGIN
     IF KEYWORD_SET(medianPlot) OR ~KEYWORD_SET(logAvgPlot) THEN BEGIN
        fmt    = 'G10.4' 
        maxh2d = MAX(h2dStr.data[h2d_nonzero_nEv_i])
        minh2d = MIN(h2dStr.data[h2d_nonzero_nEv_i])
        medh2d = MEDIAN(h2dStr.data[h2d_nonzero_nEv_i])
     ENDIF ELSE BEGIN
        fmt    = 'F10.2'
        maxh2d = ALOG10(MAX(h2dStr.data[h2d_nonzero_nEv_i]))
        minh2d = ALOG10(MIN(h2dStr.data[h2d_nonzero_nEv_i]))
        medh2d = ALOG10(MEDIAN(h2dStr.data[h2d_nonzero_nEv_i]))
     ENDELSE
     PRINTF,lun,h2dStr.title
     ;; PRINTF,lun,FORMAT='("Max, min:",T20,F10.2,T35,F10.2)', $
     ;;        MAX(h2dStr.data[h2d_nonzero_nEv_i]), $
     ;;        MIN(h2dStr.data[h2d_nonzero_nEv_i])
     PRINTF,lun,FORMAT='("Max, min. med:",T20,' + fmt + ',T35,' + fmt + ',T50,' + fmt +')', $
            maxh2d, $
            minh2d, $
            medh2d            

     IF KEYWORD_SET(do_grossRate_fluxQuantities) $
        OR KEYWORD_SET(do_grossRate_with_long_width) THEN BEGIN
        grossFmt      = 'G18.6'
        PRINTF,lun,FORMAT='("Gross dayside, nightside:",T30,'+ grossFmt + ',T50,' + grossFmt + ')', $
               grossDay,grossNight
     ENDIF
  ENDIF


  ;;Do custom range for flux plot, if requested
  IF  KEYWORD_SET(plotRange) OR KEYWORD_SET(plotAutoscale) THEN BEGIN
     IF KEYWORD_SET(plotRange) AND KEYWORD_SET(plotAutoscale) THEN BEGIN
        PRINTF,lun,"Both plotRange and plotAutoscale are set! Assuming you'd rather have me autoscale..."
     ENDIF
     CASE 1 OF
        KEYWORD_SET(plotAutoscale): BEGIN
           h2dStr.lim   = [MIN(h2dStr.data[h2d_nonzero_nEv_i]), $
                           MAX(h2dStr.data[h2d_nonzero_nEv_i])]
        END
        KEYWORD_SET(plotRange): BEGIN
           h2dStr.lim   = plotRange
        END
     ENDCASE
  ENDIF ELSE BEGIN
     h2dStr.lim         = [MIN(h2dStr.data),MAX(h2dStr.data)]
  ENDELSE
  
  IF KEYWORD_SET(logFluxPlot) THEN BEGIN 
     IF KEYWORD_SET(do_plot_i_instead_of_histos) THEN BEGIN
        h2dStr.data[0,WHERE(h2dStr.data[0] NE 0,/NULL)] = ALOG10(h2dStr.data[WHERE(h2dStr.data[0] NE 0,/NULL)])
     ENDIF ELSE BEGIN
        h2dStr.data[where(h2dStr.data NE 0,/NULL)]=ALOG10(h2dStr.data[where(h2dStr.data NE 0,/NULL)]) 
        inData[where(inData NE 0,/NULL)]=ALOG10(inData[where(inData NE 0,/NULL)]) 
     ENDELSE
     h2dStr.lim        = ALOG10(h2dStr.lim)
     h2dStr.is_logged  = 1
  ENDIF

  dataRawPtr           = PTR_NEW(inData)

  out_h2dMask          = h2dMask

  IF removed_ii[0] NE -1 THEN out_removed_ii = removed_ii ELSE out_removed_ii = !NULL
END