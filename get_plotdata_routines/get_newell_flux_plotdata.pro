;2016/06/04 RUN IT!!
;;2016/11/30 Added this weird varPlotIsKeepInds variable. 
;;Because the eSpec DB is so gigantic, it is a real issue to keep track of removed_ii variables (there are always millions). Because of
;;this, for the eSpec DB it makes way more sense to keep track of the indices that we have KEPT. So that's what is done here for
;;"nonAlfvén" data.
PRO GET_NEWELL_FLUX_PLOTDATA,maximus,plot_i,MINM=minM,MAXM=maxM, $
                             BINM=binM, $
                             SHIFTM=shiftM, $
                             MINI=minI,MAXI=maxI,BINI=binI, $
                             EQUAL_AREA_BINNING=EA_binning, $
                             DO_LSHELL=do_lshell, MINL=minL,MAXL=maxL,BINL=binL, $
                             OUTH2DBINSMLT=outH2DBinsMLT, $
                             OUTH2DBINSILAT=outH2DBinsILAT, $
                             OUTH2DBINSLSHELL=outH2DBinsLShell, $
                             FLUXPLOTTYPE=fluxPlotType, $
                             PLOTRANGE=plotRange, $
                             PLOTAUTOSCALE=plotAutoscale, $
                             NEWELL_THE_CUSP=Newell_the_cusp, $
                             REMOVE_OUTLIERS=remove_outliers, $
                             REMOVE_LOG_OUTLIERS=remove_log_outliers, $
                             NOPOSFLUX=noPosFlux, $
                             NONEGFLUX=noNegFlux, $
                             ABSFLUX=absFlux, $
                             EFLUX_ESPEC_DATA=eFlux_eSpec_data, $
                             ENUMFLUX_ESPEC_DATA=eNumFlux_eSpec_data, $
                             ;; IFLUX_ESPEC_DATA=iFlux_eSpec_data, $
                             ;; INUMFLUX_ESPEC_DATA=iNumFlux_eSpec_data, $
                             INDICES__ESPEC=indices__eSpec, $
                             ;; INDICES__ION=indices__ion, $
                             ESPEC__JUNK_ALFVEN_CANDIDATES=eSpec__junk_alfven_candidates, $
                             ESPEC__ALL_FLUXES=eSpec__all_fluxes, $
                             COMBINE_ACCELERATED=comb_accelerated, $
                             ESPEC__NEWELL_2009_INTERP=eSpec__Newell_2009_interp, $
                             ESPEC__USE_2000KM_FILE=eSpec__use_2000km_file, $
                             ESPEC_MLT=eSpec_mlt, $
                             ESPEC_ILAT=eSpec_ilat, $
                             ESPEC_DELTA_T=eSpec_delta_t, $
                             ESPEC_THISTDENOMINATOR=eSpec_tHistDenominator, $
                             OUT_REMOVED_II=out_removed_ii, $
                             LOGFLUXPLOT=logFluxPlot, $
                             DIVIDE_BY_WIDTH_X=divide_by_width_x, $
                             MULTIPLY_BY_WIDTH_X=multiply_by_width_x, $
                             MULTIPLY_FLUXES_BY_PROBOCCURRENCE=multiply_fluxes_by_probOccurrence, $
                             H2DPROBOCC=H2DProbocc, $
                             DO_TIMEAVG_FLUXQUANTITIES=do_timeAvg_fluxQuantities, $
                             DO_LOGAVG_THE_TIMEAVG=do_logavg_the_timeAvg, $
                             DO_GROSSRATE_FLUXQUANTITIES=do_grossRate_fluxQuantities, $
                             GROSSRATE__H2D_AREAS=h2dAreas, $
                             DO_GROSSRATE_WITH_LONG_WIDTH=do_grossRate_with_long_width, $
                             GROSSRATE__H2D_LONGWIDTHS=h2dLongWidths, $
                             GROSSRATE__CENTERS_MLT=centersMLT, $
                             GROSSRATE__CENTERS_ILAT=centersILAT, $
                             GROSSCONVFACTORARR=grossConvFactorArr, $
                             WRITE_GROSSRATE_INFO_TO_THIS_FILE=grossRate_info_file, $
                             GROSSLUN=grossLun, $
                             SHOW_INTEGRALS=show_integrals, $
                             THISTDENOMINATOR=tHistDenominator, $
                             H2DSTRARR=h2dStrArr, $
                             TMPLT_H2DSTR=tmplt_h2dStr, $
                             H2D_NONZERO_NEV_I=h2d_nonzero_nEv_i, $
                             H2DFLUXN=h2dFluxN, $
                             H2DMASK=h2dMask, $
                             UPDATE_H2D_MASK=update_h2d_mask, $
                             OUT_H2DMASK=out_h2dMask, $
                             DATANAMEARR=dataNameArr,DATARAWPTRARR=dataRawPtrArr, $
                             VARPLOTH2DINDS=varPlotH2DInds, $
                             VARPLOTRAWINDS=varPlotRawInds, $
                             REMOVED_II_LISTARR=removed_ii_listArr, $
                             ;; VARPLOTISKEEPINDS=varPlotIsKeepInds, $
                             MEDIANPLOT=medianplot, $
                             MEDHISTOUTDATA=medHistOutData, $
                             MEDHISTOUTTXT=medHistOutTxt, $
                             MEDHISTDATADIR=medHistDataDir, $
                             LOGAVGPLOT=logAvgPlot, $
                             DIV_FLUXPLOTS_BY_APPLICABLE_ORBS=div_fluxPlots_by_applicable_orbs, $
                             ORBCONTRIB_H2DSTR_FOR_DIVISION=orbContrib_h2dStr_for_division, $
                             GET_EFLUX=get_eflux, $
                             GET_ENUMFLUX=get_eNumFlux, $
                             NEWELL_ANALYZE_EFLUX=newell_analyze_eFlux, $
                             NEWELL_ANALYZE_MULTIPLY_BY_TYPE_PROBABILITY=newell_analyze_multiply_by_type_probability, $
                             NEWELL_ANALYSIS__OUTPUT_SUMMARY=newell_analysis__output_summary, $
                             TXTOUTPUTDIR=txtOutputDir, $
                             GET_PFLUX=get_pFlux, $
                             GET_IFLUX=get_iFlux, $
                             GET_OXYFLUX=get_oxyFlux, $
                             GET_CHAREE=get_ChareE, $
                             GET_CHARIE=get_chariE, $
                             DO_PLOT_I_INSTEAD_OF_HISTOS=do_plot_i_instead_of_histos, $
                             PRINT_MAX_AND_MIN=print_mandm, $
                             FANCY_PLOTNAMES=fancy_plotNames, $
                             NPLOTS=nPlots, $
                             MASKMIN=maskMin, $
                             KEEPME=keepMe, $
                             LUN=lun
  
  COMPILE_OPT idl2

  @common__newell_espec.pro

  IF KEYWORD_SET(newell_analysis__output_summary) THEN BEGIN

     hamFile = "newell_event_info--"+GET_TODAY_STRING(/DO_YYYYMMDD_FMT)+".txt"
     PRINT,"Opening " + hamFile + '...'
     OPENW,sum_lun,txtOutputDir+hamFile,/GET_LUN,/APPEND
     
  ENDIF 

  IF KEYWORD_SET(eFlux_eSpec_data) OR KEYWORD_SET(eNumFlux_eSpec_data) $
  THEN BEGIN
     nonAlfven       = 1
     ;; nonAlf_inds     = indices__eSpec
  ENDIF;;  ELSE BEGIN
  ;;    IF KEYWORD_SET(iFlux_eSpec_data) OR KEYWORD_SET(iNumFlux_eSpec_data) $
  ;;    THEN BEGIN
  ;;       nonAlfven    = 1
  ;;       nonAlf_inds  = indices__ion
  ;;    ENDIF 
  ;; ENDELSE

  IF KEYWORD_SET(nonAlfven) THEN BEGIN

     SPLIT_ESPECDB_I_BY_ESPEC_TYPE,indices__eSpec, $
                                   OUT_TITLES=out_titles, $
                                   OUT_DATANAMESUFFS=out_datanamesuffs, $
                                   OUT_I_LIST=out_i_list, $
                                   SUMMARY=newell_analysis__output_summary, $
                                   COMBINE_ACCELERATED=comb_accelerated, $
                                   SUM_LUN=sum_lun

     IF KEYWORD_SET(newell_analyze_multiply_by_type_probability) THEN BEGIN

        GET_H2D_NEWELLS__EACH_TYPE__NONALFVEN,eSpec,indices__eSpec, $
                                              MINM=minM, $
                                              MAXM=maxM, $
                                              BINM=binM, $
                                              SHIFTM=shiftM, $
                                              MINI=minI, $
                                              MAXI=maxI, $
                                              BINI=binI, $
                                              EQUAL_AREA_BINNING=EA_binning, $
                                              NEWELL_PLOTRANGE=newell_plotRange, $
                                              LOG_NEWELLPLOT=log_newellPlot, $
                                              NEWELLPLOT_AUTOSCALE=newellPlot_autoscale, $
                                              NEWELLPLOT_NORMALIZE=newellPlot_normalize, $
                                              /NEWELLPLOT_PROBOCCURRENCE, $
                                              COMBINE_ACCELERATED=comb_accelerated, $
                                              TMPLT_H2DSTR=tmplt_h2dStr, $
                                              H2DSTRS=h2dStrs, $
                                              ;; H2DMASKSTR=h2dMaskStr, $
                                              H2DFLUXN=junk_h2dFluxN, $
                                              NEWELL_NONZERO_NEV_I=newell_nonzero_nEv_i, $
                                              ;; MASKMIN=maskMin, $
                                              DATANAMES=dataNames, $
                                              DATARAWPTRS=dataRawPtrs, $
                                              CB_FORCE_OOBHIGH=cb_force_oobHigh, $
                                              CB_FORCE_OOBLOW=cb_force_oobLow, $
                                              PRINT_MANDM=print_mAndM, $
                                              LUN=lun

        H2DProboccurrenceList           = LIST(h2dStrs[0].data,h2dStrs[1].data,h2dStrs[2].data)
        h2dStrs                         = !NULL
        dataRawPtrs                     = !NULL
     ENDIF

  ENDIF ELSE BEGIN

     SPLIT_ALFDB_I_BY_ESPEC_TYPE,plot_i,maximus.despun, $
                                 OUT_TITLES=out_titles, $
                                 OUT_DATANAMESUFFS=out_datanamesuffs, $
                                 OUT_I_LIST=out_i_list, $
                                 SUMMARY=newell_analysis__output_summary, $
                                 DESPUN_ALF_DB=despun_alf_db, $
                                 SUM_LUN=sum_lun

     IF KEYWORD_SET(newell_analyze_multiply_by_type_probability) THEN BEGIN

        GET_H2D_NEWELLS__EACH_TYPE,eSpec,plot_i, $
                                   MINM=minM,MAXM=maxM, $
                                   BINM=binM, $
                                   SHIFTM=shiftM, $
                                   MINI=minI,MAXI=maxI,BINI=binI, $
                                   EQUAL_AREA_BINNING=EA_binning, $
                                   NEWELL_PLOTRANGE=newell_plotRange, $
                                   LOG_NEWELLPLOT=log_newellPlot, $
                                   NEWELLPLOT_AUTOSCALE=newellPlot_autoscale, $
                                   NEWELLPLOT_NORMALIZE=newellPlot_normalize, $
                                   NEWELLPLOT_PROBOCCURRENCE=newellPlot_probOccurrence, $
                                   COMBINE_ACCELERATED=comb_accelerated, $
                                   TMPLT_H2DSTR=tmplt_h2dStr, $
                                   H2DSTRS=h2dStrs, $
                                   ;; H2DMASKSTR=h2dMaskStr, $
                                   H2DFLUXN=junk_h2dFluxN, $
                                   NEWELL_NONZERO_NEV_I=newell_nonzero_nEv_i, $
                                   ;; MASKMIN=maskMin, $
                                   DATANAMES=dataNames, $
                                   DATARAWPTRS=dataRawPtrs, $
                                   CB_FORCE_OOBHIGH=cb_force_oobHigh, $
                                   CB_FORCE_OOBLOW=cb_force_oobLow, $
                                   PRINT_MANDM=print_mAndM, $
                                   LUN=lun

        H2DProboccurrenceList           = LIST(h2dStrs[0].data,h2dStrs[1].data,h2dStrs[2].data)
        IF KEYWORD_SET(comb_accelerated) THEN BEGIN
           H2DProboccurrenceList.Add,h2dStrs[3].data
        ENDIF
        h2dStrs                         = !NULL
        dataRawPtrs                     = !NULL
     ENDIF
  ENDELSE

  IF KEYWORD_SET(newell_analysis__output_summary) THEN BEGIN
     CLOSE,sum_lun
     FREE_LUN,sum_lun
  ENDIF
  
  FOR k=0,N_ELEMENTS(out_i_list)-1 DO BEGIN
     
     tmp_i           = out_i_list[k]

     IF tmp_i[0] EQ -1 THEN CONTINUE

     CASE N_ELEMENTS(noPosFlux) OF
        0:   noPosF     = !NULL
        1:   noPosF     = noPosFlux
        ELSE: noPosF    = noPosFlux[k]
     ENDCASE

     CASE N_ELEMENTS(noNegFlux) OF
        0:   noNegF     = !NULL
        1:   noNegF     = noNegFlux
        ELSE: noNegF    = noNegFlux[k]
     ENDCASE

     CASE N_ELEMENTS(absFlux) OF
        0:   absF       = !NULL
        1:   absF       = absFlux
        ELSE: absF      = absFlux[k]
     ENDCASE

     CASE N_ELEMENTS(logFluxPlot) OF
        0:   logP       = !NULL
        1:   logP       = logFluxPlot
        ELSE: logP      = logFluxPlot[k]
     ENDCASE

     dims                  = SIZE(plotRange,/DIMENSIONS)
     CASE N_ELEMENTS(dims) OF 
        0:   plotR     = !NULL
        1: BEGIN
           CASE dims OF
              0: plotR = !NULL
              2: plotR = plotRange
              ELSE: BEGIN
              END
           ENDCASE
        END
        2:   plotR     = plotRange[*,k]
     ENDCASE


     ;;Need to provide a new h2dFluxN and a new mask for each of these
     GET_H2D_NEVENTS_AND_MASK,maximus,tmp_i, $
                              IN_MLTS=KEYWORD_SET(eSpec_mlt  ) ? NEWELL__eSpec.mlt [tmp_i] : !NULL, $
                              IN_ILATS=KEYWORD_SET(eSpec_ilat) ? NEWELL__eSpec.ilat[tmp_i] : !NULL, $
                              MINM=minM,MAXM=maxM, $
                              BINM=binM, $
                              SHIFTM=shiftM, $
                              MINI=minI,MAXI=maxI,BINI=binI, $
                              EQUAL_AREA_BINNING=EA_binning, $
                              DO_LSHELL=do_lShell, MINL=minL,MAXL=maxL,BINL=binL, $
                              NEVENTSPLOTRANGE=nEventsPlotRange, $
                              TMPLT_H2DSTR=tmplt_h2dStr, $
                              H2DSTR=tempNh2dStr,H2DMASKSTR=temph2dMaskStr, $
                              H2DFLUXN=temph2dFluxN,H2D_NONZERO_NEV_I=temph2d_nonzero_nEv_i, $
                              MASKMIN=maskMin, $
                              DATANAME=dataName,DATARAWPTR=dataRawPtr, $
                              CB_FORCE_OOBHIGH=cb_force_oobHigh, $
                              CB_FORCE_OOBLOW=cb_force_oobLow, $
                              PRINT_MANDM=print_mAndM, $
                              LUN=lun     

     temph2dmask    = temph2dmaskstr.data





     GET_FLUX_PLOTDATA,maximus,tmp_i, $
                       MINM=minM,MAXM=maxM, $
                       BINM=binM, $
                       SHIFTM=shiftM, $
                       MINI=minI,MAXI=maxI,BINI=binI, $
                       EQUAL_AREA_BINNING=EA_binning, $
                       DO_LSHELL=do_lshell, MINL=minL,MAXL=maxL,BINL=binL, $
                       OUTH2DBINSMLT=outH2DBinsMLT, $
                       OUTH2DBINSILAT=outH2DBinsILAT, $
                       OUTH2DBINSLSHELL=outH2DBinsLShell, $
                       FLUXPLOTTYPE=fluxPlotType, $
                       PLOTRANGE=plotR, $
                       PLOTAUTOSCALE=plotAutoscale, $
                       NEWELL_THE_CUSP=Newell_the_cusp, $
                       REMOVE_OUTLIERS=remove_outliers, $
                       REMOVE_LOG_OUTLIERS=remove_log_outliers, $
                       NOPOSFLUX=noPosF, $
                       NONEGFLUX=noNegF, $
                       ABSFLUX=absF, $
                       EFLUX_ESPEC_DATA=eFlux_eSpec_data, $
                       ENUMFLUX_ESPEC_DATA=eNumFlux_eSpec_data, $
                       ;; IFLUX_ESPEC_DATA=iFlux_eSpec_data, $
                       ;; INUMFLUX_ESPEC_DATA=iNumFlux_eSpec_data, $
                       INDICES__ESPEC=KEYWORD_SET(nonAlfven) ? tmp_i : indices__eSpec, $
                       ESPEC__JUNK_ALFVEN_CANDIDATES=eSpec__junk_alfven_candidates, $
                       ESPEC__ALL_FLUXES=eSpec__all_fluxes, $
                       ESPEC__NEWELL_2009_INTERP=eSpec__Newell_2009_interp, $
                       ESPEC__USE_2000KM_FILE=eSpec__use_2000km_file, $
                       ESPEC_MLT=eSpec_mlt, $
                       ESPEC_ILAT=eSpec_ilat, $
                       ESPEC_DELTA_T=eSpec_delta_t, $
                       ESPEC_THISTDENOMINATOR=eSpec_tHistDenominator, $
                       OUT_REMOVED_II=out_removed_ii, $
                       LOGFLUXPLOT=logP, $
                       DIVIDE_BY_WIDTH_X=divide_by_width_x, $
                       MULTIPLY_BY_WIDTH_X=multiply_by_width_x, $
                       MULTIPLY_FLUXES_BY_PROBOCCURRENCE=multiply_fluxes_by_probOccurrence, $
                       H2DPROBOCC=H2DProbocc, $
                       DO_TIMEAVG_FLUXQUANTITIES=do_timeAvg_fluxQuantities, $
                       DO_LOGAVG_THE_TIMEAVG=do_logavg_the_timeAvg, $
                       DO_GROSSRATE_FLUXQUANTITIES=do_grossRate_fluxQuantities, $
                       GROSSRATE__H2D_AREAS=h2dAreas, $
                       DO_GROSSRATE_WITH_LONG_WIDTH=do_grossRate_with_long_width, $
                       GROSSRATE__H2D_LONGWIDTHS=h2dLongWidths, $
                       GROSSRATE__CENTERS_MLT=centersMLT, $
                       GROSSRATE__CENTERS_ILAT=centersILAT, $
                       GROSSCONVFACTOR=grossConvFactor, $
                       WRITE_GROSSRATE_INFO_TO_THIS_FILE=grossRate_info_file, $
                       GROSSLUN=grossLun, $
                       SHOW_INTEGRALS=show_integrals, $
                       THISTDENOMINATOR=tHistDenominator, $
                       H2DSTR=h2dStr, $
                       TMPLT_H2DSTR=tmplt_h2dStr, $
                       H2D_NONZERO_NEV_I=temph2d_nonzero_nEv_i, $
                       H2DFLUXN=temph2dFluxN, $
                       H2DMASK=temph2dMask, $
                       UPDATE_H2D_MASK=update_h2d_mask, $
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

     ;; IF ~KEYWORD_SET(eSpec_mlt) THEN h2dStrArr[KEYWORD_SET(nPlots)].data = out_h2dMask

     ;;Add Newell-specific stuff
     h2dStr.title        += out_titles[k]
     dataName            += out_datanamesuffs[k]
     h2dStr.mask          = out_h2dMask
     h2dStr.hasMask       = 1

     IF KEYWORD_SET(newell_analyze_multiply_by_type_probability) THEN BEGIN
        dataName         += '_mult_probOcc'
        h2dStr.data      *= H2DProboccurrenceList[k]
     ENDIF

     h2dStrArr            = [h2dStrArr,h2dStr] 
     IF keepMe THEN BEGIN
        dataNameArr       = [dataNameArr,dataName] 
        dataRawPtrArr     =[dataRawPtrArr,dataRawPtr] 
        varPlotH2DInds    = [varPlotH2DInds,N_ELEMENTS(h2dStrArr)-1]
        varPlotRawInds    = [varPlotRawInds,N_ELEMENTS(dataRawPtrArr)-1]
        ;; varPlotIsKeepInds = [varPlotIsKeepInds,KEYWORD_SET(nonAlfven)]

        IF KEYWORD_SET(nonAlfven) THEN BEGIN
           ;; junker         = MAKE_ARRAY(N_ELEMENTS(eSpec_mlt),VALUE=0B,/BYTE)
           ;; junker[tmp_i]  = 1B
           ;; out_removed_ii = WHERE(~TEMPORARY(junker))

           junker         = MAKE_ARRAY(N_ELEMENTS(eSpec_mlt),VALUE=0B,/BYTE)
           junker[CGSETDIFFERENCE(indices__eSpec,tmp_i,COUNT=nJunked)]  = 1B
           out_removed_ii = WHERE(TEMPORARY(junker))

        ENDIF
        ;;If nonAlfven, rather than being removed indices, tmp_i are the indices to KEEP
        ;; IF KEYWORD_SET(nonAlfven) THEN BEGIN
        ;;    removed_ii_listArr = [removed_ii_listArr,LIST(tmp_i)]
        ;; ENDIF ELSE BEGIN
        removed_ii_listArr = [removed_ii_listArr,LIST(TEMPORARY(out_removed_ii))]
        ;; ENDELSE
     ENDIF 

     IF KEYWORD_SET(do_grossRate_fluxQuantities) $
        OR KEYWORD_SET(do_grossRate_with_long_width) THEN BEGIN
        grossConvFactorArr   = [grossConvFactorArr,grossConvFactor]
     ENDIF

  ENDFOR

END
