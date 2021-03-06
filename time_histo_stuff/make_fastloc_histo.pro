;2015/10/21 Now using DB produced by fastloc_intervals3
;2015/04/07
;The purpose of this pro is to now take fastloc output that has been processed by combine_fastloc_intervals and to make a
;'denominator histogram', so to speak, so we know where events are actually happening. 
;This should be standardized so that these files don't get remade all the time.
;For the histogram, these things should only be divided up by altitude,mlt,and ilat.
;
;2015/05/01
;I originally thought that we should have a default delta_t=5 sec between data points in all fastloc* programs, so I hardcoded
;that here. I have since commented it out, and now just use the actual time between data points. If the time between points is
;longer than 10 seconds, I just treat it like a 10-second delta_t (see combine_fastloc_intervals.pro).

;So let's say you wanted to make a time histo for duskward IMF, with By>=5 nT. First get the
;indices file by running get_fastloc_inds__IMF_conds with keyword /MAKE_OUTINDSFILE, then provide
;those indices as the keyword FASTLOC_INDS here.

PRO MAKE_FASTLOC_HISTO,FASTLOC_STRUCT=fastLoc, $
                       FASTLOC_TIMES=fastLoc_Times, $
                       FASTLOC_DELTA_T=fastloc_delta_t, $
                       OUTTIMEHISTO=outTimeHisto, $
                       FASTLOC_INDS=fastLoc_inds, $
                       OUT_DELTA_TS=out_delta_ts, $
                       MINMLT=minMLT,MAXMLT=maxMLT, $
                       BINMLT=binMLT, $
                       SHIFTMLT=shiftM, $
                       MINILAT=minILAT,MAXILAT=maxILAT,BINILAT=binILAT, $
                       EQUAL_AREA_BINNING=EA_binning, $
                       USE_AACGM_COORDS=use_AACGM, $
                       BOTH_HEMIS=both_hemis, $
                       DO_LSHELL=do_lShell, $
                       MINLSHELL=minLshell, $
                       MAXLSHELL=maxLshell, $
                       BINLSHELL=binLshell, $
                       FOR_ESPEC_DBS=for_eSpec_DBs, $
                       ESPEC__USE_2000KM_FILE=eSpec__use_2000km_file, $
                       MINALT=minAlt,MAXALT=maxAlt,BINALT=binAlt, $
                       FASTLOCFILE=fastLocFile, $
                       FASTLOCTIMEFILE=fastLocTimeFile, $
                       OUTFILEPREFIX=outFilePrefix, $
                       OUTFILESUFFIX=outFileSuffix, $
                       OUTDIR=outDir, $
                       OUTPUT_TEXTFILE=output_textFile,LUN=lun

  COMPILE_OPT idl2


  ;def outputs
  ;; defOutFilePrefix = 'fastLoc_intervals3--timeHisto--INDS_from_get_fastloc_inds_imf_conds'
  ;; defOutDir = '/SPENCEdata/Research/database/FAST/ephemeris/fastLoc_intervals3/time_histos/'

  ;; defOutFilePrefix = 'fastLoc_intervals4--timeHisto--inds_from_get_fastloc_inds_imf_conds'
  ;; defOutFileSuffix = ''
  ;; defOutDir        = '/SPENCEdata/Research/database/FAST/ephemeris/fastLoc_intervals4/time_histos/'

  ;; IF N_ELEMENTS(outFilePrefix) EQ 0 THEN outFilePrefix = defOutFilePrefix
  ;; IF N_ELEMENTS(outFileSuffix) EQ 0 THEN outFileSuffix = defOutFileSuffix
  ;; IF N_ELEMENTS(outDir) EQ 0 THEN outDir = defOutDir

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1

  IF KEYWORD_SET(DO_lShell) THEN latTypeStr = "_lShell" ELSE latTypeStr = "_ILAT"
  ;set up outfilename
  ;It's gotta be standardized!
  ;; minOrb = MIN(fastLoc.orbit,MAX=maxOrb)
  ;; fNameSansPref = STRING(format='(A0,I0,"-",I0,"-",G0.2,"_MLT--",I0,"-",I0,"-",G0.2,A0,A0)', $
  ;;                        outFilePrefix,minMLT,maxMLT,binMLT, $
  ;;                        (KEYWORD_SET(do_lShell) ? minLshell : minILAT),(KEYWORD_SET(do_lShell) ? maxLshell : maxILAT), $
  ;;                        (KEYWORD_SET(do_lShell) ? binLshell : binILAT),latTypeStr,outFileSuffix)
  ;; outFileName=fNameSansPref + ".sav"

  ;; IF FILE_TEST(outDir+outFileName) THEN BEGIN
  ;;    PRINTF,lun,'fastLoc timehisto file already exists: ' + outDir+outFileName
  ;;    PRINTF,lun,"Restoring..."
  ;;    RESTORE,outDir+outFileName
  ;;    IF N_ELEMENTS(outTimeHisto) EQ 0 THEN BEGIN
  ;;       PRINTF,lun,"Error! No outTimeHisto is in this file! Possibly corrupted/old timehisto file?"
  ;;       STOP
  ;;    ENDIF
  ;; ENDIF
  ;; ENDIF ELSE BEGIN

                                ;are we doing a text file?
     ;; IF KEYWORD_SET(output_textFile) THEN BEGIN
     ;;    textFileName='txtoutput/'+fNameSansPref + ".txt"
        
     ;;    OPENW,textLun,outDir+textFileName,/GET_LUN
     ;;    PRINTF,textLun,"Output from make_fastloc_histo"
     ;;    PRINTF,textLun,"The filename gives {min,max,binsize}{MLT,(ILAT|lShell)}--{min,max}Orb"
     ;;    PRINTF,textLun,FORMAT='("MLT",T10,"(ILAT|lShell)",T25,"Time in bin (minutes)")'
     ;; ENDIF
     
  ;;Get these in memory
  ;; LOAD_FASTLOC_AND_FASTLOC_TIMES,fastLoc, $
  ;;                                fastLoc_times, $
  ;;                                fastLoc_delta_t, $
  ;;                                USE_AACGM_COORDS=use_AACGM, $
  ;;                                FOR_ESPEC_DBS=for_eSpec_DBs;; , $
                                 ;; ESPEC__USE_2000KM_FILE=eSpec__use_2000km_file


     ;;avoid any trickery
     nFastLoc = N_ELEMENTS(fastLoc.orbit)
     nFastLoc_Times = N_ELEMENTS(fastLoc_times)
     IF nFastLoc NE nFastLoc_times THEN BEGIN
        PRINTF,lun,"Something is wrong. nFastLoc = " + strcompress(nFastLoc) + " while nFastLoc_times = " + strcompress(nFastLoc_times) + "."
        PRINTF,lun,"Fix it! In the meantime, we're quitting."
        RETURN
     ENDIF
     
     IF fastLoc_delta_t EQ !NULL THEN BEGIN
        ;; IF fastLoc_times EQ !NULL THEN fastLoc_times = str_to_time(fastLoc.time)
        ;; fastLoc_delta_t = shift(fastLoc_times,-1)-fastLoc_times
        ;; save,fastLoc_times,fastLoc_delta_t,FILENAME=fastLocDir+fastLocTimeFile+'_raw'
        ;; fastLoc_delta_t[-1] = 10.0                             ;treat last element specially, since otherwise it is a huge negative number
        ;; fastLoc_delta_t = ROUND(fastLoc_delta_t*8.0)/8.0 ;round to nearest eigth of a second
        ;; fastLoc_delta_t(WHERE(fastLoc_delta_t GT 10.0)) = 10.0 ;many events with a large delta_t correspond to ends of intervals/orbits
        ;; save,fastLoc_times,fastLoc_delta_t,FILENAME=fastLocDir+fastLocTimeFile
        PRINTF,lun,"Why is fastloc_delta_t empty? Returning..."
        RETURN
     ENDIF
     
                                ;Are we only using a user-supplied array of indices?
     ;; IF KEYWORD_SET(fastLoc_inds) THEN BEGIN
     ;;    fastLoc = RESIZE_FASTLOC(fastLoc,fastLoc_inds,FASTLOC_TIMES=fastLoc_times,FASTLOC_DELTA_T=fastLoc_delta_t)
     ;; ENDIF
     
     IF (WHERE(fastLoc_delta_t LT 0) )[0] NE -1 THEN STOP

     ;;fix MLTs
     fastLocMLTs   = SHIFT_MLTS_FOR_H2D(fastLoc,fastLoc_inds,shiftM)

     fastLocILATS  = (KEYWORD_SET(do_lShell) ? fastLoc.lShell : fastLoc.ILAT)[fastLoc_inds]

     ;;loop over MLTs and ILATs
     IF KEYWORD_SET(both_hemis) THEN fastLocILATS = ABS(fastLocILATS)

     CASE 1 OF
        KEYWORD_SET(EA_binning): BEGIN
           
           LOAD_EQUAL_AREA_BINNING_STRUCT,EA

           ;;set up grid
           nBins        = N_ELEMENTS(EA.minI)
           
           outTimeHisto  = MAKE_ARRAY(nBins,/DOUBLE) ;how long FAST spends in each bin
           
           latSwitch_i = [0,WHERE((EA.minI[1:-1]-EA.minI[0:-2]) NE 0),N_ELEMENTS(EA.minI)-1]

           FOR k=0,N_ELEMENTS(latSwitch_i)-2 DO BEGIN
              tmpInds = [latSwitch_i[k]:(latSwitch_i[k+1]-1)]

            FOR kk=0,N_ELEMENTS(tmpInds)-1 DO BEGIN

               tempInds = WHERE((fastLocMLTs  GE EA.minM[tmpInds[kk]]) AND (fastLocMLTs  LT EA.maxM[tmpInds[kk]]) AND $
                                (fastLocILATS GE EA.minI[tmpInds[kk]]) AND (fastLocILATS LT EA.maxI[tmpInds[kk]]))
                 IF tempInds[0] NE -1 THEN BEGIN
                    tempBinTime = TOTAL(DOUBLE(fastLoc_delta_t[fastLoc_inds[tempInds]]))
                    outTimeHisto[tmpInds[kk]] = tempBinTime
                    
                    IF KEYWORD_SET(output_textFile) THEN PRINTF,textLun,FORMAT='(F0.2,T10,F0.2,T20,F0.3)', $
                       MEAN([EA.minM[tmpInds[kk]],EA.maxM[tmpInds[kk]]]),MEAN([EA.minI[tmpInds[kk]],EA.maxI[tmpInds[kk]]]),DOUBLE(tempBinTime)/60.0
                 ENDIF ELSE tempBinTime = DOUBLE(0.0)
              ENDFOR
           ENDFOR
           ;;Last by hand
           tempInds = WHERE((fastLocMLTs  GE EA.minM[nBins-1]) AND (fastLocMLTs  LT EA.maxM[nBins-1]) AND $
                            (fastLocILATS GE EA.minI[nBins-1]) AND (fastLocILATS LT EA.maxI[nBins-1]))
           IF tempInds[0] NE -1 THEN BEGIN
              tempBinTime = TOTAL(DOUBLE(fastLoc_delta_t[fastLoc_inds[tempInds]]))
              outTimeHisto[nBins-1] = tempBinTime
              
              IF KEYWORD_SET(output_textFile) THEN PRINTF,textLun,FORMAT='(F0.2,T10,F0.2,T20,F0.3)', $
                 MEAN([EA.minM[nBins-1],EA.maxM[nBins-1]]),MEAN([EA.minI[nBins-1],EA.maxI[nBins-1]]),DOUBLE(tempBinTime)/60.0
           ENDIF ELSE tempBinTime = DOUBLE(0.0)

        END
        ELSE: BEGIN
           ;;set up grid
           nXlines  = (maxMLT-minMLT)/binMLT + 1
           nYlines  = ((KEYWORD_SET(do_lShell) ? maxLshell : maxILAT)-(KEYWORD_SET(do_lShell) ? minLshell : minILAT))/ $
                      (KEYWORD_SET(do_lShell) ? binLshell : binILAT) + 1
           
           mlts     = INDGEN(nXlines)*binMLT+minMLT
           ilats    = INDGEN(nYlines)*(KEYWORD_SET(do_lShell) ? binLshell : binILAT)+ $
                      (KEYWORD_SET(do_lShell) ? minLshell : minILAT)
           
           nMLT     = N_ELEMENTS(mlts)
           nILAT    = N_ELEMENTS(ilats)
           
           outTimeHisto  = MAKE_ARRAY(nMLT,nILAT,/DOUBLE) ;how long FAST spends in each bin
           
           FOR j=0, nILAT-2 DO BEGIN 
              FOR i=0, nMLT-2 DO BEGIN 
                 tempInds = WHERE(fastLocMLTs GE mlts[i] AND fastLocMLTs LT mlts[i+1] AND $
                                  fastLocILATS GE ilats[j] AND $
                                  fastLocILATS LT ilats[j+1])
                 IF tempInds[0] NE -1 THEN BEGIN
                    tempBinTime = TOTAL(DOUBLE(fastLoc_delta_t[fastLoc_inds[tempInds]]))
                    outTimeHisto[i,j] = tempBinTime
                    
                    IF KEYWORD_SET(output_textFile) THEN PRINTF,textLun,FORMAT='(F0.2,T10,F0.2,T20,F0.3)',mlts[i],ilats[j],DOUBLE(tempBinTime)/60.0
                 ENDIF ELSE tempBinTime = DOUBLE(0.0)
              ENDFOR
           ENDFOR

        END
     ENDCASE

     
     ;; ;;save the file
     ;; IF NOT KEYWORD_SET(fastLoc_Inds) AND $
     ;; NOT ((outFilePrefix EQ defOutFilePrefix) AND (outFileSuffix EQ defOutFileSuffix)) THEN BEGIN
     ;;    save,outTimeHisto,FILENAME=outDir+outFileName
     ;;    PRINTF,lun,'Saving ' + outDir+outFileName + '...'
     ;; ENDIF ELSE BEGIN
     ;;    PRINTF,lun,'Not saving ' + outDir+outFileName+'...'
     ;; ENDELSE
     
     ;; save,outTimeHisto,FILENAME=outDir+outFileName
     ;; PRINTF,lun,'Saving ' + outDir+outFileName + '...'
     
     ;; IF KEYWORD_SET(output_textFile) THEN CLOSE,textLun
  ;; ENDELSE

     out_delta_ts              = fastLoc_delta_t[fastLoc_inds]
END