FUNCTION GET_TIMEHIST_DENOMINATOR,fastLocInterped_i, $
                                  HERE_ARE_YOUR_FASTLOC_INDS=fastLoc_inds, $
                                  MINM=minM,MAXM=maxM, $
                                  BINM=binM, $
                                  SHIFTM=shiftM, $
                                  MINI=minI,MAXI=maxI,BINI=binI, $
                                  EQUAL_AREA_BINNING=EA_binning, $
                                  USE_AACGM_COORDS=use_AACGM, $
                                  DO_LSHELL=do_lshell, MINL=minL,MAXL=maxL,BINL=binL, $
                                  HEMI=hemi, $
                                  ;; OUT_FASTLOC_STRUCT=out_fastLoc, $
                                  FASTLOCOUTPUTDIR=fastLocOutputDir, $
                                  MAKE_TIMEHIST_H2DSTR=make_timeHist_h2dStr, $
                                  THISTDENOMPLOTRANGE=tHistDenomPlotRange, $
                                  THISTDENOMPLOTAUTOSCALE=tHistDenomPlotAutoscale, $
                                  THISTDENOMPLOTNORMALIZE=tHistDenomPlotNormalize, $
                                  THISTDENOMPLOT_NOMASK=tHistDenomPlot_noMask, $
                                  TMPLT_H2DSTR=tmplt_h2dStr, $
                                  H2DSTR=h2dStr, $
                                  DATANAME=dataName, $
                                  DATARAWPTR=dataRawPtr, $
                                  H2D_NONZERO_NEV_I=h2d_nonzero_nEv_i, $
                                  PRINT_MAXANDMIN=print_mandm, $
                                  SAVE_FASTLOC_INDS=save_fastLoc_inds, $
                                  PARAMSTR_FOR_SAVING=paramStr, $
                                  INDSFILEPREFIX=indsFilePrefix, $
                                  INDSFILESUFFIX=indsFileSuffix, $
                                  IND_FILEDIR=ind_fileDir, $
                                  BURSTDATA_EXCLUDED=burstData_excluded, $
                                  DO_NOT_SET_DEFAULTS=do_not_set_defaults, $
                                  FOR_ESPEC_DBS=for_eSpec_DBs, $
                                  ESPEC__USE_2000KM_FILE=eSpec__use_2000km_file, $
                                  ;; DONT_LOAD_IN_MEMORY=nonMem, $
                                  LUN=lun

  COMPILE_OPT idl2

  IF KEYWORD_SET(for_eSpec_DBs) THEN BEGIN
     @common__fastloc_espec_vars.pro

     ;;As of 2016/12/01, these are they:
     ;; COMMON FL_ESPEC_VARS,FL_eSpec__fastLoc,FASTLOC_E__times,FASTLOC_E__delta_t, $
     ;;    FASTLOC_E__good_i,FASTLOC_E__cleaned_i,FASTLOC_E__HAVE_GOOD_I, $
     ;;    FASTLOC_E__dbFile,FASTLOC_E__dbTimesFile

  ENDIF ELSE BEGIN
     @common__fastloc_vars.pro

     ;;As of 2016/12/01, these are they:
     ;; COMMON FL_VARS, $
     ;;    FL__fastLoc, $
     ;;    FASTLOC__times, $
     ;;    FASTLOC__delta_t, $
     ;;    FASTLOC__good_i, $
     ;;    FASTLOC__cleaned_i, $
     ;;    FASTLOC__HAVE_GOOD_I, $
     ;;    FASTLOC__dbFile, $
     ;;    FASTLOC__dbTimesFile

  ENDELSE

  IF N_ELEMENTS(print_mandm) EQ 0 THEN print_mandm = 1
  IF N_ELEMENTS(lun)         EQ 0 THEN lun         = -1 ;stdout

     IF N_ELEMENTS(tmplt_h2dStr) EQ 0 THEN BEGIN
        tmplt_h2dStr  = MAKE_H2DSTR_TMPLT(BIN1=binM,BIN2=(KEYWORD_SET(DO_lshell) ? binL : binI),$
                                          MIN1=MINM,MIN2=(KEYWORD_SET(DO_LSHELL) ? MINL : MINI),$
                                          MAX1=MAXM,MAX2=(KEYWORD_SET(DO_LSHELL) ? MAXL : MAXI), $
                                          SHIFT1=shiftM,SHIFT2=shiftI, $
                                          EQUAL_AREA_BINNING=EA_binning, $
                                          DO_PLOT_I_INSTEAD_OF_HISTOS=do_plot_i, $
                                          ;; PLOT_I=plot_i, $
                                          DO_TIMEAVG_FLUXQUANTITIES=do_timeAvg_fluxQuantities, $
                                          CB_FORCE_OOBHIGH=cb_force_oobHigh, $
                                          CB_FORCE_OOBLOW=cb_force_oobLow)
     ENDIF

  PRINTF,lun,"Getting time histogram denominator ..."

  @orbplot_tplot_defaults.pro

  CASE 1 OF
     KEYWORD_SET(for_eSpec_DBs): BEGIN
        IF N_ELEMENTS(FL_eSpec__fastLoc) NE 0 AND $
           N_ELEMENTS(FASTLOC_E__times)  NE 0 $
        THEN BEGIN
        ENDIF ELSE BEGIN
           loadFL        = 1
        ENDELSE
     END
     ELSE: BEGIN
        IF N_ELEMENTS(FL__fastLoc) NE 0 AND $
           N_ELEMENTS(FASTLOC__times) NE 0 AND $
           N_ELEMENTS(FASTLOC__delta_t) NE 0 $
        THEN BEGIN
        ENDIF ELSE BEGIN
           loadFL           = 1
        ENDELSE
     END
  ENDCASE

  IF KEYWORD_SET(loadFL) THEN BEGIN

     LOAD_FASTLOC_AND_FASTLOC_TIMES,dbStruct,dbTimes,fastloc_delta_t, $
                                    DBDIR=loaddataDir, $
                                    DBFILE=dbFile, $
                                    DB_TFILE=dbTimesFile, $
                                    COORDINATE_SYSTEM=coordinate_system, $
                                    INCLUDE_32HZ=include_32Hz, $
                                    USE_AACGM_COORDS=use_aacgm, $
                                    USE_MAG_COORDS=use_mag, $
                                    FOR_ESPEC_DBS=for_eSpec_DBs
  ENDIF

  MAKE_FASTLOC_HISTO, $
     OUTTIMEHISTO=tHistDenominator, $
     FASTLOC_INDS=fastLocInterped_i, $
     OUT_DELTA_TS=out_delta_ts, $
     FASTLOC_STRUCT=KEYWORD_SET(for_eSpec_DBs) ? FL_eSpec__fastLoc : FL__fastLoc, $
     FASTLOC_TIMES=KEYWORD_SET(for_eSpec_DBs) ? FASTLOC_E__times : FASTLOC__times, $
     FASTLOC_DELTA_T=KEYWORD_SET(for_eSpec_DBs) ? FASTLOC_E__delta_t : FASTLOC__delta_t, $
     MINMLT=minM, $
     MAXMLT=maxM, $
     BINMLT=binM, $
     SHIFTMLT=shiftM, $
     MINILAT=minI,MAXILAT=maxI,BINILAT=binI, $
     EQUAL_AREA_BINNING=EA_binning, $
     ;; USE_AACGM_COORDS=use_AACGM, $
     BOTH_HEMIS=KEYWORD_SET(tmplt_h2dStr.both_hemis), $
     DO_LSHELL=do_lshell,MINLSHELL=minL,MAXLSHELL=maxL,BINLSHELL=binL, $
     FOR_ESPEC_DBS=for_eSpec_DBs, $
     ESPEC__USE_2000KM_FILE=eSpec__use_2000km_file, $
     FASTLOCFILE=KEYWORD_SET(for_eSpec_DBs) ? FASTLOC_E__dbFile : FASTLOC__dbFile, $
     FASTLOCTIMEFILE=KEYWORD_SET(for_eSpec_DBs) ? FASTLOC_E__dbTimesFile : FASTLOC__dbTimesFile

  PRINT_TIMEHISTO_SUMMARY, $
     KEYWORD_SET(for_eSpec_DBs) ? FL_eSpec__fastLoc : FL__fastLoc, $
     fastLocInterped_i, $
     CLOCKSTR=clockStr, ANGLELIM1=angleLim1, ANGLELIM2=angleLim2, $
     ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, $
     minMLT=minM,maxMLT=maxM, $
     BINMLT=binM, $
     SHIFTMLT=shiftM, $
     MINILAT=minI,MAXILAT=maxI,BINILAT=binI, $
     EQUAL_AREA_BINNING=EA_binning, $
     DO_LSHELL=do_lShell,MINLSHELL=minL,MAXLSHELL=maxL,BINLSHELL=binL, $
     MIN_MAGCURRENT=minMC,MAX_NEGMAGCURRENT=maxNegMC, $
     HWMAUROVAL=HwMAurOval,HWMKPIND=HwMKpInd, $
     BYMIN=byMin, $
     BYMAX=byMax, $
     BZMIN=bzMin, $
     BZMAX=bzMax, $
     BTMIN=btMin, $
     BTMAX=btMax, $
     BXMIN=bxMin, $
     BXMAX=bxMax, $
     DO_ABS_BYMIN=abs_byMin, $
     DO_ABS_BYMAX=abs_byMax, $
     DO_ABS_BZMIN=abs_bzMin, $
     DO_ABS_BZMAX=abs_bzMax, $
     DO_ABS_BTMIN=abs_btMin, $
     DO_ABS_BTMAX=abs_btMax, $
     DO_ABS_BXMIN=abs_bxMin, $
     DO_ABS_BXMAX=abs_bxMax, $
     BX_OVER_BYBZ_LIM=Bx_over_ByBz_Lim, $
     ;; PARAMSTRING=paramString, PARAMSTRPREFIX=plotPrefix,PARAMSTRSUFFIX=plotSuffix,$
     DO_UTC_RANGE=DO_UTC_range,T1_ARR=t1_arr,T2_ARR=t2_arr, $
     DO_IMF_CONDS=do_IMF_conds, $
     SATELLITE=satellite, OMNI_COORDS=omni_Coords, $
     HEMI=hemi, $
     DELAY=delay, $
     MULTIPLE_DELAYS=multiple_delays, $
     STABLEIMF=stableIMF,SMOOTHWINDOW=smoothWindow, $
     INCLUDENOCONSECDATA=includeNoConsecData, $
     HOYDIA=hoyDia,MASKMIN=maskMin,LUN=lun


  ;;Out vars
  ;; out_fastLoc = KEYWORD_SET(for_eSpec_DBs) ? TEMPORARY(FL_eSpec__fastLoc) : FL_fastLoc

  IF KEYWORD_SET(make_timeHist_h2dStr) THEN BEGIN


     h2dStr                    = tmplt_h2dStr
     h2dStr.is_fluxData        = 0
     
     dataName                  = "tHistDenom"

     ;;temp this, just in case we're not masking
     IF KEYWORD_SET(tHistDenomPlot_noMask) THEN BEGIN
        h2d_include_i          = INDGEN(N_ELEMENTS(h2dStr.data))
        h2dStr.dont_mask_me    = 1
     ENDIF ELSE BEGIN
        h2d_include_i          = KEYWORD_SET(h2d_nonzero_nEv_i) ? h2d_nonzero_nEv_i : INDGEN(N_ELEMENTS(h2dStr.data))
     ENDELSE

     h2dStr.labelFormat        = defTHistDenomCBLabelFormat
     h2dStr.logLabels          = defTHistDenomLogLabels
     h2dStr.do_plotIntegral    = defTHistDenom_doPlotIntegral
     h2dStr.do_midCBLabel      = defTHistDenom_do_midCBLabel
     h2dStr.title              = defTHistDenomPlotTitle
     h2dStr.data               = tHistDenominator/60.
     IF KEYWORD_SET(tHistDenomPlotAutoscale) THEN BEGIN
        PRINTF,lun,"Autoscaling tHistDenom plot..."
        h2dStr.lim             = [MIN(h2dStr.data[h2d_include_i]), $
        ;; h2dStr.lim             = [MIN(h2dStr.data[WHERE(h2dStr.data GT 0.0)]), $
                                   MAX(h2dStr.data[h2d_include_i])]
     ENDIF ELSE BEGIN
        h2dStr.lim             = KEYWORD_SET(tHistDenomPlotRange) ? tHistDenomPlotRange : [0,500]
     ENDELSE

     dataRawPtr                = PTR_NEW(out_delta_ts)

     IF KEYWORD_SET(print_mandm) THEN BEGIN
        fmt    = 'F0.2'
        maxh2d = MAX(h2dStr.data[h2d_include_i])
        minh2d = MIN(h2dStr.data[h2d_include_i])
        medh2d = MEDIAN(h2dStr.data[h2d_include_i])

        PRINTF,lun,h2dStr.title
        PRINTF,lun,FORMAT='("Max, min. med:",T20,' + fmt + ',T35,' + fmt + ',T50,' + fmt +')', $
               maxh2d, $
               minh2d, $
               medh2d
     ENDIF

     IF KEYWORD_SET(tHistDenomPlotNormalize) AND KEYWORD_SET(tHistDenomPlotAutoscale) THEN BEGIN
        PRINTF,lun,"You're asking me to both autoscale and normalize tHistDenom! What does it mean?"
        STOP
     ENDIF

     IF KEYWORD_SET(tHistDenomPlotNormalize) THEN BEGIN
        dataName += "_normed"
        maxTHist                = MAX(h2dStr.data[h2d_include_i])
        h2dStr.title            = defTHistDenomNormedPlotTitle + $
                                  STRING(FORMAT='(" (norm: ",G0.2,"min)")',maxTHist)
        h2dStr.lim              = [0.0,1]
        h2dStr.data             = h2dStr.data/maxTHist
     ENDIF
     h2dStr.name                = dataName

  ENDIF

  ;; IF KEYWORD_SET(nonMem) THEN BEGIN
  ;;    CLEAR_FL_COMMON_VARS
  ;;    CLEAR_FL_E_COMMON_VARS
  ;; ENDIF

  RETURN,tHistDenominator

END