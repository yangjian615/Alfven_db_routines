;2016/06/02
PRO GET_H2D_NEWELLS__EACH_TYPE,eSpec,plot_i, $
                               MINM=minM,MAXM=maxM, $
                               BINM=binM, $
                               SHIFTM=shiftM, $
                               MINI=minI,MAXI=maxI,BINI=binI, $
                               NEWELL_PLOTRANGE=newell_plotRange, $
                               LOG_NEWELLPLOT=log_newellPlot, $
                               NEWELLPLOT_AUTOSCALE=newellPlot_autoscale, $
                               NEWELLPLOT_NORMALIZE=newellPlot_normalize, $
                               NEWELLPLOT_PROBOCCURRENCE=newellPlot_probOccurrence, $
                               TMPLT_H2DSTR=tmplt_h2dStr, $
                               H2DSTRS=h2dStrs, $
                               ;; H2DMASKSTR=h2dMaskStr, $
                               H2DFLUXN=h2dFluxN, $
                               NEWELL_NONZERO_NEV_I=newell_nonzero_nEv_i, $
                               ;; MASKMIN=maskMin, $
                               DATANAMES=dataNames, $
                               DATARAWPTRS=dataRawPtrs, $
                               CB_FORCE_OOBHIGH=cb_force_oobHigh, $
                               CB_FORCE_OOBLOW=cb_force_oobLow, $
                               PRINT_MANDM=print_mAndM, $
                               LUN=lun


  COMPILE_OPT idl2

  ;;This common block is defined ONLY here, in GET_ESPEC_ION_DB_IND, and in LOAD_ALF_NEWELL_ESPEC_DB
  COMMON NWLL_ALF, $
     NWLL_ALF__eSpec, $
     NWLL_ALF__HAVE_GOOD_I, $
     NWLL_ALF__good_eSpec_i, $
     NWLL_ALF__good_alf_i, $
     NWLL_ALF__failCodes, $
     NWLL_ALF__despun, $
     NWLL_ALF__charERange, $
     NWLL_ALF__dbFile, $
     NWLL_ALF__dbDir, $
     NWLL_ALF__RECALCULATE
     

  LOAD_MAXIMUS_AND_CDBTIME,!NULL,!NULL,DO_DESPUNDB=despun,/CHECK_DB

  IF N_ELEMENTS(NWLL_ALF__eSpec) EQ 0 OR N_ELEMENTS(NWLL_ALF__good_alf_i) EQ 0 THEN BEGIN
     LOAD_ALF_NEWELL_ESPEC_DB,espec,good_alf_i,DESPUN_ALF_DB=despun
  ENDIF ELSE BEGIN
     eSpec            = NWLL_ALF__eSpec
     good_eSpec_i     = NWLL_ALF__good_eSpec_i
     good_alf_i       = NWLL_ALF__good_alf_i
  ENDELSE

  plot_i__good_espec  = CGSETINTERSECTION(plot_i,good_alf_i,INDICES_B=temp_eSpec_indices)


  tmp_eSpec           = { x:eSpec.x[temp_eSpec_indices], $
                          ;; orbit:eSpec.orbit[temp_eSpec_indices], $
                          MLT:eSpec.mlt[temp_eSpec_indices], $
                          ILAT:eSpec.ilat[temp_eSpec_indices], $
                          mono:eSpec.mono[temp_eSpec_indices], $
                          broad:eSpec.broad[temp_eSpec_indices], $
                          diffuse:eSpec.diffuse[temp_eSpec_indices], $
                          Je:eSpec.Je[temp_eSpec_indices], $
                          Jee:eSpec.Jee[temp_eSpec_indices], $
                          nBad_eSpec:eSpec.nBad_eSpec[temp_eSpec_indices]}

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Indices
  mono_i              = WHERE((tmp_eSpec.mono EQ 1) OR (tmp_eSpec.mono EQ 2),nMono)
  broad_i             = WHERE((tmp_eSpec.broad EQ 1) OR (tmp_eSpec.broad EQ 2),nBroad)
  diffuse_i           = WHERE(tmp_eSpec.diffuse EQ 1,nDiffuse)

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;MLTs
  mlt_mono            = tmp_eSpec.mlt[mono_i]-shiftM
  mlt_broad           = tmp_eSpec.mlt[broad_i]-shiftM
  mlt_diffuse         = tmp_eSpec.mlt[diffuse_i]-shiftM
  mlt_mono[WHERE(mlt_mono LT 0)]        = mlt_mono[WHERE(mlt_mono LT 0)] + 24
  mlt_broad[WHERE(mlt_broad LT 0)]      = mlt_broad[WHERE(mlt_broad LT 0)] + 24
  mlt_diffuse[WHERE(mlt_diffuse LT 0)]  = mlt_diffuse[WHERE(mlt_diffuse LT 0)] + 24

  mlt_list        = LIST(TEMPORARY(mlt_mono),TEMPORARY(mlt_broad),TEMPORARY(mlt_diffuse))

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;ILATs
  ilat_mono       = tmp_eSpec.ilat[mono_i]
  ilat_broad      = tmp_eSpec.ilat[broad_i]
  ilat_diffuse    = tmp_eSpec.ilat[diffuse_i]
  ilat_list       = LIST(TEMPORARY(ilat_mono),TEMPORARY(ilat_broad),TEMPORARY(ilat_diffuse))

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Bonus
  titles          = ['Monoenergetic','Broadband','Diffuse']
  dataNames       = ['mono'         ,'broad'    ,'diffuse']

  h2dStrs         = !NULL
  dataRawPtrs     = !NULL
  newell_nonzero_nev_i_list = LIST()  
  nPlots          = 3
  FOR i=0,nPlots-1 DO BEGIN
     tmpDataName  = dataNames[i]
     GET_H2D_NEWELL_AND_MASK,tmp_eSpec, $ ;eSpec_i, $
                             TITLE=titles[i], $
                             IN_MLTS=mlt_list[i], $
                             IN_ILATS=ilat_list[i], $
                             MINM=minM,MAXM=maxM, $
                             BINM=binM, $
                             SHIFTM=shiftM, $
                             MINI=minI,MAXI=maxI,BINI=binI, $
                             DO_LSHELL=do_lShell, MINL=minL,MAXL=maxL,BINL=binL, $
                             NEWELL_PLOTRANGE=newell_plotRange, $
                             LOG_NEWELLPLOT=log_newellPlot, $
                             NEWELLPLOT_AUTOSCALE=newellPlot_autoscale, $
                             NEWELLPLOT_NORMALIZE=newellPlot_normalize, $
                             NEWELLPLOT_PROBOCCURRENCE=newellPlot_probOccurrence, $
                             TMPLT_H2DSTR=tmplt_h2dStr, $
                             H2DSTR=h2dStr, $
                             ;; H2DMASKSTR=h2dMaskStr, $
                             H2DFLUXN=h2dFluxN, $
                             NEWELL_NONZERO_NEV_I=newell_nonzero_nEv_i, $
                             ;; MASKMIN=maskMin, $
                             DATANAME=tmpDataName, $
                             DATARAWPTR=dataRawPtr, $
                             CB_FORCE_OOBHIGH=cb_force_oobHigh, $
                             CB_FORCE_OOBLOW=cb_force_oobLow, $
                             PRINT_MANDM=print_mAndM, $
                             LUN=lun
     
     newell_nonzero_nev_i_list.add,newell_nonzero_nEv_i
     h2dStrs      = [h2dStrs,h2dStr]
     dataNames[i] = tmpDataName
     dataRawPtrs  = [dataRawPtrs,dataRawPtr]

  ENDFOR

  IF KEYWORD_SET(newellPlot_probOccurrence) THEN BEGIN
     denom        = h2dStrs[0].data +h2dStrs[1].data+h2dStrs[2].data
     tmp_div_i    = WHERE(denom GT 0)
     IF tmp_div_i[0] EQ -1 THEN STOP
     FOR i=0,nPlots-1 DO BEGIN
        
        h2dStrs[i].data[tmp_div_i] = h2dStrs[i].data[tmp_div_i]/FLOAT(denom[tmp_div_i])
        h2dStrs[i].lim             = KEYWORD_SET(newell_plotRange) AND N_ELEMENTS(newell_plotRange) EQ 2 ? $
                                     DOUBLE(newell_plotRange) : $
                                     DOUBLE([0,1]) 
        IF KEYWORD_SET(log_newellPlot) THEN BEGIN
           dataNames[i]     = 'log_' + dataNames[i]
           h2dStrs[i].data[newell_nonzero_nev_i_list[i]] = ALOG10(h2dStrs[i].data[newell_nonzero_nev_i_list[i]])
           h2dStrs[i].lim    = [(h2dStrs[i].lim[0] LT 1e-5) ? -5 : ALOG10(h2dStrs[i].lim[0]),ALOG10(h2dStrs[i].lim[1])] ;lower bound must be one
           h2dStrs[i].title     = 'Log ' + h2dStrs[i].title
           h2dStrs[i].name      = dataNames[i]
           h2dStrs[i].is_logged = 1
        ENDIF

        IF KEYWORD_SET(newellPlot_normalize) THEN BEGIN
           dataNames[i]        += '_normed'
           maxNEv               = MAX(h2dStrs[i].data[newell_nonzero_nEv_i_list[i]])
           h2dStrs[i].data      = h2dStrs[i].data/maxNEv
           h2dStrs[i].lim       = [0.0,1.0]
           h2dStrs[i].title    += STRING(FORMAT='(" (norm: ",G0.3,")")',maxNEv)
           h2dStrs[i].name      = dataNames[i]
        ENDIF

     ENDFOR
  ENDIF

END