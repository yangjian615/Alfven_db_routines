FUNCTION GET_TIMEHIST_DENOMINATOR,CLOCKSTR=clockStr, ANGLELIM1=angleLim1, ANGLELIM2=angleLim2, $
                                  ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, $
                                  DO_IMF_CONDS=do_IMF_conds, $
                                  BYMIN=byMin, BYMAX=byMax, BZMIN=bzMin, BZMAX=bzMax, SATELLITE=satellite, OMNI_COORDS=omni_Coords, $
                                  DELAY=delay, STABLEIMF=stableIMF, SMOOTHWINDOW=smoothWindow, INCLUDENOCONSECDATA=includeNoConsecData, $
                                  DO_UTC_RANGE=DO_UTC_range,T1_ARR=t1_arr,T2_ARR=t2_arr, $
                                  MINM=minM,MAXM=maxM,BINM=binM, $
                                  MINI=minI,MAXI=maxI,BINI=binI, $
                                  DO_LSHELL=do_lshell, MINL=minL,MAXL=maxL,BINL=binL, $
                                  HEMI=hemi, $
                                  FASTLOC_STRUCT=fastLoc,FASTLOC_TIMES=fastLoc_Times,FASTLOC_DELTA_T=fastLoc_delta_t, $
                                  FASTLOCFILE=fastLocFile, FASTLOCTIMEFILE=fastLocTimeFile, FASTLOCOUTPUTDIR=fastLocOutputDir, $
                                  INDSFILEPREFIX=indsFilePrefix,INDSFILESUFFIX=indsFileSuffix, $
                                  BURSTDATA_EXCLUDED=burstData_excluded, $
                                  DATANAMEARR=dataNameArr,DATARAWPTRARR=dataRawPtrArr,KEEPME=keepme


     ;Get the appropriate divisor for IMF conditions
  IF KEYWORD_SET(do_IMF_conds) THEN BEGIN
     GET_FASTLOC_INDS_IMF_CONDS,fastLocInterped_i,CLOCKSTR=clockStr, ANGLELIM1=angleLim1, ANGLELIM2=angleLim2, $
                                ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, $
                                BYMIN=byMin, BYMAX=byMax, BZMIN=bzMin, BZMAX=bzMax, SATELLITE=satellite, OMNI_COORDS=omni_Coords, $
                                HEMI='BOTH', DELAY=delay, STABLEIMF=stableIMF, SMOOTHWINDOW=smoothWindow, INCLUDENOCONSECDATA=includeNoConsecData, $
                                HWMAUROVAL=0,HWMKPIND=!NULL, $
                                MAKE_OUTINDSFILE=1, $
                                OUTINDSPREFIX=indsFilePrefix,OUTINDSSUFFIX=indsFileSuffix,OUTINDSFILEBASENAME=outIndsBasename, $
                                FASTLOC_STRUCT=fastLoc,FASTLOC_TIMES=fastLoc_Times,FASTLOC_DELTA_T=fastLoc_delta_t, $
                                FASTLOCFILE=fastLocFile, FASTLOCTIMEFILE=fastLocTimeFile, FASTLOCOUTPUTDIR=fastLocOutputDir, $
                                BURSTDATA_EXCLUDED=burstData_excluded
  ENDIF ELSE BEGIN
     IF KEYWORD_SET(do_UTC_range) THEN BEGIN
        GET_FASTLOC_INDS_UTC_RANGE,fastLocInterped_i,T1_ARR=t1_arr,T2_ARR=t2_arr, $
                                   ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, $
                                   HEMI=hemi, $
                                   HWMAUROVAL=HwMAurOval,HWMKPIND=HwMKpInd, $
                                   MAKE_OUTINDSFILE=1, $
                                   OUTINDSPREFIX=indsFilePrefix,OUTINDSSUFFIX=indsFileSuffix,OUTINDSFILEBASENAME=outIndsBasename, $
                                   FASTLOC_STRUCT=fastLoc,FASTLOC_TIMES=fastLoc_Times,FASTLOC_DELTA_T=fastloc_delta_t, $
                                   FASTLOCFILE=fastLocFile, FASTLOCTIMEFILE=fastLocTimeFile, FASTLOCOUTPUTDIR=fastLocOutputDir
     ENDIF
  ENDELSE

     MAKE_FASTLOC_HISTO,OUTTIMEHISTO=tHistDenominator, $
                        FASTLOC_INDS=fastLocInterped_i, $
                        FASTLOC_STRUCT=fastLoc,FASTLOC_TIMES=fastLoc_Times,FASTLOC_DELTA_T=fastloc_delta_t, $
                        MINMLT=minM,MAXMLT=maxM,BINMLT=binM, $
                        MINILAT=minI,MAXILAT=maxI,BINILAT=binI, $
                        DO_LSHELL=do_lshell,MINLSHELL=minL,MAXLSHELL=maxL,BINLSHELL=binL, $
                        FASTLOCFILE=fastLocFile,FASTLOCTIMEFILE=fastLocTimeFile, $
                        OUTFILEPREFIX=outIndsBasename,OUTFILESUFFIX=outFileSuffix, OUTDIR=fastLocOutputDir, $
                        OUTPUT_TEXTFILE=output_textFile


  RETURN,tHistDenominator

END