;2015/10/16
;Just generalize, my man
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
                      FLUXPLOTTYPE=fluxPlotType,PLOTRANGE=plotRange, $
                      NOPOSFLUX=noPosFlux, $
                      NONEGFLUX=noNegFlux, $
                      ABSFLUX=absFlux, $
                      LOGFLUXPLOT=logFluxPlot, $
                      DIVIDE_BY_WIDTH_X=divide_by_width_x, $
                      DO_TIMEAVG_FLUXQUANTITIES=do_timeAvg_fluxQuantities, $
                      THISTDENOMINATOR=tHistDenominator, $
                      H2DSTR=h2dStr, $
                      TMPLT_H2DSTR=tmplt_h2dStr, $
                      H2D_NONZERO_NEV_I=h2d_nonzero_nEv_i, $
                      H2DFLUXN=h2dFluxN, $
                      DATANAME=dataName,DATARAWPTR=dataRawPtr, $
                      MEDIANPLOT=medianplot,MEDHISTOUTDATA=medHistOutData,MEDHISTOUTTXT=medHistOutTxt,MEDHISTDATADIR=medHistDataDir, $
                      LOGAVGPLOT=logAvgPlot, $
                      WRITEHDF5=writeHDF5,WRITEASCII=writeASCII,SQUAREPLOT=squarePlot,SAVERAW=saveRaw, $
                      GET_EFLUX=get_eflux, $
                      GET_ENUMFLUX=get_eNumFlux, $
                      GET_PFLUX=get_pFlux, $
                      GET_IFLUX=get_iFlux, $
                      GET_OXYFLUX=get_oxyFlux, $
                      GET_CHAREE=get_ChareE, $
                      GET_CHARIE=get_chariE, $
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
     IF STRUPCASE(fluxplottype) EQ STRUPCASE("Integ") THEN BEGIN
        h2dStr.title        = title__alfDB_ind_09
        inData              = maximus.integ_elec_energy_flux[tmp_i] 
     ENDIF ELSE BEGIN
        IF STRUPCASE(fluxplottype) EQ STRUPCASE("Max") THEN BEGIN
           h2dStr.title     = title__alfDB_ind_08
           inData           = maximus.elec_energy_flux[tmp_i]
        ENDIF
     ENDELSE
  ENDIF

  IF KEYWORD_SET(get_eNumFlux) THEN BEGIN
     dataName               = "eNumFl"
     h2dStr.labelFormat     = fluxPlotColorBarLabelFormat
     h2dStr.logLabels       = logeNumFluxLabels
     h2dStr.do_plotIntegral = eNumFlux_do_plotIntegral
     h2dStr.do_midCBLabel   = eNumFlux_do_midCBLabel

     IF STRUPCASE(fluxPlotType) EQ STRUPCASE("Total_Eflux_Integ") THEN BEGIN
        h2dStr.title        = title__alfDB_ind_11
        inData              = maximus.total_eflux_integ[tmp_i] 
     ENDIF ELSE BEGIN
        IF STRUPCASE(fluxPlotType) EQ STRUPCASE("Eflux_Losscone_Integ") THEN BEGIN
           h2dStr.title     = title__alfDB_ind_10
           inData           = maximus.eflux_losscone_integ[tmp_i]
        ENDIF ELSE BEGIN
           IF STRUPCASE(fluxPlotType) EQ STRUPCASE("ESA_Number_flux") THEN BEGIN
              h2dStr.title  = title__alfDB_esa_nFlux
           ENDIF
           ;;NOTE: microCoul_per_m2__to_num_per_cm2 = 1. / 1.6e-9
           inData           = maximus.esa_current[tmp_i] * 1. / 1.6e-9
        ENDELSE
     ENDELSE
  ENDIF
     
  IF KEYWORD_SET(get_pFlux) THEN BEGIN

     h2dStr.title           = title__alfDB_ind_49
     dataName               = "pFlux"
     h2dStr.labelFormat     = fluxPlotPPlotCBLabelFormat
     h2dStr.logLabels       = logPFluxLabels
     h2dStr.do_plotIntegral = PFlux_do_plotIntegral
     h2dStr.do_midCBLabel   = PFlux_do_midCBLabel

     inData                 = maximus.pFluxEst[tmp_i]

  ENDIF

  IF KEYWORD_SET(get_iFlux) THEN BEGIN
     ;; h2dStr.title= "Ion Flux (ergs/cm!U2!N-s)"
     dataName               = "iflux" 
     h2dStr.labelFormat     = fluxPlotColorBarLabelFormat
     h2dStr.logLabels       = logiFluxLabels
     h2dStr.do_plotIntegral = iFlux_do_plotIntegral
     h2dStr.do_midCBLabel   = iFlux_do_midCBLabel

     IF STRUPCASE(fluxplottype) EQ STRUPCASE("Integ") THEN BEGIN
        h2dStr.title        = title__alfDB_ind_17
     inData                 = maximus.integ_ion_flux[tmp_i]
     ENDIF ELSE BEGIN
        IF STRUPCASE(fluxplottype) EQ STRUPCASE("Max") THEN BEGIN
           h2dStr.title     = title__alfDB_ind_15
           inData           = maximus.ion_flux[tmp_i]
        ENDIF ELSE BEGIN
           IF STRUPCASE(fluxplottype) EQ STRUPCASE("Max_Up") THEN BEGIN
              h2dStr.title  = title__alfDB_ind_16
              inData        = maximus.ion_flux_up[tmp_i]
           ENDIF ELSE BEGIN
              IF STRUPCASE(fluxplottype) EQ STRUPCASE("Integ_Up") THEN BEGIN
                 h2dStr.title= title__alfDB_ind_18
                 inData     = maximus.integ_ion_flux_up[tmp_i]
              ENDIF ELSE BEGIN
                 IF STRUPCASE(fluxplottype) EQ STRUPCASE("Energy") THEN BEGIN
                    h2dStr.title= title__alfDB_ind_14
                    inData  = maximus.ion_energy_flux[tmp_i]
                 ENDIF
              ENDELSE
           ENDELSE
        ENDELSE
     ENDELSE

     IF KEYWORD_SET(divide_by_width_x) THEN BEGIN
        scale_width_for_these_plots = [STRUPCASE("Integ"),STRUPCASE("Max"),STRUPCASE("Max_Up"),STRUPCASE("Integ_Up")]
        scale_to_cm = WHERE(STRUPCASE(fluxPlotType) EQ scale_width_for_these_plots)
        IF scale_to_cm[0] EQ -1 THEN BEGIN
           factor = 1.D
        ENDIF ELSE BEGIN 
           factor = .01D 
           PRINT,'...Scaling WIDTH_X to centimeters for '+fluxPlotType+' plots...'
        ENDELSE
     ENDIF
  ENDIF

  IF KEYWORD_SET(get_ChareE) THEN BEGIN
     dataName               = 'charEE'
     h2dStr.labelFormat     = fluxPlotChareCBLabelFormat
     h2dStr.logLabels       = logChareLabels
     h2dStr.do_plotIntegral = Charee_do_plotIntegral
     h2dStr.do_midCBLabel   = Charee_do_midCBLabel

     IF STRUPCASE(fluxplottype) EQ STRUPCASE("lossCone") THEN BEGIN
        h2dStr.title        = title__alfDB_ind_12
        inData              = maximus.max_chare_losscone[tmp_i] 
     ENDIF ELSE BEGIN
        IF STRUPCASE(fluxplottype) EQ STRUPCASE("Total") THEN BEGIN
           h2dStr.title     = title__alfDB_ind_13
           inData           = maximus.max_chare_total[tmp_i]
        ENDIF
     ENDELSE
  ENDIF

  IF KEYWORD_SET(get_ChariE) THEN BEGIN
     h2dStr.title           = title__alfDB_ind_19
     dataName               = 'charIE'
     h2dStr.labelFormat     = fluxPlotChariCBLabelFormat
     h2dStr.logLabels       = logChariLabels
     h2dStr.do_plotIntegral = Charie_do_plotIntegral
     h2dStr.do_midCBLabel   = Charie_do_midCBLabel
     inData                 = maximus.char_ion_energy[tmp_i] 
  ENDIF

  ;;Handle name of data
  ;;Log plots desired?
  absStr                    = ""
  negStr                    = ""
  posStr                    = ""
  logStr                    = ""
  IF KEYWORD_SET(absFlux)THEN BEGIN
     absEStr                = 'Abs--' 
     PRINTF,lun,"N pos elements in " + dataName + " data: ",N_ELEMENTS(where(inData GT 0.))
     PRINTF,lun,"N neg elements in " + dataName + " data: ",N_ELEMENTS(where(inData LT 0.))
     inData = ABS(inData)
  ENDIF
  IF KEYWORD_SET(noNegFlux) THEN BEGIN
     negEStr                = 'NoNegs--'
     PRINTF,lun,"N elements in " + dataName + " before junking neg vals: ",N_ELEMENTS(inData)
     gt_i                   =  WHERE(inData GT 0.)
     inData                 = inData[gt_i]
     tmp_i                 = tmp_i[gt_i]
     PRINTF,lun,"N elements in " + dataName + " after junking neg vals: ",N_ELEMENTS(inData)
  ENDIF
  IF KEYWORD_SET(noPosFlux) THEN BEGIN
     posEStr                = 'NoPos--'
     PRINTF,lun,"N elements in " + dataName + " before junking pos vals: ",N_ELEMENTS(inData)
     lt_i                   =  WHERE(inData LT 0.)
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
  h2dStr.title              = absnegslogStr + h2dStr.title


  IF KEYWORD_SET(divide_by_width_x) THEN BEGIN
     PRINT,'Dividing by WIDTH_X!'

     dataName               = 'spatialAvg_' + dataName

     ;; inds_to_scale_to_cm       = [15,16,17,18,26,28,30]
     ;; scale_to_cm               = WHERE(maxInd EQ inds_to_scale_to_cm) 
     ;;If the ion plots didn't pick this up, set it to 1
     ;;NOTE, oxy also needs to be scaled!!!
     IF N_ELEMENTS(factor) EQ 0 THEN factor = 1.0D

     inData                 = inData*factor/maximus.width_x[tmp_i]
  ENDIF

  ;;Is this going to be a time-averaged plot?
  IF KEYWORD_SET(do_timeAvg_fluxQuantities) THEN BEGIN
     inData                 = inData * maximus.width_time[tmp_i]
     h2dStr.title           = 'Time-averaged ' + h2dStr.title
     dataName               = 'timeAvgd_' + dataName
  ENDIF

  ;;fix MLTs
  mlts                      = maximus.mlt[tmp_i]-shiftM        ;shift MLTs backwards, because we want to shift the binning FORWARD
  mlts[WHERE(mlts LT 0.)]   = mlts[WHERE(mlts LT 0.)] + 24.

  CASE 1 OF
     KEYWORD_SET(medianplot): BEGIN 

        IF KEYWORD_SET(medHistOutData) THEN BEGIN
           medHistDatFile      = medHistDataDir + dataName+"medhist_data.sav"
        ENDIF
        
        h2dStr.data=median_hist(mlts, $
                                (KEYWORD_SET(DO_LSHELL) ? maximus.lshell : maximus.ilat)[tmp_i],$
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
                           (KEYWORD_SET(do_lshell) ? maximus.lshell : maximus.ilat)[tmp_i],$
                           inData,$
                           MIN1=minM,MIN2=(KEYWORD_SET(do_lshell) ? minL : minI),$
                           MAX1=maxM,MAX2=(KEYWORD_SET(do_lshell) ? maxL : maxI),$
                           BINSIZE1=binM,BINSIZE2=(KEYWORD_SET(do_lshell) ? binL : binI),$
                           OBIN1=outH2DBinsMLT,OBIN2=outH2DBinsILAT) 

        PROBOCCURRENCE_AND_TIMEAVG_SANITY_CHECK,h2dStr,tHistDenominator,outH2DBinsMLT,outH2DBinsILAT,H2DFluxN,dataName

        h2dStr.data[WHERE(h2dstr.data GT 0)] = h2dStr.data[WHERE(h2dstr.data GT 0)]/tHistDenominator[WHERE(h2dstr.data GT 0)]

     END
     ELSE: BEGIN
        h2dStr.data=hist2d(mlts, $
                           (KEYWORD_SET(DO_LSHELL) ? maximus.lshell : maximus.ilat)[tmp_i],$
                           (KEYWORD_SET(logAvgPlot) ? ALOG10(inData) : inData),$
                           MIN1=MINM,MIN2=(KEYWORD_SET(DO_LSHELL) ? MINL : MINI),$
                           MAX1=MAXM,MAX2=(KEYWORD_SET(DO_LSHELL) ? MAXL : MAXI),$
                           BINSIZE1=binM,BINSIZE2=(KEYWORD_SET(do_lshell) ? binL : binI),$
                           OBIN1=outH2DBinsMLT,OBIN2=outH2DBinsILAT) 
        h2dStr.data[h2d_nonzero_nEv_i]=h2dStr.data[h2d_nonzero_nEv_i]/h2dFluxN[h2d_nonzero_nEv_i] 
        
        IF KEYWORD_SET(logAvgPlot) THEN h2dStr.data[where(h2dFluxN NE 0,/null)] = 10^(h2dStr.data[where(h2dFluxN NE 0,/null)])
        
     END
  ENDCASE

  IF KEYWORD_SET(print_mandm) THEN BEGIN
     IF KEYWORD_SET(medianPlot) OR ~KEYWORD_SET(logAvgPlot) THEN BEGIN
        fmt    = 'G10.4' 
        maxh2d = MAX(h2dStr.data[h2d_nonzero_nEv_i])
        minh2d = MIN(h2dStr.data[h2d_nonzero_nEv_i])
     ENDIF ELSE BEGIN
        fmt    = 'F10.2'
        maxh2d = ALOG10(MAX(h2dStr.data[h2d_nonzero_nEv_i]))
        minh2d = ALOG10(MIN(h2dStr.data[h2d_nonzero_nEv_i]))
     ENDELSE
     PRINTF,lun,h2dStr.title
     ;; PRINTF,lun,FORMAT='("Max, min:",T20,F10.2,T35,F10.2)', $
     ;;        MAX(h2dStr.data[h2d_nonzero_nEv_i]), $
     ;;        MIN(h2dStr.data[h2d_nonzero_nEv_i])
     PRINTF,lun,FORMAT='("Max, min:",T20,' + fmt + ',T35,' + fmt + ')', $
            maxh2d, $
            minh2d
  ENDIF


  ;;Do custom range for flux plot, if requested
  IF  KEYWORD_SET(plotRange) THEN h2dStr.lim=plotRange $
  ELSE h2dStr.lim = [MIN(h2dStr.data),MAX(h2dStr.data)]
  
  IF KEYWORD_SET(logFluxPlot) THEN BEGIN 
     h2dStr.data[where(h2dStr.data NE 0,/NULL)]=ALOG10(h2dStr.data[where(h2dStr.data NE 0,/null)]) 
     inData[where(inData NE 0,/null)]=ALOG10(inData[where(inData NE 0,/null)]) 
     h2dStr.lim = ALOG10(h2dStr.lim)
     h2dStr.is_logged = 1
  ENDIF

  dataRawPtr = PTR_NEW(inData)

END