;2015/10/20 This files reads what gets parsed by rd_fastloc3_output
;*fastloc_intervals1 uses electron data to get data intervals and outputs FAST ephemeris data at the same resolution as the ESA data.
;*fastloc_intervals2 uses electron data to get data intervals, but outputs data with 5-s resolution (as opposed to the resolution of
;  the particle data).
;*fastloc_intervals3 uses electron data to get data intervals at 5-s resolution, and very importantly includes the sample period of 
;  the fluxgate magnetometer.

PRO combine_fastloc_intervals3,fastLoc

  date='20151020'

  fastLoc_DB='/SPENCEdata/software/sdt/batch_jobs/FASTlocation/batch_output__intervals/'
  contents_file='./orbits_contained_in_fastloc_'+date+'.txt'

  ;; fNamePrefix='Dartmouth_fastloc_intervals'
  ;; fNameSuffix=''
  fNamePrefix='Dartmouth_fastloc_intervals3'
  fNameSuffix='--below_aur_oval'
  fNameSuffLen=STRLEN(fNameSuffix)

  outDir='/SPENCEdata/Research/database/time_histos/'
  ;; outSuffix='500-3126--below_aur_oval'
  ;; outSuffix='3127-5999--below_aur_oval'
  ;; outSuffix='6000-10780--below_aur_oval'
  outSuffix='14064-16361--below_aur_oval'
  outFileSansFExt = 'fastLoc_intervals3--'+outSuffix+'--'+date
  outFile = outFileSansFExt+'.sav'
  outTimeFile = outFileSansFExt+'--times.sav'
  outTimeFile_raw = outFileSansFExt+'--times.sav_raw'

 ;open file to write list of orbits included
  OPENW,outlun,contents_file,/get_lun

  min_orbit=14064
  max_orbit=16361

  FOR j=min_orbit,max_orbit DO BEGIN
     
     filename=fNamePrefix+'_'+strcompress(j,/remove_all)+'_0'+fNameSuffix
                                ;filename='orb'+strcompress(j,/remove_all)+'_dflux'
     result=file_which(fastLoc_DB,filename)
     IF result THEN BEGIN
        FOR jj=0,12 DO BEGIN
           result=file_which(fastLoc_DB,filename)
           IF result THEN BEGIN
              print,j,jj
              printf,outlun,j,jj
              rd_fastloc3_output,result,dat,FNAMESUFFLEN=fNameSuffLen
              IF j GT min_orbit THEN BEGIN
                 fastLoc={ORBIT:[fastLoc.orbit,dat.orbit],$
                          TIME:[fastLoc.time,dat.time],$
                          ALT:[fastLoc.alt,dat.alt],$
                          MLT:[fastLoc.mlt,dat.mlt],$
                          ILAT:[fastLoc.ilat,dat.ilat],$
                          FIELDS_MODE:[fastLoc.FIELDS_MODE,dat.FIELDS_MODE],$
                          SAMPLE_T:[fastLoc.SAMPLE_T,dat.SAMPLE_T],$
                          INTERVAL:[fastLoc.INTERVAL,dat.INTERVAL],$
                          INTERVAL_START:[fastLoc.INTERVAL_START,dat.INTERVAL_START],$
                          INTERVAL_STOP:[fastLoc.INTERVAL_STOP,dat.INTERVAL_STOP],$
                          LSHELL:[fastLoc.LSHELL,dat.LSHELL]}
              ENDIF ELSE BEGIN
                 fastLoc=dat
              ENDELSE
           ENDIF
           filename=fNamePrefix+'_'+strcompress(j,/remove_all)+'_'+strcompress(jj+1,/remove_all)+fNameSuffix
        ENDFOR
     ENDIF ELSE PRINT,"Couldn't open " + filename + "!!!"
  ENDFOR
  
  save,fastLoc,FILENAME=outDir+outFile
  
  ;do fastloctimes
  fastloc_times = str_to_time(fastLoc.time)
  fastLoc_delta_t = shift(fastLoc_Times,-1)-fastLoc_Times
  save,fastLoc_Times,fastLoc_delta_t,FILENAME=outDir+outTimeFile_raw
  fastLoc_delta_t[-1] = 10.0                                ;treat last element specially, since otherwise it is a huge negative number
  fastLoc_delta_t = ROUND(fastLoc_delta_t*4.0)/4.0          ;round to nearest quarter of a second
  fastLoc_delta_t(WHERE(fastLoc_delta_t GT 10.0)) = 10.0    ;many events with a large delta_t correspond to ends of intervals/orbits
  save,fastloc_times,fastLoc_delta_t,filename=outDir+outTimeFile

  RETURN
  
END
